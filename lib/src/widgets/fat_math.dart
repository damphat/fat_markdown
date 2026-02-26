import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;
import 'fat_scrollable_block.dart';
import '../fat_theme.dart';

class FatMath extends StatelessWidget {
  final md.Element element;
  const FatMath({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final formula = element.textContent.trim();
    final isBlock = element.tag == 'latex-block';

    if (formula.isEmpty) {
      return isBlock ? const SizedBox(height: 24) : const SizedBox.shrink();
    }

    final ft = FatMarkdownTheme.of(context);
    final math = Math.tex(
      formula,
      mathStyle: isBlock ? MathStyle.display : MathStyle.text,
      textStyle: Theme.of(context).textTheme.bodyLarge,
      onErrorFallback: (err) => Text(
        formula,
        style: TextStyle(
          fontFamily: ft.codeFontFamily,
          fontFamilyFallback: ft.codeFontFamilyFallback,
          color: Theme.of(context).colorScheme.error,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.errorContainer.withValues(alpha: 0.3),
        ),
      ),
    );

    return isBlock ? FatScrollableBlock(child: math) : math;
  }
}
