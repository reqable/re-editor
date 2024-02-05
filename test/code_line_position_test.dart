import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  group('CodeLinePosition constructor ', () {
    test('`CodeLinePosition()`', () {
      const CodeLinePosition position = CodeLinePosition(
        index: 1,
        offset: 2,
        affinity: TextAffinity.upstream
      );
      expect(position.index, 1);
      expect(position.offset, 2);
      expect(position.affinity, TextAffinity.upstream);
    });
    test('`CodeLinePosition.from()`', () {
      final CodeLinePosition position = CodeLinePosition.from(
        index: 1,
        position: const TextPosition(
          offset: 2,
          affinity: TextAffinity.upstream
        )
      );
      expect(position.index, 1);
      expect(position.offset, 2);
      expect(position.affinity, TextAffinity.upstream);
    });
  });

  group('CodeLinePosition method ', () {
    test('`copyWith`', () {
      const CodeLinePosition position = CodeLinePosition(
        index: 1,
        offset: 2,
        affinity: TextAffinity.downstream
      );
      expect(position.copyWith(), position);
      expect(position.copyWith(
        index: 0
      ), const CodeLinePosition(
        index: 0,
        offset: 2,
        affinity: TextAffinity.downstream
      ));
      expect(position.copyWith(
        offset: 0
      ), const CodeLinePosition(
        index: 1,
        offset: 0,
        affinity: TextAffinity.downstream
      ));
      expect(position.copyWith(
        affinity: TextAffinity.upstream
      ), const CodeLinePosition(
        index: 1,
        offset: 2,
        affinity: TextAffinity.upstream
      ));
      expect(position.copyWith(
        index: 0,
        offset: 0,
        affinity: TextAffinity.downstream
      ), const CodeLinePosition(
        index: 0,
        offset: 0,
        affinity: TextAffinity.downstream
      ));
    });
  });

  group('CodeLinePosition operator ', () {
    test('`==`', () {
      {
        final CodeLinePosition position1 = CodeLinePosition.from(
          index: 1,
          position: const TextPosition(
            offset: 2,
            affinity: TextAffinity.upstream
          )
        );
        final CodeLinePosition position2 = CodeLinePosition.from(
          index: 1,
          position: const TextPosition(
            offset: 2,
            affinity: TextAffinity.upstream
          )
        );
        expect(position1, position2);
      }
      {
        final CodeLinePosition position1 = CodeLinePosition.from(
          index: 1,
          position: const TextPosition(
            offset: 1,
            affinity: TextAffinity.upstream
          )
        );
        final CodeLinePosition position2 = CodeLinePosition.from(
          index: 2,
          position: const TextPosition(
            offset: 2,
            affinity: TextAffinity.upstream
          )
        );
        expect(position1 == position2, false);
      }
    });
  });
}