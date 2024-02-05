import 'package:flutter_test/flutter_test.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  group('CodeFindOption getter ', () {
    test('`regExp`', () async {
      {
        const CodeFindOption option = CodeFindOption(
          pattern: 'a', 
          caseSensitive: false, 
          regex: false
        );
        expect(option.regExp, RegExp('a', caseSensitive: false));
      }
      {
        const CodeFindOption option = CodeFindOption(
          pattern: 'a', 
          caseSensitive: true, 
          regex: false
        );
        expect(option.regExp, RegExp('a', caseSensitive: true));
      }
      {
        const CodeFindOption option = CodeFindOption(
          pattern: 'a', 
          caseSensitive: false, 
          regex: true
        );
        expect(option.regExp, RegExp('a', caseSensitive: false));
      }
      {
        const CodeFindOption option = CodeFindOption(
          pattern: '*', 
          caseSensitive: false, 
          regex: false
        );
        expect(option.regExp, RegExp('\\*', caseSensitive: false));
      }
    });
  });
  group('CodeFindOption method ', () {
    test('`copyWith`', () async {
      const CodeFindOption option = CodeFindOption(
        pattern: '', 
        caseSensitive: false, 
        regex: false
      );
      expect(option.copyWith(), option);
      expect(option.copyWith(
        pattern: 'a'
      ), const CodeFindOption(
        pattern: 'a', 
        caseSensitive: false, 
        regex: false
      ));
      expect(option.copyWith(
        caseSensitive: true,
      ), const CodeFindOption(
        pattern: '', 
        caseSensitive: true, 
        regex: false
      ));
      expect(option.copyWith(
        regex: true,
      ), const CodeFindOption(
        pattern: '', 
        caseSensitive: false, 
        regex: true
      ));
      expect(option.copyWith(
        pattern: 'abc', 
        caseSensitive: true, 
        regex: true
      ), const CodeFindOption(
        pattern: 'abc', 
        caseSensitive: true, 
        regex: true
      ));
    });
  });
  group('CodeFindOption operator ', () {
    test('`==`', () async {
      expect(const CodeFindOption(
        pattern: 'a', 
        caseSensitive: true, 
        regex: true
      ) == const CodeFindOption(
        pattern: 'a', 
        caseSensitive: true, 
        regex: true
      ), true);
      expect(const CodeFindOption(
        pattern: 'a', 
        caseSensitive: true, 
        regex: true
      ) == const CodeFindOption(
        pattern: 'b', 
        caseSensitive: true, 
        regex: true
      ), false);
      expect(const CodeFindOption(
        pattern: 'a', 
        caseSensitive: false, 
        regex: true
      ) == const CodeFindOption(
        pattern: 'a', 
        caseSensitive: true, 
        regex: true
      ), false);
      expect(const CodeFindOption(
        pattern: 'a', 
        caseSensitive: true, 
        regex: false
      ) == const CodeFindOption(
        pattern: 'a', 
        caseSensitive: true, 
        regex: true
      ), false);
    });
  });
}