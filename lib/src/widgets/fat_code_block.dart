import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:syntax_highlight/syntax_highlight.dart';
import '../fat_theme.dart';

class FatCodeBlock extends StatefulWidget {
  final md.Element element;
  const FatCodeBlock({super.key, required this.element});

  @override
  State<FatCodeBlock> createState() => _FatCodeBlockState();
}

class _FatCodeBlockState extends State<FatCodeBlock> {
  static final _loadedLanguages = <String>{};
  static HighlighterTheme? _lightTheme, _darkTheme;

  static const _bundledLanguages = {
    'css',
    'dart',
    'go',
    'html',
    'java',
    'javascript',
    'json',
    'kotlin',
    'python',
    'rust',
    'sql',
    'swift',
    'typescript',
    'yaml',
  };

  @override
  void initState() {
    super.initState();
    _initHighlighter();
  }

  String get text => widget.element.textContent.trim();

  String? get language {
    final code = widget.element.children?.firstOrNull as md.Element?;
    return code?.attributes['class']?.replaceFirst('language-', '');
  }

  Future<void> _initHighlighter() async {
    final lang = _normalize(language);
    final needsThemes = _lightTheme == null || _darkTheme == null;
    final needsLang =
        lang != 'text' &&
        !_loadedLanguages.contains(lang) &&
        _bundledLanguages.contains(lang);

    if (!needsThemes && !needsLang) return;

    try {
      if (needsThemes) {
        _lightTheme = await HighlighterTheme.loadLightTheme();
        _darkTheme = await HighlighterTheme.loadDarkTheme();
      }
      if (needsLang) {
        await Highlighter.initialize([lang]);
        _loadedLanguages.add(lang);
      }
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('FatCodeBlock init failed: $e');
    }
  }

  @override
  void didUpdateWidget(FatCodeBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.element != widget.element) _initHighlighter();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ft = FatMarkdownTheme.of(context);
    final lang = _normalize(language);
    final decoration = ft.resolveBlockDecoration(context);

    return Container(
      decoration: decoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CodeHeader(language: language, text: text, ft: ft),
          Divider(
            height: 1,
            thickness: 1,
            color: ft.resolveDividerColor(context),
          ),
          _CodeContent(
            text: text,
            language: lang,
            ft: ft,
            highlighterTheme: theme.brightness == Brightness.dark
                ? _darkTheme
                : _lightTheme,
            isLoaded: _loadedLanguages.contains(lang),
          ),
        ],
      ),
    );
  }

  String _normalize(String? lang) {
    if (lang == null) return 'text';
    return switch (lang.toLowerCase()) {
      'js' => 'javascript',
      'ts' => 'typescript',
      'py' => 'python',
      final l => l,
    };
  }
}

class _CodeHeader extends StatelessWidget {
  final String? language;
  final String text;
  final FatMarkdownTheme ft;

  const _CodeHeader({
    required this.language,
    required this.text,
    required this.ft,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: ft.codeBlockHeaderPadding,
      child: Row(
        children: [
          if (language != null)
            Text(
              language!.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.copy, size: 14),
            onPressed: () => Clipboard.setData(ClipboardData(text: text)),
            visualDensity: VisualDensity.compact,
            tooltip: 'Copy code',
          ),
        ],
      ),
    );
  }
}

class _CodeContent extends StatelessWidget {
  final String text;
  final String language;
  final HighlighterTheme? highlighterTheme;
  final bool isLoaded;
  final FatMarkdownTheme ft;

  const _CodeContent({
    required this.text,
    required this.language,
    required this.highlighterTheme,
    required this.isLoaded,
    required this.ft,
  });

  @override
  Widget build(BuildContext context) {
    final style = ft.codeBlockTextStyle(context);

    final content = (highlighterTheme != null && isLoaded)
        ? Text.rich(
            Highlighter(
              language: language,
              theme: highlighterTheme!,
            ).highlight(text),
            style: style,
          )
        : Text(text, style: style);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: ft.codeBlockPadding,
      child: content,
    );
  }
}
