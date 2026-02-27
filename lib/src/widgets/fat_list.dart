import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'fat_node.dart';
import '../fat_theme.dart';

class FatList extends StatelessWidget {
  final md.Element element;
  const FatList({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final isOrdered = element.tag == 'ol';
    final items = (element.children ?? []).whereType<md.Element>().toList();

    return Column(
      spacing: 4,
      children: [
        for (final (i, item) in items.indexed)
          _FatListItem(
            bullet: isOrdered ? '${i + 1}.' : '•',
            isBullet: !isOrdered,
            element: item,
          ),
      ],
    );
  }
}

class _FatListItem extends StatelessWidget {
  final String bullet;
  final bool isBullet;
  final md.Element element;

  const _FatListItem({
    required this.bullet,
    required this.isBullet,
    required this.element,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: isBullet ? 28 : 36,
          child: Align(
            alignment: isBullet ? Alignment.center : Alignment.topRight,
            child: Padding(
              padding: isBullet
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(right: 6),
              child: Text(
                bullet,
                style: isBullet
                    ? const TextStyle(fontWeight: FontWeight.bold)
                    : null,
                strutStyle: FatMarkdownTheme.of(context).inlineStrutStyle,
              ),
            ),
          ),
        ),
        Expanded(child: FatMarkdownNodeList(nodes: element.children ?? [])),
      ],
    );
  }
}
