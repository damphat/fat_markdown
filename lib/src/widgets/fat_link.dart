import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'fat_node.dart';

TextSpan buildLinkSpan(BuildContext context, md.Element e) {
  final url = e.attributes['href'] ?? '';
  final config = FatMarkdownConfig.of(context);
  final cs = Theme.of(context).colorScheme;
  final recognizer = TapGestureRecognizer()
    ..onTap = () => config.onLinkTap?.call(url);
  return TextSpan(
    text: e.textContent,
    mouseCursor: SystemMouseCursors.click,
    recognizer: recognizer,
    style: TextStyle(
      color: cs.primary,
      decoration: TextDecoration.underline,
      decorationColor: cs.primary.withValues(alpha: 0.5),
    ),
  );
}

class FatLink extends StatelessWidget {
  final md.Element element;
  const FatLink({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    return Text.rich(buildLinkSpan(context, element));
  }
}
