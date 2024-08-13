import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_editor_exmaple/find.dart';
import 'package:re_editor_exmaple/menu.dart';
import 'package:re_highlight/languages/dart.dart';
import 'package:re_highlight/styles/atom-one-light.dart';

const List<CodePrompt> _kStringPrompts = [
  CodeFieldPrompt(word: 'length', type: 'int'),
  CodeFieldPrompt(word: 'isEmpty', type: 'bool'),
  CodeFieldPrompt(word: 'isNotEmpty', type: 'bool'),
  CodeFieldPrompt(word: 'characters', type: 'Characters'),
  CodeFieldPrompt(word: 'hashCode', type: 'int'),
  CodeFieldPrompt(word: 'codeUnits', type: 'List<int>'),
  CodeFieldPrompt(word: 'runes', type: 'Runes'),
  CodeFunctionPrompt(word: 'codeUnitAt', type: 'int', parameters: {'index': 'int'}),
  CodeFunctionPrompt(word: 'replaceAll', type: 'String', parameters: {
    'from': 'Pattern',
    'replace': 'String',
  }),
  CodeFunctionPrompt(word: 'contains', type: 'bool', parameters: {
    'other': 'String',
  }),
  CodeFunctionPrompt(word: 'split', type: 'List<String>', parameters: {
    'pattern': 'Pattern',
  }),
  CodeFunctionPrompt(word: 'endsWith', type: 'bool', parameters: {
    'other': 'String',
  }),
  CodeFunctionPrompt(word: 'startsWith', type: 'bool', parameters: {
    'other': 'String',
  })
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
        Lsp: true,
        viewBuilder: (context, notifier, onSelected) async {
          // 创建代码提示View
          //notifier.value.prompts.clear();
          var data = notifier.value.selection;
          var contentResult = await sendhandleCompletion(uurl, data.baseIndex, data.baseOffset);
          //debugger();
          var Autolist = (contentResult["items"] as List<dynamic>).map((a) {
            var m = a as Map<String, dynamic>;
            return CodeFieldPrompt(word: m["label"].toString(), type: "");
          });
          //triggerCharacters
          if (!const ['.', '[', '"', "'"].contains(notifier.value.input)) {
            Autolist = Autolist.where((prompt) => prompt.match(notifier.value.input, caseInsensitive: true));
          }
          notifier.value.prompts.addAll(Autolist);
          //debugger();
          return _DefaultCodeAutocompleteListView(
            notifier: notifier,
            onSelected: onSelected,
          );
        },
        promptsBuilder: DefaultCodeAutocompletePromptsBuilder(
          language: langDart,
          directPrompts: [
            CodeFieldPrompt(word: 'foo', type: 'String'),
            CodeFieldPrompt(word: 'bar', type: 'String'),
            CodeFunctionPrompt(word: 'hello', type: 'void', parameters: {
              'value': 'String',
            })
          ],
          relatedPrompts: {
            'foo': _kStringPrompts,
            'bar': _kStringPrompts,
          },
        ),
        child: CodeEditor(
          style: CodeEditorStyle(
            fontSize: 18,
            codeTheme: CodeHighlightTheme(languages: {'dart': CodeHighlightThemeMode(mode: langDart)}, theme: atomOneLightTheme),
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
                DefaultCodeChunkIndicator(width: 20, controller: chunkController, notifier: notifier)
              ],
            );
          },
          findBuilder: (context, controller, readOnly) => CodeFindPanelView(controller: controller, readOnly: readOnly),
          toolbarController: const ContextMenuControllerImpl(),
          sperator: Container(width: 1, color: Colors.blue),
        ));
  }
}

class _DefaultCodeAutocompleteListView extends StatefulWidget implements PreferredSizeWidget {
  static const double kItemHeight = 26;

  final ValueNotifier<CodeAutocompleteEditingValue> notifier;
  final ValueChanged<CodeAutocompleteResult> onSelected;

  const _DefaultCodeAutocompleteListView({
    required this.notifier,
    required this.onSelected,
  });

