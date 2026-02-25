import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

class FatCheckbox extends StatelessWidget {
  final md.Element element;

  const FatCheckbox({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final checked = element.attributes.containsKey('checked');
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: checked ? scheme.primary : scheme.outline,
            width: 1.5,
          ),
          color: checked ? scheme.primary : Colors.transparent,
        ),
        child: checked
            ? Icon(Icons.check, size: 14, color: scheme.onPrimary)
            : null,
      ),
    );
  }
}
