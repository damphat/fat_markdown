import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'fat_node.dart';
import 'fat_theme.dart';

class FatBlockquote extends StatelessWidget {
  final md.Element element;
  const FatBlockquote({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final ft = FatTheme.of(context);
    return Container(
      padding: EdgeInsets.only(
        left: ft.blockquotePaddingLeft,
        top: 4,
        bottom: 4,
      ),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: ft.blockquoteBorderWidth,
          ),
        ),
      ),
      child: FatMarkdownNodeList(nodes: element.children ?? []),
    );
  }
}
