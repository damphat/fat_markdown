import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'fat_node.dart';
import '../fat_theme.dart';

class FatHeading extends StatelessWidget {
  final md.Element element;
  const FatHeading({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final level = int.parse(element.tag.substring(1));
    final tt = Theme.of(context).textTheme;
    final style = switch (level) {
      1 => tt.headlineMedium,
      2 => tt.headlineSmall,
      3 => tt.titleLarge,
      _ => tt.titleMedium,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: FatMarkdownTheme.of(context).headingTopSpacing),
        DefaultTextStyle.merge(
          style: style,
          child: FatMarkdownNodeList(
            nodes: element.children ?? [],
            isInlineGroup: true,
          ),
        ),
        if (level <= 2) const Divider(height: 1),
      ],
    );
  }
}
