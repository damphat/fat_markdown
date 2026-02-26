import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'fat_syntaxes.dart';
import 'fat_config.dart';
import 'fat_theme.dart';
import 'widgets/fat_node.dart';

/// A powerful Flutter widget that renders Markdown with LaTeX and syntax highlighting.
///
/// ```dart
/// FatMarkdown(
///   data: '# Hello\n\nThis is **fat** markdown with $E=mc^2$.',
///   onLinkTap: (url) => launchUrl(Uri.parse(url)),
/// )
/// ```
///
/// Customize appearance via [FatMarkdownTheme] in your [ThemeData.extensions].
class FatMarkdown extends StatefulWidget {
  const FatMarkdown({
    super.key,
    required this.data,
    this.mode = FatMarkdownMode.normal,
    this.onLinkTap,
    this.onImageTap,
    this.enableMath = true,
  });

  /// The Markdown string to render.
  final String data;

  /// Rendering mode. Use [FatMarkdownMode.treeview] for debugging.
  final FatMarkdownMode mode;

  /// Whether to parse and render LaTeX math expressions.
  final bool enableMath;

  /// Called when a link is tapped.
  final void Function(String url)? onLinkTap;

  /// Called when an image is tapped. Receives the tapped URL and a list of all
  /// image URLs in the document (useful for implementing a gallery).
  final void Function(String url, List<String> allImages)? onImageTap;

  @override
  State<FatMarkdown> createState() => _FatMarkdownState();
}

class _FatMarkdownState extends State<FatMarkdown> {
  late List<md.Node> _nodes;
  late List<String> _allImages;

  @override
  void initState() {
    super.initState();
    _parseData();
  }

  @override
  void didUpdateWidget(FatMarkdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data ||
        oldWidget.enableMath != widget.enableMath) {
      _parseData();
    }
  }

  void _parseData() {
    try {
      final doc = md.Document(
        extensionSet: md.ExtensionSet.gitHubWeb,
        blockSyntaxes: [if (widget.enableMath) LatexBlockSyntax()],
        inlineSyntaxes: [
          if (widget.enableMath) LatexInlineSyntax(),
          BrSyntax(),
        ],
        encodeHtml: false,
      );
      _nodes = doc.parseLines(widget.data.split('\n'));
    } catch (e) {
      debugPrint('FatMarkdown error: $e');
      _nodes = [md.Text(widget.data)];
    }
    _allImages = _collectImages(_nodes);
  }

  List<String> _collectImages(List<md.Node> nodes) {
    final images = <String>[];
    for (final node in nodes) {
      if (node is md.Element) {
        if (node.tag == 'img') {
          final src = node.attributes['src'];
          if (src != null) images.add(src);
        }
        images.addAll(_collectImages(node.children ?? []));
      }
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return FatMarkdownConfig(
      mode: widget.mode,
      onLinkTap: widget.onLinkTap,
      onImageTap: widget.onImageTap,
      allImages: _allImages,
      enableMath: widget.enableMath,
      child: SelectionArea(child: FatMarkdownNodeList(nodes: _nodes)),
    );
  }
}
