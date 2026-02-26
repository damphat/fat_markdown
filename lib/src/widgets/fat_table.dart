import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'fat_node.dart';
import '../fat_theme.dart';

class FatTable extends StatelessWidget {
  final md.Element element;

  const FatTable({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final ft = FatMarkdownTheme.of(context);
    final rows = <TableRow>[];
    bool isHead = false;

    for (var section in element.children ?? []) {
      if (section is md.Element &&
          (section.tag == 'thead' || section.tag == 'tbody')) {
        isHead = section.tag == 'thead';
        for (var rowElement in section.children ?? []) {
          if (rowElement is md.Element && rowElement.tag == 'tr') {
            final cells = <Widget>[];
            for (var cellElement in rowElement.children ?? []) {
              if (cellElement is md.Element) {
                final textAlign = switch (cellElement.attributes['align']) {
                  'center' => TextAlign.center,
                  'right' => TextAlign.right,
                  _ => TextAlign.left,
                };
                cells.add(cell(context, cellElement, textAlign, isHead));
              }
            }
            rows.add(row(context, cells, isHead));
          }
        }
      }
    }

    return table(context, rows, ft);
  }

  /// Builds a single table cell.
  Widget cell(
    BuildContext context,
    md.Element element,
    TextAlign textAlign,
    bool isHeader,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: DefaultTextStyle.merge(
        textAlign: textAlign,
        style: isHeader
            ? const TextStyle(fontWeight: FontWeight.bold)
            : const TextStyle(),
        child: FatMarkdownNodeList(
          nodes: element.children ?? [],
          isInlineGroup: true,
        ),
      ),
    );
  }

  /// Builds a table row.
  TableRow row(BuildContext context, List<Widget> cells, bool isHeader) {
    return TableRow(children: cells);
  }

  /// Builds the table widget.
  ///
  /// Always stretches to fill width AND scrolls when content overflows:
  /// - [Container] with `minWidth = parentWidth` keeps background full-width.
  /// - [SingleChildScrollView] handles overflow.
  Widget table(BuildContext context, List<TableRow> rows, FatMarkdownTheme ft) {
    final decoration = ft.resolveBlockDecoration(context);
    final border = ft.resolveTableBorder(context);
    final stretch = ft.tableStretch;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: decoration,
            constraints: BoxConstraints(
              minWidth: stretch ? constraints.maxWidth : 0,
              maxWidth: stretch ? constraints.maxWidth : double.infinity,
            ),
            clipBehavior: Clip.antiAlias,
            child: Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              border: border,
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: rows,
            ),
          ),
        );
      },
    );
  }
}
