import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';

class BasicField extends StatelessWidget {
  const BasicField({super.key});

  @override
  Widget build(BuildContext context) {
    return CodeEditor(
      wordWrap: false,
      controller: CodeLineEditingController.fromText(
          '${'Hello Reqable💐👏 ' * 10}\n' * 100),
    );
  }
}
