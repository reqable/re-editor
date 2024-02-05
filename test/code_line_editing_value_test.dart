import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  group('CodeLineEditingValue constructor ', () {
    test('`CodeLineEditingValue()`', () {
      {
        final CodeLineEditingValue value = CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc')
          ])
        );
        expect(value.codeLines, CodeLines.of(const [
          CodeLine('abc')
        ]));
        expect(value.selection, const CodeLineSelection.zero());
        expect(value.composing, TextRange.empty);
      }
      {
        final CodeLineEditingValue value = CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc')
          ]),
          selection: const CodeLineSelection.collapsed(
            index: 0,
            offset: 1
          ),
          composing: const TextRange(
            start: 1,
            end: 2
          )
        );
        expect(value.codeLines, CodeLines.of(const [
          CodeLine('abc')
        ]));
        expect(value.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        expect(value.composing, const  TextRange(
          start: 1,
          end: 2
        ));
      }
    });

    test('`CodeLineEditingValue.empty()`', () {
      const CodeLineEditingValue value = CodeLineEditingValue.empty();
      expect(value.codeLines, CodeLines.of(const [
        CodeLine.empty
      ]));
      expect(value.selection, const CodeLineSelection.zero());
      expect(value.composing, TextRange.empty);
    });
  });

  group('CodeLineEditingValue method ', () {
    test('`copyWith()`', () {
      final CodeLineEditingValue value = CodeLineEditingValue(
        codeLines: CodeLines.of(const [
          CodeLine('abc')
        ]),
        selection: const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ),
        composing: const TextRange(
          start: 1,
          end: 2
        )
      );
      expect(value.copyWith(), value);
      expect(value.copyWith(
        codeLines: CodeLines.of(const [
          CodeLine('foo'),
          CodeLine('bar')
        ])
      ), CodeLineEditingValue(
        codeLines: CodeLines.of(const [
          CodeLine('foo'),
          CodeLine('bar')
        ]),
        selection: const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ),
        composing: const TextRange(
          start: 1,
          end: 2
        )
      ));
      expect(value.copyWith(
        selection: const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ),
      ), CodeLineEditingValue(
        codeLines: CodeLines.of(const [
          CodeLine('abc')
        ]),
        selection: const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ),
        composing: const TextRange(
          start: 1,
          end: 2
        )
      ));
      expect(value.copyWith(
        composing: const TextRange(
          start: 2,
          end: 3
        )
      ), CodeLineEditingValue(
        codeLines: CodeLines.of(const [
          CodeLine('abc')
        ]),
        selection: const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ),
        composing: const TextRange(
          start: 2,
          end: 3
        )
      ));
    });
  });

  group('CodeLineEditingValue operator ', () {
    test('`==`', () {
      {
        final CodeLineEditingValue value1 = CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc')
          ]),
          selection: const CodeLineSelection.collapsed(
            index: 0,
            offset: 0
          ),
          composing: const TextRange(
            start: 0,
            end: 0
          )
        );
        final CodeLineEditingValue value2 = CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc')
          ]),
          selection: const CodeLineSelection.collapsed(
            index: 0,
            offset: 0
          ),
          composing: const TextRange(
            start: 0,
            end: 0
          )
        );
        expect(value1, value2);
      }
      {
        final CodeLineEditingValue value1 = CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc')
          ]),
          selection: const CodeLineSelection.collapsed(
            index: 0,
            offset: 0
          ),
          composing: const TextRange(
            start: 0,
            end: 0
          )
        );
        final CodeLineEditingValue value2 = CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('foobar')
          ]),
          selection: const CodeLineSelection.collapsed(
            index: 0,
            offset: 0
          ),
          composing: const TextRange(
            start: 0,
            end: 0
          )
        );
        expect(value1 != value2, true);
      }
      {
        final CodeLineEditingValue value1 = CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc')
          ]),
          selection: const CodeLineSelection.collapsed(
            index: 0,
            offset: 0
          ),
          composing: const TextRange(
            start: 0,
            end: 0
          )
        );
        final CodeLineEditingValue value2 = CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc')
          ]),
          selection: const CodeLineSelection.collapsed(
            index: 0,
            offset: 1
          ),
          composing: const TextRange(
            start: 0,
            end: 0
          )
        );
        expect(value1 != value2, true);
      }
      {
        final CodeLineEditingValue value1 = CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc')
          ]),
          selection: const CodeLineSelection.collapsed(
            index: 0,
            offset: 0
          ),
          composing: const TextRange(
            start: 0,
            end: 0
          )
        );
        final CodeLineEditingValue value2 = CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc')
          ]),
          selection: const CodeLineSelection.collapsed(
            index: 0,
            offset: 0
          ),
          composing: const TextRange(
            start: 1,
            end: 0
          )
        );
        expect(value1 != value2, true);
      }
    });
  });
}