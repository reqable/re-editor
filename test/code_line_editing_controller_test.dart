import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('CodeLineEditingController constructor ', () {
    test('`CodeLineEditingController()`', () {
      {
        final CodeLineEditingController controller = CodeLineEditingController();
        expect(controller.value, const CodeLineEditingValue.empty());
        expect(controller.options, const CodeLineOptions());
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('abc'),
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        );
        expect(controller.value, CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc'),
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        ));
        expect(controller.options, const CodeLineOptions());
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          options: const CodeLineOptions(
            lineBreak: TextLineBreak.crlf,
            indentSize: 4
          )
        );
        expect(controller.value, const CodeLineEditingValue.empty());
        expect(controller.options, const CodeLineOptions(
          lineBreak: TextLineBreak.crlf,
          indentSize: 4
        ));
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('abc'),
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          options: const CodeLineOptions(
            lineBreak: TextLineBreak.crlf,
            indentSize: 4
          )
        );
        expect(controller.value, CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc'),
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        ));
        expect(controller.options, const CodeLineOptions(
          lineBreak: TextLineBreak.crlf,
          indentSize: 4
        ));
      }
    });

    test('`CodeLineEditingController.fromText()`', () {
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        expect(controller.value, const CodeLineEditingValue.empty());
        expect(controller.options, const CodeLineOptions());
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar', const CodeLineOptions(
          lineBreak: TextLineBreak.crlf,
          indentSize: 4
        ));
        expect(controller.value, CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc'),
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        ));
        expect(controller.options, const CodeLineOptions(
          lineBreak: TextLineBreak.crlf,
          indentSize: 4
        ));
      }
    });
  });

  group('CodeLineEditingController setter & getter ', () {
    test('`value`', () {
      final CodeLineEditingController controller = CodeLineEditingController();
      expect(controller.value, const CodeLineEditingValue.empty());
      final CodeLineEditingValue value = CodeLineEditingValue(
        codeLines: CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ])
      );
      controller.value = value;
      expect(controller.value, value);
    });

    test('`codeLines`', () {
      final CodeLineEditingController controller = CodeLineEditingController();
      expect(controller.codeLines, CodeLines.of(const [
        CodeLine.empty
      ]));
      final CodeLines codeLines = CodeLines.of(const [
        CodeLine('abc'),
        CodeLine('foo'),
        CodeLine('bar'),
      ]);
      controller.codeLines = codeLines;
      expect(controller.codeLines, codeLines);
    });

    test('`selection`', () {
      final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
      expect(controller.selection, const CodeLineSelection.zero());
      const CodeLineSelection selection = CodeLineSelection.collapsed(
        index: 0,
        offset: 1
      );
      controller.selection = selection;
      expect(controller.selection, selection);
    });

    test('`composing`', () {
      final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
      expect(controller.composing, TextRange.empty);
      const TextRange composing = TextRange.collapsed(1);
      controller.composing = composing;
      expect(controller.composing, composing);
    });

    test('`baseLine`', () {
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        expect(controller.baseLine, controller.codeLines[0]);
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 0
        );
        expect(controller.baseLine, controller.codeLines[1]);
      }
    });

    test('`extentLine`', () {
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        expect(controller.extentLine, controller.codeLines[0]);
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 0
        );
        expect(controller.extentLine, controller.codeLines[2]);
      }
    });

    test('`startLine`', () {
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        expect(controller.startLine, controller.codeLines[0]);
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 0
        );
        expect(controller.startLine, controller.codeLines[1]);
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selection = const CodeLineSelection(
          baseIndex: 2,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 0
        );
        expect(controller.startLine, controller.codeLines[1]);
      }
    });

    test('`endLine`', () {
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        expect(controller.endLine, controller.codeLines[0]);
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 0
        );
        expect(controller.endLine, controller.codeLines[2]);
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selection = const CodeLineSelection(
          baseIndex: 2,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 0
        );
        expect(controller.endLine, controller.codeLines[2]);
      }
    });

    test('`isComposing`', () {
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        expect(controller.isComposing, false);
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.composing = const TextRange.collapsed(0);
        expect(controller.isComposing, false);
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.composing = const TextRange(
          start: 0,
          end: 1
        );
        expect(controller.isComposing, true);
      }
    });

    test('`text`', () {
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        expect(controller.text, 'abc');
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        expect(controller.text, 'abc\nfoo\nbar');
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar', const CodeLineOptions(
          lineBreak: TextLineBreak.crlf
        ));
        expect(controller.text, 'abc\r\nfoo\r\nbar');
      }
    });

    test('`selectedText`', () {
      // Empty
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        expect(controller.selectedText, '');
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        expect(controller.selectedText, '');
        controller.selection = CodeLineSelection.fromRange(
          range: const CodeLineRange(
            index: 0,
            start: 0,
            end: 1
          )
        );
        expect(controller.selectedText, 'a');
        controller.selection = CodeLineSelection.fromRange(
          range: const CodeLineRange(
            index: 0,
            start: 0,
            end: 3
          )
        );
        expect(controller.selectedText, 'abc');
      }
      // Multi code lines and LF linebreak
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        expect(controller.selectedText, '');
        controller.selection = CodeLineSelection.fromRange(
          range: const CodeLineRange(
            index: 1,
            start: 0,
            end: 1
          )
        );
        expect(controller.selectedText, 'f');
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 3
        );
        expect(controller.selectedText, 'foo');
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 3,
          extentIndex: 1,
          extentOffset: 0,
        );
        expect(controller.selectedText, 'foo');
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 3,
        );
        expect(controller.selectedText, 'abc\nfoo');
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 3,
        );
        expect(controller.selectedText, 'abc\nfoo\nbar');
      }
      // Multi code lines and CRLF linebreak
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar', const CodeLineOptions(
          lineBreak: TextLineBreak.crlf
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 3,
        );
        expect(controller.selectedText, 'abc\r\nfoo');
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 3,
        );
        expect(controller.selectedText, 'abc\r\nfoo\r\nbar');
      }
    });


    test('`unforldLineSelection`', () {
      // Empty
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        expect(controller.unforldLineSelection, controller.selection);
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0, 
          offset: 1
        );
        expect(controller.unforldLineSelection, controller.selection);
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selection = const CodeLineSelection.collapsed(
          index: 1, 
          offset: 1
        );
        expect(controller.unforldLineSelection, controller.selection);
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 3,
        );
        expect(controller.unforldLineSelection, controller.selection);
      }
      // Collapsed code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar'),
            ]),
          ])
        );
        controller.selection = const CodeLineSelection.collapsed(
          index: 0, 
          offset: 1
        );
        expect(controller.unforldLineSelection, controller.selection);
      }
      // More collapsed code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('abc', [
              CodeLine('123'),
              CodeLine('456'),
              CodeLine('789'),
            ]),
            CodeLine('foo', [
              CodeLine('123'),
              CodeLine('456'),
              CodeLine('789'),
            ]),
            CodeLine('bar', [
              CodeLine('123'),
              CodeLine('456'),
              CodeLine('789'),
            ]),
          ])
        );
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 3,
        );
        expect(controller.unforldLineSelection, const CodeLineSelection(
          baseIndex: 4,
          baseOffset: 0,
          extentIndex: 8,
          extentOffset: 3,
        ));
      }
    });
  });

  group('CodeLineEditingController method ', () {
    test('`edit()`', () {
      // Starts with empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        // Input a letter 'a'
        controller.edit(const TextEditingValue(
          text: 'a',
          selection: TextSelection.collapsed(
            offset: 1
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('a')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        expect(controller.composing, TextRange.empty);
        // Replace with a letter 'b'
        controller.edit(const TextEditingValue(
          text: 'b',
          selection: TextSelection.collapsed(
            offset: 1
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('b')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        expect(controller.composing, TextRange.empty);
        // Replace with letters 'abc'
        controller.edit(const TextEditingValue(
          text: 'abc',
          selection: TextSelection.collapsed(
            offset: 3
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        expect(controller.composing, TextRange.empty);
        // Input a letter 'd' and select letter 'd'
        controller.edit(const TextEditingValue(
          text: 'abcd',
          selection: TextSelection(
            baseOffset: 3,
            extentOffset: 4
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abcd')
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 3,
          extentIndex: 0,
          extentOffset: 4
        ));
        expect(controller.composing, TextRange.empty);
        // Have a composing
        controller.edit(const TextEditingValue(
          text: 'abca a a a a',
          selection: TextSelection.collapsed(
            offset: 12
          ),
          composing: TextRange(
            start: 3,
            end: 12
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abca a a a a')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 12
        ));
        expect(controller.composing, const TextRange(
          start: 3,
          end: 12
        ));
      }
      // Starts with a single line and has a selection range
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selection = CodeLineSelection.fromRange(
          range: const CodeLineRange(
            index: 0,
            start: 0,
            end: 1
          )
        );
        // Replace selection 'a' with a letter 'c'
        controller.edit(const TextEditingValue(
          text: 'cbc',
          selection: TextSelection.collapsed(
            offset: 1
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('cbc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        expect(controller.composing, TextRange.empty);
        // Select all
        controller.selection = CodeLineSelection.fromRange(
          range: const CodeLineRange(
            index: 0,
            start: 0,
            end: 3
          )
        );
        // Replace selection 'cbc' with a letter 'a'
        controller.edit(const TextEditingValue(
          text: 'a',
          selection: TextSelection.collapsed(
            offset: 1
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('a')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        expect(controller.composing, TextRange.empty);
      }
      // Starts with multi lines
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('abc'),
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        );
        // Edit line index 0
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        );
        controller.edit(const TextEditingValue(
          text: 'abc1',
          selection: TextSelection.collapsed(
            offset: 4
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc1'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 4
        ));
        expect(controller.composing, TextRange.empty);
        // Edit line index 1
        controller.selection = const CodeLineSelection.collapsed(
          index: 1,
          offset: 3
        );
        controller.edit(const TextEditingValue(
          text: 'foo1',
          selection: TextSelection.collapsed(
            offset: 4
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc1'),
          CodeLine('foo1'),
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 4
        ));
        expect(controller.composing, const TextRange(
          start: -1,
          end: -1
        ));
        // Edit line index 2
        controller.selection = const CodeLineSelection.collapsed(
          index: 2,
          offset: 3
        );
        controller.edit(const TextEditingValue(
          text: 'bar1',
          selection: TextSelection.collapsed(
            offset: 4
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc1'),
          CodeLine('foo1'),
          CodeLine('bar1'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 4
        ));
        expect(controller.composing, TextRange.empty);
        // Edit line index 2 and select the input
        controller.edit(const TextEditingValue(
          text: 'bar2',
          selection: TextSelection(
            baseOffset: 3,
            extentOffset: 4
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc1'),
          CodeLine('foo1'),
          CodeLine('bar2'),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 2,
          baseOffset: 3,
          extentIndex: 2,
          extentOffset: 4
        ));
        expect(controller.composing, TextRange.empty);
        // Have a composing
        controller.edit(const TextEditingValue(
          text: 'bara a a a a',
          selection: TextSelection.collapsed(
            offset: 12
          ),
          composing: TextRange(
            start: 3,
            end: 12
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc1'),
          CodeLine('foo1'),
          CodeLine('bara a a a a'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 12
        ));
        expect(controller.composing, const TextRange(
          start: 3,
          end: 12
        ));
      }
      // Starts with multi lines and has a selection range
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('abc'),
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        );
        // Replace 'abc' with '1'
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 3
        );
        controller.edit(const TextEditingValue(
          text: '1',
          selection: TextSelection.collapsed(
            offset: 1
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('1'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        expect(controller.composing, TextRange.empty);
        // Replace 'foo' with '2'
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 3
        );
        controller.edit(const TextEditingValue(
          text: '2',
          selection: TextSelection.collapsed(
            offset: 1
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('1'),
          CodeLine('2'),
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 1
        ));
        expect(controller.composing, TextRange.empty);
        // Reset codeLines
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]);
        // Select two line 'abc' and 'foo'
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 3
        );
        controller.edit(const TextEditingValue(
          text: 'a',
          selection: TextSelection.collapsed(
            offset: 1
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('a'),
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        expect(controller.composing, TextRange.empty);
        // Reset codeLines
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]);
        // Select three line, and base before extent
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          extentIndex: 2,
          extentOffset: 1
        );
        // Input 'a'
        controller.edit(const TextEditingValue(
          text: 'ab1',
          selection: TextSelection.collapsed(
            offset: 3
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ab1ar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        expect(controller.composing, TextRange.empty);
        // Reset codeLines
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]);
        // Select three line, and extent before base
        controller.selection = const CodeLineSelection(
          baseIndex: 2,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        // Input '1'
        controller.edit(const TextEditingValue(
          text: '1ar',
          selection: TextSelection.collapsed(
            offset: 1
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ab1ar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        expect(controller.composing, TextRange.empty);
        // Reset codeLines
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]);
        // Select three line, and base before extent
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          extentIndex: 2,
          extentOffset: 1
        );
        // Input 'a' with a composing
        controller.edit(const TextEditingValue(
          text: 'aba ',
          selection: TextSelection.collapsed(
            offset: 4
          ),
          composing: TextRange(
            start: 2,
            end: 4
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('aba ar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 4
        ));
        expect(controller.composing, const TextRange(
          start: 2,
          end: 4
        ));
        // Reset codeLines
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]);
        // Select three line, and extent before base
        controller.selection = const CodeLineSelection(
          baseIndex: 2,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        // Input 'a'
        controller.edit(const TextEditingValue(
          text: 'a ar',
          selection: TextSelection.collapsed(
            offset: 2
          ),
          composing: TextRange(
            start: 0,
            end: 2
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('aba ar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 4
        ));
        expect(controller.composing, const TextRange(
          start: 2,
          end: 4
        ));
      }
      // Starts with multi lines and has collapsed chunks
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('abc', [
              CodeLine('123'),
              CodeLine('456')
            ]),
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        );
        // Replace 'abc' with '1'
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 3
        );
        controller.edit(const TextEditingValue(
          text: '1',
          selection: TextSelection.collapsed(
            offset: 1
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('1', [
            CodeLine('123'),
            CodeLine('456')
          ]),
          CodeLine('foo'),
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        expect(controller.composing, TextRange.empty);
        // Replace 'foo' with '2'
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 3
        );
        controller.edit(const TextEditingValue(
          text: '2',
          selection: TextSelection.collapsed(
            offset: 1
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('1', [
            CodeLine('123'),
            CodeLine('456')
          ]),
          CodeLine('2'),
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 1
        ));
        expect(controller.composing, TextRange.empty);
        // Select line '1' and '2' and replace with '3'
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 1
        );
        controller.edit(const TextEditingValue(
          text: '3',
          selection: TextSelection.collapsed(
            offset: 1
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('3'),
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        expect(controller.composing, TextRange.empty);
        // Reset code lines
        controller.value = CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc', [
              CodeLine('123'),
              CodeLine('456')
            ]),
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        );
        // Select three line, and base before extent
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          extentIndex: 2,
          extentOffset: 1
        );
        controller.edit(const TextEditingValue(
          text: 'ab1',
          selection: TextSelection.collapsed(
            offset: 3
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ab1ar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        expect(controller.composing, TextRange.empty);
        // Reset code lines
        controller.value = CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc', [
              CodeLine('123'),
              CodeLine('456')
            ]),
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        );
        // Select three line, and extent before base
        controller.selection = const CodeLineSelection(
          baseIndex: 2,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        controller.edit(const TextEditingValue(
          text: '1ar',
          selection: TextSelection.collapsed(
            offset: 1
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ab1ar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        expect(controller.composing, TextRange.empty);
        // Test more chunks
        controller.value = CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc', [
              CodeLine('123'),
              CodeLine('123')
            ]),
            CodeLine('foo', [
              CodeLine('456'),
              CodeLine('456')
            ]),
            CodeLine('bar', [
              CodeLine('789'),
              CodeLine('789')
            ]),
          ])
        );
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          extentIndex: 1,
          extentOffset: 1
        );
        controller.edit(const TextEditingValue(
          text: 'ab1',
          selection: TextSelection.collapsed(
            offset: 3
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ab1oo', [
            CodeLine('456'),
            CodeLine('456')
          ]),
          CodeLine('bar', [
            CodeLine('789'),
            CodeLine('789')
          ]),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        expect(controller.composing, TextRange.empty);
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 1
        );
        controller.edit(const TextEditingValue(
          text: '2ar',
          selection: TextSelection.collapsed(
            offset: 1
          )
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('a2ar', [
            CodeLine('789'),
            CodeLine('789')
          ]),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ));
        expect(controller.composing, TextRange.empty);
      }
    });

    test('`selectLine()`', () {
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selectLine(0);
        expect(controller.selection, CodeLineSelection.fromRange(
          range: const CodeLineRange(
            index: 0,
            start: 0,
            end: 3
          )
        ));
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selectLine(0);
        expect(controller.selection, CodeLineSelection.fromRange(
          range: const CodeLineRange(
            index: 0,
            start: 0,
            end: 3
          )
        ));
        controller.selectLine(1);
        expect(controller.selection, CodeLineSelection.fromRange(
          range: const CodeLineRange(
            index: 1,
            start: 0,
            end: 3
          )
        ));
        controller.selectLine(2);
        expect(controller.selection, CodeLineSelection.fromRange(
          range: const CodeLineRange(
            index: 2,
            start: 0,
            end: 3
          )
        ));
      }
      // Out of range
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selectLine(-1);
        expect(controller.selection, const CodeLineSelection.zero());
        controller.selectLine(3);
        expect(controller.selection, const CodeLineSelection.zero());
      }
    });

    test('`selectLines()`', () {
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selectLines(0, 1);
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 3
        ));
        controller.selectLines(1, 0);
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 3,
          extentIndex: 0,
          extentOffset: 0
        ));
        // Out of range
        controller.selectLines(0, 3);
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 3,
          extentIndex: 0,
          extentOffset: 0
        ));
      }
    });

    test('`selectAll()`', () {
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.selectAll();
        expect(controller.selection, const CodeLineSelection.zero());
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selectAll();
        expect(controller.selection, CodeLineSelection.fromRange(
          range: const CodeLineRange(
            index: 0,
            start: 0,
            end: 3
          )
        ));
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selectAll();
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 3
        ));
      }
    });

    test('`cancelSelection()`', () {
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.cancelSelection();
        expect(controller.selection, const CodeLineSelection.zero());
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selectAll();
        controller.cancelSelection();
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3,
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        controller.cancelSelection();
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          extentIndex: 0,
          extentOffset: 1
        );
        controller.cancelSelection();
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1,
        ));
      }
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selectAll();
        controller.cancelSelection();
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 3,
        ));
      }
    });

    test('`moveSelectionLinesUp()`', () {
      // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.moveSelectionLinesUp();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty
        ]));
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.moveSelectionLinesUp();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc')
        ]));
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selection = const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        );
        controller.moveSelectionLinesUp();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('foo'),
          CodeLine('abc'),
          CodeLine('bar'),
        ]));
        controller.selection = const CodeLineSelection.collapsed(
          index: 2,
          offset: 0
        );
        controller.moveSelectionLinesUp();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('foo'),
          CodeLine('bar'),
          CodeLine('abc'),
        ]));
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 1,
          extentIndex: 2,
          extentOffset: 1
        );
        controller.moveSelectionLinesUp();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('bar'),
          CodeLine('abc'),
          CodeLine('foo'),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 1,
          extentOffset: 1
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 2,
          baseOffset: 2,
          extentIndex: 1,
          extentOffset: 1
        );
        controller.moveSelectionLinesUp();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 2,
          extentIndex: 0,
          extentOffset: 1
        ));
      }
    });

    test('`moveSelectionLinesDown()`', () {
      // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.moveSelectionLinesDown();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty
        ]));
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.moveSelectionLinesDown();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc')
        ]));
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.moveSelectionLinesDown();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('foo'),
          CodeLine('abc'),
          CodeLine('bar'),
        ]));
        controller.selection = const CodeLineSelection.collapsed(
          index: 2,
          offset: 0
        );
        controller.moveSelectionLinesDown();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('foo'),
          CodeLine('abc'),
          CodeLine('bar'),
        ]));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 1,
          extentOffset: 1
        );
        controller.moveSelectionLinesDown();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('bar'),
          CodeLine('foo'),
          CodeLine('abc'),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 1,
          extentIndex: 2,
          extentOffset: 1
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 2,
          extentIndex: 0,
          extentOffset: 1
        );
        controller.moveSelectionLinesDown();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('bar'),
          CodeLine('foo'),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 2,
          baseOffset: 2,
          extentIndex: 1,
          extentOffset: 1
        ));
      }
    });

    test('`moveCursor(left)`', () {
      // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.moveCursor(AxisDirection.left);
        expect(controller.selection, const CodeLineSelection.zero());
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        );
        controller.moveCursor(AxisDirection.left);
        expect(controller.selection, const CodeLineSelection.zero());
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        );
        controller.moveCursor(AxisDirection.left);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1,
          affinity: TextAffinity.downstream
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        controller.moveCursor(AxisDirection.left);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1,
          affinity: TextAffinity.downstream
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          extentIndex: 0,
          extentOffset: 1
        );
        controller.moveCursor(AxisDirection.left);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1,
          affinity: TextAffinity.downstream
        ));
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\bar');
        controller.selection = const CodeLineSelection.collapsed(
          index: 1,
          offset: 1
        );
        controller.moveCursor(AxisDirection.left);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 0,
          affinity: TextAffinity.downstream
        ));
        controller.moveCursor(AxisDirection.left);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3,
          affinity: TextAffinity.downstream
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 1,
          extentIndex: 1,
          extentOffset: 2
        );
        controller.moveCursor(AxisDirection.left);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 1,
          affinity: TextAffinity.downstream
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          extentIndex: 1,
          extentOffset: 1
        );
        controller.moveCursor(AxisDirection.left);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
          affinity: TextAffinity.downstream
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        controller.moveCursor(AxisDirection.left);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
          affinity: TextAffinity.downstream
        ));
      }
      // Affinity change
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
          affinity: TextAffinity.upstream
        );
        controller.moveCursor(AxisDirection.left);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1,
          affinity: TextAffinity.downstream
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          baseAffinity: TextAffinity.downstream,
          extentIndex: 0,
          extentOffset: 2,
          extentAffinity: TextAffinity.upstream,
        );
        controller.moveCursor(AxisDirection.left);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
          affinity: TextAffinity.upstream
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          baseAffinity: TextAffinity.upstream,
          extentIndex: 0,
          extentOffset: 2,
          extentAffinity: TextAffinity.downstream,
        );
        controller.moveCursor(AxisDirection.left);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
          affinity: TextAffinity.upstream
        ));
      }

    });

    test('`moveCursor(right)`', () {
      // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.zero());
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 0
        );
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1,
          affinity: TextAffinity.upstream
        ));
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
          affinity: TextAffinity.upstream
        ));
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3,
          affinity: TextAffinity.upstream
        ));
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3,
          affinity: TextAffinity.upstream
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
          affinity: TextAffinity.downstream
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          extentIndex: 0,
          extentOffset: 1
        );
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
          affinity: TextAffinity.downstream
        ));
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nar');
        controller.selection = const CodeLineSelection.collapsed(
          index: 1,
          offset: 1
        );
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 2,
          affinity: TextAffinity.upstream
        ));
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 3,
          affinity: TextAffinity.upstream
        ));
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 0,
          affinity: TextAffinity.upstream
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 1,
          extentIndex: 1,
          extentOffset: 2
        );
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 2,
          affinity: TextAffinity.downstream
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          extentIndex: 1,
          extentOffset: 1
        );
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 1,
          affinity: TextAffinity.downstream
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 1,
          affinity: TextAffinity.downstream
        ));
      }
      // Affinity change
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
          affinity: TextAffinity.downstream
        );
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3,
          affinity: TextAffinity.upstream
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          baseAffinity: TextAffinity.downstream,
          extentIndex: 0,
          extentOffset: 2,
          extentAffinity: TextAffinity.upstream,
        );
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
          affinity: TextAffinity.downstream
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          baseAffinity: TextAffinity.upstream,
          extentIndex: 0,
          extentOffset: 2,
          extentAffinity: TextAffinity.downstream,
        );
        controller.moveCursor(AxisDirection.right);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
          affinity: TextAffinity.downstream
        ));
      }
    });

    test('`moveCursor(up)`', () {
      // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.moveCursor(AxisDirection.up);
        expect(controller.selection, const CodeLineSelection.zero());
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        );
        controller.moveCursor(AxisDirection.up);
        expect(controller.selection, const CodeLineSelection.zero());
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoofoo\nbar');
        controller.selection = const CodeLineSelection.collapsed(
          index: 1,
          offset: 1
        );
        controller.moveCursor(AxisDirection.up);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        controller.moveCursor(AxisDirection.up);
        expect(controller.selection, const CodeLineSelection.zero());
        controller.selection = const CodeLineSelection.collapsed(
          index: 1,
          offset: 6
        );
        controller.moveCursor(AxisDirection.up);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 1,
          extentIndex: 1,
          extentOffset: 2
        );
        controller.moveCursor(AxisDirection.up);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 2,
          baseOffset: 1,
          extentIndex: 1,
          extentOffset: 1
        );
        controller.moveCursor(AxisDirection.up);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 1,
          extentOffset: 1
        );
        controller.moveCursor(AxisDirection.up);
        expect(controller.selection, const CodeLineSelection.zero());
      }
    });

    test('`moveCursor(down)`', () {
      // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.moveCursor(AxisDirection.down);
        expect(controller.selection, const CodeLineSelection.zero());
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        );
        controller.moveCursor(AxisDirection.down);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoofoo\nbar');
        controller.selection = const CodeLineSelection.collapsed(
          index: 1,
          offset: 2
        );
        controller.moveCursor(AxisDirection.down);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 2
        ));
        controller.moveCursor(AxisDirection.down);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 3
        ));
        controller.selection = const CodeLineSelection.collapsed(
          index: 1,
          offset: 6
        );
        controller.moveCursor(AxisDirection.down);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 3
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 1,
          extentIndex: 1,
          extentOffset: 2
        );
        controller.moveCursor(AxisDirection.down);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 2
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 2,
          extentIndex: 1,
          extentOffset: 1
        );
        controller.moveCursor(AxisDirection.down);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 2
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 2,
          extentIndex: 2,
          extentOffset: 1
        );
        controller.moveCursor(AxisDirection.down);
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 3
        ));
      }
    });

    test('`moveCursorToLineStart() & moveCursorToLineEnd() & moveCursorToPageStart() & moveCursorToPageEnd()`', () {
      // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.moveCursorToLineStart();
        expect(controller.selection, const CodeLineSelection.zero());
        controller.moveCursorToLineEnd();
        expect(controller.selection, const CodeLineSelection.zero());
        controller.moveCursorToPageStart();
        expect(controller.selection, const CodeLineSelection.zero());
        controller.moveCursorToPageEnd();
        expect(controller.selection, const CodeLineSelection.zero());
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.moveCursorToLineEnd();
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        controller.moveCursorToLineStart();
        expect(controller.selection, const CodeLineSelection.zero());
        controller.moveCursorToPageEnd();
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        controller.moveCursorToPageStart();
        expect(controller.selection, const CodeLineSelection.zero());
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selection = const CodeLineSelection.collapsed(
          index: 1,
          offset: 1
        );
        controller.moveCursorToLineEnd();
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 3
        ));
        controller.moveCursorToLineStart();
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        ));
        controller.moveCursorToPageEnd();
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 3
        ));
        controller.moveCursorToPageStart();
        expect(controller.selection, const CodeLineSelection.zero());
      }
    });

    test('`deleteSelectionLines()`', () {
      // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.deleteSelectionLines();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty
        ]));
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.deleteSelectionLines();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty
        ]));
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.deleteSelectionLines();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('foo'),
          CodeLine('bar'),
        ]));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 0
        );
        controller.deleteSelectionLines();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty
        ]));
        controller.deleteSelectionLines();
      }
      // Multi code lines, keep extent offset
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        );
        controller.deleteSelectionLines();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('foo'),
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
      }
      // Multi code lines, failed to keep extent offset
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo123\nbar');
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 6
        );
        controller.deleteSelectionLines();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
      }
    });

    test('`deleteSelection()`', () {
      // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.deleteSelection();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty
        ]));
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.deleteSelection();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc')
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        controller.deleteSelection();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ac')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 1,
          extentIndex: 1,
          extentOffset: 2
        );
        controller.deleteSelection();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('fo'),
          CodeLine('bar')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 1
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 1,
          extentOffset: 1
        );
        controller.deleteSelection();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ao'),
          CodeLine('bar')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        controller.selectAll();
        controller.deleteSelection();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
      }
      // Multi code lines (have chunks)
      {
        final CodeLineEditingController controller = CodeLineEditingController();
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc', [
            CodeLine('123')
          ]),
          CodeLine('foo', [
            CodeLine('456')
          ]),
          CodeLine('bar', [
            CodeLine('789')
          ])
        ]);
        controller.deleteSelection();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc', [
            CodeLine('123')
          ]),
          CodeLine('foo', [
            CodeLine('456')
          ]),
          CodeLine('bar', [
            CodeLine('789')
          ])
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        controller.deleteSelection();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ac', [
            CodeLine('123')
          ]),
          CodeLine('foo', [
            CodeLine('456')
          ]),
          CodeLine('bar', [
            CodeLine('789')
          ])
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 1,
          extentIndex: 2,
          extentOffset: 1
        );
        controller.deleteSelection();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ac', [
            CodeLine('123')
          ]),
          CodeLine('far', [
            CodeLine('789')
          ])
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 1
        ));
      }
    });

    test('`deleteBackward()`', () {
       // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.deleteBackward();
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        );
        controller.deleteBackward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ab')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ));
        controller.deleteBackward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('a')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        controller.deleteBackward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
        controller.deleteBackward();
        // Rest code lines
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc{}')
        ]);
        // Delete the {} at same time
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 4
        );
        controller.deleteBackward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        // Rest code lines
        controller.codeLines = CodeLines.of([
          CodeLine('${controller.options.indent}${controller.options.indent}abc')
        ]);
        // Delete an indent
        controller.selection = CodeLineSelection.collapsed(
          index: 0,
          offset: controller.options.indentSize
        );
        controller.deleteBackward();
        expect(controller.codeLines, CodeLines.of([
          CodeLine('${controller.options.indent}abc')
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selection = const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        );
        controller.deleteBackward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abcfoo'),
          CodeLine('bar')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
      }
      // Multi code lines (have chunks)
      {
        final CodeLineEditingController controller = CodeLineEditingController();
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc', [
            CodeLine('123')
          ]),
          CodeLine('foo', [
            CodeLine('456')
          ]),
          CodeLine('bar', [
            CodeLine('789')
          ])
        ]);
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        );
        controller.deleteBackward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ab', [
            CodeLine('123')
          ]),
          CodeLine('foo', [
            CodeLine('456')
          ]),
          CodeLine('bar', [
            CodeLine('789')
          ])
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ));
        controller.selection = const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        );
        controller.deleteBackward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ab'),
          CodeLine('123foo', [
            CodeLine('456')
          ]),
          CodeLine('bar', [
            CodeLine('789')
          ])
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 3
        ));
      }
      // Multi code lines (have nested chunks)
      {
        final CodeLineEditingController controller = CodeLineEditingController();
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc', [
            CodeLine('{', [
              CodeLine('123')
            ]),
            CodeLine('}')
          ]),
          CodeLine('foo', [
            CodeLine('{', [
              CodeLine('456')
            ]),
            CodeLine('}')
          ]),
          CodeLine('bar', [
            CodeLine('{', [
              CodeLine('789')
            ]),
            CodeLine('}')
          ])
        ]);
        controller.selection = const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        );
        controller.deleteBackward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('{', [
            CodeLine('123')
          ]),
          CodeLine('}foo', [
            CodeLine('{', [
              CodeLine('456')
            ]),
            CodeLine('}')
          ]),
          CodeLine('bar', [
            CodeLine('{', [
              CodeLine('789')
            ]),
            CodeLine('}')
          ])
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 1
        ));
        controller.deleteBackward();
        controller.deleteBackward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('{'),
          CodeLine('123foo', [
            CodeLine('{', [
              CodeLine('456')
            ]),
            CodeLine('}')
          ]),
          CodeLine('bar', [
            CodeLine('{', [
              CodeLine('789')
            ]),
            CodeLine('}')
          ])
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 3
        ));
      }
    });

    test('`deleteForward()`', () {
       // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.deleteForward();
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        );
        controller.deleteForward();
        controller.selection = const CodeLineSelection.zero();
        controller.deleteForward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('bc')
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
        controller.deleteForward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('c')
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
        controller.deleteForward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
        controller.deleteForward();
        // Rest code lines
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc{}')
        ]);
        // Delete the {} at same time
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 4
        );
        controller.deleteForward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        // Rest code lines
        controller.codeLines = CodeLines.of([
          CodeLine('${controller.options.indent}${controller.options.indent}abc')
        ]);
        // Delete an indent
        controller.selection = CodeLineSelection.collapsed(
          index: 0,
          offset: controller.options.indentSize
        );
        controller.deleteForward();
        expect(controller.codeLines, CodeLines.of([
          CodeLine('${controller.options.indent}abc')
        ]));
        expect(controller.selection, CodeLineSelection.collapsed(
          index: 0,
          offset: controller.options.indentSize
        ));
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        );
        controller.deleteForward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abcfoo'),
          CodeLine('bar')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        controller.selection = const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        );
        controller.deleteForward();
        controller.deleteForward();
        controller.deleteForward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abcfoo'),
          CodeLine.empty
        ]));
        controller.deleteForward();
      }
      // Multi code lines (have chunks)
      {
        final CodeLineEditingController controller = CodeLineEditingController();
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc', [
            CodeLine('123')
          ]),
          CodeLine('foo', [
            CodeLine('456')
          ]),
          CodeLine('bar', [
            CodeLine('789')
          ])
        ]);
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        );
        controller.deleteForward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ab', [
            CodeLine('123')
          ]),
          CodeLine('foo', [
            CodeLine('456')
          ]),
          CodeLine('bar', [
            CodeLine('789')
          ])
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ));
        controller.deleteForward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ab123'),
          CodeLine('foo', [
            CodeLine('456')
          ]),
          CodeLine('bar', [
            CodeLine('789')
          ])
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ));
      }
      // Multi code lines (have nested chunks)
      {
        final CodeLineEditingController controller = CodeLineEditingController();
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc', [
            CodeLine('{', [
              CodeLine('123')
            ]),
            CodeLine('}')
          ]),
          CodeLine('foo', [
            CodeLine('{', [
              CodeLine('456')
            ]),
            CodeLine('}')
          ]),
          CodeLine('bar', [
            CodeLine('{', [
              CodeLine('789')
            ]),
            CodeLine('}')
          ])
        ]);
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        );
        controller.deleteForward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc{', [
            CodeLine('123')
          ]),
          CodeLine('}'),
          CodeLine('foo', [
            CodeLine('{', [
              CodeLine('456')
            ]),
            CodeLine('}')
          ]),
          CodeLine('bar', [
            CodeLine('{', [
              CodeLine('789')
            ]),
            CodeLine('}')
          ])
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        controller.deleteForward();
        controller.deleteForward();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc123'),
          CodeLine('}'),
          CodeLine('foo', [
            CodeLine('{', [
              CodeLine('456')
            ]),
            CodeLine('}')
          ]),
          CodeLine('bar', [
            CodeLine('{', [
              CodeLine('789')
            ]),
            CodeLine('}')
          ])
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
      }
    });

    test('`applyNewLine()`', () {
      // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.applyNewLine();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty,
          CodeLine.empty
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        ));
        controller.applyNewLine();
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 0
        ));
      }
      // Single code line, cursor at begin
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.applyNewLine();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty,
          CodeLine('abc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        ));
      }
      // Single code line, cursor at end
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        );
        controller.applyNewLine();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine.empty,
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        ));
      }
      // Single code line, has a selection
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        controller.applyNewLine();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('a'),
          CodeLine('c'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        ));
      }
      // Single code line, all have selected
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.selectAll();
        controller.applyNewLine();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty,
          CodeLine.empty,
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        ));
      }
      // Multi code lines, select lines 0 - 1
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          extentIndex: 1,
          extentOffset: 2
        );
        controller.applyNewLine();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ab'),
          CodeLine('o'),
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        ));
      }
      // Multi code lines, have a chunk
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('{', [
              CodeLine('foo'),
              CodeLine('bar')
            ]),
            CodeLine('}')
          ])
        );
        controller.applyNewLine();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty,
          CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine('}')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        ));
      }
      // Multi code lines, have a few of chunks
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('{', [
              CodeLine('foo'),
              CodeLine('bar')
            ]),
            CodeLine('}'),
            CodeLine('{', [
              CodeLine('foo'),
              CodeLine('bar')
            ]),
            CodeLine('}'),
            CodeLine('{', [
              CodeLine('foo'),
              CodeLine('bar')
            ]),
            CodeLine('}')
          ])
        );
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 4,
          extentOffset: 1
        );
        controller.applyNewLine();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine('', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('}')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        ));
      }
      // Test auto indent
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('  abc');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 5
        );
        controller.applyNewLine();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('  abc'),
          CodeLine('  ')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 2
        ));
      }
      // Test auto indent in closure
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('{}');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        );
        controller.applyNewLine();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine('  '),
          CodeLine('}')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 2
        ));
      }
      // Test auto indent size in closure
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('{}',
          const CodeLineOptions(
            indentSize: 6
          )
        );
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        );
        controller.applyNewLine();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine('      '),
          CodeLine('}')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 6
        ));
      }
      // Test indent align
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('  {}');
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        );
        controller.applyNewLine();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('  {'),
          CodeLine('    '),
          CodeLine('  }')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 4
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 3,
          extentIndex: 2,
          extentOffset: 2
        );
        controller.applyNewLine();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('  {'),
          CodeLine('    '),
          CodeLine('  }')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 4
        ));
      }
    });

    test('`applyIndent()`', () {
      // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          CodeLine(controller.options.indent)
        ]));
        expect(controller.selection, CodeLineSelection.collapsed(
          index: 0,
          offset: controller.options.indentSize
        ));
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          CodeLine(controller.options.indent * 2)
        ]));
        expect(controller.selection, CodeLineSelection.collapsed(
          index: 0,
          offset: controller.options.indentSize * 2
        ));
      }
      // Single code line
      {
        // Assign indent size is 2
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc',
          const CodeLineOptions(
            indentSize: 2
          )
        );
        // cursor at begin
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          const CodeLine('  abc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ));
        // cursor at end
        controller.selection = CodeLineSelection.collapsed(
          index: 0,
          offset: controller.codeLines.first.length
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          const CodeLine('  abc ')
        ]));
        expect(controller.selection, CodeLineSelection.collapsed(
          index: 0,
          offset: controller.codeLines.first.length
        ));
        // cursor at mid (after 'a')
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          const CodeLine('  a bc ')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 4
        ));
        // Reset code lines, and select 'a'
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc')
        ]);
        controller.selection = CodeLineSelection.fromRange(
          range: const CodeLineRange(
            index: 0,
            start: 0,
            end: 1
          )
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          const CodeLine('  bc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ));
        // Reset code lines, and select 'b'
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc')
        ]);
        controller.selection = CodeLineSelection.fromRange(
          range: const CodeLineRange(
            index: 0,
            start: 1,
            end: 2
          )
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          const CodeLine('a c')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ));
        // Reset code lines, and select 'c'
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc')
        ]);
        controller.selection = CodeLineSelection.fromRange(
          range: const CodeLineRange(
            index: 0,
            start: 2,
            end: 3
          )
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          const CodeLine('ab  ')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 4
        ));
        // Reset code lines, and select all
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc')
        ]);
        controller.selectAll();
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('  abc')
        ]));
        expect(controller.selection, CodeLineSelection.fromRange(
          range: const CodeLineRange(
            index: 0,
            start: 0,
            end: 5
          )
        ));
        // Reset code lines, with a whitespace as prefix and selection offset is at 0
        controller.codeLines = CodeLines.of(const [
          CodeLine(' abc')
        ]);
        controller.selection = const CodeLineSelection.zero();
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          const CodeLine('   abc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
        ));
        // Reset code lines, with a whitespace as prefix and selection offset is at 1
        controller.codeLines = CodeLines.of(const [
          CodeLine(' abc')
        ]);
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          const CodeLine('  abc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
        ));
        // Reset code lines, with a whitespace as prefix and selected
        controller.codeLines = CodeLines.of(const [
          CodeLine(' abc')
        ]);
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 1
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          const CodeLine('  abc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2,
        ));
        // Reset code lines, with a whitespace as prefix and select all
        controller.codeLines = CodeLines.of(const [
          CodeLine(' abc')
        ]);
        controller.selectAll();
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          const CodeLine('  abc')
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 5
        ));
      }
      // Multi code lines
      {
        // Assign indent size is 2
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar',
          const CodeLineOptions(
            indentSize: 2
          )
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('  abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ));
        // select line 1-2 (all letters)
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 3
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('  abc'),
          CodeLine('  foo'),
          CodeLine('  bar'),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 5
        ));
        // Reset code lines
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]);
        // select line 1-2 (not all letters), base before extent
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 1,
          extentIndex: 2,
          extentOffset: 2
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('  foo'),
          CodeLine('  bar'),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 3,
          extentIndex: 2,
          extentOffset: 4
        ));
        // Reset code lines
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]);
        // select line 1-2 (not all letters), base after extent
        controller.selection = const CodeLineSelection(
          baseIndex: 2,
          baseOffset: 2,
          extentIndex: 1,
          extentOffset: 1
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('  foo'),
          CodeLine('  bar'),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 2,
          baseOffset: 4,
          extentIndex: 1,
          extentOffset: 3
        ));
        // Reset code lines
        controller.codeLines = CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]);
        // select line 1-2 (not all letters), the offset of line 2 is at 0 position
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 1,
          extentIndex: 2,
          extentOffset: 0
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('  foo'),
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 3,
          extentIndex: 2,
          extentOffset: 0
        ));
        // Reset code lines, add one whitespace at begin
        controller.codeLines = CodeLines.of(const [
          CodeLine(' abc'),
          CodeLine(' foo'),
          CodeLine(' bar'),
        ]);
        // select three lines and offset both at 1
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 2,
          extentOffset: 1
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('  abc'),
          CodeLine('  foo'),
          CodeLine('  bar'),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 2,
          extentOffset: 1
        ));
        // Reset code lines, add three whitespace at begin
        controller.codeLines = CodeLines.of(const [
          CodeLine('   abc'),
          CodeLine('   foo'),
          CodeLine('   bar'),
        ]);
        // select three lines and offset both at 1
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 2,
          extentOffset: 1
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('    abc'),
          CodeLine('    foo'),
          CodeLine('    bar'),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 2,
          extentOffset: 1
        ));
      }
      // Multi code lines, have a chunk.
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('{', [
              CodeLine('foo'),
              CodeLine('bar')
            ]),
            CodeLine('}')
          ]),
          options: const CodeLineOptions(
            indentSize: 2
          )
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('  {', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine('}')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ));
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('  { ', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine('}')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 4
        ));
        // Reset code lines and select all
        controller.codeLines = CodeLines.of(const [
          CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine('}')
        ]);
        controller.selectAll();
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('  {', [
            CodeLine('  foo'),
            CodeLine('  bar')
          ]),
          CodeLine('  }')
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 3
        ));
      }
      // Multi code lines, have a few of chunks
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('{', [
              CodeLine('foo'),
              CodeLine('bar')
            ]),
            CodeLine('}'),
            CodeLine('{', [
              CodeLine('foo'),
              CodeLine('bar')
            ]),
            CodeLine('}'),
            CodeLine('{', [
              CodeLine('foo'),
              CodeLine('bar')
            ]),
            CodeLine('}')
          ])
        );
        controller.selectAll();
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          CodeLine('${controller.options.indent}{', [
            CodeLine('${controller.options.indent}foo'),
            CodeLine('${controller.options.indent}bar')
          ]),
          CodeLine('${controller.options.indent}}'),
          CodeLine('${controller.options.indent}{', [
            CodeLine('${controller.options.indent}foo'),
            CodeLine('${controller.options.indent}bar')
          ]),
          CodeLine('${controller.options.indent}}'),
          CodeLine('${controller.options.indent}{', [
            CodeLine('${controller.options.indent}foo'),
            CodeLine('${controller.options.indent}bar')
          ]),
          CodeLine('${controller.options.indent}}')
        ]));
        expect(controller.selection, CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 5,
          extentOffset: controller.options.indentSize + 1
        ));
        // Reset code lines
        controller.codeLines = CodeLines.of(const [
          CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine('}'),
          CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine('}'),
          CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine('}')
        ]);
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 4,
          extentOffset: 1,
        );
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          CodeLine('${controller.options.indent}{', [
            CodeLine('${controller.options.indent}foo'),
            CodeLine('${controller.options.indent}bar')
          ]),
          CodeLine('${controller.options.indent}}'),
          CodeLine('${controller.options.indent}{', [
            CodeLine('${controller.options.indent}foo'),
            CodeLine('${controller.options.indent}bar')
          ]),
          CodeLine('${controller.options.indent}}'),
          CodeLine('${controller.options.indent}{', [
            const CodeLine('foo'),
            const CodeLine('bar')
          ]),
          const CodeLine('}')
        ]));
        expect(controller.selection, CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 4,
          extentOffset: controller.options.indentSize + 1
        ));
      }
      // Multi code lines, have nested chunks
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('{', [
              CodeLine('foo'),
              CodeLine('bar', [
                CodeLine('{', [
                  CodeLine('foo'),
                  CodeLine('bar')
                ]),
                CodeLine('}')
              ])
            ]),
            CodeLine('}'),
          ])
        );
        controller.selectAll();
        controller.applyIndent();
        expect(controller.codeLines, CodeLines.of([
          CodeLine('${controller.options.indent}{', [
            CodeLine('${controller.options.indent}foo'),
            CodeLine('${controller.options.indent}bar', [
              CodeLine('${controller.options.indent}{', [
                CodeLine('${controller.options.indent}foo'),
                CodeLine('${controller.options.indent}bar')
              ]),
              CodeLine('${controller.options.indent}}')
            ])
          ]),
          CodeLine('${controller.options.indent}}'),
        ]));
        expect(controller.selection, CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: controller.options.indentSize + 1
        ));
      }
    });

    test('`applyOutdent()`', () {
      // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc')
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
        // have one whitespace
        controller.codeLines = CodeLines.of(const [
          CodeLine(' abc')
        ]);
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc')
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
        // have one whitespace + one indent
        controller.codeLines = CodeLines.of([
          CodeLine(' ${controller.options.indent}abc')
        ]);
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of([
          CodeLine('${controller.options.indent}abc')
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc')
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
        // have one whitespace + one indent and selection position is after 'a'
        controller.codeLines = CodeLines.of([
          CodeLine(' ${controller.options.indent}abc')
        ]);
        controller.selection = CodeLineSelection.collapsed(
          index: 0,
          offset: 2 + controller.options.indentSize
        );
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of([
          CodeLine('${controller.options.indent}abc')
        ]));
        expect(controller.selection, CodeLineSelection.collapsed(
          index: 0,
          offset: 1 + controller.options.indentSize
        ));
        // have two indent and selection position is in the mid of intents
        controller.codeLines = CodeLines.of([
          CodeLine('${controller.options.indent}${controller.options.indent}abc')
        ]);
        controller.selection = CodeLineSelection.collapsed(
          index: 0,
          offset: controller.options.indentSize
        );
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of([
          CodeLine('${controller.options.indent}abc')
        ]));
        expect(controller.selection, CodeLineSelection.collapsed(
          index: 0,
          offset: controller.options.indentSize
        ));
        // have two indent and have selected the first
        controller.codeLines = CodeLines.of([
          CodeLine('${controller.options.indent}${controller.options.indent}abc')
        ]);
        controller.selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: controller.options.indentSize
        );
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of([
          CodeLine('${controller.options.indent}abc')
        ]));
        expect(controller.selection, CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: controller.options.indentSize
        ));
        // have two indent and have selected the second
        controller.codeLines = CodeLines.of([
          CodeLine('${controller.options.indent}${controller.options.indent}abc')
        ]);
        controller.selection = CodeLineSelection(
          baseIndex: 0,
          baseOffset: controller.options.indentSize,
          extentIndex: 0,
          extentOffset: controller.options.indentSize * 2
        );
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of([
          CodeLine('${controller.options.indent}abc')
        ]));
        expect(controller.selection, CodeLineSelection.collapsed(
          index: 0,
          offset: controller.options.indentSize
        ));
        // have three whitespace and have selected the first (one indent = two whitespace)
        controller.codeLines = CodeLines.of(const [
          CodeLine('   abc')
        ]);
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 1
        );
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('  abc')
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 1
        ));
        // have three whitespace and have selected the second (one indent = two whitespace)
        controller.codeLines = CodeLines.of(const [
          CodeLine('   abc')
        ]);
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('  abc')
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        ));
        // have three whitespace and have selected the third (one indent = two whitespace)
        controller.codeLines = CodeLines.of(const [
          CodeLine('   abc')
        ]);
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 2,
          extentIndex: 0,
          extentOffset: 3
        );
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('  abc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ));
      }
      // Multi code lines without indent
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.applyOutdent();
        // select line 1-2 (all letters)
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 3
        );
        controller.applyOutdent();
        // select all
        controller.selectAll();
        controller.applyOutdent();
      }
      // Multi code lines with indents
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText(' abc \n foo \n bar ');
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc '),
          CodeLine(' foo '),
          CodeLine(' bar '),
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
        // select line 1-2 (all letters)
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 5
        );
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc '),
          CodeLine('foo '),
          CodeLine('bar '),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 4
        ));
        // Rest code lines
        controller.codeLines = CodeLines.of(const [
          CodeLine(' abc '),
          CodeLine(' foo '),
          CodeLine(' bar '),
        ]);
        // select all
        controller.selectAll();
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc '),
          CodeLine('foo '),
          CodeLine('bar '),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 4
        ));
        // Rest code lines
        controller.codeLines = CodeLines.of([
          CodeLine(' ${controller.options.indent}abc'),
          CodeLine(' ${controller.options.indent}${controller.options.indent}foo'),
          CodeLine(' ${controller.options.indent}${controller.options.indent}${controller.options.indent}bar'),
        ]);
        controller.selectAll();
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of([
          CodeLine('${controller.options.indent}abc'),
          CodeLine('${controller.options.indent}${controller.options.indent}foo'),
          CodeLine('${controller.options.indent}${controller.options.indent}${controller.options.indent}bar'),
        ]));
        expect(controller.selection, CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 3 + controller.options.indentSize * 3
        ));
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of([
          const CodeLine('abc'),
          CodeLine('${controller.options.indent}foo'),
          CodeLine('${controller.options.indent}${controller.options.indent}bar'),
        ]));
        expect(controller.selection, CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 3 + controller.options.indentSize * 2
        ));
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of([
          const CodeLine('abc'),
          const CodeLine('foo'),
          CodeLine('${controller.options.indent}bar'),
        ]));
        expect(controller.selection, CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 3 + controller.options.indentSize
        ));
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 3
        ));
      }
      // Multi code lines, have a chunk.
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine(' {', [
              CodeLine(' foo'),
              CodeLine(' bar')
            ]),
            CodeLine('}')
          ])
        );
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine(' foo'),
            CodeLine(' bar')
          ]),
          CodeLine('}')
        ]));
        expect(controller.selection, const CodeLineSelection.zero());
        // Rest code lines
        controller.codeLines = CodeLines.of(const [
          CodeLine(' {', [
            CodeLine(' foo'),
            CodeLine(' bar')
          ]),
          CodeLine(' }')
        ]);
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 0
        );
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine(' }')
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 0
        ));
        // Rest code lines
        controller.codeLines = CodeLines.of(const [
          CodeLine(' {', [
            CodeLine(' foo'),
            CodeLine(' bar')
          ]),
          CodeLine(' }')
        ]);
        controller.selectAll();
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine('}')
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 1
        ));
        controller.applyOutdent();
        // Rest code lines
        controller.codeLines = CodeLines.of(const [
          CodeLine('{', [
            CodeLine(' foo'),
            CodeLine(' bar')
          ]),
          CodeLine('}')
        ]);
        controller.selectAll();
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine('}')
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 1
        ));
      }
      // Multi code lines, have a few of chunks
      {
        final CodeLineEditingController controller = CodeLineEditingController();
        controller.codeLines = CodeLines.of([
          CodeLine('${controller.options.indent}{', [
            CodeLine('${controller.options.indent}foo'),
            CodeLine('${controller.options.indent}bar')
          ]),
          CodeLine('${controller.options.indent}}'),
          CodeLine('${controller.options.indent}{', [
            CodeLine('${controller.options.indent}foo'),
            CodeLine('${controller.options.indent}bar')
          ]),
          CodeLine('${controller.options.indent}}'),
          CodeLine('${controller.options.indent}{', [
            CodeLine('${controller.options.indent}foo'),
            CodeLine('${controller.options.indent}bar')
          ]),
          CodeLine('${controller.options.indent}}')
        ]);
        controller.selectAll();
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine('}'),
          CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine('}'),
          CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine('}')
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 5,
          extentOffset: 1
        ));
        // Reset code lines
        controller.codeLines = CodeLines.of([
          CodeLine('${controller.options.indent}{', [
            CodeLine('${controller.options.indent}foo'),
            CodeLine('${controller.options.indent}bar')
          ]),
          CodeLine('${controller.options.indent}}'),
          CodeLine('${controller.options.indent}{', [
            CodeLine('${controller.options.indent}foo'),
            CodeLine('${controller.options.indent}bar')
          ]),
          CodeLine('${controller.options.indent}}'),
          CodeLine('${controller.options.indent}{', [
            CodeLine('${controller.options.indent}foo'),
            CodeLine('${controller.options.indent}bar')
          ]),
          CodeLine('${controller.options.indent}}')
        ]);
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 4,
          extentOffset: 1,
        );
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of([
          const CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          const CodeLine('}'),
          const CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          const  CodeLine('}'),
          CodeLine('{', [
            CodeLine('${controller.options.indent}foo'),
            CodeLine('${controller.options.indent}bar')
          ]),
          CodeLine('${controller.options.indent}}')
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 4,
          extentOffset: 0
        ));
        controller.applyOutdent();
      }
      // Multi code lines, have nested chunks
      {
        final CodeLineEditingController controller = CodeLineEditingController();
        controller.codeLines = CodeLines.of([
          CodeLine('${controller.options.indent}{', [
            CodeLine('${controller.options.indent}foo'),
            CodeLine('${controller.options.indent}bar', [
              CodeLine('${controller.options.indent}{', [
                CodeLine('${controller.options.indent}foo'),
                CodeLine('${controller.options.indent}bar')
              ]),
              CodeLine('${controller.options.indent}}')
            ])
          ]),
          CodeLine('${controller.options.indent}}'),
        ]);
        controller.selectAll();
        controller.applyOutdent();
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar', [
              CodeLine('{', [
                CodeLine('foo'),
                CodeLine('bar')
              ]),
              CodeLine('}')
            ])
          ]),
          CodeLine('}'),
        ]));
        expect(controller.selection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 1
        ));
      }
    });

    test('`collapseChunk() && expandChunk()`', () {
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.collapseChunk(0, 3);
        expect(controller.value, CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar'),
            ]),
          ])
        ));
        controller.expandChunk(0);
        expect(controller.value, CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('abc'),
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        ));
      }
      {
        const String json = '{\n'
          '  "start": "foo",\n'
          '  "abc": [\n'
          '    0,\n'
          '    1,\n'
          '    2,\n'
          '  ],\n'
          '  "end": "bar"\n'
          '}';
        final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
        // Collapse inner array
        controller.collapseChunk(2, 6);
        expect(controller.value, CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('{'),
            CodeLine('  "start": "foo",'),
            CodeLine('  "abc": [', [
              CodeLine('    0,'),
              CodeLine('    1,'),
              CodeLine('    2,'),
            ]),
            CodeLine('  ],'),
            CodeLine('  "end": "bar"'),
            CodeLine('}'),
          ])
        ));
        // Collapse the root object
        controller.collapseChunk(0, 5);
        expect(controller.value, CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('{', [
              CodeLine('  "start": "foo",'),
              CodeLine('  "abc": [', [
                CodeLine('    0,'),
                CodeLine('    1,'),
                CodeLine('    2,'),
              ]),
              CodeLine('  ],'),
              CodeLine('  "end": "bar"'),
            ]),
            CodeLine('}'),
          ])
        ));
        // Expand the root object
        controller.expandChunk(0);
        expect(controller.value, CodeLineEditingValue(
          codeLines: CodeLines.of(const [
            CodeLine('{'),
            CodeLine('  "start": "foo",'),
            CodeLine('  "abc": [', [
              CodeLine('    0,'),
              CodeLine('    1,'),
              CodeLine('    2,'),
            ]),
            CodeLine('  ],'),
            CodeLine('  "end": "bar"'),
            CodeLine('}'),
          ])
        ));
        // Expand the inner array
        controller.expandChunk(2);
        expect(controller.value, CodeLineEditingController.fromText(json).value);
      }
      // Test selection
      {
        const String json = '{\n'
          '  "start": "foo",\n'
          '  "abc": [\n'
          '    0,\n'
          '    1,\n'
          '    2,\n'
          '  ],\n'
          '  "end": "bar"\n'
          '}';
        // Selection position before array
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = const CodeLineSelection.collapsed(
            index: 1,
            offset: 0
          );
          controller.collapseChunk(2, 6);
          expect(controller.selection, const CodeLineSelection.collapsed(
            index: 1,
            offset: 0
          ));
        }
        // Selection range before array (base before extent)
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = const CodeLineSelection(
            baseIndex: 0,
            baseOffset: 0,
            extentIndex: 1,
            extentOffset: 0
          );
          controller.collapseChunk(2, 6);
          expect(controller.selection, const CodeLineSelection(
            baseIndex: 0,
            baseOffset: 0,
            extentIndex: 1,
            extentOffset: 0
          ));
        }
        // Selection range before array (base after extent)
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = const CodeLineSelection(
            baseIndex: 1,
            baseOffset: 0,
            extentIndex: 0,
            extentOffset: 0
          );
          controller.collapseChunk(2, 6);
          expect(controller.selection, const CodeLineSelection(
            baseIndex: 1,
            baseOffset: 0,
            extentIndex: 0,
            extentOffset: 0
          ));
        }
        // Selection position is inside the collapse region, should move position to parent end.
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = const CodeLineSelection.collapsed(
            index: 3,
            offset: 0
          );
          controller.collapseChunk(2, 6);
          expect(controller.selection, CodeLineSelection.collapsed(
            index: 2,
            offset: controller.codeLines[2].text.length
          ));
        }
        // Selection range is included in collapse region, should move position to parent end.
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = const CodeLineSelection(
            baseIndex: 3,
            baseOffset: 0,
            extentIndex: 5,
            extentOffset: 0
          );
          controller.collapseChunk(2, 6);
          expect(controller.selection, CodeLineSelection.collapsed(
            index: 2,
            offset: controller.codeLines[2].text.length
          ));
        }
        // Selection base is before collapse region and extent is after collapse region
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = const CodeLineSelection(
            baseIndex: 1,
            baseOffset: 0,
            extentIndex: 7,
            extentOffset: 0
          );
          controller.collapseChunk(2, 6);
          expect(controller.selection, const CodeLineSelection(
            baseIndex: 1,
            baseOffset: 0,
            extentIndex: 4,
            extentOffset: 0
          ));
        }
        // Selection base is before collapse region and extent is inside collapse region
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = const CodeLineSelection(
            baseIndex: 1,
            baseOffset: 0,
            extentIndex: 4,
            extentOffset: 0
          );
          controller.collapseChunk(2, 6);
          expect(controller.selection, CodeLineSelection(
            baseIndex: 1,
            baseOffset: 0,
            extentIndex: 2,
            extentOffset: controller.codeLines[2].text.length
          ));
        }
        // Selection base is inside collapse region and extent is after collapse region
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = const CodeLineSelection(
            baseIndex: 4,
            baseOffset: 0,
            extentIndex: 7,
            extentOffset: 0
          );
          controller.collapseChunk(2, 6);
          expect(controller.selection, CodeLineSelection(
            baseIndex: 2,
            baseOffset: controller.codeLines[2].text.length,
            extentIndex: 4,
            extentOffset: 0
          ));
        }
        // Selection extent is before collapse region and base is after collapse region
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = const CodeLineSelection(
            baseIndex: 7,
            baseOffset: 0,
            extentIndex: 1,
            extentOffset: 0
          );
          controller.collapseChunk(2, 6);
          expect(controller.selection, const CodeLineSelection(
            baseIndex: 4,
            baseOffset: 0,
            extentIndex: 1,
            extentOffset: 0
          ));
        }
        // Selection extent is before collapse region and base is inside collapse region
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = const CodeLineSelection(
            baseIndex: 4,
            baseOffset: 0,
            extentIndex: 1,
            extentOffset: 0
          );
          controller.collapseChunk(2, 6);
          expect(controller.selection, CodeLineSelection(
            baseIndex: 2,
            baseOffset: controller.codeLines[2].text.length,
            extentIndex: 1,
            extentOffset: 0
          ));
        }
        // Selection extent is inside collapse region and base is after collapse region
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = const CodeLineSelection(
            baseIndex: 7,
            baseOffset: 0,
            extentIndex: 4,
            extentOffset: 0
          );
          controller.collapseChunk(2, 6);
          expect(controller.selection, CodeLineSelection(
            baseIndex: 4,
            baseOffset: 0,
            extentIndex: 2,
            extentOffset: controller.codeLines[2].text.length,
          ));
        }
        // Selection position after array
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = const CodeLineSelection.collapsed(
            index: 7,
            offset: 0
          );
          controller.collapseChunk(2, 6);
          expect(controller.selection, const CodeLineSelection.collapsed(
            index: 4,
            offset: 0
          ));
        }
        // Selection range after array (base before extent)
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = const CodeLineSelection(
            baseIndex: 7,
            baseOffset: 0,
            extentIndex: 8,
            extentOffset: 0
          );
          controller.collapseChunk(2, 6);
          expect(controller.selection, const CodeLineSelection(
            baseIndex: 4,
            baseOffset: 0,
            extentIndex: 5,
            extentOffset: 0
          ));
        }
        // Selection range after array (base after extent)
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = const CodeLineSelection(
            baseIndex: 8,
            baseOffset: 0,
            extentIndex: 7,
            extentOffset: 0
          );
          controller.collapseChunk(2, 6);
          expect(controller.selection, const CodeLineSelection(
            baseIndex: 5,
            baseOffset: 0,
            extentIndex: 4,
            extentOffset: 0
          ));
        }
      }
      // Test composing
      {
        const String json = '{\n'
          '  "start": "foo",\n'
          '  "abc": [\n'
          '    0,\n'
          '    1,\n'
          '    2,\n'
          '  ],\n'
          '  "end": "bar"\n'
          '}';
        // Composing is before the collapsed chunk
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.composing = TextRange.empty;
          controller.collapseChunk(2, 6);
          expect(controller.composing, TextRange.empty);
          controller.expandChunk(2);
          expect(controller.composing, TextRange.empty);
        }
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.composing = const TextRange.collapsed(1);
          controller.collapseChunk(2, 6);
          expect(controller.composing, const TextRange.collapsed(1));
          controller.expandChunk(2);
          expect(controller.composing, const TextRange.collapsed(1));
        }
        // Composing is in the collapsed chunk
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = CodeLineSelection.fromPosition(
            position: const CodeLinePosition(
              index: 3,
              offset: 0
            )
          );
          controller.composing = const TextRange.collapsed(1);
          controller.collapseChunk(2, 6);
          expect(controller.composing, TextRange.empty);
        }
        // Composing is after the collapsed chunk
        {
          final CodeLineEditingController controller = CodeLineEditingController.fromText(json);
          controller.selection = CodeLineSelection.fromPosition(
            position: const CodeLinePosition(
              index: 7,
              offset: 0
            )
          );
          controller.composing = const TextRange.collapsed(1);
          controller.collapseChunk(2, 6);
          expect(controller.composing, const TextRange.collapsed(1));
          controller.expandChunk(2);
          expect(controller.composing, const TextRange.collapsed(1));
        }
      }
    });

    test('`replaceSelection()`', () {
      // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.replaceSelection('abc');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.replaceSelection('abc');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abcabc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        controller.replaceSelection('foo');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abcfooabc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 6
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 3,
          extentIndex: 0,
          extentOffset: 6
        );
        controller.replaceSelection('bar');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abcbarabc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 6
        ));
        controller.replaceSelection('');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abcbarabc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 6
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 3,
          extentIndex: 0,
          extentOffset: 6
        );
        controller.replaceSelection('');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abcabc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 3
        ));
        controller.replaceSelection('foo\nbar');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abcfoo'),
          CodeLine('barabc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 3
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 3
        );
        controller.replaceSelection('123\n456\n789');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abcfoo'),
          CodeLine('123'),
          CodeLine('456'),
          CodeLine('789abc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 3,
          offset: 3
        ));
        controller.replaceSelection('456', const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 3
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abcfoo'),
          CodeLine('456'),
          CodeLine('456'),
          CodeLine('789abc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 3
        ));
        controller.replaceSelection('123\n123', const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 2,
          extentOffset: 3
        ));
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('abcfoo'),
          CodeLine('123'),
          CodeLine('123'),
          CodeLine('789abc')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 3
        ));
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('abc', [
              CodeLine('123')
            ]),
            CodeLine('foo', [
              CodeLine('456')
            ]),
            CodeLine('bar', [
              CodeLine('789')
            ]),
          ])
        );
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        controller.replaceSelection(' ');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('a c', [
            CodeLine('123')
          ]),
          CodeLine('foo', [
            CodeLine('456')
          ]),
          CodeLine('bar', [
            CodeLine('789')
          ]),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 1,
          baseOffset: 0,
          extentIndex: 1,
          extentOffset: 3
        );
        controller.replaceSelection('hello\nreqable\n');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('a c', [
            CodeLine('123')
          ]),
          CodeLine('hello'),
          CodeLine('reqable'),
          CodeLine('', [
            CodeLine('456')
          ]),
          CodeLine('bar', [
            CodeLine('789')
          ]),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 3,
          offset: 0
        ));
        controller.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 4,
          extentOffset: 3
        );
        controller.replaceSelection('b');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('ab', [
            CodeLine('789')
          ]),
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        ));
      }
    });

    test('`replaceAll()`', () {
      // Empty content
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('');
        controller.replaceAll('', 'abc');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty
        ]));
        controller.replaceAll('abc', 'abc');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine.empty
        ]));
      }
      // Single code line
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
        controller.replaceAll('abc', 'foo');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('foo')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 0
        ));
        controller.selection = const CodeLineSelection.collapsed(
          index: 0,
          offset: 2
        );
        controller.replaceAll('o', '123');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('f123123')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 4
        ));
        controller.replaceAll('123', '123456789');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('f123456789123456789')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 10
        ));
        controller.replaceAll('123456789', '\n');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('f'),
          CodeLine(''),
          CodeLine('')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        ));
      }
      // Multi code lines
      {
        final CodeLineEditingController controller = CodeLineEditingController.fromText('abc\nfoo\nbar');
        controller.replaceAll('a', '123');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('123bc'),
          CodeLine('foo'),
          CodeLine('b123r')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 0
        ));
        controller.selection = const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        );
        controller.replaceAll('b', '456');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('123456c'),
          CodeLine('foo'),
          CodeLine('456123r')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 1,
          offset: 0
        ));
        controller.selection = const CodeLineSelection.collapsed(
          index: 2,
          offset: 7
        );
        controller.replaceAll(RegExp('\\d'), 'zzz');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine('zzzzzzzzzzzzzzzzzzc'),
          CodeLine('foo'),
          CodeLine('zzzzzzzzzzzzzzzzzzr')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 2,
          offset: 19
        ));
        controller.replaceAll('zzzzz', '\n');
        expect(controller.codeLines, CodeLines.of(const [
          CodeLine(''),
          CodeLine(''),
          CodeLine(''),
          CodeLine('zzzc'),
          CodeLine('foo'),
          CodeLine(''),
          CodeLine(''),
          CodeLine(''),
          CodeLine('zzzr')
        ]));
        expect(controller.selection, const CodeLineSelection.collapsed(
          index: 8,
          offset: 4
        ));
      }
    });

    test('`clearComposing()`', () {
      final CodeLineEditingController controller = CodeLineEditingController.fromText('abc');
      const TextRange composing = TextRange(
        start: 0,
        end: 1
      );
      controller.composing = composing;
      expect(controller.composing, composing);
      expect(controller.isComposing, true);
      controller.clearComposing();
      expect(controller.composing, TextRange.empty);
      expect(controller.isComposing, false);
    });

  });
}