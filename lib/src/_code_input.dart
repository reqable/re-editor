part of re_editor;

class _CodeInputController extends ChangeNotifier implements DeltaTextInputClient {

  CodeLineEditingController _controller;
  FocusNode _focusNode;
  bool _readOnly;
  bool _autocompleteSymbols;
  bool _updateCausedByFloatingCursor;
  late Offset _floatingCursorStartingOffset;

  TextInputConnection? _textInputConnection;
  TextEditingValue? _remoteEditingValue;

  final _CodeFloatingCursorController _floatingCursorController;
  Timer? _floatingCursorScrollTimer;

  GlobalKey? _editorKey;

  _CodeInputController({
    required CodeLineEditingController controller,
    required _CodeFloatingCursorController floatingCursorController,
    required FocusNode focusNode,
    required bool readOnly,
    required bool autocompleteSymbols,
  }) : _controller = controller,
    _floatingCursorController = floatingCursorController,
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
      // This is necessary because otherwise the content of the line where the floating cursor was started
      // will be pasted over to the line where the floating cursor was stopped.
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
        _floatingCursorStartingOffset = render.calculateTextPositionViewportOffset(selection.base)!;
        _floatingCursorController.setFloatingCursorPositions(
          floatingCursorOffset: _floatingCursorStartingOffset,
          finalCursorSelection: selection,
        );
        break;
      case FloatingCursorDragState.Update:
        final Offset updatedOffset = _floatingCursorStartingOffset + point.offset!;

        final double topBound = render.paintBounds.top + render.paddingTop;
        final double leftBound = render.paintBounds.left + render.paddingLeft;
        final double bottomBound = render.paintBounds.bottom - render.paddingBottom - render.floatingCursorHeight;
        final double rightBound = render.paintBounds.right - render.paddingRight;

        // Clamp the offset coordinates to the paint bounds
        Offset clampedUpdatedOffset = Offset(
          updatedOffset.dx.clamp(leftBound, rightBound),
          updatedOffset.dy.clamp(topBound, bottomBound),
        );

        // An adjustment is made on the y-axis so that whenever it is in between lines, the line where the center
        // of the floating cursor is will be selected.
        Offset adjustedClampedUpdatedOffset = clampedUpdatedOffset + Offset(0, render.floatingCursorHeight / 2);
        final CodeLinePosition newPosition = render.calculateTextPosition(adjustedClampedUpdatedOffset)!;

        // The offset at which the actual cursor would end up if floating cursor was terminated now.
        final Offset? snappedNewOffset = render.calculateTextPositionViewportOffset(newPosition);

        CodeLineSelection newSelection = CodeLineSelection.fromPosition(position: newPosition);


        if (clampedUpdatedOffset != updatedOffset) {
          // When the cursor is at one of the edges, adjust the starting offset so that the floating cursor
          // does not get "loose" when starting to move in the opposite direction.
          _floatingCursorStartingOffset += clampedUpdatedOffset - updatedOffset;
        }

        if (clampedUpdatedOffset.dy == topBound || clampedUpdatedOffset.dy == bottomBound || clampedUpdatedOffset.dx == rightBound || clampedUpdatedOffset.dx == leftBound) {
          _floatingCursorScrollTimer ??= Timer.periodic(const Duration(milliseconds: 50), (timer) {
            render.autoScrollWhenDraggingFloatingCursor(clampedUpdatedOffset);
            final CodeLinePosition newPos = render.calculateTextPosition(adjustedClampedUpdatedOffset)!;
            final Offset? snappedNewOffset = render.calculateTextPositionViewportOffset(newPos);

            // This step ensures that the preview cursor will keep updating when scrolling
            if (adjustedClampedUpdatedOffset.dx > snappedNewOffset!.dx + render.textStyle.fontSize!) {
              _floatingCursorController.updatePreviewCursorOffset(snappedNewOffset);
            }
            else {
              _floatingCursorController.updatePreviewCursorOffset(null);
            }
          });
        }
        else {
          if (_floatingCursorScrollTimer != null) {
            _floatingCursorScrollTimer!.cancel();
            _floatingCursorScrollTimer = null;
          }
        }

        // Only turn on the preview cursor if we are away from the end of the line (relatively to the font size)
        if (adjustedClampedUpdatedOffset.dx > snappedNewOffset!.dx + render.textStyle.fontSize!) {
          _floatingCursorController.setFloatingCursorPositions(
            floatingCursorOffset: clampedUpdatedOffset,
            previewCursorOffset: snappedNewOffset,
            finalCursorOffset: snappedNewOffset,
            finalCursorSelection:newSelection
          );
        }
        else {
          _floatingCursorController.setFloatingCursorPositions(
            floatingCursorOffset: clampedUpdatedOffset,
            finalCursorOffset: snappedNewOffset,
            finalCursorSelection: newSelection
          );
        }

        break;
      case FloatingCursorDragState.End:
        if (_floatingCursorScrollTimer != null) {
          _floatingCursorScrollTimer!.cancel();
          _floatingCursorScrollTimer = null;
        }
        selection = _floatingCursorController.value.finalCursorSelection!;
        final CodeLinePosition finalPosition = CodeLinePosition(
          index: selection.baseIndex,
          offset: selection.baseOffset,
          affinity: selection.baseAffinity);

        final Offset? finalOffset = render.calculateTextPositionViewportOffset(finalPosition);

        // If the final selection is in not the viewport, make it visible without animating the floating cursor.
        // Otherwise, play the floating cursor reset animation.
        if (finalOffset != null && (finalOffset.dx < 0 || finalOffset.dy < 0)) {
          render.makePositionCenterIfInvisible(
            CodeLinePosition(
              index: selection.baseIndex,
              offset: selection.baseOffset,
              affinity: selection.baseAffinity),
            animated: true);
            _floatingCursorController.disableFloatingCursor();
        }
        else {
          _floatingCursorController.animateDisableFloatingCursor();
        }


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
    final BuildContext? context = _editorKey?.currentContext;
    if (context == null) {
      return;
    }
    if (!_hasInputConnection) {
      // Fix PlatformException issue on new flutter version.
      // See https://github.com/reqable/re-editor/issues/83
      final TextInputConnection connection = TextInput.attach(this,
        _TextInputConfiguration(
          flutterViewId: View.maybeOf(context)?.viewId ?? 0,
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

class _TextInputConfiguration extends TextInputConfiguration {

  final int flutterViewId;

  const _TextInputConfiguration({
    required this.flutterViewId,
    required super.enableDeltaModel,
    required super.inputAction,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'viewId': flutterViewId,
    };
  }

}