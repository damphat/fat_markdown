/// fat_markdown — A powerful Flutter Markdown widget with LaTeX and syntax highlighting.
///
/// ## Usage
///
/// ```dart
/// import 'package:fat_markdown/fat_markdown.dart';
///
/// FatMarkdown(
///   data: markdownString,
///   onLinkTap: (url) => launchUrl(Uri.parse(url)),
/// )
/// ```
///
/// ## Theming
///
/// Override [FatMarkdownTheme] via `ThemeData.extensions` for fine-grained control:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       FatMarkdownTheme(
///         codeFontSize: 14,
///         tableStretch: true,
///       ),
///     ],
///   ),
/// )
/// ```
library;

export 'src/fat_markdown.dart' show FatMarkdown;
export 'src/fat_config.dart' show FatMarkdownMode;
export 'src/fat_theme.dart' show FatMarkdownTheme;
