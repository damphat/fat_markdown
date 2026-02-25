import 'package:fat_markdown/fat_markdown.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'image_slider.dart';
import 'markdown_editor.dart';

class HomePage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;

  const HomePage({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  bool _showTreeView = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onLinkTap(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  void _onImageTap(String url, List<String> allImages) {
    if (allImages.isEmpty) return;
    int index = allImages.indexOf(url);
    if (index == -1) index = 0;

    showDialog(
      context: context,
      builder: (_) => ImageSliderDialog(
        images: allImages,
        initialIndex: index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fat Markdown'),
        elevation: 3,
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeToggle,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Editor ──────────────────────────────────────────────
                Expanded(
                  flex: 2,
                  child: MarkdownEditor(
                    controller: _controller,
                    onChanged: () => setState(() {}),
                  ),
                ),
                const VerticalDivider(width: 1),
                // ── Preview ─────────────────────────────────────────────
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: FatMarkdown(
                      data: _controller.text,
                      mode: _showTreeView
                          ? FatMarkdownMode.treeview
                          : FatMarkdownMode.normal,
                      onLinkTap: _onLinkTap,
                      onImageTap: _onImageTap,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Bottom bar ────────────────────────────────────────────────
          ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  const Text('Debug tree-view:'),
                  const SizedBox(width: 8),
                  Switch(
                    value: _showTreeView,
                    onChanged: (v) => setState(() => _showTreeView = v),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
