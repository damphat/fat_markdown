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
/// Override [FatTheme] via `ThemeData.extensions` for fine-grained control:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       FatTheme(
///         codeFontSize: 14,
///         tableStretch: true,
///       ),
///     ],
///   ),
/// )
/// ```
library;

export 'src/fat_markdown.dart' show FatMarkdown;
export 'src/widgets/fat_config.dart' show FatMarkdownMode, FatMarkdownConfig;
export 'src/widgets/fat_node.dart' show FatMarkdownNodeList;
export 'src/fat_syntaxes.dart' show LatexBlockSyntax, LatexInlineSyntax;
export 'src/widgets/fat_theme.dart' show FatTheme;
export 'src/widgets/fat_blockquote.dart' show FatBlockquote;
export 'src/widgets/fat_checkbox.dart' show FatCheckbox;
export 'src/widgets/fat_code_block.dart' show FatCodeBlock;
export 'src/widgets/fat_heading.dart' show FatHeading;
export 'src/widgets/fat_image.dart' show FatImage;
export 'src/widgets/fat_inline_code.dart' show FatInlineCode;
export 'src/widgets/fat_link.dart' show FatLink, buildLinkSpan;
export 'src/widgets/fat_list.dart' show FatList;
export 'src/widgets/fat_math.dart' show FatMath;
export 'src/widgets/fat_scrollable_block.dart' show FatScrollableBlock;
export 'src/widgets/fat_table.dart' show FatTable;
export 'src/widgets/fat_tree_view.dart' show FatTreeViewNode;
