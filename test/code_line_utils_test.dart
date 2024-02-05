import 'package:flutter_test/flutter_test.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  group('CodeLineUtils', () {
    test('toTextLinesSync', () {
      expect(CodeLineUtils.toTextLines(''), const [
        ''
      ]);
      expect(CodeLineUtils.toTextLines('abc'), const [
        'abc'
      ]);
      expect(CodeLineUtils.toTextLines('abc\nfoo\nbar'), const [
        'abc',
        'foo',
        'bar'
      ]);
      expect(CodeLineUtils.toTextLines('abc\r\nfoo\rbar'), const [
        'abc',
        'foo',
        'bar'
      ]);
    });
    test('toCodeLinesSync', () {
      expect(CodeLineUtils.toCodeLines('abc\nfoo\nbar'), CodeLines.of(const [
        CodeLine('abc'),
        CodeLine('foo'),
        CodeLine('bar')
      ]));
    });

    test('toCodeLines', () async {
      expect(await CodeLineUtils.toCodeLinesAsync('abc\nfoo\nbar'), CodeLines.of(const [
        CodeLine('abc'),
        CodeLine('foo'),
        CodeLine('bar')
      ]));
    });
  });
}
