import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  group('CodeFindController getter ', () {
    test('`allMatchSelections`', () async {
      {
        final CodeFindController controller = CodeFindController(CodeLineEditingController());
        expect(controller.allMatchSelections, null);
        controller.close();
      }
      {
        final CodeFindController controller = CodeFindController(CodeLineEditingController.fromText('abc'), const CodeFindValue(
          option: CodeFindOption(
            pattern: 'a',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: false
        ));
        expect(controller.allMatchSelections, null);
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.allMatchSelections, const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 0,
            extentIndex: 0,
            extentOffset: 1
          )
        ]);
        controller.close();
      }
      {
        final CodeFindController controller = CodeFindController(CodeLineEditingController.fromText('abc\nfoo\nbar'), const CodeFindValue(
          option: CodeFindOption(
            pattern: 'a',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: false
        ));
        expect(controller.allMatchSelections, null);
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.allMatchSelections, const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 0,
            extentIndex: 0,
            extentOffset: 1
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 1,
            extentIndex: 2,
            extentOffset: 2
          )
        ]);
        controller.close();
      }
      {
        final CodeFindController controller = CodeFindController(CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar')
            ]),
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar')
            ]),
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar')
            ])
          ])
        ), const CodeFindValue(
          option: CodeFindOption(
            pattern: 'a',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: false
        ));
        expect(controller.allMatchSelections, null);
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.allMatchSelections, const [
          CodeLineSelection(
            baseIndex: 0,
            baseOffset: 0,
            extentIndex: 0,
            extentOffset: 1
          ),
          CodeLineSelection(
            baseIndex: 1,
            baseOffset: 0,
            extentIndex: 1,
            extentOffset: 1
          ),
          CodeLineSelection(
            baseIndex: 2,
            baseOffset: 0,
            extentIndex: 2,
            extentOffset: 1
          ),
        ]);
        controller.close();
      }
    });

    test('`currentMatchSelection`', () async {
      {
        final CodeFindController controller = CodeFindController(CodeLineEditingController());
        expect(controller.currentMatchSelection, null);
        controller.close();
      }
      {
        final CodeFindController controller = CodeFindController(CodeLineEditingController.fromText('abc'), const CodeFindValue(
          option: CodeFindOption(
            pattern: 'a',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: false
        ));
        expect(controller.currentMatchSelection, null);
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.currentMatchSelection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 1
        ));
        controller.close();
      }
      {
        final CodeFindController controller = CodeFindController(CodeLineEditingController.fromText('abc\nfoo\nbar'), const CodeFindValue(
          option: CodeFindOption(
            pattern: 'a',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: false
        ));
        expect(controller.currentMatchSelection, null);
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.currentMatchSelection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 1
        ));
        controller.nextMatch();
        expect(controller.currentMatchSelection, const CodeLineSelection(
          baseIndex: 2,
          baseOffset: 1,
          extentIndex: 2,
          extentOffset: 2
        ));
        controller.close();
      }
      {
        final CodeFindController controller = CodeFindController(CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar')
            ]),
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar')
            ]),
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar')
            ])
          ])
        ), const CodeFindValue(
          option: CodeFindOption(
            pattern: 'a',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: false
        ));
        expect(controller.currentMatchSelection, null);
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.currentMatchSelection, const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 0,
          extentIndex: 0,
          extentOffset: 1
        ));
      }
    });
  });

  group('CodeFindController method ', () {
    test('`findMode`', () async {
      {
        final CodeFindController controller = CodeFindController(CodeLineEditingController.fromText('abc'));
        expect(controller.value, null);
        controller.findMode();
        expect(controller.value, const CodeFindValue(
          option: CodeFindOption(
            pattern: '',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: false
        ));
      }
      {
        final CodeLineEditingController editingController = CodeLineEditingController.fromText('abc');
        editingController.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        final CodeFindController controller = CodeFindController(editingController);
        expect(controller.value, null);
        controller.findMode();
        expect(controller.value, const CodeFindValue(
          option: CodeFindOption(
            pattern: 'b',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: false,
          searching: true
        ));
        expect(controller.findInputController.text, 'b');
        expect(controller.findInputController.selection, const TextSelection(
          baseOffset: 0,
          extentOffset: 1
        ));
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.value, CodeFindValue(
          option: const CodeFindOption(
            pattern: 'b',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: false,
          result: CodeFindResult(
            index: 0,
            matches: const [
              CodeLineSelection(
                baseIndex: 0,
                baseOffset: 1,
                extentIndex: 0,
                extentOffset: 2
              )
            ],
            option: const CodeFindOption(
              pattern: 'b',
              caseSensitive: false,
              regex: false
            ),
            codeLines: CodeLines.of([
              const CodeLine('abc')
            ]),
            dirty: false
          )
        ));
      }
    });

    test('`replaceMode`', () async {
      {
        final CodeFindController controller = CodeFindController(CodeLineEditingController.fromText('abc'));
        expect(controller.value, null);
        controller.replaceMode();
        expect(controller.value, const CodeFindValue(
          option: CodeFindOption(
            pattern: '',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: true,
        ));
      }
      {
        final CodeLineEditingController editingController = CodeLineEditingController.fromText('abc');
        editingController.selection = const CodeLineSelection(
          baseIndex: 0,
          baseOffset: 1,
          extentIndex: 0,
          extentOffset: 2
        );
        final CodeFindController controller = CodeFindController(editingController);
        expect(controller.value, null);
        controller.replaceMode();
        expect(controller.value, const CodeFindValue(
          option: CodeFindOption(
            pattern: 'b',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: true,
          searching: true
        ));
        expect(controller.findInputController.text, 'b');
        expect(controller.findInputController.selection, const TextSelection(
          baseOffset: 0,
          extentOffset: 1
        ));
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.value, CodeFindValue(
          option: const CodeFindOption(
            pattern: 'b',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: true,
          result: CodeFindResult(
            index: 0,
            matches: const [
              CodeLineSelection(
                baseIndex: 0,
                baseOffset: 1,
                extentIndex: 0,
                extentOffset: 2
              )
            ],
            option: const CodeFindOption(
              pattern: 'b',
              caseSensitive: false,
              regex: false
            ),
            codeLines: CodeLines.of([
              const CodeLine('abc')
            ]),
            dirty: false
          )
        ));
      }
    });

    test('`focusOnFindInput`', () {
      final CodeFindController controller = CodeFindController(CodeLineEditingController());
      controller.findInputController.text = 'abc';
      controller.focusOnFindInput();
      expect(controller.findInputController.selection, const TextSelection(
        baseOffset: 0,
        extentOffset: 3
      ));
    });

    test('`focusOnReplaceInput`', () {
      final CodeFindController controller = CodeFindController(CodeLineEditingController());
      controller.replaceInputController.text = 'abc';
      controller.focusOnReplaceInput();
      expect(controller.replaceInputController.selection, const TextSelection(
        baseOffset: 0,
        extentOffset: 3
      ));
    });

    test('`toggleMode`', () {
      final CodeFindController controller = CodeFindController(CodeLineEditingController.fromText('abc'));
      controller.findMode();
      expect(controller.value?.replaceMode, false);
      controller.toggleMode();
      expect(controller.value?.replaceMode, true);
      controller.toggleMode();
      expect(controller.value?.replaceMode, false);
      controller.toggleMode();
      expect(controller.value?.replaceMode, true);
    });

    test('`close`', () {
      final CodeFindController controller = CodeFindController(CodeLineEditingController.fromText('abc'));
      controller.findMode();
      expect(controller.value != null, true);
      controller.close();
      expect(controller.value != null, false);
      controller.findMode();
      expect(controller.value != null, true);
      controller.close();
      expect(controller.value != null, false);
    });

    test('`toggleRegex`', () {
      final CodeFindController controller = CodeFindController(CodeLineEditingController.fromText('abc'));
      controller.findMode();
      expect(controller.value?.option.regex, false);
      controller.toggleRegex();
      expect(controller.value?.option.regex, true);
      controller.toggleRegex();
      expect(controller.value?.option.regex, false);
      controller.toggleRegex();
      expect(controller.value?.option.regex, true);
    });

    test('`toggleCaseSensitive`', () {
      final CodeFindController controller = CodeFindController(CodeLineEditingController.fromText('abc'));
      controller.findMode();
      expect(controller.value?.option.caseSensitive, false);
      controller.toggleCaseSensitive();
      expect(controller.value?.option.caseSensitive, true);
      controller.toggleCaseSensitive();
      expect(controller.value?.option.caseSensitive, false);
      controller.toggleCaseSensitive();
      expect(controller.value?.option.caseSensitive, true);
    });

    test('`previousMatch & nextMatch`', () async {
      {
        final CodeFindController controller = CodeFindController(CodeLineEditingController.fromText('abcabcabc'));
        controller.findMode();
        controller.findInputController.text = 'a';
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.value, CodeFindValue(
          option: const CodeFindOption(
            pattern: 'a',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: false,
          result: CodeFindResult(
            index: 0,
            matches: const [
              CodeLineSelection(
                baseIndex: 0,
                baseOffset: 0,
                extentIndex: 0,
                extentOffset: 1
              ),
              CodeLineSelection(
                baseIndex: 0,
                baseOffset: 3,
                extentIndex: 0,
                extentOffset: 4
              ),
              CodeLineSelection(
                baseIndex: 0,
                baseOffset: 6,
                extentIndex: 0,
                extentOffset: 7
              )
            ],
            option: const CodeFindOption(
              pattern: 'a',
              caseSensitive: false,
              regex: false
            ),
            codeLines: CodeLines.of([
              const CodeLine('abcabcabc')
            ]),
            dirty: false
          )
        ));
        controller.previousMatch();
        expect(controller.value, CodeFindValue(
          option: const CodeFindOption(
            pattern: 'a',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: false,
          result: CodeFindResult(
            index: 2,
            matches: const [
              CodeLineSelection(
                baseIndex: 0,
                baseOffset: 0,
                extentIndex: 0,
                extentOffset: 1
              ),
              CodeLineSelection(
                baseIndex: 0,
                baseOffset: 3,
                extentIndex: 0,
                extentOffset: 4
              ),
              CodeLineSelection(
                baseIndex: 0,
                baseOffset: 6,
                extentIndex: 0,
                extentOffset: 7
              )
            ],
            option: const CodeFindOption(
              pattern: 'a',
              caseSensitive: false,
              regex: false
            ),
            codeLines: CodeLines.of([
              const CodeLine('abcabcabc')
            ]),
            dirty: false
          )
        ));
        controller.previousMatch();
        expect(controller.value, CodeFindValue(
          option: const CodeFindOption(
            pattern: 'a',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: false,
          result: CodeFindResult(
            index: 1,
            matches: [
              const CodeLineSelection(
                baseIndex: 0,
                baseOffset: 0,
                extentIndex: 0,
                extentOffset: 1
              ),
              const CodeLineSelection(
                baseIndex: 0,
                baseOffset: 3,
                extentIndex: 0,
                extentOffset: 4
              ),
              const CodeLineSelection(
                baseIndex: 0,
                baseOffset: 6,
                extentIndex: 0,
                extentOffset: 7
              )
            ],
            option: const CodeFindOption(
              pattern: 'a',
              caseSensitive: false,
              regex: false
            ),
            codeLines: CodeLines.of([
              const CodeLine('abcabcabc')
            ]),
            dirty: false
          )
        ));
        controller.nextMatch();
        expect(controller.value, CodeFindValue(
          option: const CodeFindOption(
            pattern: 'a',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: false,
          result: CodeFindResult(
            index: 2,
            matches: const [
              CodeLineSelection(
                baseIndex: 0,
                baseOffset: 0,
                extentIndex: 0,
                extentOffset: 1
              ),
              CodeLineSelection(
                baseIndex: 0,
                baseOffset: 3,
                extentIndex: 0,
                extentOffset: 4
              ),
              CodeLineSelection(
                baseIndex: 0,
                baseOffset: 6,
                extentIndex: 0,
                extentOffset: 7
              )
            ],
            option: const CodeFindOption(
              pattern: 'a',
              caseSensitive: false,
              regex: false
            ),
            codeLines: CodeLines.of(const [
              CodeLine('abcabcabc')
            ]),
            dirty: false
          )
        ));
        controller.nextMatch();
        expect(controller.value, CodeFindValue(
          option: const CodeFindOption(
            pattern: 'a',
            caseSensitive: false,
            regex: false
          ),
          replaceMode: false,
          result: CodeFindResult(
            index: 0,
            matches: const [
              CodeLineSelection(
                baseIndex: 0,
                baseOffset: 0,
                extentIndex: 0,
                extentOffset: 1
              ),
              CodeLineSelection(
                baseIndex: 0,
                baseOffset: 3,
                extentIndex: 0,
                extentOffset: 4
              ),
              CodeLineSelection(
                baseIndex: 0,
                baseOffset: 6,
                extentIndex: 0,
                extentOffset: 7
              )
            ],
            option: const CodeFindOption(
              pattern: 'a',
              caseSensitive: false,
              regex: false
            ),
            codeLines: CodeLines.of(const [
              CodeLine('abcabcabc')
            ]),
            dirty: false
          )
        ));
      }
      // Test auto expand chubnk
      {
        final CodeLineEditingController editingController = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar'),
            ]),
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar'),
            ]),
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar'),
            ]),
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar'),
            ])
          ]
        ));
        final CodeFindController controller = CodeFindController(editingController);
        controller.findMode();
        controller.findInputController.text = 'a';
        await Future.delayed(const Duration(milliseconds: 200));
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        ]));
        controller.nextMatch();
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        ]));
        controller.nextMatch();
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        ]));
        controller.previousMatch();
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        ]));
        controller.previousMatch();
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        ]));
        controller.previousMatch();
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]));
      }
    });

    test('`replaceMatch`', () async {
      {
        final CodeLineEditingController editingController = CodeLineEditingController.fromText('abcabcabc');
        final CodeFindController controller = CodeFindController(editingController);
        controller.replaceMode();
        controller.findInputController.text = 'a';
        controller.replaceInputController.text = 'b';
        await Future.delayed(const Duration(milliseconds: 200));
        controller.replaceMatch();
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('bbcabcabc')
        ]));
        await Future.delayed(const Duration(milliseconds: 200));
        controller.replaceMatch();
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('bbcbbcabc')
        ]));
        await Future.delayed(const Duration(milliseconds: 200));
        controller.replaceMatch();
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('bbcbbcbbc')
        ]));
      }
      // replace with same text
      {
        final CodeLineEditingController editingController = CodeLineEditingController.fromText('abcabcabc');
        final CodeFindController controller = CodeFindController(editingController);
        controller.replaceMode();
        controller.findInputController.text = 'a';
        controller.replaceInputController.text = 'a';
        await Future.delayed(const Duration(milliseconds: 200));
        controller.replaceMatch();
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('abcabcabc')
        ]));
        expect(editingController.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 1
        ));
        expect(controller.value?.result?.index, 1);
        expect(controller.value?.result?.dirty, false);
        await Future.delayed(const Duration(milliseconds: 200));
        controller.replaceMatch();
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('abcabcabc')
        ]));
        expect(editingController.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 4
        ));
        expect(controller.value?.result?.index, 2);
        expect(controller.value?.result?.dirty, false);
        await Future.delayed(const Duration(milliseconds: 200));
        controller.replaceMatch();
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('abcabcabc')
        ]));
        expect(editingController.selection, const CodeLineSelection.collapsed(
          index: 0,
          offset: 7
        ));
        expect(controller.value?.result?.index, 0);
        expect(controller.value?.result?.dirty, false);
      }
      // Test code line chunks
      {
        final CodeLineEditingController editingController = CodeLineEditingController(
          codeLines: CodeLines.of(const [
             CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar')
            ]),
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar')
            ]),
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar')
            ])
          ])
        );
        final CodeFindController controller = CodeFindController(editingController);
        controller.replaceMode();
        controller.findInputController.text = 'a';
        controller.replaceInputController.text = 'b';
        await Future.delayed(const Duration(milliseconds: 200));
        controller.replaceMatch();
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('bbc'),
          CodeLine('foo'),
          CodeLine('bar'),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar')
          ])
        ]));
        await Future.delayed(const Duration(milliseconds: 200));
        controller.replaceMatch();
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('bbc'),
          CodeLine('foo'),
          CodeLine('bbr'),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar')
          ]),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar')
          ])
        ]));
        await Future.delayed(const Duration(milliseconds: 200));
        controller.replaceMatch();
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('bbc'),
          CodeLine('foo'),
          CodeLine('bbr'),
          CodeLine('bbc'),
          CodeLine('foo'),
          CodeLine('bar'),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar')
          ])
        ]));
      }
    });
  });
}