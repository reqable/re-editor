import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  const DefaultCodeChunkAnalyzer analyzer = DefaultCodeChunkAnalyzer();
  group('DefaultCodeChunkAnalyzer.parse()', () {
    test('A single code line with empty content', () {
      {
        final CodeLines codeLines = CodeLines.of([
          CodeLine.empty
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
    });
    test('A single code line without quota', () {
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('abc')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('(')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('(', 0)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine(')')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol(')', 0)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('[')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('[', 0)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine(']')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol(']', 0)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('{')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('{', 0)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('}')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('}', 0)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('()')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('(', 0),
          CodeChunkSymbol(')', 0)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('[]')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('[', 0),
          CodeChunkSymbol(']', 0)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('{}')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('{', 0),
          CodeChunkSymbol('}', 0)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('()[]{}')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('(', 0),
          CodeChunkSymbol(')', 0),
          CodeChunkSymbol('[', 0),
          CodeChunkSymbol(']', 0),
          CodeChunkSymbol('{', 0),
          CodeChunkSymbol('}', 0)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('123{[foo]((abc))[[]]{{bar}}()}')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('{', 0),
          CodeChunkSymbol('[', 0),
          CodeChunkSymbol(']', 0),
          CodeChunkSymbol('(', 0),
          CodeChunkSymbol('(', 0),
          CodeChunkSymbol(')', 0),
          CodeChunkSymbol(')', 0),
          CodeChunkSymbol('[', 0),
          CodeChunkSymbol('[', 0),
          CodeChunkSymbol(']', 0),
          CodeChunkSymbol(']', 0),
          CodeChunkSymbol('{', 0),
          CodeChunkSymbol('{', 0),
          CodeChunkSymbol('}', 0),
          CodeChunkSymbol('}', 0),
          CodeChunkSymbol('(', 0),
          CodeChunkSymbol(')', 0),
          CodeChunkSymbol('}', 0),
        ]);
      }
    });

    test('A single code line with quotas', () {
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('"')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('\'')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('\\"\\"')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('\\\'\\\'')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('"abc"')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('\'abc\'')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('"\'abc\'"')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('"("')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('\'(\'')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('"()[]{}"')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('\'()[]{}\'')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('"\'()[]{}\'"')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('\\"\'()[]{}\'\\"')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('""(')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('(', 0),
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('""(""')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('(', 0),
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('""("")')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('(', 0),
          CodeChunkSymbol(')', 0),
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('\'\'(')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('(', 0),
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('\'\'(\'\'')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('(', 0),
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('\'\'(\'\')')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('(', 0),
          CodeChunkSymbol(')', 0),
        ]);
      }
    });

    test('A single code line with unbalanced quotas', () {
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('\'(')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('"(')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('\'(\'\')')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('"\'()[]{}')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('"\'()"[]')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('[', 0),
          CodeChunkSymbol(']', 0),
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('"\\"()"[]')
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('[', 0),
          CodeChunkSymbol(']', 0),
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('\\"()"[]')
        ]);
        expect(analyzer.parse(codeLines), const []);
      }
    });

    test('Multi code lines', () {
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('()'),
          CodeLine('[]'),
          CodeLine('{}'),
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('(', 0),
          CodeChunkSymbol(')', 0),
          CodeChunkSymbol('[', 1),
          CodeChunkSymbol(']', 1),
          CodeChunkSymbol('{', 2),
          CodeChunkSymbol('}', 2),
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('('),
          CodeLine('{'),
          CodeLine('['),
          CodeLine('inner1'),
          CodeLine('inner2'),
          CodeLine('inner3'),
          CodeLine(']'),
          CodeLine('{'),
          CodeLine('inner'),
          CodeLine('inner4'),
          CodeLine('inner5'),
          CodeLine('inner6'),
          CodeLine('inner7'),
          CodeLine('}'),
          CodeLine('}'),
          CodeLine(')'),
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('(', 0),
          CodeChunkSymbol('{', 1),
          CodeChunkSymbol('[', 2),
          CodeChunkSymbol(']', 6),
          CodeChunkSymbol('{', 7),
          CodeChunkSymbol('}', 13),
          CodeChunkSymbol('}', 14),
          CodeChunkSymbol(')', 15),
        ]);
      }
      // Half collapsed code lines
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('('),
          CodeLine('[', [
            CodeLine('inner1'),
            CodeLine('inner2'),
            CodeLine('inner3'),
          ]),
          CodeLine(']'),
          CodeLine(')'),
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('(', 0),
          CodeChunkSymbol('[', 1),
          CodeChunkSymbol(']', 2),
          CodeChunkSymbol(')', 3),
        ]);
      }
      // All collapsed code lines
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('(', [
            CodeLine('{', [
              CodeLine('[', [
                CodeLine('inner1'),
                CodeLine('inner2'),
                CodeLine('inner3'),
              ])
            ]),
            CodeLine(']'),
            CodeLine('{', [
              CodeLine('inner', [
                CodeLine('inner4'),
                CodeLine('inner5'),
                CodeLine('inner6'),
                CodeLine('inner7'),
              ])
            ]),
            CodeLine('}'),
            CodeLine('}'),
          ]),
          CodeLine(')'),
        ]);
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('(', 0),
          CodeChunkSymbol(')', 1),
        ]);
      }
    });

    test('Parse a json string', () {
      {
        final CodeLines codeLines = CodeLineUtils.toCodeLines(File(join('test', 'data', 'json_pretty.json')).readAsStringSync());
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('{', 0),
          CodeChunkSymbol('{', 1),
          CodeChunkSymbol('[', 2),
          CodeChunkSymbol(']', 4),
          CodeChunkSymbol('}', 5),
          CodeChunkSymbol('[', 6),
          CodeChunkSymbol('{', 7),
          CodeChunkSymbol('}', 10),
          CodeChunkSymbol('{', 11),
          CodeChunkSymbol('}', 14),
          CodeChunkSymbol(']', 15),
          CodeChunkSymbol('}', 17),
        ]);
      }
      {
        final CodeLines codeLines = CodeLineUtils.toCodeLines(File(join('test', 'data', 'json_flatted.json')).readAsStringSync());
        expect(analyzer.parse(codeLines), const [
          CodeChunkSymbol('{', 0),
          CodeChunkSymbol('{', 0),
          CodeChunkSymbol('[', 0),
          CodeChunkSymbol(']', 0),
          CodeChunkSymbol('}', 0),
          CodeChunkSymbol('[', 0),
          CodeChunkSymbol('{', 0),
          CodeChunkSymbol('}', 0),
          CodeChunkSymbol('{', 0),
          CodeChunkSymbol('}', 0),
          CodeChunkSymbol(']', 0),
          CodeChunkSymbol('}', 0),
        ]);
      }
    });
  });

  group('DefaultCodeChunkAnalyzer.run()', () {
    test('A single code line', () {
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine.empty
        ]);
        expect(analyzer.run(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('abc')
        ]);
        expect(analyzer.run(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('abc(){}[]')
        ]);
        expect(analyzer.run(codeLines), const []);
      }
    });
    test('Multi code lines', () {
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine.empty,
          CodeLine.empty,
          CodeLine.empty,
          CodeLine.empty,
          CodeLine.empty,
        ]);
        expect(analyzer.run(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('abc'),
          CodeLine('abc'),
          CodeLine('abc'),
          CodeLine('abc'),
        ]);
        expect(analyzer.run(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('abc(){}[]'),
          CodeLine('abc(){}[]'),
          CodeLine('abc(){}[]'),
          CodeLine('abc(){}[]'),
          CodeLine('abc(){}[]'),
        ]);
        expect(analyzer.run(codeLines), const []);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('abc('),
          CodeLine('abc'),
          CodeLine('abc'),
          CodeLine('abc'),
          CodeLine('abc)'),
        ]);
        expect(analyzer.run(codeLines), const [
          CodeChunk(0, 4)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('abc('),
          CodeLine('abc['),
          CodeLine('abc{}'),
          CodeLine('abc]'),
          CodeLine('abc)'),
        ]);
        expect(analyzer.run(codeLines), const [
          CodeChunk(0, 4),
          CodeChunk(1, 3)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('{'),
          CodeLine('}'),
          CodeLine('{'),
          CodeLine('}'),
          CodeLine('{'),
          CodeLine('}'),
        ]);
        expect(analyzer.run(codeLines), const [
          CodeChunk(0, 1),
          CodeChunk(2, 3),
          CodeChunk(4, 5)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('abc('),
          CodeLine('abc[[[['),
          CodeLine('abc'),
          CodeLine('abc]]]]'),
          CodeLine('abc)'),
        ]);
        expect(analyzer.run(codeLines), const [
          CodeChunk(0, 4),
          CodeChunk(1, 3)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('abc('),
          CodeLine('[[[['),
          CodeLine('abc'),
          CodeLine(']'),
          CodeLine(']'),
          CodeLine(']'),
          CodeLine(']'),
          CodeLine('abc)'),
        ]);
        expect(analyzer.run(codeLines), const [
          CodeChunk(0, 7),
          CodeChunk(1, 3)
        ]);
      }
      {
        final CodeLines codeLines = CodeLines.of(const [
          CodeLine('abc('),
          CodeLine('abc['),
          CodeLine('abc'),
          CodeLine('abc['),
          CodeLine('abc)'),
        ]);
        expect(analyzer.run(codeLines), const [
          CodeChunk(0, 4),
        ]);
      }
    });
    test('Parse a json string', () {
      {
        final CodeLines codeLines = CodeLineUtils.toCodeLines(File(join('test', 'data', 'json_pretty.json')).readAsStringSync());
        expect(analyzer.run(codeLines), const [
          CodeChunk(0, 17),
          CodeChunk(1, 5),
          CodeChunk(2, 4),
          CodeChunk(6, 15),
          CodeChunk(7, 10),
          CodeChunk(11, 14)
        ]);
      }
      {
        final CodeLines codeLines = CodeLineUtils.toCodeLines(File(join('test', 'data', 'json_flatted.json')).readAsStringSync());
        expect(analyzer.run(codeLines), const []);
      }
    });
  });
}