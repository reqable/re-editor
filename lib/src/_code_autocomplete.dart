part of re_editor;

class _DefaultCodeAutocompletePromptsBuilder implements DefaultCodeAutocompletePromptsBuilder {
  final Mode? language;
  final List<CodeKeywordPrompt> keywordPrompts;
  final List<CodePrompt> directPrompts;
  final Map<String, List<CodePrompt>> relatedPrompts;

  final Set<CodePrompt> _allKeywordPrompts = {};

  _DefaultCodeAutocompletePromptsBuilder({this.language, required this.keywordPrompts, required this.directPrompts, required this.relatedPrompts}) {
    _allKeywordPrompts.addAll(keywordPrompts);
    _allKeywordPrompts.addAll(directPrompts);
    final dynamic keywords = language?.keywords;
    if (keywords is Map) {
      final dynamic keywordList = keywords['keyword'];
      if (keywordList is List) {
        _allKeywordPrompts.addAll(keywordList.map((keyword) => CodeKeywordPrompt(word: keyword)));
      }
      final dynamic builtInList = keywords['built_in'];
      if (builtInList is List) {
        _allKeywordPrompts.addAll(builtInList.map((keyword) => CodeKeywordPrompt(word: keyword)));
      }
      final dynamic literalList = keywords['literal'];
      if (literalList is List) {
        _allKeywordPrompts.addAll(literalList.map((keyword) => CodeKeywordPrompt(word: keyword)));
      }
      final dynamic typeList = keywords['type'];
      if (typeList is List) {
        _allKeywordPrompts.addAll(typeList.map((keyword) => CodeKeywordPrompt(word: keyword)));
      }
    }
  }

  @override
  CodeAutocompleteEditingValue? build(BuildContext context, CodeLine codeLine, CodeLineSelection selection) {
    final String text = codeLine.text;
    final Characters charactersBefore = text.substring(0, selection.extentOffset).characters;
    if (charactersBefore.isEmpty) {
      return null;
    }
    final Characters charactersAfter = text.substring(selection.extentOffset).characters;
    // FIXME：Check whether the position is inside a string
    if (charactersBefore.containsSymbols(const ['\'', '"']) && charactersAfter.containsSymbols(const ['\'', '"'])) {
      return null;
    }
    // TODO Should check operator `->` for some languages like c/c++
    final Iterable<CodePrompt> prompts;
    final String input;
    if (charactersBefore.takeLast(1).string == '.') {
      ///这部分其实应该删除，做自动补全应该放在外面
      input = '.';
      int start = charactersBefore.length - 2;
      for (; start >= 0; start--) {
        if (!charactersBefore.elementAt(start).isValidVariablePart) {
          break;
        }
      }
      final String target = charactersBefore.getRange(start + 1, charactersBefore.length - 1).string;
      prompts = relatedPrompts[target] ?? const [];
    } else {
      int start = charactersBefore.length - 1;
      for (; start >= 0; start--) {
        if (!charactersBefore.elementAt(start).isValidVariablePart) {
          break;
        }
      }
      input = charactersBefore.getRange(start + 1, charactersBefore.length).string;
      if (input.isEmpty) {
        return null;
      }
      if (start > 0 && charactersBefore.elementAt(start) == '.') {
        final int mark = start;
        for (start = start - 1; start >= 0; start--) {
          if (!charactersBefore.elementAt(start).isValidVariablePart) {
            break;
          }
        }
        final String target = charactersBefore.getRange(start + 1, mark).string;
        prompts = relatedPrompts[target]?.where((prompt) => prompt.match(input)) ?? const [];
      } else {
        ///匹配allKeyword
        prompts = _allKeywordPrompts.where((prompt) => prompt.match(input));
      }
    }

    ///禁止内置硬编码
    /*if (prompts.isEmpty) {
      return null;
    }*/
    return CodeAutocompleteEditingValue(input: input, prompts: prompts.toList(), index: 0, selection: selection);
  }
}

class _CodeAutocomplete extends StatefulWidget {
  const _CodeAutocomplete({
    required this.viewBuilder,
    required this.promptsBuilder,
    required this.child,
    required this.Lsp,
    required this.HoverViewBuilder,
  });
  final CodeHoverWidgetBuilder HoverViewBuilder;
  final CodeAutocompleteWidgetBuilder viewBuilder;
  final CodeAutocompletePromptsBuilder promptsBuilder;
  final Widget child;

