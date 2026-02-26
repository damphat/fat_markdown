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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        final editor = MarkdownEditor(
          controller: _controller,
          onChanged: () => setState(() {}),
        );

        final preview = _buildPreview(context);

        if (isMobile) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Fat Markdown'),
                elevation: 3,
                actions: [
                  IconButton(
                    icon: Icon(
                      widget.isDark ? Icons.light_mode : Icons.dark_mode,
                    ),
                    onPressed: widget.onThemeToggle,
                    tooltip: 'Toggle Theme',
                  ),
                ],
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Editor', icon: Icon(Icons.edit)),
                    Tab(text: 'Preview', icon: Icon(Icons.remove_red_eye)),
                  ],
                ),
              ),
              body: TabBarView(children: [editor, preview]),
            ),
          );
        }

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
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Editor ──────────────────────────────────────────────
              Expanded(flex: 2, child: editor),
              const VerticalDivider(width: 1),
              // ── Preview ─────────────────────────────────────────────
              Expanded(flex: 3, child: preview),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPreview(BuildContext context) {
    return Column(
      children: [
        // ── Preview Toolbar ───────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
        // ── Content ───────────────────────────────────────────────────
        Expanded(
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
    );
  }
}
