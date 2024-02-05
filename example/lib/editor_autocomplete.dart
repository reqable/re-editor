import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_editor_exmaple/find.dart';
import 'package:re_editor_exmaple/menu.dart';
import 'package:re_highlight/languages/dart.dart';
import 'package:re_highlight/styles/atom-one-light.dart';

const List<CodePrompt> _kStringPrompts = [
  CodeFieldPrompt(
    word: 'length',
    type: 'int'
  ),
  CodeFieldPrompt(
    word: 'isEmpty',
    type: 'bool'
  ),
  CodeFieldPrompt(
    word: 'isNotEmpty',
    type: 'bool'
  ),
  CodeFieldPrompt(
    word: 'characters',
    type: 'Characters'
  ),
  CodeFieldPrompt(
    word: 'hashCode',
    type: 'int'
  ),
  CodeFieldPrompt(
    word: 'codeUnits',
    type: 'List<int>'
  ),
  CodeFieldPrompt(
    word: 'runes',
    type: 'Runes'
  ),
  CodeFunctionPrompt(
    word: 'codeUnitAt',
    type: 'int',
    parameters: {
      'index': 'int'
    }
  ),
  CodeFunctionPrompt(
    word: 'replaceAll',
    type: 'String',
    parameters: {
      'from': 'Pattern',
      'replace': 'String',
    }
  ),
  CodeFunctionPrompt(
    word: 'contains',
    type: 'bool',
    parameters: {
      'other': 'String',
    }
  ),
  CodeFunctionPrompt(
    word: 'split',
    type: 'List<String>',
    parameters: {
      'pattern': 'Pattern',
    }
  ),
  CodeFunctionPrompt(
    word: 'endsWith',
    type: 'bool',
    parameters: {
      'other': 'String',
    }
  ),
  CodeFunctionPrompt(
    word: 'startsWith',
    type: 'bool',
    parameters: {
      'other': 'String',
    }
  )
];

class AutoCompleteEditor extends StatefulWidget {

  const AutoCompleteEditor();

  @override
  State<StatefulWidget> createState() => _AutoCompleteEditorState();

}

class _AutoCompleteEditorState extends State<AutoCompleteEditor> {

  final CodeLineEditingController _controller = CodeLineEditingController();