  ///使用lsp提供服务，监听每个输入字符
  final bool Lsp;

  @override
  State<StatefulWidget> createState() => _CodeAutocompleteState();
}

class _CodeAutocompleteState extends State<_CodeAutocomplete> {
  late final _CodeAutocompleteNavigateAction _navigateAction;
  late final _CodeAutocompleteAction _selectAction;
  late final _CodeHoverAction _hoverAction;

  ValueChanged<CodeAutocompleteResult>? _onAutocomplete;
  OverlayEntry? _overlayEntry;
  OverlayEntry? _overlayEntry1;
  ValueNotifier<CodeAutocompleteEditingValue>? _notifier;

  @override
  void initState() {
    super.initState();
    _navigateAction = _CodeAutocompleteNavigateAction(
      onInvoke: (intent) {
        final CodeAutocompleteEditingValue? value = _notifier?.value;
        if (value == null) {
          return null;
        }
        int newIndex = value.index;
        if (intent.direction == AxisDirection.up) {
          newIndex--;
        } else {
          newIndex++;
        }
        if (newIndex < 0) {
          newIndex = value.prompts.length - 1;
        } else if (newIndex >= value.prompts.length) {
          newIndex = 0;
        }
        _notifier?.value = value.copyWith(
          index: newIndex,
        );
        return intent;
      },
    );

    _hoverAction = _CodeHoverAction<cursorHoverIntent>(
      onInvoke: (intent) {
        print("baseIndex:${intent.selection?.baseIndex},baseOffset:${intent.selection?.baseOffset}");
        if (_overlayEntry1 != null) {
          _overlayEntry1?.remove();
          _overlayEntry1 = null;
        }

        if (intent.mouseStatus == MouseStatus.exit || intent.selection == null) {
          return;
        }

        _overlayEntry1 = OverlayEntry(
          builder: (context) {
            return Center(
              child: FutureBuilder<Widget?>(
                future: _ToastbuildWidget(context, intent.selection!, intent.layerLink, intent.position, intent.lineHeight),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(); //const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    print('异步错误: ${snapshot.error}');
                    return Container();
                  } else if (snapshot.hasData) {
                    if (snapshot.data == null) {
                      _overlayEntry1?.remove();
                    }
                    return snapshot.data!;
                  } else {
                    return Container();
                  }
                },
              ),
            );
          },
        );
        Overlay.of(context, rootOverlay: true).insert(_overlayEntry1!);
        return null;
      },
    );
    _selectAction = _CodeAutocompleteAction<CodeShortcutNewLineIntent>(
      onInvoke: (intent) {
        final CodeAutocompleteEditingValue? value = _notifier?.value;
        if (value == null) {
          return null;
        }
        _onAutocomplete?.call(value.autocomplete);
        return intent;
      },
    );
  }

  Future<Widget?> _ToastbuildWidget(BuildContext context, CodeLineSelection selection, LayerLink layerLink, Offset position, double lineHeight) async {
    final PreferredSizeWidget? child;
    child = await widget.HoverViewBuilder(context, selection);
    if (child == null) {
      return null;
    }
    /*final Size screenSize = MediaQuery.of(context).size;
    final double offsetX;
    if (position.dx + child.preferredSize.width > screenSize.width) {
      offsetX = screenSize.width - (position.dx + child.preferredSize.width);
    } else {
      offsetX = 0;
    }
    final double offsetY;
    if (position.dy + child.preferredSize.height > screenSize.height) {
      offsetY = -child.preferredSize.height - lineHeight;
    } else {
      offsetY = 0;
    }*/
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: position.dx - child.preferredSize.width / 2,
          top: position.dy - child.preferredSize.height - 10,
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.transparent,
                child: TapRegion(
                    onTapOutside: (event) {
                      dismiss();
                    },
                    child: CodeEditorTapRegion(
                        child: ExcludeSemantics(
                      child: child,
                    ))),
              )),
        )
      ],
    );
  }

  @override
  void didUpdateWidget(covariant _CodeAutocomplete oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Actions(actions: {
      CodeShortcutCursorMoveIntent: _navigateAction,
      CodeShortcutNewLineIntent: _selectAction,
      cursorHoverIntent: _hoverAction,
    }, child: widget.child);
  }

  void show({
    required LayerLink layerLink,
    required Offset position,
    required double lineHeight,
    required CodeLineEditingValue value,
    required ValueChanged<CodeAutocompleteResult> onAutocomplete,
  }) {
    dismiss();
    CodeAutocompleteEditingValue? autocompleteEditingValue = widget.promptsBuilder.build(
      context,
      value.codeLines[value.selection.extentIndex],
      value.selection,
    );
    //杜绝硬编码 他只要有输入就可以使用
    if (autocompleteEditingValue == null || autocompleteEditingValue.input == '') {
      return;
    }
    if (autocompleteEditingValue.prompts.isEmpty && !widget.Lsp) {
      return;
    }
    /*if (autocompleteEditingValue == null) {
      if (!widget.Lsp) {
        return;
      }
      autocompleteEditingValue = CodeAutocompleteEditingValue(input: '', prompts: [], index: 0, selection: value.selection);
    } else if (widget.Lsp) {
      autocompleteEditingValue = autocompleteEditingValue.copyWith(selection: value.selection);
    }*/
    //_buildWidget(context, layerLink, position, lineHeight);
    _notifier = ValueNotifier(autocompleteEditingValue);
    _onAutocomplete = onAutocomplete;
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Center(
          child: FutureBuilder<Widget>(
            future: _buildWidget(context, layerLink, position, lineHeight),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); //const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                print('异步错误: ${snapshot.error}');
                return Container();
              } else if (snapshot.hasData) {
                return snapshot.data!;
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    _navigateAction.setEnabled(true);
    _selectAction.setEnabled(true);
  }

  void dismiss() {
    _notifier = null;
    _onAutocomplete = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _navigateAction.setEnabled(false);
    _selectAction.setEnabled(false);
  }

  Future<Widget> _buildWidget(BuildContext context, LayerLink layerLink, Offset position, double lineHeight) async {
    final PreferredSizeWidget child;
    child = await widget.viewBuilder(context, _notifier!, (result) {
      _onAutocomplete?.call(result);
    });
    final Size screenSize = MediaQuery.of(context).size;
    final double offsetX;
    if (position.dx + child.preferredSize.width > screenSize.width) {
      offsetX = screenSize.width - (position.dx + child.preferredSize.width);
    } else {
      offsetX = 0;
    }
    final double offsetY;
    if (position.dy + child.preferredSize.height > screenSize.height) {
      offsetY = -child.preferredSize.height - lineHeight;
    } else {
      offsetY = 0;
    }
    return CompositedTransformFollower(
      link: layerLink,
      showWhenUnlinked: false,
      offset: const Offset(0, 0),
      child: Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            child: TapRegion(
                onTapOutside: (event) {
                  dismiss();
                },
                child: CodeEditorTapRegion(
                    child: ExcludeSemantics(
                  child: child,
                ))),
          )),
    );
  }
}

