import 'package:flutter_test/flutter_test.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  group('CodeLine getter ', () {
    test('`length`', () {
      {
        const CodeLine codeLine = CodeLine.empty;
        expect(codeLine.length, 0);
      }
      {
        const CodeLine codeLine = CodeLine('abc');
        expect(codeLine.length, 3);
      }
      {
        const CodeLine codeLine = CodeLine('abc', [
          CodeLine('foo'),
          CodeLine('bar')
        ]);
        expect(codeLine.length, 3);
      }
    });

    test('`chunkParent`', () {
      {
        const CodeLine codeLine = CodeLine('abc');
        expect(codeLine.chunkParent, false);
      }
      {
        const CodeLine codeLine = CodeLine('abc', [
          CodeLine('foo'),
          CodeLine('bar')
        ]);
        expect(codeLine.chunkParent, true);
      }
    });

    test('`lineCount`', () {
      {
        const CodeLine codeLine = CodeLine.empty;
        expect(codeLine.lineCount, 1);
      }
      {
        const CodeLine codeLine = CodeLine('abc');
        expect(codeLine.lineCount, 1);
      }
      {
        const CodeLine codeLine = CodeLine('abc', [
          CodeLine('foo'),
          CodeLine('bar')
        ]);
        expect(codeLine.lineCount, 3);
      }
      {
        const CodeLine codeLine = CodeLine('abc', [
          CodeLine('foo', [
            CodeLine('inner', [
              CodeLine('inner1'),
              CodeLine('inner2'),
              CodeLine('inner3'),
            ])
          ]),
          CodeLine('bar', [
            CodeLine('inner', [
              CodeLine('inner4'),
              CodeLine('inner5'),
              CodeLine('inner6'),
              CodeLine('inner7'),
            ])
          ]),
        ]);
        expect(codeLine.lineCount, 12);
      }
    });

    test('`charCount`', () {
      {
        const CodeLine codeLine = CodeLine.empty;
        expect(codeLine.charCount, 0);
      }
      {
        const CodeLine codeLine = CodeLine('abc');
        expect(codeLine.charCount, 3);
      }
      {
        const CodeLine codeLine = CodeLine('abc', [
          CodeLine('foo'),
          CodeLine('bar')
        ]);
        expect(codeLine.charCount, 9);
      }
      {
        const CodeLine codeLine = CodeLine('abc', [
          CodeLine('foo', [
            CodeLine('inner', [
              CodeLine('inner1'),
              CodeLine('inner2'),
              CodeLine('inner3'),
            ])
          ]),
          CodeLine('bar', [
            CodeLine('inner', [
              CodeLine('inner4'),
              CodeLine('inner5'),
              CodeLine('inner6'),
              CodeLine('inner7'),
            ])
          ]),
        ]);
        expect(codeLine.charCount, 61);
      }
    });
  });

  group('CodeLine method ', () {
    test('`toString()`', () {
      {
        const CodeLine codeLine = CodeLine('abc');
        expect(codeLine.toString(), 'abc');
      }
      {
        const CodeLine codeLine = CodeLine('abc', [
          CodeLine('foo'),
          CodeLine('bar')
        ]);
        expect(codeLine.toString(), 'abc');
      }
    });

    test('`asString()`', () {
      {
        const CodeLine codeLine = CodeLine('abc');
        expect(codeLine.asString(0, TextLineBreak.lf), 'abc');
        expect(codeLine.asString(1, TextLineBreak.lf), 'bc');
        expect(codeLine.asString(3, TextLineBreak.lf), '');
      }
      {
        const CodeLine codeLine = CodeLine('abc', [
          CodeLine('foo'),
          CodeLine('bar')
        ]);
        expect(codeLine.asString(0, TextLineBreak.lf), 'abc\nfoo\nbar');
        expect(codeLine.asString(0, TextLineBreak.crlf), 'abc\r\nfoo\r\nbar');
        expect(codeLine.asString(1, TextLineBreak.lf), 'bc\nfoo\nbar');
        expect(codeLine.asString(3, TextLineBreak.lf), '\nfoo\nbar');
      }
      {
        const CodeLine codeLine = CodeLine('abc', [
          CodeLine('foo'),
          CodeLine('bar'),
          CodeLine('123', [
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        ]);
        expect(codeLine.asString(0, TextLineBreak.lf), 'abc\nfoo\nbar\n123\nfoo\nbar');
      }
    });

    test('`flat()`', () {
      {
        const CodeLine codeLine = CodeLine('abc');
        expect(codeLine.flat(), const ['abc']);
      }
      {
        const CodeLine codeLine = CodeLine('abc', [
          CodeLine('foo'),
          CodeLine('bar')
        ]);
        expect(codeLine.flat(), const ['abc', 'foo', 'bar']);
      }
      {
        const CodeLine codeLine = CodeLine('abc', [
          CodeLine('foo'),
          CodeLine('bar'),
          CodeLine('123', [
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        ]);
        expect(codeLine.flat(), const ['abc', 'foo', 'bar', '123', 'foo', 'bar']);
      }
    });

    test('`copyWith()`', () {
      {
        const CodeLine codeLine = CodeLine('abc');
        expect(codeLine.copyWith(), codeLine);
      }
      {
        const CodeLine codeLine = CodeLine('abc', [
          CodeLine('foo'),
          CodeLine('bar')
        ]);
        expect(codeLine.copyWith(), codeLine);
      }
      {
        final CodeLine codeLine = const CodeLine('abc', [
          CodeLine('foo'),
          CodeLine('bar')
        ]).copyWith(
          text: '123',
        );
        expect(codeLine.text, '123');
        expect(codeLine.chunks, const [
          CodeLine('foo'),
          CodeLine('bar')
        ]);
      }
      {
        final CodeLine codeLine = const CodeLine('abc', [
          CodeLine('foo'),
          CodeLine('bar')
        ]).copyWith(
          text: '123',
          chunks: const []
        );
        expect(codeLine.text, '123');
        expect(codeLine.chunks, const []);
      }
    });
  });

  group('CodeLine operator ', () {
    test('`==`', () {
      {
        final CodeLine codeLine1 = CodeLine('abc' * 1);
        final CodeLine codeLine2 = CodeLine('abc' * 1);
        expect(codeLine1, codeLine2);
      }
      {
        final CodeLine codeLine1 = CodeLine('abc' * 1, [
          CodeLine('foo' * 1),
          CodeLine('bar' * 1)
        ]);
        final CodeLine codeLine2 = CodeLine('abc' * 1, [
          CodeLine('foo' * 1),
          CodeLine('bar' * 1)
        ]);
        expect(codeLine1, codeLine2);
      }
      {
        final CodeLine codeLine1 = CodeLine('abc' * 1, [
          const CodeLine('foo'),
          const CodeLine('bar')
        ]);
        final CodeLine codeLine2 = CodeLine('abc' * 2, [
          const CodeLine('foo'),
          const CodeLine('bar')
        ]);
        expect(codeLine1 == codeLine2, false);
      }
      {
        final CodeLine codeLine1 = CodeLine('abc' * 1, [
          CodeLine('foo' * 1),
          CodeLine('bar' * 1)
        ]);
        final CodeLine codeLine2 = CodeLine('abc' * 1, [
          CodeLine('foo' * 2),
          CodeLine('bar' * 2)
        ]);
        expect(codeLine1 == codeLine2, false);
      }
    });
  });
}