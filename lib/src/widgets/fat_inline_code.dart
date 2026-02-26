import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import '../fat_theme.dart';

/// Renders inline code: `` `code` ``
class FatInlineCode extends StatelessWidget {
  final md.Element element;
  const FatInlineCode({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final ft = FatMarkdownTheme.of(context);
    return Container(
      padding: ft.inlineCodePadding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(ft.inlineCodeBorderRadius),
      ),
      child: Text(
        element.textContent,
        style: ft.inlineCodeTextStyle(context),
      ),
    );
  }
}
