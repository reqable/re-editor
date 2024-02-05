part of re_editor;

class _CodeShortcuts extends StatefulWidget {

  final CodeShortcutsActivatorsBuilder builder;
  final Widget child;

  const _CodeShortcuts({
    required this.builder,
    required this.child
  });

  @override
  State<StatefulWidget> createState() => _CodeShortcutsState();

}

class _CodeShortcutsState extends State<_CodeShortcuts> {

  late final Map<ShortcutActivator, Intent> _shortcuts;

  @override
  void initState() {
    super.initState();
    _shortcuts = {};
    _buildShortcuts();
  }

  @override
  void didUpdateWidget (_CodeShortcuts oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.builder != widget.builder) {
      _buildShortcuts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: _shortcuts,
      child: widget.child
    );
  }

  void _buildShortcuts() {
    _shortcuts.clear();
    for (final CodeShortcutType type in CodeShortcutType.values) {
      if (type == CodeShortcutType.backspace) {
        if (Platform.isAndroid || Platform.isIOS) {
          continue;
        }
      }
      final List<ShortcutActivator>? activators = widget.builder.build(type);
      if (activators == null || activators.isEmpty) {
        continue;
      }
      for (final ShortcutActivator activator in activators) {
        _shortcuts[activator] = kCodeShortcutIntents[type]!;
      }
    }
  }

}

class _CodeShortcutActions extends StatelessWidget {

  final CodeLineEditingController editingController;
  final CodeFindController? findController;
  final CodeCommentFormatter? commentFormatter;
  final Map<Type, Action<Intent>>? overrideActions;
  final bool readOnly;
  final Widget child;

  const _CodeShortcutActions({
    required this.editingController,
    this.findController,
    this.commentFormatter,
    required this.overrideActions,
    required this.readOnly,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final Map<Type, Action<Intent>> actions = {};
    for (final Intent intent in kCodeShortcutIntents.values) {
      actions[intent.runtimeType] = _CompoDoNothingCallbackAction(
        controller: editingController,
        onInvoke: (intent) {
          return _onAction(context, intent);
        },
      );
    }
    return Actions(
      actions: {
        ...actions,
        if (overrideActions != null)
          ...overrideActions!
      },
      child: child
    );
  }

  Object? _onAction(BuildContext context, Intent intent) {
    final Action<Intent>? action = Actions.maybeFind(context, intent: intent);
    if (action != null && action.isActionEnabled && action.consumesKey(intent)) {
      if (action is CallbackAction) {
        action.invoke(intent);
      }
      return null;
    }
    if (intent is CodeShortcutEditableIntent && readOnly) {
      return null;
    }
    if (editingController.isComposing) {
      return null;
    }
    switch (intent.runtimeType) {
      case CodeShortcutSelectAllIntent: {
        editingController.selectAll();
        break;
      }
      case CodeShortcutLineSelectIntent: {
        editingController.selectLines(editingController.selection.baseIndex, editingController.selection.extentIndex);
        break;
      }
      case CodeShortcutCutIntent: {
        editingController.cut();
        break;
      }
      case CodeShortcutCopyIntent: {
        editingController.copy();
        break;
      }
      case CodeShortcutPasteIntent: {
        editingController.paste();
        break;
      }
      case CodeShortcutUndoIntent: {
        editingController.undo();
        break;
      }
      case CodeShortcutRedoIntent: {
        editingController.redo();
        break;
      }
      case ShortcutLineDeleteIntent: {
        editingController.deleteSelectionLines(true);
        break;
      }
      case ShortcutLineMoveIntent: {
        if ((intent as ShortcutLineMoveIntent).direction == VerticalDirection.up) {
          editingController.moveSelectionLinesUp();
        } else {
          editingController.moveSelectionLinesDown();
        }
        break;
      }
      case CodeShortcutIndentIntent: {
        editingController.applyIndent();
        break;
      }
      case CodeShortcutOutdentIntent: {
        editingController.applyOutdent();
        break;
      }
      case CodeShortcutCommentIntent: {
        final CodeLineEditingValue? value = commentFormatter?.format(
          editingController.value, editingController.options.indent,
          (intent as CodeShortcutCommentIntent).single);
        if (value != null) {
          editingController.runRevocableOp(() {
            editingController.value = value;
          });
        }
        break;
      }
      case CodeShortcutCursorMoveIntent: {
        editingController.moveCursor((intent as CodeShortcutCursorMoveIntent).direction);
        break;
      }
      case CodeShortcutCursorMoveLineEdgeIntent: {
        if ((intent as CodeShortcutCursorMoveLineEdgeIntent).forward) {
          editingController.moveCursorToLineEnd();
        } else {
          editingController.moveCursorToLineStart();
        }
        break;
      }
      case CodeShortcutCursorMoveDocEdgeIntent: {
        if ((intent as CodeShortcutCursorMoveDocEdgeIntent).forward) {
          editingController.moveCursorToPageEnd();
        } else {
          editingController.moveCursorToPageStart();
        }
        break;
      }
      case CodeShortcutCursorMovePageIntent: {
        if ((intent as CodeShortcutCursorMovePageIntent).forward) {
          editingController.moveCursorToPageDown();
        } else {
          editingController.moveCursorToPageUp();
        }
        break;
      }
      case CodeShortcutCursorMoveWordBoundaryIntent: {
        if ((intent as CodeShortcutCursorMoveWordBoundaryIntent).forward) {
          editingController.moveCursorToWordBoundaryForward();
        } else {
          editingController.moveCursorToWordBoundaryBackward();
        }
        break;
      }
      case CodeShortcutSelectionExtendIntent: {
        editingController.extendSelection((intent as CodeShortcutSelectionExtendIntent).direction);
        break;
      }
      case CodeShortcutSelectionExtendLineEdgeIntent: {
        if ((intent as CodeShortcutSelectionExtendLineEdgeIntent).forward) {
          editingController.extendSelectionToLineEnd();
        } else {
          editingController.extendSelectionToLineStart();
        }
        break;
      }
      case CodeShortcutSelectionExtendPageEdgeIntent: {
        if ((intent as CodeShortcutSelectionExtendPageEdgeIntent).forward) {
          editingController.extendSelectionToPageEnd();
        } else {
          editingController.extendSelectionToPageStart();
        }
        break;
      }
      case CodeShortcutDeleteIntent: {
        if ((intent as CodeShortcutDeleteIntent).forward) {
          editingController.deleteForward();
        } else {
          editingController.deleteBackward();
        }
        break;
      }
      case CodeShortcutNewLineIntent: {
        editingController.applyNewLine();
        break;
      }
      case CodeShortcutTransposeCharactersIntent: {
        editingController.transposeCharacters();
        break;
      }
      case CodeShortcutFindIntent: {
        findController?.findMode();
        break;
      }
      case CodeShortcutFindToggleMatchCaseIntent: {
        findController?.toggleCaseSensitive();
        break;
      }
      case CodeShortcutFindToggleRegexIntent: {
        findController?.toggleRegex();
        break;
      }
      case CodeShortcutReplaceIntent: {
        findController?.replaceMode();
        break;
      }
      case CodeShortcutEscIntent: {
        if (findController?.value != null) {
          findController?.close();
        } else {
          editingController.cancelSelection();
        }
        break;
      }
    }
    return intent;
  }

}

class _CompoDoNothingCallbackAction<T extends Intent> extends CallbackAction<T> {

  final CodeLineEditingController controller;

  _CompoDoNothingCallbackAction({
    required this.controller,
    required super.onInvoke,
  });

  @override
  bool consumesKey(T intent) {
    return !controller.isComposing;
  }

}