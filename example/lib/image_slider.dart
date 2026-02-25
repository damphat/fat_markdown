import 'package:flutter/material.dart';

class ImageSliderDialog extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImageSliderDialog({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<ImageSliderDialog> createState() => _ImageSliderDialogState();
}

class _ImageSliderDialogState extends State<ImageSliderDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (idx) => setState(() => _currentIndex = idx),
            itemBuilder: (context, index) {
              final url = widget.images[index];
              return Center(
                child: InteractiveViewer(
                  child: Image.network(
                    url,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.images.asMap().entries.map((entry) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == entry.key
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
