import 'package:flutter/material.dart';

/// A utility widget that provides horizontal scrolling for block elements.
/// Small content is centered within the available width;
/// wide content can be scrolled horizontally.
class FatScrollableBlock extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const FatScrollableBlock({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Padding(
              padding: padding,
              child: Center(child: child),
            ),
          ),
        );
      },
    );
  }
}