class _CodeHoverAction<T extends Intent> extends CallbackAction<T> {
  bool _isEnabled = true;

  _CodeHoverAction({required super.onInvoke});

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  @override
  bool get isActionEnabled => _isEnabled;
}

class _CodeAutocompleteAction<T extends Intent> extends CallbackAction<T> {
  bool _isEnabled = false;

  _CodeAutocompleteAction({required super.onInvoke});

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  @override
  bool get isActionEnabled => _isEnabled;
}

class _CodeAutocompleteNavigateAction extends _CodeAutocompleteAction<CodeShortcutCursorMoveIntent> {
  _CodeAutocompleteNavigateAction({required super.onInvoke});

  @override
  bool consumesKey(CodeShortcutCursorMoveIntent intent) {
    return intent.direction == AxisDirection.up || intent.direction == AxisDirection.down;
  }
}

final RegExp validVariableRegex = RegExp(
  r'^[\p{L}$_][\p{L}\p{N}$_]*$',
  unicode: true,
  dotAll: true,
);

extension _CodeAutocompleteStringExtension on String {
  bool get isValidVariablePart {
    // 使用正则表达式检查变量名
    return validVariableRegex.hasMatch(this);
  }
}

extension _CodeAutocompleteCharactersExtension on Characters {
  bool containsSymbols(List<String> symbols) {
    for (int i = length - 1; i >= 0; i--) {
      if (symbols.contains(elementAt(i))) {
        return true;
      }
    }
    return false;
  }
}
