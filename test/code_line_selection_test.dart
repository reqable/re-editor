import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  group('CodeLineSelection constructor ', () {
    test('`CodeLineSelection()`', () {
      const CodeLineSelection selection = CodeLineSelection(
        baseIndex: 1,
        baseOffset: 2,
        extentIndex: 3,
        extentOffset: 4,
        baseAffinity: TextAffinity.upstream
      );
      expect(selection.baseIndex, 1);
      expect(selection.baseOffset, 2);
      expect(selection.extentIndex, 3);
      expect(selection.extentOffset, 4);
      expect(selection.baseAffinity, TextAffinity.upstream);
    });
    test('`CodeLineSelection.collapsed()`', () {
      const CodeLineSelection selection = CodeLineSelection.collapsed(
        index: 1,
        offset: 2,
        affinity: TextAffinity.upstream
      );
      expect(selection.baseIndex, 1);
      expect(selection.baseOffset, 2);
      expect(selection.extentIndex, 1);
      expect(selection.extentOffset, 2);
      expect(selection.baseAffinity, TextAffinity.upstream);
    });
    test('`CodeLineSelection.fromPosition()`', () {
      final CodeLineSelection selection = CodeLineSelection.fromPosition(
        position: const CodeLinePosition(
          index: 1,
          offset: 2,
          affinity: TextAffinity.upstream
        )
      );
      expect(selection.baseIndex, 1);
      expect(selection.baseOffset, 2);
      expect(selection.extentIndex, 1);
      expect(selection.extentOffset, 2);
      expect(selection.baseAffinity, TextAffinity.upstream);
    });
    test('`CodeLineSelection.fromRange()`', () {
      final CodeLineSelection selection = CodeLineSelection.fromRange(
        range: const CodeLineRange(
          index: 1,
          start: 2,
          end: 3
        )
      );
      expect(selection.baseIndex, 1);
      expect(selection.baseOffset, 2);
      expect(selection.extentIndex, 1);
      expect(selection.extentOffset, 3);
      expect(selection.baseAffinity, TextAffinity.downstream);
    });
    test('`CodeLineSelection.fromTextSelection()`', () {
      final CodeLineSelection selection = CodeLineSelection.fromTextSelection(
        index: 1,
        selection: const TextSelection(
          baseOffset: 2,
          extentOffset: 3,
          affinity: TextAffinity.upstream
        )
      );
      expect(selection.baseIndex, 1);
      expect(selection.baseOffset, 2);
      expect(selection.extentIndex, 1);
      expect(selection.extentOffset, 3);
      expect(selection.baseAffinity, TextAffinity.upstream);
    });
    test('`CodeLineSelection.zero()`', () {
      const CodeLineSelection selection = CodeLineSelection.zero();
      expect(selection.baseIndex, 0);
      expect(selection.baseOffset, 0);
      expect(selection.extentIndex, 0);
      expect(selection.extentOffset, 0);
      expect(selection.baseAffinity, TextAffinity.downstream);
    });
  });

  group('CodeLineSelection getter ', () {
    test('`base`', () {
      // Multi code line selected and base before extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 1,
        );
        expect(selection.base, const CodeLinePosition(
          index: 0,
          offset: 0,
          affinity: TextAffinity.downstream
        ));
      }
      // Multi code line selected and base after extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          extentIndex: 0,
          extentOffset: 0,
          baseIndex: 1,
          baseOffset: 1,
        );
        expect(selection.base, const CodeLinePosition(
          index: 1,
          offset: 1,
          affinity: TextAffinity.downstream
        ));
      }
      // Single code line selected and base before extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 1,
        );
        expect(selection.base, const CodeLinePosition(
          index: 0,
          offset: 0,
          affinity: TextAffinity.downstream
        ));
      }
      // Single code line selected and base after extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          extentIndex: 0,
          extentOffset: 0,
          baseIndex: 0,
          baseOffset: 1,
        );
        expect(selection.base, const CodeLinePosition(
          index: 0,
          offset: 1,
          affinity: TextAffinity.downstream
        ));
      }
      // collapsed and upstream
      {
        const CodeLineSelection selection = CodeLineSelection.collapsed(
          index: 0,
          offset: 0,
          affinity: TextAffinity.upstream
        );
        expect(selection.base, const CodeLinePosition(
          index: 0,
          offset: 0,
          affinity: TextAffinity.upstream
        ));
      }
      // collapsed and downstream
      {
        const CodeLineSelection selection = CodeLineSelection.collapsed(
          index: 0,
          offset: 0,
          affinity: TextAffinity.downstream
        );
        expect(selection.base, const CodeLinePosition(
          index: 0,
          offset: 0,
          affinity: TextAffinity.downstream
        ));
      }
    });

    test('`extent`', () {
      // Multi code line selected and base before extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 1,
        );
        expect(selection.extent, const CodeLinePosition(
          index: 1,
          offset: 1,
          affinity: TextAffinity.downstream
        ));
      }
      // Multi code line selected and base after extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          extentIndex: 0,
          extentOffset: 0,
          baseIndex: 1,
          baseOffset: 1,
        );
        expect(selection.extent, const CodeLinePosition(
          index: 0,
          offset: 0,
          affinity: TextAffinity.downstream
        ));
      }
      // Single code line selected and base before extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 1,
        );
        expect(selection.extent, const CodeLinePosition(
          index: 0,
          offset: 1,
          affinity: TextAffinity.downstream
        ));
      }
      // Single code line selected and base after extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          extentIndex: 0,
          extentOffset: 0,
          baseIndex: 0,
          baseOffset: 1,
        );
        expect(selection.extent, const CodeLinePosition(
          index: 0,
          offset: 0,
          affinity: TextAffinity.downstream
        ));
      }
      // collapsed and upstream
      {
        const CodeLineSelection selection = CodeLineSelection.collapsed(
          index: 0,
          offset: 0,
          affinity: TextAffinity.upstream
        );
        expect(selection.extent, const CodeLinePosition(
          index: 0,
          offset: 0,
          affinity: TextAffinity.upstream
        ));
      }
      // collapsed and downstream
      {
        const CodeLineSelection selection = CodeLineSelection.collapsed(
          index: 0,
          offset: 0,
          affinity: TextAffinity.downstream
        );
        expect(selection.extent, const CodeLinePosition(
          index: 0,
          offset: 0,
          affinity: TextAffinity.downstream
        ));
      }
    });

    test('`start`', () {
      // Multi code line selected and base before extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 1,
        );
        expect(selection.start, selection.base);
      }
      // Multi code line selected and base after extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          extentIndex: 0,
          extentOffset: 0,
          baseIndex: 1,
          baseOffset: 1,
        );
        expect(selection.start, selection.extent);
      }
      // Single code line selected and base before extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 1,
        );
        expect(selection.start, selection.base);
      }
      // Single code line selected and base after extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          extentIndex: 0,
          extentOffset: 0,
          baseIndex: 0,
          baseOffset: 1,
        );
        expect(selection.start, selection.extent);
      }
      // collapsed
      {
        const CodeLineSelection selection = CodeLineSelection.collapsed(
          index: 0,
          offset: 0,
        );
        expect(selection.start, selection.base);
        expect(selection.start, selection.extent);
      }
    });

    test('`end`', () {
      // Multi code line selected and base before extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 1,
        );
        expect(selection.start, selection.base);
      }
      // Multi code line selected and base after extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          extentIndex: 0,
          extentOffset: 0,
          baseIndex: 1,
          baseOffset: 1,
        );
        expect(selection.start, selection.extent);
      }
      // Single code line selected and base before extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 1,
        );
        expect(selection.start, selection.base);
      }
      // Single code line selected and base after extent
      {
        const CodeLineSelection selection = CodeLineSelection(
          extentIndex: 0,
          extentOffset: 0,
          baseIndex: 0,
          baseOffset: 1,
        );
        expect(selection.start, selection.extent);
      }
      // collapsed
      {
        const CodeLineSelection selection = CodeLineSelection.collapsed(
          index: 0,
          offset: 0,
        );
        expect(selection.start, selection.base);
        expect(selection.start, selection.extent);
      }
    });

    test('`startIndex`', () {
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 1,
        );
        expect(selection.startIndex, 0);
      }
      {
        const CodeLineSelection selection = CodeLineSelection(
          extentIndex: 0,
          extentOffset: 0,
          baseIndex: 1,
          baseOffset: 1,
        );
        expect(selection.startIndex, 0);
      }
    });

    test('`startOffset`', () {
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 1,
        );
        expect(selection.startOffset, 0);
      }
      {
        const CodeLineSelection selection = CodeLineSelection(
          extentIndex: 0,
          extentOffset: 0,
          baseIndex: 1,
          baseOffset: 1,
        );
        expect(selection.startOffset, 0);
      }
    });

    test('`endIndex`', () {
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 1,
        );
        expect(selection.endIndex, 1);
      }
      {
        const CodeLineSelection selection = CodeLineSelection(
          extentIndex: 0,
          extentOffset: 0,
          baseIndex: 1,
          baseOffset: 1,
        );
        expect(selection.endIndex, 1);
      }
    });

    test('`endOffset`', () {
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 1,
        );
        expect(selection.endOffset, 1);
      }
      {
        const CodeLineSelection selection = CodeLineSelection(
          extentIndex: 0,
          extentOffset: 0,
          baseIndex: 1,
          baseOffset: 1,
        );
        expect(selection.endOffset, 1);
      }
    });

    test('`isCollapsed`', () {
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 0,
        );
        expect(selection.isCollapsed, true);
      }
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 1,
        );
        expect(selection.isCollapsed, false);
      }
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 0,
        );
        expect(selection.isCollapsed, false);
      }
    });

    test('`isSameLine`', () {
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 0,
        );
        expect(selection.isSameLine, true);
      }
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 1,
        );
        expect(selection.isSameLine, true);
      }
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 0,
        );
        expect(selection.isSameLine, false);
      }
    });
  });

  group('CodeLineSelection method ', () {
    test('`contains()`', () {
      // Collapsed
      {
        const CodeLineSelection selection = CodeLineSelection.collapsed(
          index: 0,
          offset: 0
        );
        expect(selection.contains(selection), true);
        expect(selection.contains(const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        )), false);
      }
      // Single code line
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 3,
        );
        expect(selection.contains(selection), true);
        expect(selection.contains(const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        )), true);
        expect(selection.contains(const CodeLineSelection.collapsed(
          index: 0,
          offset: 4
        )), false);
        expect(selection.contains(const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 1
        )), true);
      }
      // Multi code line
      {
        const CodeLineSelection selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 3,
          extentOffset: 3,
        );
        expect(selection.contains(selection), true);
        expect(selection.contains(const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        )), true);
        expect(selection.contains(const CodeLineSelection.collapsed(
          index: 0,
          offset: 4
        )), true);
        expect(selection.contains(const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 1000
        )), true);
        expect(selection.contains(const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 1000
        )), true);
        expect(selection.contains(const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 3,
          extentOffset: 1000
        )), false);
      }
    });

    test('`copyWith()`', () {
      const CodeLineSelection selection = CodeLineSelection(
        baseIndex: 0,
        baseOffset: 0,
        extentIndex: 3,
        extentOffset: 3,
      );
      expect(selection.copyWith(), selection);
      expect(selection.copyWith(
        baseIndex: 3,
        baseOffset: 3,
        extentIndex: 0,
        extentOffset: 0,
        baseAffinity: TextAffinity.upstream,
        extentAffinity: TextAffinity.upstream
      ), const CodeLineSelection(
        baseIndex: 3,
        baseOffset: 3,
        extentIndex: 0,
        extentOffset: 0,
        baseAffinity: TextAffinity.upstream,
        extentAffinity: TextAffinity.upstream
      ));
      expect(selection.copyWith(
        baseIndex: 3,
        baseAffinity: TextAffinity.upstream
      ), const CodeLineSelection(
        baseIndex: 3,
        baseOffset: 0,
        extentIndex: 3,
        extentOffset: 3,
        baseAffinity: TextAffinity.upstream
      ));
      expect(selection.copyWith(
        baseOffset: 3,
        baseAffinity: TextAffinity.upstream
      ), const CodeLineSelection(
        baseIndex: 0,
        baseOffset: 3,
        extentIndex: 3,
        extentOffset: 3,
        baseAffinity: TextAffinity.upstream
      ));
      expect(selection.copyWith(
        extentIndex: 0,
        extentAffinity: TextAffinity.upstream
      ), const CodeLineSelection(
        baseIndex: 0,
        baseOffset: 0,
        extentIndex: 0,
        extentOffset: 3,
        extentAffinity: TextAffinity.upstream
      ));
      expect(selection.copyWith(
        extentOffset: 0,
        extentAffinity: TextAffinity.upstream
      ), const CodeLineSelection(
        baseIndex: 0,
        baseOffset: 0,
        extentIndex: 3,
        extentOffset: 0,
        extentAffinity: TextAffinity.upstream
      ));
    });
  });
}