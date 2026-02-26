import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import '../fat_config.dart';

class FatImage extends StatelessWidget {
  final md.Element element;

  const FatImage({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final url = element.attributes['src'] ?? '';
    final alt = element.attributes['alt'] ?? '';
    final config = FatMarkdownConfig.of(context);

    return GestureDetector(
      onTap: () => config.onImageTap?.call(url, config.allImages),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              url,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Text(
                alt.isEmpty ? 'Image' : alt,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
