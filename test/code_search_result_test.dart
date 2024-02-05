import 'package:flutter_test/flutter_test.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  group('CodeFindResult getter ', () {
    test('`previous & next & current`', () async {
      const CodeFindResult result = CodeFindResult(
        index: 0,
        matches: [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines([]),
        dirty: false
      );
      expect(result.currentMatch, const CodeLineSelection(
        baseIndex: 0,
        baseOffset: 1,
        extentIndex: 0,
        extentOffset: 2
      ));
      expect(result.next, result.copyWith(
        index: 1
      ));
      expect(result.next.currentMatch, const CodeLineSelection(
        baseIndex: 1,
        baseOffset: 1,
        extentIndex: 1,
        extentOffset: 2
      ));
      expect(result.next.next, result.copyWith(
        index: 2
      ));
      expect(result.next.next.currentMatch, const CodeLineSelection(
        baseIndex: 2,
        baseOffset: 1,
        extentIndex: 2,
        extentOffset: 2
      ));
      expect(result.next.next.next, result.copyWith(
        index: 0
      ));
      expect(result.next.next.next.currentMatch, const CodeLineSelection(
        baseIndex: 0,
        baseOffset: 1,
        extentIndex: 0,
        extentOffset: 2
      ));
      expect(result.previous, result.copyWith(
        index: 2
      ));
      expect(result.previous.currentMatch, const CodeLineSelection(
        baseIndex: 2,
        baseOffset: 1,
        extentIndex: 2,
        extentOffset: 2
      ));
      expect(result.previous.previous, result.copyWith(
        index: 1
      ));
      expect(result.previous.previous.currentMatch, const CodeLineSelection(
        baseIndex: 1,
        baseOffset: 1,
        extentIndex: 1,
        extentOffset: 2
      ));
      expect(result.previous.previous.previous, result.copyWith(
        index: 0
      ));
      expect(result.previous.previous.previous.currentMatch, const CodeLineSelection(
        baseIndex: 0,
        baseOffset: 1,
        extentIndex: 0,
        extentOffset: 2
      ));
    });
  });

  group('CodeFindResult method ', () {
    test('`copyWith`', () async {
      const CodeFindResult result = CodeFindResult(
        index: 0,
        matches: [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines([]),
        dirty: false
      );
      expect(result.copyWith(), result);
      expect(result.copyWith(
        index: 1
      ), const CodeFindResult(
        index: 1,
        matches: [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines([]),
        dirty: false
      ));
      expect(result.copyWith(
        matches: []
      ), const CodeFindResult(
        index: 0,
        matches: [],
        option: CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines([]),
        dirty: false
      ));
      expect(result.copyWith(
        option: const CodeFindOption(
          pattern: 'a',
          caseSensitive: true,
          regex: true,
        ),
      ), const CodeFindResult(
        index: 0,
        matches: [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: CodeFindOption(
          pattern: 'a',
          caseSensitive: true,
          regex: true,
        ),
        codeLines: CodeLines([]),
        dirty: false
      ));
      expect(result.copyWith(
        codeLines: CodeLines.of([
          const CodeLine('abc')
        ])
      ), CodeFindResult(
        index: 0,
        matches: const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: const CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines.of([
          const CodeLine('abc')
        ]),
        dirty: false
      ));
      expect(result.copyWith(
        dirty: true
      ), const CodeFindResult(
        index: 0,
        matches: [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines([]),
        dirty: true
      ));
    });
  });

  group('CodeFindResult operator ', () {
    test('`==`', () async {
      expect(CodeFindResult(
        index: 0,
        matches: const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: const CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines.of([
          const CodeLine('abc')
        ]),
        dirty: true
      ) == CodeFindResult(
        index: 0,
        matches: const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: const CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines.of([
          const CodeLine('abc')
        ]),
        dirty: true
      ), true);
      expect(CodeFindResult(
        index: 1,
        matches: const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: const CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines.of([
          const CodeLine('abc')
        ]),
        dirty: true
      ) == CodeFindResult(
        index: 0,
        matches: const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: const CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines.of([
          const CodeLine('abc')
        ]),
        dirty: true
      ), false);
      expect(CodeFindResult(
        index: 0,
        matches: const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
        ],
        option: const CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines.of([
          const CodeLine('abc')
        ]),
        dirty: true
      ) == CodeFindResult(
        index: 0,
        matches: const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: const CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines.of([
          const CodeLine('abc')
        ]),
        dirty: true
      ), false);
      expect(CodeFindResult(
        index: 0,
        matches: const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: const CodeFindOption(
          pattern: 'a',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines.of([
          const CodeLine('abc')
        ]),
        dirty: true
      ) == CodeFindResult(
        index: 0,
        matches: const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: const CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines.of([
          const CodeLine('abc')
        ]),
        dirty: true
      ), false);
      expect(CodeFindResult(
        index: 0,
        matches: const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: const CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines.of([
          const CodeLine('a')
        ]),
        dirty: true
      ) == CodeFindResult(
        index: 0,
        matches: const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: const CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines.of([
          const CodeLine('abc')
        ]),
        dirty: true
      ), false);
      expect(CodeFindResult(
        index: 0,
        matches: const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: const CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines.of([
          const CodeLine('abc')
        ]),
        dirty: true
      ) == CodeFindResult(
        index: 0,
        matches: const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 1,
            extentIndex: 0,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 1,
            extentIndex: 1,
            extentOffset: 2
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ],
        option: const CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        codeLines: CodeLines.of([
          const CodeLine('abc')
        ]),
        dirty: false
      ), false);
    });
  });
}