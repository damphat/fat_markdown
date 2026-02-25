import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

/// Renders a single markdown AST node in tree-view (debug) mode.
class FatTreeViewNode extends StatefulWidget {
  final md.Node node;
  const FatTreeViewNode({super.key, required this.node});

  @override
  State<FatTreeViewNode> createState() => _FatTreeViewNodeState();
}

class _FatTreeViewNodeState extends State<FatTreeViewNode> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    if (widget.node is md.Text) {
      return _Txt(text: (widget.node as md.Text).text);
    }
    return _Elt(
      element: widget.node as md.Element,
      expanded: _expanded,
      onToggle: () => setState(() => _expanded = !_expanded),
    );
  }
}

class _Txt extends StatelessWidget {
  final String text;
  const _Txt({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      jsonEncode(text),
      style: TextStyle(
        color: cs.onSurface.withValues(alpha: 0.7),
        fontFamily: 'monospace',
        fontSize: 12,
      ),
    );
  }
}

class _Elt extends StatelessWidget {
  final md.Element element;
  final bool expanded;
  final VoidCallback onToggle;

  const _Elt({
    required this.element,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final kids = element.children;
    final hasKids = kids != null && kids.isNotEmpty;

    Widget tag({bool open = true, bool self = false, bool collapsed = false}) {
      return Text.rich(
        TextSpan(
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          children: [
            TextSpan(
              text: '<',
              style: TextStyle(color: cs.outline),
            ),
            if (!open)
              TextSpan(
                text: '/',
                style: TextStyle(color: cs.outline),
              ),
            TextSpan(
              text: element.tag,
              style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold),
            ),
            if (open)
              ...element.attributes.entries.expand(
                (a) => [
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: a.key,
                    style: TextStyle(color: cs.secondary),
                  ),
                  TextSpan(
                    text: '="',
                    style: TextStyle(color: cs.outline),
                  ),
                  TextSpan(
                    text: a.value,
                    style: TextStyle(color: cs.tertiary),
                  ),
                  TextSpan(
                    text: '"',
                    style: TextStyle(color: cs.outline),
                  ),
                ],
              ),
            TextSpan(
              text: self ? '/>' : (collapsed ? '>...' : '>'),
              style: TextStyle(color: cs.outline),
            ),
          ],
        ),
      );
    }

    if (!hasKids) return tag(self: true);

    if (kids.every((n) => n is md.Text)) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          tag(),
          ...kids.map((n) => _Txt(text: (n as md.Text).text)),
          tag(open: false),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  size: 14,
                  color: cs.outline,
                ),
                tag(collapsed: !expanded),
              ],
            ),
          ),
        ),
        if (expanded) ...[
          Container(
            margin: const EdgeInsets.only(left: 7),
            padding: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: cs.outlineVariant, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: kids.map((n) => FatTreeViewNode(node: n)).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: tag(open: false),
          ),
        ],
      ],
    );
  }
}
