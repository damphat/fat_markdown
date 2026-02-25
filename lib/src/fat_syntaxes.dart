import 'package:markdown/markdown.dart' as md;

/// Syntax for inline LaTeX: `$E=mc^2$`
class LatexInlineSyntax extends md.InlineSyntax {
  LatexInlineSyntax() : super(r'\$((?:\\\$|[^$])+)\$');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(md.Element('latex', [md.Text(match[1]!)]));
    return true;
  }
}

/// Syntax for block LaTeX:
/// ```
/// $$
/// E=mc^2
/// $$
/// ```
class LatexBlockSyntax extends md.BlockSyntax {
  LatexBlockSyntax() : super();

  @override
  RegExp get pattern => RegExp(r'^(\s*)\$\$\s*$');

  @override
  md.Node? parse(md.BlockParser parser) {
    if (parser.isDone) return null;

    final match = pattern.firstMatch(parser.current.content);
    if (match == null) return null;

    final childLines = <String>[];
    parser.advance();

    while (!parser.isDone) {
      final currentLine = parser.current.content;
      if (pattern.hasMatch(currentLine)) {
        parser.advance();
        break;
      }
      childLines.add(currentLine);
      parser.advance();
    }

    // Always return element even when $$ is not closed, to avoid crash in live editor.
    return md.Element('latex-block', [md.Text(childLines.join('\n'))]);
  }
}

/// Syntax for `<br>` tags.
class BrSyntax extends md.InlineSyntax {
  BrSyntax() : super(r'<br\s*/?>', caseSensitive: false);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(md.Element.empty('br'));
    return true;
  }
}
