import 'package:flutter_test/flutter_test.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  group('CodeFindValue constructor ', () {
    test('`empty`', () async {
      const CodeFindValue value = CodeFindValue.empty();
      expect(value.option, const CodeFindOption(
        pattern: '',
        caseSensitive: false,
        regex: false,
      ));
      expect(value.replaceMode, false);
      expect(value.result, null);
    });
  });
  group('CodeFindValue method ', () {
    test('`copyWith`', () async {
      const CodeFindValue value = CodeFindValue.empty();
      {
        final CodeFindValue newValue = value.copyWith(
          result: CodeFindResult(
            index: 0, 
            matches: [], 
            option: value.option, 
            codeLines: const CodeLines([]),
            dirty: false
          )
        );
        expect(newValue.result, CodeFindResult(
          index: 0, 
          matches: [], 
          option: value.option, 
          codeLines: const CodeLines([]),
          dirty: false
        ));
        expect(newValue.replaceMode, value.replaceMode); 
        expect(newValue.option, value.option); 
      }
      {
        final CodeFindValue newValue = value.copyWith(
          replaceMode: true,
          result: null
        );
        expect(newValue.result, null);
        expect(newValue.replaceMode, true); 
        expect(newValue.option, value.option); 
      }
      {
        final CodeFindValue newValue = value.copyWith(
          option: const CodeFindOption(
            pattern: 'a', 
            caseSensitive: true, 
            regex: true
          ),
          result: null
        );
        expect(newValue.result, null);
        expect(newValue.replaceMode, value.replaceMode); 
        expect(newValue.option, const CodeFindOption(
          pattern: 'a', 
          caseSensitive: true, 
          regex: true
        )); 
      }

    });
  });
  group('CodeFindValue operator ', () {
    test('`==`', () async {
      expect(const CodeFindValue(
        option: CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        replaceMode: false,
        result: CodeFindResult(
          index: 0, 
          matches: [], 
          option: CodeFindOption(
            pattern: '',
            caseSensitive: false,
            regex: false,
          ), 
          codeLines: CodeLines([]),
          dirty: false
        )
      ) == const CodeFindValue(
        option: CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        replaceMode: false,
        result: CodeFindResult(
          index: 0, 
          matches: [], 
          option: CodeFindOption(
            pattern: '',
            caseSensitive: false,
            regex: false,
          ), 
          codeLines: CodeLines([]),
          dirty: false
        )
      ), true);
      expect(const CodeFindValue(
        option: CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        replaceMode: false,
        result: CodeFindResult(
          index: 0, 
          matches: [], 
          option: CodeFindOption(
            pattern: '',
            caseSensitive: false,
            regex: false,
          ), 
          codeLines: CodeLines([]),
          dirty: false
        )
      ) == const CodeFindValue(
        option: CodeFindOption(
          pattern: 'a',
          caseSensitive: false,
          regex: false,
        ),
        replaceMode: false,
        result: CodeFindResult(
          index: 0, 
          matches: [], 
          option: CodeFindOption(
            pattern: '',
            caseSensitive: false,
            regex: false,
          ), 
          codeLines: CodeLines([]),
          dirty: false
        )
      ), false);
      expect(const CodeFindValue(
        option: CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        replaceMode: false,
        result: CodeFindResult(
          index: 0, 
          matches: [], 
          option: CodeFindOption(
            pattern: '',
            caseSensitive: false,
            regex: false,
          ), 
          codeLines: CodeLines([]),
          dirty: false
        )
      ) == const CodeFindValue(
        option: CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        replaceMode: true,
        result: CodeFindResult(
          index: 0, 
          matches: [], 
          option: CodeFindOption(
            pattern: '',
            caseSensitive: false,
            regex: false,
          ), 
          codeLines: CodeLines([]),
          dirty: false
        )
      ), false);
      expect(const CodeFindValue(
        option: CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        replaceMode: false,
        result: CodeFindResult(
          index: 0, 
          matches: [], 
          option: CodeFindOption(
            pattern: '',
            caseSensitive: false,
            regex: false,
          ), 
          codeLines: CodeLines([]),
          dirty: false
        )
      ) == const CodeFindValue(
        option: CodeFindOption(
          pattern: '',
          caseSensitive: false,
          regex: false,
        ),
        replaceMode: false,
        result: CodeFindResult(
          index: 1, 
          matches: [], 
          option: CodeFindOption(
            pattern: '',
            caseSensitive: false,
            regex: false,
          ), 
          codeLines: CodeLines([]),
          dirty: false
        )
      ), false);
    });
  });
}