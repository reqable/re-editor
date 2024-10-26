part of re_editor;

class _CodeInputController extends ChangeNotifier implements DeltaTextInputClient {

  CodeLineEditingController _controller;
  FocusNode _focusNode;
  bool _readOnly;
  bool _autocompleteSymbols;
  bool _updateCausedByFloatingCursor;
  late Offset _floatingCursorStartingOffset;
  late CodeLineSelection _newSelection;

  TextInputConnection? _textInputConnection;
  TextEditingValue? _remoteEditingValue;

  GlobalKey? _editorKey;

  _CodeInputController({
    required CodeLineEditingController controller,
    required FocusNode focusNode,
    required bool readOnly,
    required bool autocompleteSymbols,
  }) : _controller = controller,
    _focusNode = focusNode,
    _readOnly = readOnly,
    _updateCausedByFloatingCursor = false,
    _autocompleteSymbols = autocompleteSymbols {
    _controller.addListener(_onCodeEditingChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void bindEditor(GlobalKey key) {
    _editorKey = key;
  }

  set controller(CodeLineEditingController value) {
    if (_controller == value) {
      return;
    }
    _controller.removeListener(_onCodeEditingChanged);
    _controller = value;
    _controller.addListener(_onCodeEditingChanged);
    _onCodeEditingChanged();
  }

  set focusNode(FocusNode value) {
    if (_focusNode == value) {
      return;
    }
    _focusNode.removeListener(_onFocusChanged);
    _focusNode = value;
    _focusNode.addListener(_onFocusChanged);
  }

  set readOnly(bool value) {
    if (_readOnly == value) {
      return;
    }
    _readOnly = value;
  }

  set autocompleteSymbols(bool value) {
    if (_autocompleteSymbols == value) {
      return;
    }
    _autocompleteSymbols = value;
  }

  set value(CodeLineEditingValue value) {
    _controller.value = value;
  }

  CodeLineEditingValue get value => _controller.value;

  set codeLines(CodeLines value) {
    _controller.codeLines = value.isEmpty ? _kInitialCodeLines : value;
  }

  CodeLines get codeLines => _controller.codeLines;

  set selection(CodeLineSelection value) => _controller.selection = value;

  CodeLineSelection get selection => _controller.selection;

  set composing(TextRange value) => _controller.composing = value;

  TextRange get composing => _controller.composing;

  @override
  void connectionClosed() {
  }

  @override
  AutofillScope? get currentAutofillScope => null;

  @override
  TextEditingValue? get currentTextEditingValue => _buildTextEditingValue();

  @override
  void performAction(TextInputAction action) {
    if (action == TextInputAction.newline) {
      // Fix issue #42, iOS will insert duplicate new lines.
      // We only do this on Android.
      if (kIsAndroid) {
        _controller.applyNewLine();
      }
    }
  }

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {
  }

  @override
  void showAutocorrectionPromptRect(int start, int end) {
  }

  @override
  void showToolbar() {
  }

  @override
  void insertTextPlaceholder(Size size) {
  }

  @override
  void removeTextPlaceholder() {
  }

  @override
  void updateEditingValueWithDeltas(List<TextEditingDelta> textEditingDeltas) {
    if (_updateCausedByFloatingCursor) {
      _updateCausedByFloatingCursor = false;
      return;
    }
    
    if (textEditingDeltas.any((delta) => delta is TextEditingDeltaInsertion && delta.textInserted == '\n')) {
      TextEditingValue newValue = _remoteEditingValue!;
      for (final TextEditingDelta delta in textEditingDeltas) {
        newValue = delta.apply(newValue);
      }
      _remoteEditingValue = newValue;
      _controller.applyNewLine();
      return;
    }

    // _Trace.begin('updateEditingValue all');
    TextEditingValue newValue = _remoteEditingValue!;
    bool smartChange = false;
    for (final TextEditingDelta delta in textEditingDeltas) {
      if (_autocompleteSymbols) {
        TextEditingDelta newDelta = _SmartTextEditingDelta(delta).apply(selection);
        if (newDelta != delta) {
          smartChange = true;
        }
        newValue = newDelta.apply(newValue);
      } else {
        newValue = delta.apply(newValue);
      }
    }
    if (newValue == _remoteEditingValue) {
      return;
    }
    if (!smartChange) {
      _remoteEditingValue = newValue;
    }
    // print('update text ${newValue.text}');
    // print('update selection ${newValue.selection}');
    // print('update composing ${newValue.composing}');
    if (newValue.usePrefix) {
      if (newValue.selection.isCollapsed && newValue.selection.start == 0) {
        _controller.deleteBackward();
      } else {
        _controller.edit(newValue.removePrefixIfNecessary());
      }
    } else {
      _controller.edit(newValue);
    }
    notifyListeners();
    // _Trace.end('updateEditingValue all');
  }

  @override
  void updateEditingValue(TextEditingValue textEditingValue) {
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {
    _updateCausedByFloatingCursor = true;
    final _CodeFieldRender? render = _editorKey?.currentContext?.findRenderObject() as _CodeFieldRender?;
    if (render == null) {
      return;
    }
    switch(point.state) {
      case FloatingCursorDragState.Start:
        (render._showCursorNotifier as _CodeCursorBlinkController).stopBlink();
        _floatingCursorStartingOffset = render.calculateTextPositionViewportOffset(selection.base)!;
        render.floatingCursorOffset = _floatingCursorStartingOffset;
        break;
      case FloatingCursorDragState.Update:
        final updatedOffset = _floatingCursorStartingOffset + point.offset!;
        // An adjustment is made to updatedOffset on the y-axis so that whenever it is in between lines, the line where the center 
        // of the floating cursor is will be selected.
        final adjustedNewOffset = updatedOffset + Offset(0, render.floatingCursorHeight/2);
        final newPosition = render.calculateTextPosition(adjustedNewOffset)!;
        _newSelection = CodeLineSelection.fromPosition(position: newPosition);
        render.floatingCursorOffset = updatedOffset;
        break;
      case FloatingCursorDragState.End:
        selection = _newSelection;
        render.floatingCursorOffset = null;
        (render._showCursorNotifier as _CodeCursorBlinkController).startBlink();
    }
  }

  @override
  void didChangeInputControl(TextInputControl? oldControl, TextInputControl? newControl) {
  }

  @override
  void performSelector(String selectorName) {
  }

  @override
  void insertContent(KeyboardInsertedContent content) {
  }

  void ensureInput() {
    if (_focusNode.hasFocus) {
      if (!_readOnly) {
        _openInputConnection();
      }
    } else {
      _focusNode.requestFocus();
    }
  }

  @override
  void notifyListeners() {
    // Do nothing here.
    super.notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _closeInputConnectionIfNeeded();
    _controller.removeListener(_onCodeEditingChanged);
    _focusNode.removeListener(_onFocusChanged);
  }

  bool get _hasInputConnection => _textInputConnection?.attached ?? false;

  void _onCodeEditingChanged() {
    _updateRemoteEditingValueIfNeeded();
    _updateRemoteComposingIfNeeded();
  }

  void _updateRemoteEditingValueIfNeeded() {
    if (!_hasInputConnection) {
      return;
    }
    TextEditingValue localValue = _buildTextEditingValue();
    if (localValue == _remoteEditingValue) {
      return;
    }
    if (localValue.composing.isValid && max(localValue.composing.start, localValue.composing.end) > localValue.text.length) {
      localValue = localValue.copyWith(
        composing: TextRange.empty
      );
    }
    // print('post text ${localValue.text}');
    // print('post selection ${localValue.selection}');
    // print('post composing ${localValue.composing}');
    _remoteEditingValue = localValue;

    _textInputConnection!.setEditingState(localValue);
  }

  void _updateRemoteComposingIfNeeded({
    bool retry = false
  }) {
    if (!_hasInputConnection) {
      return;
    }
    final _CodeFieldRender? render = _editorKey?.currentContext?.findRenderObject() as _CodeFieldRender?;
    if (render == null) {
      return;
    }
    final Offset? composingStart = render.calculateTextPositionViewportOffset(selection.base.copyWith(
      offset: _remoteEditingValue?.composing.start
    ));
    final Offset? composingEnd = render.calculateTextPositionViewportOffset(selection.extent.copyWith(
      offset: _remoteEditingValue?.composing.end
    ));
    if (composingStart != null && composingEnd != null) {
      _textInputConnection!.setComposingRect(Rect.fromPoints(composingStart, composingEnd + Offset(0, render.lineHeight)));
    }
    final Offset? caret = render.calculateTextPositionViewportOffset(selection.base) ?? composingStart;
    if (caret != null) {
      _textInputConnection!.setCaretRect(Rect.fromLTWH(caret.dx, caret.dy, render.cursorWidth, render.lineHeight));
    } else if (!retry) {
      Future.delayed(const Duration(milliseconds: 10), () {
        _updateRemoteComposingIfNeeded(
          retry: true
        );
      });
    }
  }

  void _updateRemoteEditableSizeAndTransform() {
    if (!_hasInputConnection) {
      return;
    }
    final _CodeFieldRender? render = _editorKey?.currentContext?.findRenderObject() as _CodeFieldRender?;
    if (render == null || !render.hasSize) {
      return;
    }
    _textInputConnection!.setEditableSizeAndTransform(render.size, render.getTransformTo(null));
  }

  void _onFocusChanged() {
    _openOrCloseInputConnectionIfNeeded();
  }

  void _openOrCloseInputConnectionIfNeeded() {
    if (_focusNode.hasFocus && !_readOnly) {
      if (_focusNode.consumeKeyboardToken()) {
        _openInputConnection();
      }
    } else {
      _closeInputConnectionIfNeeded();
      _controller.clearComposing();
    }
  }

  void _openInputConnection() {
    if (!_hasInputConnection) {
      final TextInputConnection connection = TextInput.attach(this,
        const TextInputConfiguration(
          enableDeltaModel: true,
          inputAction: TextInputAction.newline
        ),
      );
      _remoteEditingValue = _buildTextEditingValue();
      connection.setEditingState(_remoteEditingValue!);
      connection.show();
      _textInputConnection = connection;
    } else {
      _textInputConnection?.show();
    }
    _updateRemoteComposingIfNeeded();
    _updateRemoteEditableSizeAndTransform();
  }

  void _closeInputConnectionIfNeeded() {
    if (_hasInputConnection) {
      _textInputConnection!.close();
    }
    _textInputConnection = null;
  }

  TextEditingValue _buildTextEditingValue() {
    final TextSelection textSelection;
    if (selection.isSameLine) {
      textSelection = TextSelection(
        baseOffset: selection.baseOffset,
        extentOffset: selection.extentOffset
      );
    } else {
      if (selection.baseIndex < selection.extentIndex) {
        textSelection = TextSelection(
          baseOffset: selection.baseOffset,
          extentOffset: codeLines[selection.baseIndex].length
        );
      } else {
        textSelection = TextSelection(
          baseOffset: 0,
          extentOffset: selection.baseOffset
        );
      }
    }
    return TextEditingValue(
      text: codeLines[selection.baseIndex].text,
      selection: textSelection,
      composing: composing
    ).appendPrefixIfNecessary();
  }

}

class _SmartTextEditingDelta {

  static const List<_ClosureSymbol> _closureSymbols = [
    _ClosureSymbol('{', '}'),
    _ClosureSymbol('[', ']'),
    _ClosureSymbol('(', ')'),
  ];

  static const List<String> _quoteSymbols = [
    '\'', '"', '`'
  ];

  static const List<_ClosureSymbol> _wrapSymbols = [
    _ClosureSymbol('{', '}'),
    _ClosureSymbol('[', ']'),
    _ClosureSymbol('(', ')'),
    _ClosureSymbol('\'', '\''),
    _ClosureSymbol('"', '"'),
    _ClosureSymbol('`', '`'),
  ];

  final TextEditingDelta _delta;

  _SmartTextEditingDelta(this._delta);

  TextEditingDelta apply(CodeLineSelection selection) {
    TextEditingDelta delta = _delta;
    if (delta is TextEditingDeltaInsertion) {
      delta = _smartInsertion(delta);
    } else if (delta is TextEditingDeltaReplacement) {
      delta = _smartReplacement(delta, selection);
    }
    return delta;
  }

  TextEditingDelta _smartInsertion(TextEditingDeltaInsertion delta) {
    for (final _ClosureSymbol symbol in _closureSymbols) {
      if (delta.textInserted == symbol.left) {
        if (!_shouldAutoClosed(delta.oldText, delta.insertionOffset, symbol)) {
          break;
        }
        return TextEditingDeltaInsertion(
          oldText: delta.oldText,
          textInserted: symbol.toString(),
          insertionOffset: delta.insertionOffset,
          selection: delta.selection,
          composing: delta.composing,
        );
      } else if (delta.textInserted == symbol.right) {
        if (!_shouldSkipClosed(delta.oldText, delta.insertionOffset, symbol)) {
          break;
        }
        return TextEditingDeltaNonTextUpdate(
          oldText: delta.oldText,
          selection: TextSelection.collapsed(
            offset: delta.insertionOffset + 1
          ),
          composing: delta.composing
        );
      }
    }
    for (final String symbol in _quoteSymbols) {
      if (delta.textInserted != symbol) {
        continue;
      }
      if (!_shouldAutoQuoted(delta.oldText, symbol, delta.insertionOffset)) {
        break;
      }
      return TextEditingDeltaInsertion(
        oldText: delta.oldText,
        textInserted: symbol * 2,
        insertionOffset: delta.insertionOffset,
        selection: delta.selection,
        composing: delta.composing,
      );
    }
    return delta;
  }

  TextEditingDelta _smartReplacement(TextEditingDeltaReplacement delta, CodeLineSelection selection) {
    if (!selection.isSameLine) {
      return delta;
    }
    if (delta.replacementText.length > 1) {
      return delta;
    }
    final int index = _wrapSymbols.indexWhere((element) => element.left == delta.replacementText);
    if (index < 0) {
      return delta;
    }
    final _ClosureSymbol symbol = _wrapSymbols[index];
    return TextEditingDeltaReplacement(
      oldText: delta.oldText,
      replacementText: symbol.left + delta.textReplaced + symbol.right,
      replacedRange: delta.replacedRange,
      selection: TextSelection(
        baseOffset: selection.startOffset + 1,
        extentOffset: selection.endOffset + 1
      ),
      composing: delta.composing
    );
  }

  bool _shouldAutoClosed(String text, int offset, _ClosureSymbol symbol) {
    final Characters characters = text.characters;
    if (characters.isEmpty) {
      return true;
    }
    int leftSymbolCount = 0;
    int rightSymbolCount = 0;
    for (int i = 0; i < characters.length; i++) {
      final String character = characters.elementAt(i);
      if (i <= offset) {
        if (character == symbol.left) {
          leftSymbolCount++;
        } else if (character == symbol.right) {
          leftSymbolCount--;
        }
      } else {
        if (character == symbol.left) {
          rightSymbolCount--;
        } else if (character == symbol.right) {
          rightSymbolCount++;
        }
      }
    }
    return max(0, leftSymbolCount) >= rightSymbolCount;
  }

  bool _shouldSkipClosed(String text, int offset, _ClosureSymbol symbol) {
    if (text.isEmpty) {
      return false;
    }
    if (offset == text.length) {
      return false;
    }
    return text.substring(offset, offset + 1) == symbol.right;
  }

  bool _shouldAutoQuoted(String text, String symbol, int offset) {
    final Characters characters = text.characters;
    if (characters.isEmpty) {
      return true;
    }
    int leftSymbolCount = 0;
    int rightSymbolCount = 0;
    for (int i = 0; i < characters.length; i++) {
      final String character = characters.elementAt(i);
      if (i < offset) {
        if (character == symbol) {
          leftSymbolCount++;
        }
      } else {
        if (character == symbol) {
          rightSymbolCount++;
        }
      }
    }
    if (leftSymbolCount == 0 && rightSymbolCount == 0) {
      return true;
    }
    if (rightSymbolCount == 0) {
      return leftSymbolCount % 2 == 0;
    }
    if (leftSymbolCount == 0) {
      return rightSymbolCount % 2 == 0;
    }
    return leftSymbolCount % 2 == rightSymbolCount % 2;
  }

}

class _ClosureSymbol {
  final String left;
  final String right;

  const _ClosureSymbol(this.left, this.right);

  @override
  String toString() {
    return left + right;
  }

}

const String _kPrefix = '\u200b';

extension _TextEditingValueExtension on TextEditingValue {

  bool get startWithPrefix => text.startsWith(_kPrefix);

  bool get usePrefix => kIsIOS || kIsAndroid;

  TextEditingValue appendPrefixIfNecessary() {
    if (!usePrefix) {
      return this;
    }
    return copyWith(
      text: '$_kPrefix$text',
      selection: selection.copyWith(
        baseOffset: selection.baseOffset + 1,
        extentOffset: selection.extentOffset + 1,
      ),
      composing: composing.isValid ? TextRange(
        start: composing.start + 1,
        end: composing.end + 1
      ) : composing
    );
  }

  TextEditingValue removePrefixIfNecessary() {
    if (!usePrefix) {
      return this;
    }
    if (!startWithPrefix) {
      return this;
    }
    return copyWith(
      text: text.substring(1),
      selection: selection.copyWith(
        baseOffset: max(0, selection.baseOffset - 1),
        extentOffset: max(0, selection.extentOffset - 1),
      ),
      composing: composing.isValid ? TextRange(
        start: max(0, composing.start - 1),
        end: max(0, composing.end - 1)
      ) : null
    );
  }

}