import 'package:flutter_test/flutter_test.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  group('CodeChunkController constructor', () {
    test('CodeChunkController()', () async {
      {
        final CodeChunkController controller = CodeChunkController(CodeLineEditingController(),
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200), () {
          expect(controller.value, const []);
          controller.dispose();
        });
      }
      {
        final CodeChunkController controller = CodeChunkController(CodeLineEditingController.fromText('{\n\n}'),
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.value, const [
          CodeChunk(0, 2)
        ]);
        controller.dispose();
      }
    });
  });

  group('CodeChunkController method', () {

    test('collapse()', () async {
      // Empty content, and no chunk
      {
        final CodeChunkController controller = CodeChunkController(CodeLineEditingController(),
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        controller.collapse(0);
        expect(controller.value, const []);
        controller.dispose();
      }
      // Non-Empty content, but no chunk
      {
        final CodeChunkController controller = CodeChunkController(CodeLineEditingController.fromText('abc'),
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        controller.collapse(0);
        expect(controller.value, const []);
        controller.dispose();
      }
      // Have a chunk, but nothing to collapse
      {
        final CodeChunkController controller = CodeChunkController(CodeLineEditingController.fromText('{\n}'),
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.value, const [
          CodeChunk(0, 1)
        ]);
        controller.collapse(0);
        expect(controller.value, const [
          CodeChunk(0, 1)
        ]);
        controller.dispose();
      }
      // Have only a chunk
      {
        final CodeLineEditingController editingController = CodeLineEditingController.fromText('{\nabc\n}');
        final CodeChunkController controller = CodeChunkController(editingController,
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.value, const [
          CodeChunk(0, 2)
        ]);
        controller.collapse(0);
        expect(controller.value, const [
          CodeChunk(0, 1)
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine('abc')
          ]),
          CodeLine('}')
        ]));
        controller.dispose();
      }
      // Have multi chunks, collapse from inside one by one
      {
        final CodeLineEditingController editingController = CodeLineEditingController.fromText('{\n\n{\n[\nabc\n(foo)\nbar\n]\n}\n\n}');
        final CodeChunkController controller = CodeChunkController(editingController,
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.value, const [
          CodeChunk(0, 10),
          CodeChunk(2, 8),
          CodeChunk(3, 7),
        ]);
        controller.collapse(3);
        expect(controller.value, const [
          CodeChunk(0, 7),
          CodeChunk(2, 5),
          CodeChunk(3, 4),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine(''),
          CodeLine('{'),
          CodeLine('[', [
            CodeLine('abc'),
            CodeLine('(foo)'),
            CodeLine('bar'),
          ]),
          CodeLine(']'),
          CodeLine('}'),
          CodeLine(''),
          CodeLine('}')
        ]));
        controller.collapse(2);
        expect(controller.value, const [
          CodeChunk(0, 5),
          CodeChunk(2, 3)
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine(''),
          CodeLine('{', [
            CodeLine('[', [
              CodeLine('abc'),
              CodeLine('(foo)'),
              CodeLine('bar'),
            ]),
            CodeLine(']')
          ]),
          CodeLine('}'),
          CodeLine(''),
          CodeLine('}')
        ]));
        controller.collapse(0);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine(''),
            CodeLine('{', [
              CodeLine('[', [
                CodeLine('abc'),
                CodeLine('(foo)'),
                CodeLine('bar'),
              ]),
              CodeLine(']')
            ]),
            CodeLine('}'),
            CodeLine(''),
            ]),
          CodeLine('}')
        ]));
        controller.collapse(0);
        expect(controller.value, const [
          CodeChunk(0, 1)
        ]);
        controller.dispose();
      }
      // Have multi chunks, collapse from top one by one
      {
        final CodeLineEditingController editingController = CodeLineEditingController.fromText('{\n\n}{\n\n}{\n\n}{\n\n}');
        final CodeChunkController controller = CodeChunkController(editingController,
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.value, const [
          CodeChunk(0, 2),
          CodeChunk(2, 4),
          CodeChunk(4, 6),
          CodeChunk(6, 8),
        ]);
        controller.collapse(0);
        expect(controller.value, const [
          CodeChunk(0, 1),
          CodeChunk(1, 3),
          CodeChunk(3, 5),
          CodeChunk(5, 7),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine('')
          ]),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}'),
        ]));
        controller.collapse(1);
        expect(controller.value, const [
          CodeChunk(0, 1),
          CodeChunk(1, 2),
          CodeChunk(2, 4),
          CodeChunk(4, 6),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}'),
        ]));
        controller.collapse(2);
        expect(controller.value, const [
          CodeChunk(0, 1),
          CodeChunk(1, 2),
          CodeChunk(2, 3),
          CodeChunk(3, 5),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}'),
        ]));
        controller.collapse(3);
        expect(controller.value, const [
          CodeChunk(0, 1),
          CodeChunk(1, 2),
          CodeChunk(2, 3),
          CodeChunk(3, 4),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}'),
        ]));
      }
      // Have multi chunks, collapse from bottom one by one
      {
        final CodeLineEditingController editingController = CodeLineEditingController.fromText('{\n\n}{\n\n}{\n\n}{\n\n}');
        final CodeChunkController controller = CodeChunkController(editingController,
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.value, const [
          CodeChunk(0, 2),
          CodeChunk(2, 4),
          CodeChunk(4, 6),
          CodeChunk(6, 8),
        ]);
        controller.collapse(6);
        expect(controller.value, const [
          CodeChunk(0, 2),
          CodeChunk(2, 4),
          CodeChunk(4, 6),
          CodeChunk(6, 7),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{', [
            CodeLine(''),
          ]),
          CodeLine('}'),
        ]));
        controller.collapse(4);
        expect(controller.value, const [
          CodeChunk(0, 2),
          CodeChunk(2, 4),
          CodeChunk(4, 5),
          CodeChunk(5, 6),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{', [
            CodeLine(''),
          ]),
          CodeLine('}{', [
            CodeLine(''),
          ]),
          CodeLine('}'),
        ]));
        controller.collapse(2);
        expect(controller.value, const [
          CodeChunk(0, 2),
          CodeChunk(2, 3),
          CodeChunk(3, 4),
          CodeChunk(4, 5),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine(''),
          CodeLine('}{', [
            CodeLine(''),
          ]),
          CodeLine('}{', [
            CodeLine(''),
          ]),
          CodeLine('}{', [
            CodeLine(''),
          ]),
          CodeLine('}'),
        ]));
        controller.collapse(0);
        expect(controller.value, const [
          CodeChunk(0, 1),
          CodeChunk(1, 2),
          CodeChunk(2, 3),
          CodeChunk(3, 4),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}'),
        ]));
      }
    });

    test('expand()', () async {
      // Empty content, and no chunk
      {
        final CodeChunkController controller = CodeChunkController(CodeLineEditingController(),
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        controller.expand(0);
        expect(controller.value, const []);
        controller.dispose();
      }
      // Non-Empty content, but no chunk
      {
        final CodeChunkController controller = CodeChunkController(CodeLineEditingController.fromText('abc'),
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        controller.expand(0);
        expect(controller.value, const []);
        controller.dispose();
      }
      // Have a chunk, but nothing to expand
      {
        final CodeChunkController controller = CodeChunkController(CodeLineEditingController.fromText('{\n}'),
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.value, const [
          CodeChunk(0, 1)
        ]);
        controller.expand(0);
        expect(controller.value, const [
          CodeChunk(0, 1)
        ]);
        controller.dispose();
      }
      // Have only a collapsed chunk
      {
        final CodeLineEditingController editingController = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('{', [
              CodeLine('abc'),
            ]),
            CodeLine('}'),
          ]
        ));
        final CodeChunkController controller = CodeChunkController(editingController, const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.value, const [
          CodeChunk(0, 1),
        ]);
        controller.expand(0);
        expect(controller.value, const [
          CodeChunk(0, 2)
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine('abc'),
          CodeLine('}'),
        ]));
        controller.dispose();
      }
      // Have multi collapsed chunks, expand from outside one by one
      {
        final CodeLineEditingController editingController = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('{', [
              CodeLine(''),
              CodeLine('{', [
                CodeLine('[', [
                  CodeLine('abc'),
                  CodeLine('(foo)'),
                  CodeLine('bar'),
                ]),
                CodeLine(']')
              ]),
              CodeLine('}'),
              CodeLine(''),
              ]),
            CodeLine('}')
          ]
        ));
        final CodeChunkController controller = CodeChunkController(editingController,
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.value, const [
          CodeChunk(0, 1),
        ]);
        controller.expand(0);
        expect(controller.value, const [
          CodeChunk(0, 5),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine(''),
          CodeLine('{', [
            CodeLine('[', [
              CodeLine('abc'),
              CodeLine('(foo)'),
              CodeLine('bar'),
            ]),
            CodeLine(']')
          ]),
          CodeLine('}'),
          CodeLine(''),
          CodeLine('}')
        ]));
        controller.expand(2);
        expect(controller.value, const [
          CodeChunk(0, 7),
          CodeChunk(2, 5),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine(''),
          CodeLine('{'),
          CodeLine('[', [
            CodeLine('abc'),
            CodeLine('(foo)'),
            CodeLine('bar'),
          ]),
          CodeLine(']'),
          CodeLine('}'),
          CodeLine(''),
          CodeLine('}')
        ]));
        controller.expand(3);
        expect(controller.value, const [
          CodeChunk(0, 10),
          CodeChunk(2, 8),
          CodeChunk(3, 7),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine(''),
          CodeLine('{'),
          CodeLine('['),
          CodeLine('abc'),
          CodeLine('(foo)'),
          CodeLine('bar'),
          CodeLine(']'),
          CodeLine('}'),
          CodeLine(''),
          CodeLine('}')
        ]));
        controller.dispose();
      }
      // Have multi collapsed chunks, expand from top one by one
      {
        final CodeLineEditingController editingController = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('{', [
              CodeLine('')
            ]),
            CodeLine('}{', [
              CodeLine('')
            ]),
            CodeLine('}{', [
              CodeLine('')
            ]),
            CodeLine('}{', [
              CodeLine('')
            ]),
            CodeLine('}'),
          ]
        ));
        final CodeChunkController controller = CodeChunkController(editingController,
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.value, const [
          CodeChunk(0, 1),
          CodeChunk(1, 2),
          CodeChunk(2, 3),
          CodeChunk(3, 4),
        ]);
        controller.expand(0);
        expect(controller.value, const [
          CodeChunk(0, 2),
          CodeChunk(2, 3),
          CodeChunk(3, 4),
          CodeChunk(4, 5),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine(''),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}'),
        ]));
        controller.expand(2);
        expect(controller.value, const [
          CodeChunk(0, 2),
          CodeChunk(2, 4),
          CodeChunk(4, 5),
          CodeChunk(5, 6),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}'),
        ]));
        controller.expand(4);
        expect(controller.value, const [
          CodeChunk(0, 2),
          CodeChunk(2, 4),
          CodeChunk(4, 6),
          CodeChunk(6, 7),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}'),
        ]));
        controller.expand(6);
        expect(controller.value, const [
          CodeChunk(0, 2),
          CodeChunk(2, 4),
          CodeChunk(4, 6),
          CodeChunk(6, 8),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}'),
        ]));
        controller.dispose();
      }
      // Have multi collapsed chunks, expand from bottom one by one
      {
        final CodeLineEditingController editingController = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('{', [
              CodeLine('')
            ]),
            CodeLine('}{', [
              CodeLine('')
            ]),
            CodeLine('}{', [
              CodeLine('')
            ]),
            CodeLine('}{', [
              CodeLine('')
            ]),
            CodeLine('}'),
          ]
        ));
        final CodeChunkController controller = CodeChunkController(editingController,
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.value, const [
          CodeChunk(0, 1),
          CodeChunk(1, 2),
          CodeChunk(2, 3),
          CodeChunk(3, 4),
        ]);
        controller.expand(3);
        expect(controller.value, const [
          CodeChunk(0, 1),
          CodeChunk(1, 2),
          CodeChunk(2, 3),
          CodeChunk(3, 5),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}{',),
          CodeLine(''),
          CodeLine('}'),
        ]));
        controller.expand(2);
        expect(controller.value, const [
          CodeChunk(0, 1),
          CodeChunk(1, 2),
          CodeChunk(2, 4),
          CodeChunk(4, 6),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine('')
          ]),
          CodeLine('}{', [
            CodeLine('')
          ]),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{',),
          CodeLine(''),
          CodeLine('}'),
        ]));
        controller.expand(1);
        expect(controller.value, const [
          CodeChunk(0, 1),
          CodeChunk(1, 3),
          CodeChunk(3, 5),
          CodeChunk(5, 7),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{', [
            CodeLine('')
          ]),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{',),
          CodeLine(''),
          CodeLine('}'),
        ]));
        controller.expand(0);
        expect(controller.value, const [
          CodeChunk(0, 2),
          CodeChunk(2, 4),
          CodeChunk(4, 6),
          CodeChunk(6, 8),
        ]);
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}{'),
          CodeLine(''),
          CodeLine('}'),
        ]));
        controller.dispose();
      }
    });

    test('collapse() and expand()', () async {
      final CodeLineEditingController editingController = CodeLineEditingController.fromText('{\n\n}{\n\n}{\n\n}{\n\n}');
      final CodeChunkController controller = CodeChunkController(editingController,
        const DefaultCodeChunkAnalyzer());
      await Future.delayed(const Duration(milliseconds: 200));
      controller.collapse(2);
      expect(controller.value, const [
        CodeChunk(0, 2),
        CodeChunk(2, 3),
        CodeChunk(3, 5),
        CodeChunk(5, 7),
      ]);
      expect(editingController.codeLines, CodeLines.of(const [
        CodeLine('{'),
        CodeLine(''),
        CodeLine('}{', [
          CodeLine(''),
        ]),
        CodeLine('}{'),
        CodeLine(''),
        CodeLine('}{'),
        CodeLine(''),
        CodeLine('}'),
      ]));
      controller.collapse(3);
      expect(controller.value, const [
        CodeChunk(0, 2),
        CodeChunk(2, 3),
        CodeChunk(3, 4),
        CodeChunk(4, 6),
      ]);
      expect(editingController.codeLines, CodeLines.of(const [
        CodeLine('{'),
        CodeLine(''),
        CodeLine('}{', [
          CodeLine(''),
        ]),
        CodeLine('}{', [
          CodeLine(''),
        ]),
        CodeLine('}{'),
        CodeLine(''),
        CodeLine('}'),
      ]));
      controller.expand(2);
      expect(controller.value, const [
        CodeChunk(0, 2),
        CodeChunk(2, 4),
        CodeChunk(4, 5),
        CodeChunk(5, 7),
      ]);
      expect(editingController.codeLines, CodeLines.of(const [
        CodeLine('{'),
        CodeLine(''),
        CodeLine('}{'),
        CodeLine(''),
        CodeLine('}{', [
          CodeLine(''),
        ]),
        CodeLine('}{'),
        CodeLine(''),
        CodeLine('}'),
      ]));
      controller.expand(4);
      expect(controller.value, const [
        CodeChunk(0, 2),
        CodeChunk(2, 4),
        CodeChunk(4, 6),
        CodeChunk(6, 8),
      ]);
      expect(editingController.codeLines, CodeLines.of(const [
        CodeLine('{'),
        CodeLine(''),
        CodeLine('}{'),
        CodeLine(''),
        CodeLine('}{'),
        CodeLine(''),
        CodeLine('}{'),
        CodeLine(''),
        CodeLine('}'),
      ]));
      controller.dispose();
    });

    test('findByIndex()', () async {
      {
        final CodeChunkController controller = CodeChunkController(CodeLineEditingController(),
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.findByIndex(0), null);
        expect(controller.findByIndex(1), null);
        controller.dispose();
      }
      {
        final CodeChunkController controller = CodeChunkController(CodeLineEditingController.fromText('{\n\n}'),
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.findByIndex(0), const CodeChunk(0, 2));
        expect(controller.findByIndex(1), null);
        controller.dispose();
      }
      {
        final CodeChunkController controller = CodeChunkController(CodeLineEditingController.fromText('{\n{\n{\n\n}\n}\n}'),
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.findByIndex(0), const CodeChunk(0, 6));
        expect(controller.findByIndex(1), const CodeChunk(1, 5));
        expect(controller.findByIndex(2), const CodeChunk(2, 4));
        expect(controller.findByIndex(3), null);
        expect(controller.findByIndex(4), null);
        expect(controller.findByIndex(5), null);
        controller.dispose();
      }
    });

    test('canCollapse()', () async {
      {
        final CodeChunkController controller = CodeChunkController(CodeLineEditingController.fromText('{\n}'),
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.canCollapse(0), false);
        controller.dispose();
      }
      {
        final CodeChunkController controller = CodeChunkController(CodeLineEditingController.fromText('{\n\n}'),
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.canCollapse(0), true);
        expect(controller.canCollapse(1), false);
        controller.dispose();
      }
      {
        final CodeChunkController controller = CodeChunkController(CodeLineEditingController.fromText('{\n{\n{\n\n}\n}\n}'),
          const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(controller.canCollapse(0), true);
        expect(controller.canCollapse(1), true);
        expect(controller.canCollapse(2), true);
        expect(controller.canCollapse(3), false);
        controller.dispose();
      }
    });

    test('auto expand invalid collapsed chunks()', () async {
      {
        final CodeLineEditingController editingController = CodeLineEditingController(
          codeLines: CodeLines.of(const [
            CodeLine('abc', [
              CodeLine('foo'),
              CodeLine('bar'),
            ]),
            CodeLine('123'),
          ])
        );
        final CodeChunkController controller = CodeChunkController(editingController, const DefaultCodeChunkAnalyzer());
        await Future.delayed(const Duration(milliseconds: 200));
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
          CodeLine('123'),
        ]));
        // Edit the code line to create invalid chunks
        editingController.codeLines = CodeLines.of(const [
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
        ]);
        await Future.delayed(const Duration(milliseconds: 200));
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]));
        // Edit the code line to create two invalid chunks and one valid chunk
        editingController.codeLines = CodeLines.of(const [
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('}'),
          CodeLine('abc', [
            CodeLine('foo'),
            CodeLine('bar'),
          ])
        ]);
        await Future.delayed(const Duration(milliseconds: 200));
        expect(editingController.codeLines, CodeLines.of(const [
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
          CodeLine('{', [
            CodeLine('foo'),
            CodeLine('bar'),
          ]),
          CodeLine('}'),
          CodeLine('abc'),
          CodeLine('foo'),
          CodeLine('bar'),
        ]));
        controller.dispose();
      }
    });

  });

}