import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Design tokens for [FatMarkdown]. Implement [ThemeExtension] so it can be
/// overridden via [ThemeData.extensions]:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       FatTheme(
///         codeFontSize: 14,
///         codeBlockBorderRadius: 12,
///         // Add border to blocks:
///         blockDecoration: BoxDecoration(
///           color: Colors.grey.shade100,
///           borderRadius: BorderRadius.circular(8),
///           border: Border.all(color: Colors.grey.shade300),
///         ),
///         // Show divider between header and code:
///         codeBlockDividerColor: Colors.grey,
///         // Show grid lines in table:
///         tableBorder: TableBorder.all(color: Colors.grey.shade300, width: 0.5),
///         // Stretch table to full width:
///         tableStretch: true,
///       ),
///     ],
///   ),
/// )
/// ```
class FatTheme extends ThemeExtension<FatTheme> {
  const FatTheme({
    this.codeFontFamily = 'RobotoMono',
    this.codeFontFamilyFallback = const ['SF Mono', 'Courier New', 'monospace'],
    this.codeFontSize = 13.0,
    this.inlineCodeFontSizeRatio = 0.88,
    this.inlineCodePadding = const EdgeInsets.symmetric(
      horizontal: 5,
      vertical: 1,
    ),
    this.codeBlockPadding = const EdgeInsets.all(12),
    this.codeBlockHeaderPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 4,
    ),
    this.headingTopSpacing = 12.0,
    this.blockquoteBorderWidth = 4.0,
    this.blockquotePaddingLeft = 16.0,
    this.inlineCodeBorderRadius = 4.0,
    this.codeBlockBorderRadius = 8.0,
    this.inlineStrutStyle = const StrutStyle(
      leading: 0.5,
      forceStrutHeight: false,
    ),
    this.blockDecoration,
    this.codeBlockDividerColor,
    this.tableBorder,
    this.tableStretch = false,
  });

  // ── Typography ────────────────────────────────────────────────────────────
  final String codeFontFamily;
  final List<String> codeFontFamilyFallback;

  /// Absolute font size for code blocks.
  final double codeFontSize;

  /// Font size ratio of inline code relative to surrounding text.
  final double inlineCodeFontSizeRatio;

  // ── Spacing ───────────────────────────────────────────────────────────────
  final EdgeInsetsGeometry inlineCodePadding;
  final EdgeInsetsGeometry codeBlockPadding;
  final EdgeInsetsGeometry codeBlockHeaderPadding;
  final double headingTopSpacing;
  final double blockquoteBorderWidth;
  final double blockquotePaddingLeft;

  // ── Border Radius ─────────────────────────────────────────────────────────
  final double inlineCodeBorderRadius;
  final double codeBlockBorderRadius;

  // ── Strut ─────────────────────────────────────────────────────────────────
  final StrutStyle inlineStrutStyle;

  // ── Block styling ─────────────────────────────────────────────────────────
  /// Decoration shared by code blocks and table containers.
  /// When `null`, each widget computes its default decoration from context
  /// (background `surfaceContainerLow` + border radius, no border).
  final BoxDecoration? blockDecoration;

  /// Color of the divider between code block header and content.
  /// - `null` (default): uses `colorScheme.outlineVariant`
  /// - `Colors.transparent`: hides the divider
  /// - Any other color: used as-is
  final Color? codeBlockDividerColor;

  /// Border inside the table (between cells and rows).
  /// - `null` (default): only horizontal lines between rows (`outlineVariant`)
  /// - `TableBorder()`: no lines at all
  /// - Explicit [TableBorder]: used as-is
  final TableBorder? tableBorder;

  /// When `true`, the table stretches to fill the available width.
  /// When `false` (default), the table uses its natural (intrinsic) width.
  final bool tableStretch;

  // ── Accessor ──────────────────────────────────────────────────────────────
  static const FatTheme _defaults = FatTheme();

  /// Returns [FatTheme] from context, falling back to defaults if not set.
  static FatTheme of(BuildContext context) =>
      Theme.of(context).extension<FatTheme>() ?? _defaults;

  // ── Helpers ───────────────────────────────────────────────────────────────
  TextStyle inlineCodeTextStyle(BuildContext context) {
    final base = DefaultTextStyle.of(context).style.fontSize;
    return TextStyle(
      fontFamily: codeFontFamily,
      fontFamilyFallback: codeFontFamilyFallback,
      fontSize: base != null ? base * inlineCodeFontSizeRatio : null,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  TextStyle codeBlockTextStyle(BuildContext context) => TextStyle(
    fontFamily: codeFontFamily,
    fontFamilyFallback: codeFontFamilyFallback,
    fontSize: codeFontSize,
    color: Theme.of(context).colorScheme.onSurface,
  );

  Color resolveDividerColor(BuildContext context) =>
      codeBlockDividerColor ?? Theme.of(context).colorScheme.outlineVariant;

  TableBorder? resolveTableBorder(BuildContext context) {
    if (tableBorder != null) return tableBorder;
    return TableBorder(
      horizontalInside: BorderSide(
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
    );
  }

  BoxDecoration resolveBlockDecoration(BuildContext context) {
    if (blockDecoration != null) return blockDecoration!;
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(codeBlockBorderRadius),
    );
  }

  // ── ThemeExtension ────────────────────────────────────────────────────────
  @override
  FatTheme copyWith({
    String? codeFontFamily,
    List<String>? codeFontFamilyFallback,
    double? codeFontSize,
    double? inlineCodeFontSizeRatio,
    EdgeInsetsGeometry? inlineCodePadding,
    EdgeInsetsGeometry? codeBlockPadding,
    EdgeInsetsGeometry? codeBlockHeaderPadding,
    double? headingTopSpacing,
    double? blockquoteBorderWidth,
    double? blockquotePaddingLeft,
    double? inlineCodeBorderRadius,
    double? codeBlockBorderRadius,
    StrutStyle? inlineStrutStyle,
    BoxDecoration? blockDecoration,
    Color? codeBlockDividerColor,
    TableBorder? tableBorder,
    bool? tableStretch,
  }) => FatTheme(
    codeFontFamily: codeFontFamily ?? this.codeFontFamily,
    codeFontFamilyFallback:
        codeFontFamilyFallback ?? this.codeFontFamilyFallback,
    codeFontSize: codeFontSize ?? this.codeFontSize,
    inlineCodeFontSizeRatio:
        inlineCodeFontSizeRatio ?? this.inlineCodeFontSizeRatio,
    inlineCodePadding: inlineCodePadding ?? this.inlineCodePadding,
    codeBlockPadding: codeBlockPadding ?? this.codeBlockPadding,
    codeBlockHeaderPadding:
        codeBlockHeaderPadding ?? this.codeBlockHeaderPadding,
    headingTopSpacing: headingTopSpacing ?? this.headingTopSpacing,
    blockquoteBorderWidth: blockquoteBorderWidth ?? this.blockquoteBorderWidth,
    blockquotePaddingLeft: blockquotePaddingLeft ?? this.blockquotePaddingLeft,
    inlineCodeBorderRadius:
        inlineCodeBorderRadius ?? this.inlineCodeBorderRadius,
    codeBlockBorderRadius: codeBlockBorderRadius ?? this.codeBlockBorderRadius,
    inlineStrutStyle: inlineStrutStyle ?? this.inlineStrutStyle,
    blockDecoration: blockDecoration ?? this.blockDecoration,
    codeBlockDividerColor: codeBlockDividerColor ?? this.codeBlockDividerColor,
    tableBorder: tableBorder ?? this.tableBorder,
    tableStretch: tableStretch ?? this.tableStretch,
  );

  @override
  FatTheme lerp(FatTheme? other, double t) {
    if (other == null) return this;
    return FatTheme(
      codeFontFamily: t < 0.5 ? codeFontFamily : other.codeFontFamily,
      codeFontFamilyFallback: t < 0.5
          ? codeFontFamilyFallback
          : other.codeFontFamilyFallback,
      codeFontSize: lerpDouble(codeFontSize, other.codeFontSize, t)!,
      inlineCodeFontSizeRatio: lerpDouble(
        inlineCodeFontSizeRatio,
        other.inlineCodeFontSizeRatio,
        t,
      )!,
      inlineCodePadding: EdgeInsetsGeometry.lerp(
        inlineCodePadding,
        other.inlineCodePadding,
        t,
      )!,
      codeBlockPadding: EdgeInsetsGeometry.lerp(
        codeBlockPadding,
        other.codeBlockPadding,
        t,
      )!,
      codeBlockHeaderPadding: EdgeInsetsGeometry.lerp(
        codeBlockHeaderPadding,
        other.codeBlockHeaderPadding,
        t,
      )!,
      headingTopSpacing: lerpDouble(
        headingTopSpacing,
        other.headingTopSpacing,
        t,
      )!,
      blockquoteBorderWidth: lerpDouble(
        blockquoteBorderWidth,
        other.blockquoteBorderWidth,
        t,
      )!,
      blockquotePaddingLeft: lerpDouble(
        blockquotePaddingLeft,
        other.blockquotePaddingLeft,
        t,
      )!,
      inlineCodeBorderRadius: lerpDouble(
        inlineCodeBorderRadius,
        other.inlineCodeBorderRadius,
        t,
      )!,
      codeBlockBorderRadius: lerpDouble(
        codeBlockBorderRadius,
        other.codeBlockBorderRadius,
        t,
      )!,
      inlineStrutStyle: t < 0.5 ? inlineStrutStyle : other.inlineStrutStyle,
      blockDecoration: t < 0.5 ? blockDecoration : other.blockDecoration,
      codeBlockDividerColor: Color.lerp(
        codeBlockDividerColor,
        other.codeBlockDividerColor,
        t,
      ),
      tableBorder: t < 0.5 ? tableBorder : other.tableBorder,
      tableStretch: t < 0.5 ? tableStretch : other.tableStretch,
    );
  }
}
