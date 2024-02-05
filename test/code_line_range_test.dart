import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  group('CodeLineRange constructor ', () {
    test('`CodeLineRange()`', () {
      const CodeLineRange range = CodeLineRange(
        index: 1,
        start: 2,
        end: 3
      );
      expect(range.index, 1);
      expect(range.start, 2);
      expect(range.end, 3);
    });

    test('`CodeLineRange.from()`', () {
      final CodeLineRange range = CodeLineRange.from(
        index: 1,
        range: const TextRange(
          start: 2,
          end: 3
        )
      );
      expect(range.index, 1);
      expect(range.start, 2);
      expect(range.end, 3);
    });

    test('`CodeLineRange.collapsed()`', () {
      const CodeLineRange range = CodeLineRange.collapsed(
        index: 1,
        offset: 2
      );
      expect(range.index, 1);
      expect(range.start, 2);
      expect(range.end, 2);
    });

    test('`CodeLineRange.empty()`', () {
      const CodeLineRange range = CodeLineRange.empty();
      expect(range.index, 0);
      expect(range.start, -1);
      expect(range.end, -1);
    });
  });

  group('CodeLineRange method ', () {
    test('`copyWith`', () {
      const CodeLineRange range = CodeLineRange(
        index: 1,
        start: 2,
        end: 3
      );
      expect(range.copyWith(), range);
      expect(range.copyWith(
        index: 0
      ), const CodeLineRange(
        index: 0,
        start: 2,
        end: 3
      ));
      expect(range.copyWith(
        start: 0
      ), const CodeLineRange(
        index: 1,
        start: 0,
        end: 3
      ));
      expect(range.copyWith(
        end: 0
      ), const CodeLineRange(
        index: 1,
        start: 2,
        end: 0
      ));
      expect(range.copyWith(
        index: 0,
        start: 0,
        end: 0
      ), const CodeLineRange(
        index: 0,
        start: 0,
        end: 0
      ));
    });
  });

  group('CodeLineRange operator ', () {
    test('`==`', () {
      {
        final CodeLineRange range1 = CodeLineRange.from(
          index: 1,
          range: const TextRange(
            start: 2,
            end: 3
          )
        );
        final CodeLineRange range2 = CodeLineRange.from(
          index: 1,
          range: const TextRange(
            start: 2,
            end: 3
          )
        );
        expect(range1, range2);
      }
      {
        final CodeLineRange range1 = CodeLineRange.from(
          index: 1,
          range: const TextRange(
            start: 2,
            end: 3
          )
        );
        final CodeLineRange range2 = CodeLineRange.from(
          index: 2,
          range: const TextRange(
            start: 2,
            end: 3
          )
        );
        expect(range1 == range2, false);
      }
    });
  });
}