  @override
  void initState() {
    rootBundle.loadString('assets/code.dart').then((value) {
      _controller.text = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CodeAutocomplete(
      builder: (context, notifier, onSelected) {
        return _DefaultCodeAutocompleteListView(
          notifier: notifier,
          onSelected: onSelected,
        );
      },
      language: langDart,
      directPrompts: [
        CodeFieldPrompt(
          word: 'foo',
          type: 'String'
        ),
        CodeFieldPrompt(
          word: 'bar',
          type: 'String'
        ),
        CodeFunctionPrompt(
          word: 'hello',
          type: 'void',
          parameters: {
            'value': 'String',
          }
        )
      ],
      releatedPrompts: {
        'foo': _kStringPrompts,
        'bar': _kStringPrompts,
      },
      child: CodeEditor(
        style: CodeEditorStyle(
          fontSize: 18,
          codeTheme: CodeHighlightTheme(
            languages: {
              'dart': CodeHighlightThemeMode(
                mode: langDart
              )
            },
            theme: atomOneLightTheme
          ),
        ),
        controller: _controller,
        wordWrap: false,
        indicatorBuilder: (context, editingController, chunkController, notifier) {
          return Row(
            children: [
              DefaultCodeLineNumber(
                controller: editingController,
                notifier: notifier,
              ),
              DefaultCodeChunkIndicator(
                width: 20,
                controller: chunkController,
                notifier: notifier
              )
            ],
          );
        },
        findBuilder: (context, controller, readOnly) => CodeFindPanelView(controller: controller, readOnly: readOnly),
        toolbarController: const ContextMenuControllerImpl(),
        sperator: Container(
          width: 1,
          color: Colors.blue
        ),
      )
    );
  }

}

class _DefaultCodeAutocompleteListView extends StatefulWidget implements PreferredSizeWidget {

  static const double kItemHeight = 26;

  final ValueNotifier<CodeAutocompleteEditingValue> notifier;
  final ValueChanged<CodeAutocompleteEditingValue> onSelected;

  const _DefaultCodeAutocompleteListView({
    required this.notifier,
    required this.onSelected,
  });

  @override
  Size get preferredSize => Size(
    250,
    // 2 is border size
    min(kItemHeight * notifier.value.prompts.length, 200) + 2
  );

  @override
  State<StatefulWidget> createState() => _DefaultCodeAutocompleteListViewState();

}

class _DefaultCodeAutocompleteListViewState extends State<_DefaultCodeAutocompleteListView> {

  @override
  void initState() {
    widget.notifier.addListener(_onValueChanged);
    super.initState();
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onValueChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.loose(widget.preferredSize),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(6)
      ),
      child: ListView.builder(
        itemCount: widget.notifier.value.prompts.length,
        scrollDirection: Axis.vertical,
        itemBuilder:(context, index) {
          final CodePrompt prompt = widget.notifier.value.prompts[index];
          final BorderRadius radius = BorderRadius.only(
            topLeft: index == 0 ? const Radius.circular(5) : Radius.zero,
            topRight: index == 0 ? const Radius.circular(5) : Radius.zero,
            bottomLeft: index == widget.notifier.value.prompts.length - 1 ? const Radius.circular(5) : Radius.zero,
            bottomRight: index == widget.notifier.value.prompts.length - 1 ? const Radius.circular(5) : Radius.zero,
          );
          return InkWell(
            borderRadius: radius,
            onTap: () {
              widget.onSelected(widget.notifier.value.copyWith(
                index: index
              ));
            },
            child: Container(
              width: double.infinity,
              height: _DefaultCodeAutocompleteListView.kItemHeight,
              padding: const EdgeInsets.only(
                left: 5,
                right: 5
              ),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: index == widget.notifier.value.index ? Color.fromARGB(255, 255, 140, 0) : null,
                borderRadius: radius
              ),
              child: RichText(
                text: prompt.createSpan(context, widget.notifier.value.word),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            )
          );
        },
      )
    );
  }

  void _onValueChanged() {
    setState(() {
    });
  }

}

extension _CodePromptExtension on CodePrompt {

  InlineSpan createSpan(BuildContext context, String input) {
    final TextStyle style = TextStyle();
    final InlineSpan span = style.createSpan(
      value: word,
      anchor: input,
      color: Colors.green,
      fontWeight: FontWeight.bold,
    );
    final CodePrompt prompt = this;
    if (prompt is CodeFieldPrompt) {
      return TextSpan(
        children: [
          span,
          TextSpan(
            text: ' ${prompt.type}',
            style: style.copyWith(
              color: Colors.cyan
            )
          )
        ]
      );
    }
    if (prompt is CodeFunctionPrompt) {
      return TextSpan(
        children: [
          span,
          TextSpan(
            text: '(...) -> ${prompt.type}',
            style: style.copyWith(
              color: Colors.cyan
            )
          )
        ]
      );
    }
    return span;
  }

}

extension _TextStyleExtension on TextStyle {

  InlineSpan createSpan({
    required String value,
    required String anchor,
    required Color color,
    FontWeight? fontWeight,
    bool casesensitive = false,
  }) {
    if (anchor.isEmpty) {
      return TextSpan(
        text: value,
        style: this,
      );
    }
    final int index;
    if (casesensitive) {
      index = value.indexOf(anchor);
    } else {
      index = value.toLowerCase().indexOf(anchor.toLowerCase());
    }
    if (index < 0) {
      return TextSpan(
        text: value,
        style: this,
      );
    }
    return TextSpan(
      children: [
        TextSpan(
          text: value.substring(0, index),
          style: this
        ),
        TextSpan(
          text: value.substring(index, index + anchor.length),
          style: copyWith(
            color: color,
            fontWeight: fontWeight,
          )
        ),
        TextSpan(
          text: value.substring(index + anchor.length),
          style: this
        )
      ]
    );
  }

}