  @override
  Size get preferredSize => Size(
      250,
      // 2 is border size
      min(kItemHeight * notifier.value.prompts.length, 150) + 2);

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
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(6)),
        child: AutoScrollListView(
          controller: ScrollController(),
          initialIndex: widget.notifier.value.index,
          scrollDirection: Axis.vertical,
          itemCount: widget.notifier.value.prompts.length,
          itemBuilder: (context, index) {
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
                  widget.onSelected(widget.notifier.value.copyWith(index: index).autocomplete);
                },
                child: Container(
                  width: double.infinity,
                  height: _DefaultCodeAutocompleteListView.kItemHeight,
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(color: index == widget.notifier.value.index ? Color.fromARGB(255, 255, 140, 0) : null, borderRadius: radius),
                  child: RichText(
                    text: prompt.createSpan(context, widget.notifier.value.input),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ));
          },
        ));
  }

  void _onValueChanged() {
    setState(() {});
  }
}

extension _CodePromptExtension on CodePrompt {
  InlineSpan createSpan(BuildContext context, String input) {
    final TextStyle style = TextStyle();
    final InlineSpan span = style.createSpan(
      value: word,
      anchor: input,
      color: Colors.blue,
      fontWeight: FontWeight.bold,
    );
    final CodePrompt prompt = this;
    if (prompt is CodeFieldPrompt) {
      return TextSpan(children: [span, TextSpan(text: ' ${prompt.type}', style: style.copyWith(color: Colors.cyan))]);
    }
    if (prompt is CodeFunctionPrompt) {
      return TextSpan(children: [span, TextSpan(text: '(...) -> ${prompt.type}', style: style.copyWith(color: Colors.cyan))]);
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
    return TextSpan(children: [
      TextSpan(text: value.substring(0, index), style: this),
      TextSpan(
          text: value.substring(index, index + anchor.length),
          style: copyWith(
            color: color,
            fontWeight: fontWeight,
          )),
      TextSpan(text: value.substring(index + anchor.length), style: this)
    ]);
  }
}

class AutoScrollListView extends StatefulWidget {
  final ScrollController controller;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final int initialIndex;
  final Axis scrollDirection;

  const AutoScrollListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    required this.itemCount,
    this.initialIndex = 0,
    this.scrollDirection = Axis.vertical,
  });

  @override
  State<StatefulWidget> createState() => _AutoScrollListViewState();
}

class _AutoScrollListViewState extends State<AutoScrollListView> {
  late final List<GlobalKey> _keys;

  @override
  void initState() {
    _keys = List.generate(widget.itemCount, (index) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoScroll();
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AutoScrollListView oldWidget) {
    if (widget.itemCount > oldWidget.itemCount) {
      _keys.addAll(List.generate(widget.itemCount - oldWidget.itemCount, (index) => GlobalKey()));
    } else if (widget.itemCount < oldWidget.itemCount) {
      _keys.sublist(oldWidget.itemCount - widget.itemCount);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoScroll();
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];
    for (int i = 0; i < widget.itemCount; i++) {
      widgets.add(Container(
        key: _keys[i],
        child: widget.itemBuilder(context, i),
      ));
    }
    return SingleChildScrollView(
      controller: widget.controller,
      scrollDirection: widget.scrollDirection,
      child: isHorizontal
          ? Row(
              children: widgets,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgets,
            ),
    );
  }

  void _autoScroll() {
    final ScrollController controller = widget.controller;
    if (!controller.hasClients) {
      return;
    }
    if (controller.position.maxScrollExtent == 0) {
      return;
    }
    double pre = 0;
    double cur = 0;
    for (int i = 0; i < _keys.length; i++) {
      final RenderObject? obj = _keys[i].currentContext?.findRenderObject();
      if (obj == null || obj is! RenderBox) {
        continue;
      }
      if (isHorizontal) {
        double width = obj.size.width;
        if (i == widget.initialIndex) {
          cur = pre + width;
          break;
        }
        pre += width;
      } else {
        double height = obj.size.height;
        if (i == widget.initialIndex) {
          cur = pre + height;
          break;
        }
        pre += height;
      }
    }
    if (pre == cur) {
      return;
    }
    if (pre < widget.controller.offset) {
      controller.jumpTo(pre - 1);
    } else if (cur > controller.offset + controller.position.viewportDimension) {
      controller.jumpTo(cur - controller.position.viewportDimension);
    }
  }

  bool get isHorizontal => widget.scrollDirection == Axis.horizontal;
}
