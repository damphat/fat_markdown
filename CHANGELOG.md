# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.9.1] - 2026-02-26

### Changed
- **Breaking:** Renamed `FatTheme` to `FatMarkdownTheme` to avoid naming conflicts with other "Fat" libraries.
- Restricted exports in `fat_markdown.dart`: internal widgets in `src/widgets/` are no longer public.
- Moved configuration classes (`FatMarkdownTheme`, `FatMarkdownConfig`) out of the `widgets/` directory.

## [0.9.0] - 2026-02-23

### Added
- Initial release.
- `FatMarkdown` widget for rendering Markdown with high performance.
- Theme system for fine-grained styling (code font, block decoration, table border, divider color, etc.).
- Syntax highlighting for 14+ languages (Dart, JS/TS, Python, Go, Rust, etc.).
- LaTeX support for both inline and block equations.
- Horizontal scroll support for code, math, and tables.
- Interactive features: Copy-to-clipboard button, image tap handlers, and custom link rendering.
- Debug mode (`FatMarkdownMode.treeview`) to render raw AST.
- Highly customizable rendering via overridable widgets.

