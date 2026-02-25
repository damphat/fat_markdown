import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'fat_config.dart';
import 'fat_theme.dart';

export 'fat_config.dart';
import 'fat_blockquote.dart';
import 'fat_checkbox.dart';
import 'fat_code_block.dart';
import 'fat_heading.dart';
import 'fat_image.dart';
import 'fat_inline_code.dart';
import 'fat_link.dart';
import 'fat_list.dart';
import 'fat_math.dart';
import 'fat_table.dart';
import 'fat_tree_view.dart';

class FatMarkdownNode extends StatelessWidget {
  final md.Node node;
  const FatMarkdownNode({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    if (FatMarkdownConfig.of(context).mode == FatMarkdownMode.treeview) {
      return FatTreeViewNode(node: node);
    }

    if (node is md.Text) return Text(node.textContent);

    if (node is md.Element) {
      final e = node as md.Element;
      return _buildElement(context, e) ??
          FatMarkdownNodeList(nodes: [e], isInlineGroup: true);
    }

    return const SizedBox.shrink();
  }

  Widget? _buildElement(BuildContext context, md.Element e) {
    switch (e.tag) {
      case 'h1' || 'h2' || 'h3' || 'h4' || 'h5' || 'h6':
        return FatHeading(element: e);
      case 'p':
        return FatMarkdownNodeList(
          nodes: e.children ?? [],
          isInlineGroup: true,
        );
      case 'blockquote':
        return FatBlockquote(element: e);
      case 'ul' || 'ol':
        return FatList(element: e);
      case 'pre':
        return FatCodeBlock(element: e);
      case 'table':
        return FatTable(element: e);
      case 'hr':
        return const Divider(height: 1);
      case 'latex-block' || 'latex':
        return FatMath(element: e);
      case 'img':
        return FatImage(element: e);
      case 'a':
        return FatLink(element: e);
      case 'input' when e.attributes['type'] == 'checkbox':
        return FatCheckbox(element: e);
      default:
        return null;
    }
  }
}

InlineSpan buildInlineSpan(BuildContext context, md.Node n) {
  if (FatMarkdownConfig.of(context).mode == FatMarkdownMode.treeview) {
    return WidgetSpan(child: FatTreeViewNode(node: n));
  }

  if (n is md.Text) {
    return TextSpan(text: n.text.replaceAll('\n', ' '));
  }

  if (n is md.Element) {
    return _buildElementSpan(context, n);
  }

  return const TextSpan();
}

InlineSpan _buildElementSpan(BuildContext context, md.Element e) {
  WidgetSpan asWidget(
    Widget w, {
    PlaceholderAlignment align = PlaceholderAlignment.middle,
  }) => WidgetSpan(alignment: align, child: w);

  List<InlineSpan> children() =>
      e.children?.map((c) => buildInlineSpan(context, c)).toList() ?? [];

  switch (e.tag) {
    case 'strong':
      return TextSpan(
        style: const TextStyle(fontWeight: FontWeight.bold),
        children: children(),
      );
    case 'em':
      return TextSpan(
        style: const TextStyle(fontStyle: FontStyle.italic),
        children: children(),
      );
    case 'del':
      return TextSpan(
        style: const TextStyle(decoration: TextDecoration.lineThrough),
        children: children(),
      );
    case 'code':
      return WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: FatInlineCode(element: e),
      );
    case 'a':
      return buildLinkSpan(context, e);
    case 'img':
      return asWidget(FatImage(element: e));
    case 'br':
      return const TextSpan(text: '\n');
    case 'latex':
      return asWidget(FatMath(element: e));
    case 'input' when e.attributes['type'] == 'checkbox':
      return asWidget(FatCheckbox(element: e));
    case 'sup':
      return TextSpan(
        text: e.textContent,
        style: const TextStyle(
          fontSize: 12,
          fontFeatures: [FontFeature.superscripts()],
        ),
      );
    case 'sub':
      return TextSpan(
        text: e.textContent,
        style: const TextStyle(
          fontSize: 12,
          fontFeatures: [FontFeature.subscripts()],
        ),
      );
    default:
      return TextSpan(children: children());
  }
}

/// Internal widget that renders a list of markdown AST nodes.
class FatMarkdownNodeList extends StatelessWidget {
  final List<md.Node> nodes;
  final bool isInlineGroup;

  const FatMarkdownNodeList({
    super.key,
    required this.nodes,
    this.isInlineGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) return const SizedBox.shrink();

    if (FatMarkdownConfig.of(context).mode == FatMarkdownMode.treeview) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: nodes.map((n) => FatMarkdownNode(node: n)).toList(),
      );
    }

    if (isInlineGroup) return _richText(context, nodes);

    // Mixed content: group consecutive inline nodes into Text.rich
    final children = <Widget>[];
    final pending = <md.Node>[];

    void flush() {
      if (pending.isEmpty) return;
      children.add(_richText(context, List.of(pending)));
      pending.clear();
    }

    for (final node in nodes) {
      if (_isBlockNode(node)) {
        flush();
        children.add(FatMarkdownNode(node: node));
      } else {
        pending.add(node);
      }
    }
    flush();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: children,
    );
  }

  Widget _richText(BuildContext context, List<md.Node> nodes) => Text.rich(
    TextSpan(
      children: nodes.map((n) => buildInlineSpan(context, n)).toList(),
    ),
    strutStyle: FatTheme.of(context).inlineStrutStyle,
  );
}

const _blockTags = {
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'p',
  'blockquote',
  'pre',
  'ul',
  'ol',
  'hr',
  'table',
  'li',
  'latex-block',
};

bool _isBlockNode(md.Node n) => n is md.Element && _blockTags.contains(n.tag);
