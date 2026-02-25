# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.9.0] - 2026-02-23

### Added
- `FatMarkdown` — the main widget, replacing the old versioned `FatMarkdownV4`.
- `FatMarkdownMode.treeview` — built-in debug mode that renders the raw AST.
- `FatTheme` — `ThemeExtension` for fine-grained styling (code font, block decoration,
  table border, divider color, etc.).
- `FatScrollableBlock` — reusable horizontal-scroll container for code, math, and tables.
- Inline LaTeX: `` $E=mc^2$ `` via `LatexInlineSyntax`.
- Block LaTeX via `LatexBlockSyntax` (fenced `$$` blocks).
- Syntax highlighting for 14 languages (Dart, JS/TS, Python, Go, Rust, etc.)
  with automatic light/dark theme detection.
- Copy-to-clipboard button in every code block header.
- Image tap handler with full-document image list for gallery support.
- `FatTable` — overridable `cell()`, `row()`, `table()` methods for custom rendering.
- `FatTable` stretch mode: fills available width or uses intrinsic width + horizontal scroll.
- `FatBlockquote`, `FatHeading`, `FatList`, `FatMath`, `FatLink`, `FatImage`,
  `FatInlineCode`, `FatCheckbox` — individual widgets, all customisable via subclassing.

### Changed
- **Breaking:** `FatMarkdownV4` is now `FatMarkdown`. Import from `package:fat_markdown/fat_markdown.dart`.
- Package structure reorganised: `lib/src/` for internals, single barrel `lib/fat_markdown.dart`.

### Removed
- `FatMarkdownV3` and all V3 source files.
- Standalone `FatMarkdownTreeView` widget (use `FatMarkdown(mode: FatMarkdownMode.treeview)` instead).

## [0.1.0] - 2026-02-06

### Added
- Initial release with basic Markdown rendering (V2/V3 iterations).
