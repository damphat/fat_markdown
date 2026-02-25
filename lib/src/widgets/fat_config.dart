import 'package:flutter/material.dart';

/// Rendering mode for FatMarkdown.
enum FatMarkdownMode {
  /// Normal rendering mode.
  normal,

  /// Debug tree-view mode — renders the raw AST nodes.
  treeview,
}

/// Inherited widget that passes configuration down the widget tree.
class FatMarkdownConfig extends InheritedWidget {
  final FatMarkdownMode mode;
  final void Function(String url)? onLinkTap;
  final void Function(String url, List<String> allImages)? onImageTap;
  final List<String> allImages;
  final bool enableMath;

  const FatMarkdownConfig({
    super.key,
    required super.child,
    required this.mode,
    this.onLinkTap,
    this.onImageTap,
    required this.allImages,
    required this.enableMath,
  });

  static FatMarkdownConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FatMarkdownConfig>()!;
  }

  @override
  bool updateShouldNotify(FatMarkdownConfig oldWidget) {
    return mode != oldWidget.mode ||
        onLinkTap != oldWidget.onLinkTap ||
        onImageTap != oldWidget.onImageTap ||
        allImages != oldWidget.allImages ||
        enableMath != oldWidget.enableMath;
  }
}
