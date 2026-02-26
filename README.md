# fat_markdown

A powerful Flutter Markdown widget with **LaTeX math** and **syntax highlighting**.

## Features

- 📝 Full GitHub-Flavoured Markdown (GFM)
- ➗ Inline and block LaTeX via `flutter_math_fork`
- 🎨 Syntax highlighting for 14 languages (Dart, JS/TS, Python, Go, Rust, SQL…)
- 🌙 Automatic light/dark theme detection for code blocks
- 📋 Copy-to-clipboard button in every code block
- 🖼️ Image tap handler with gallery support
- 📊 Tables with stretch/scroll mode
- ✅ GitHub-style checkboxes
- 🔗 Tappable links
- 🐞 Built-in tree-view debug mode
- 🎨 Fully themeable via `FatMarkdownTheme` (`ThemeExtension`)

## Installation

```yaml
dependencies:
  fat_markdown: ^0.9.1
```

## Usage

```dart
import 'package:fat_markdown/fat_markdown.dart';

FatMarkdown(
  data: '# Hello\n\nThis is **fat** markdown with $E=mc^2$.',
  onLinkTap: (url) => launchUrl(Uri.parse(url)),
  onImageTap: (url, allImages) { /* open gallery */ },
)
```

## Theming

Customise via `FatMarkdownTheme` in your `ThemeData.extensions`:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      FatMarkdownTheme(
        codeFontSize: 14,
        tableStretch: true,
        codeBlockDividerColor: Colors.transparent, // hide divider
      ),
    ],
  ),
)
```

## Debug Mode

Inspect the parsed AST with the built-in tree-view:

```dart
FatMarkdown(
  data: markdownString,
  mode: FatMarkdownMode.treeview,
)
```

## License

MIT © 2026 damphat
