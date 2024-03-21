part of re_editor;

/// An immutable style describing how to format and paint editor content.
class CodeEditorStyle {

  /// Creates a code editor style.
  const CodeEditorStyle({
    this.fontSize,
    this.fontFamily,
    this.fontHeight,
    this.textColor,
    this.hintTextColor,
    this.backgroundColor,
    this.selectionColor,
    this.highlightColor,
    this.cursorColor,
    this.cursorWidth,
    this.cursorLineColor,
    this.chunkIndicatorColor,
    this.codeTheme,
  }) : assert(fontSize == null || fontSize > 0),
    assert(fontHeight == null || fontHeight >= 1.0),
    assert(cursorWidth == null || cursorWidth > 0);

  /// The size of fonts (in logical pixels) to use when painting the text.
  ///
  /// The value specified matches the dimension of the
  /// [em square](https://fonts.google.com/knowledge/glossary/em) of the
  /// underlying font, and more often then not isn't exactly the height or the
  /// width of glyphs in the font.
  ///
  /// Default value is 13.0 pixels.
  final double? fontSize;

  /// The name of the font to use when painting the text (e.g., Roboto).
  ///
  /// If the font is defined in a package, this will be prefixed with
  /// 'packages/package_name/' (e.g. 'packages/cool_fonts/Roboto'). The
  /// prefixing is done by the constructor when the `package` argument is
  /// provided.
  ///
  /// The value provided in [fontFamily] will act as the preferred/first font
  /// family that glyphs are looked for in, followed in order by the font families
  /// in [fontFamilyFallback]. When [fontFamily] is null or not provided, the
  /// first value in [fontFamilyFallback] acts as the preferred/first font
  /// family. When neither is provided, then the default platform font will
  /// be used.
  final String? fontFamily;

  /// The height of this text span, as a multiple of the font size.
  ///
  /// When [fontHeight] is null or omitted, the line height will be determined
  /// by the font's metrics directly, which may differ from the fontSize.
  /// When [fontHeight] is non-null, the line height of the span of text will be a
  /// multiple of [fontSize] and be exactly `fontSize * height` logical pixels
  /// tall.
  ///
  /// For most fonts, setting [fontHeight] to 1.0 is not the same as omitting or
  /// setting height to null because the [fontSize] sets the height of the EM-square,
  /// which is different than the font provided metrics for line height. The
  /// following diagram illustrates the difference between the font-metrics
  /// defined line height and the line height produced with `height: 1.0`
  /// (which forms the upper and lower edges of the EM-square):
  ///
  /// See [StrutStyle] and [TextHeightBehavior] for further control of line
  /// height at the paragraph level.
  final double? fontHeight;

  /// The color to use when painting the text.
  ///
  /// The [textColor] property is shorthand for `Paint()..color = color`.
  final Color? textColor;

  /// The color to use when painting the hint text.
  ///
  /// The [hintTextColor] property is shorthand for `Paint()..color = color`.
  final Color? hintTextColor;

  /// The color to use as the background for the editor.
  ///
  /// Note, this is not the text background color.
  final Color? backgroundColor;

  /// The color to use as the background for the selected text.
  ///
  /// The paint layer is under [highlightColor].
  final Color? selectionColor;

  /// The color to use as the background for the highlighted text, such as
  /// the search matched text.
  ///
  /// The paint layer is above [selectionColor].
  final Color? highlightColor;

  /// The color of the cursor.
  ///
  /// The cursor indicates the current location of text insertion point in
  /// the field.
  ///
  /// If this is null it will default to the ambient
  /// [DefaultSelectionStyle.cursorColor]. If that is null, and the
  /// [ThemeData.platform] is [TargetPlatform.iOS] or [TargetPlatform.macOS]
  /// it will use [CupertinoThemeData.primaryColor]. Otherwise it will use
  /// the value of [ColorScheme.primary] of [ThemeData.colorScheme].
  final Color? cursorColor;

  /// How thick the cursor will be.
  ///
  /// Defaults to 2.0.
  ///
  /// The cursor will draw under the text. The cursor width will extend
  /// to the right of the boundary between characters for left-to-right text
  /// and to the left for right-to-left text. This corresponds to extending
  /// downstream relative to the selected position. Negative values may be used
  /// to reverse this behavior.
  final double? cursorWidth;

  /// The color to use as the border for the focused line.
  final Color? cursorLineColor;

  /// The color of the chunked indicator at the end of the line.
  final Color? chunkIndicatorColor;

  /// The code syntax highlighting rules and styles.
  final CodeHighlightTheme? codeTheme;

}

/// Creates a code editor.
///
/// You can freely define the styles of the editor, such as text style,
/// line number view, search view, scroll bar, etc.
///
/// Similar to [TextField], editor uses [CodeLineEditingController] as the content controller.
/// You can create a controller using the following code.
///
/// ```dart
/// final controller = CodeLineEditingController.fromText('Hello World');
/// ```
/// or
/// ```dart
/// final controller = CodeLineEditingController.fromFile('/Users/megatronking/hello.py');
/// ```
///
/// If [wordWrap] mode is turned off, the editor will support both horizontal and vertical scrolling,
/// and you can use [CodeScrollController] to control the scrolling.
///
/// You can use [CodeFindBuilder] to create search widget and use [CodeFindController] to control the widget and
/// search actions.
///
/// The editor has many built-in shortcut key actions. If you need to customize shortcut keys, you can use
/// [shortcutsActivatorsBuilder] or [shortcutOverrideActions]. By default, the editor will use [DefaultCodeShortcutsActivatorsBuilder].
///
/// Regarding code folding, you can write a custom code folding analyzer with [chunkAnalyzer].
/// By default, the editor will use [DefaultCodeChunkAnalyzer]. This works for some commonly used languages,
/// but may not work for some languages (such as python).
class CodeEditor extends StatefulWidget {

  const CodeEditor({
    super.key,
    this.controller,
    this.scrollController,
    this.findController,
    this.toolbarController,
    this.onChanged,
    this.style,
    this.hint,
    this.padding,
    this.margin,
    this.indicatorBuilder,
    this.scrollbarBuilder,
    this.findBuilder,
    this.shortcutsActivatorsBuilder,
    this.shortcutOverrideActions,
    this.sperator,
    this.border,
    this.readOnly,
    this.showCursorWhenReadOnly,
    this.wordWrap,
    this.autofocus,
    this.focusNode,
    this.chunkAnalyzer,
    this.commentFormatter,
  }) : assert(indicatorBuilder != null || (indicatorBuilder == null && sperator == null));

  /// Similar to [TextField], editor uses [CodeLineEditingController] as the content controller.
  final CodeLineEditingController? controller;

  /// Controls horizontal and vertical scrolling.
  final CodeScrollController? scrollController;

  /// Controls the search widget and actions.
  final CodeFindController? findController;

  /// Controls the selection toolbar.
  final SelectionToolbarController? toolbarController;

  /// Called when the user initiates a change to the editor's
  /// value was changed, such as insertion or deletion.
  ///
  /// Same as [CodeLineEditingController.addListener].
  final ValueChanged<CodeLineEditingValue>? onChanged;

  /// The style to use for the editor.
  final CodeEditorStyle? style;

  /// Text that suggests what sort of input the field accepts.
  final String? hint;

  /// The padding of the editor field, excludes the addtional wdigets like line number widget.
  final EdgeInsetsGeometry? padding;

  /// The margin value of the whole editor, includes the addtional wdigets like line number widget.
  final EdgeInsetsGeometry? margin;

  /// Use this to build your own indicator widget like line number widget.
  /// See [DefaultCodeLineNumber] and [DefaultCodeChunkIndicator].
  final CodeIndicatorBuilder? indicatorBuilder;

  /// Use this to build your own scroll bar widget.
  final CodeScrollbarBuilder? scrollbarBuilder;

  /// Use this to build your own search widget.
  /// The search widget will appear on the top of editor field.
  final CodeFindBuilder? findBuilder;

  /// Customize your shortcut keys.
  final CodeShortcutsActivatorsBuilder? shortcutsActivatorsBuilder;

  /// Override built-in shortcut key actions.
  final Map<Type, Action<Intent>>? shortcutOverrideActions;

  /// A sperator widget between indicator and editor field.
  final Widget? sperator;

  /// The border of the editor.
  final Border? border;

  /// Whether the text can be changed.
  ///
  /// When this is set to true, the text cannot be modified
  /// by any shortcut or keyboard operation. The text is still selectable.
  ///
  /// Defaults to false.
  final bool? readOnly;

  /// Whether to show cursor when in readonly mode.
  ///
  /// The cursor refers to the blinking caret when the editor is focused.
  final bool? showCursorWhenReadOnly;

  /// Should wrap the word.
  final bool? wordWrap;

  /// Whether this editor field should focus itself if nothing else is already
  /// focused.
  ///
  /// If true, the keyboard will open as soon as this text field obtains focus.
  /// Otherwise, the keyboard is only shown after the user taps the editor field.
  ///
  /// Defaults to false.
  final bool? autofocus;

  /// Controls whether this widget has keyboard focus.
  final FocusNode? focusNode;

  /// Decide which parts of code can be folded.
  ///
  /// Defaults to [DefaultCodeChunkAnalyzer].
  ///
  /// If you wish to turn off code folding, you can use [NonCodeChunkAnalyzer].
  final CodeChunkAnalyzer? chunkAnalyzer;

  /// Control how one or more lines of code are commented.
  final CodeCommentFormatter? commentFormatter;

  @override
  State<StatefulWidget> createState() => _CodeEditorState();

}

class _CodeEditorState extends State<CodeEditor> {

  late FocusNode _focusNode;
  late _CodeLineEditingControllerDelegate _editingController;
  late CodeScrollController _scrollController;
  late CodeFindController _findController;
  late CodeChunkController _chunkController;
  late final GlobalKey _editorKey;

  final LayerLink _startHandleLayerLink = LayerLink();
  final LayerLink _endHandleLayerLink = LayerLink();
  final LayerLink _toolbarLayerLink = LayerLink();
  final ValueNotifier<bool> _effectiveToolbarVisibility = ValueNotifier<bool>(true);

  late _SelectionOverlayController _selectionOverlayController;

  @override
  void initState() {
    super.initState();
    _editorKey = GlobalKey();
    _focusNode = widget.focusNode ?? FocusNode();
    _editingController = _CodeLineEditingControllerDelegate();
    _editingController.delegate =  widget.controller ?? CodeLineEditingController();
    _findController = widget.findController ?? CodeFindController(_editingController);
    _scrollController = widget.scrollController ?? CodeScrollController();
    _scrollController.bindEditor(_editorKey);
    _findController.addListener(_updateWidget);
    _chunkController = CodeChunkController(_editingController, widget.chunkAnalyzer ?? const DefaultCodeChunkAnalyzer());

    _editingController.bindEditor(_editorKey);

    _selectionOverlayController = kIsAndroid || kIsIOS ? _MobileSelectionOverlayController(
      context: context,
      controller: _editingController,
      editorKey: _editorKey,
      startHandleLayerLink: _startHandleLayerLink,
      endHandleLayerLink: _endHandleLayerLink,
      toolbarVisibility: _effectiveToolbarVisibility,
      focusNode: _focusNode,
      onShowToolbar: (context, anchors, renderRect) {
        widget.toolbarController?.show(
          context: context,
          controller: _editingController,
          anchors: anchors,
          renderRect: renderRect,
          layerLink: _toolbarLayerLink,
          visibility: _effectiveToolbarVisibility,
        );
      },
      onHideToolbar: () {
        widget.toolbarController?.hide(context);
      },
    ) : _DesktopSelectionOverlayController(
      onShowToolbar: (context, anchors, renderRect) {
        widget.toolbarController?.show(
          context: context,
          controller: _editingController,
          anchors: anchors,
          renderRect: renderRect,
          layerLink: _toolbarLayerLink,
          visibility: _effectiveToolbarVisibility,
        );
      },
      onHideToolbar: () {
        widget.toolbarController?.hide(context);
      },
    );
  }

  @override
  void dispose() {
    _findController.removeListener(_updateWidget);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _editingController.dispose();
    }
    if (widget.findController == null) {
      _findController.dispose();
    }
    if (widget.scrollController== null) {
      _scrollController.dispose();
    }
    _chunkController.dispose();
    _selectionOverlayController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CodeEditor oldWidget) {
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode();
    }
    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller == null) {
        _editingController.delegate.dispose();
      }
      _editingController.delegate = widget.controller ?? CodeLineEditingController();
      _editingController.bindEditor(_editorKey);
    }
    if (oldWidget.findController != widget.findController || oldWidget.controller != widget.controller) {
      if (oldWidget.findController == null) {
        _findController.dispose();
      }
      _findController = widget.findController ?? CodeFindController(_editingController);
      _findController.removeListener(_updateWidget);
      _findController.addListener(_updateWidget);
    }
    if (oldWidget.scrollController != widget.scrollController) {
      if (oldWidget.scrollController == null) {
        _scrollController.dispose();
      }
      _scrollController = widget.scrollController ?? CodeScrollController();
      _scrollController.bindEditor(_editorKey);
    }
    if (oldWidget.chunkAnalyzer != widget.chunkAnalyzer || oldWidget.controller != widget.controller) {
      _chunkController.dispose();
      _chunkController = CodeChunkController(_editingController, widget.chunkAnalyzer ?? const DefaultCodeChunkAnalyzer());
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextSelectionThemeData selectionTheme = TextSelectionTheme.of(context);
    final TextStyle baseStyle = TextStyle(
      fontSize: widget.style?.fontSize ?? _kDefaultTextSize,
      fontFamily: widget.style?.fontFamily,
      height: widget.style?.fontHeight ?? _kDefaultFontHeight,
    );
    final bool readOnly = widget.readOnly ?? false;
    final bool autofocus = widget.autofocus ?? true;
    final bool wordWrap = widget.wordWrap ?? true;
    final PreferredSizeWidget? find = widget.findBuilder?.call(context, _findController, readOnly);
    final Widget editable = _CodeEditable(
      editorKey: _editorKey,
      hint: widget.hint,
      indicatorBuilder: widget.indicatorBuilder,
      scrollbarBuilder: widget.scrollbarBuilder,
      textStyle: baseStyle.copyWith(
        color: widget.style?.textColor ?? theme.textTheme.bodyLarge?.color,
      ),
      hintTextColor: widget.style?.hintTextColor,
      backgroundColor: widget.style?.backgroundColor,
      selectionColor: widget.style?.selectionColor ?? selectionTheme.selectionColor ?? theme.colorScheme.primary.withOpacity(0.4),
      highlightColor: widget.style?.highlightColor ?? selectionTheme.selectionColor ?? theme.colorScheme.primary.withOpacity(0.4),
      cursorColor:  widget.style?.cursorColor ?? selectionTheme.cursorColor ?? theme.colorScheme.primary,
      cursorLineColor: widget.style?.cursorLineColor,
      chunkIndicatorColor: widget.style?.chunkIndicatorColor,
      cursorWidth: widget.style?.cursorWidth ?? _kDefaultCaretWidth,
      showCursorWhenReadOnly: widget.showCursorWhenReadOnly ?? true,
      sperator: widget.sperator,
      border: widget.border,
      onChanged: widget.onChanged,
      focusNode: _focusNode,
      padding: (widget.padding ?? _kDefaultPadding).add(EdgeInsets.only(
        top: find == null ? 0 : find.preferredSize.height
      )),
      margin:  widget.margin ?? EdgeInsets.zero,
      controller: _editingController,
      codeTheme: widget.style?.codeTheme,
      readOnly: readOnly,
      autofocus: autofocus,
      wordWrap: wordWrap,
      findController: _findController,
      scrollController: _scrollController,
      chunkController: _chunkController,
      startHandleLayerLink: _startHandleLayerLink,
      endHandleLayerLink: _endHandleLayerLink,
      toolbarLayerLink: _toolbarLayerLink,
      selectionOverlayController: _selectionOverlayController,
    );
    final Widget detector = _CodeSelectionGestureDetector(
      controller: _editingController,
      chunkController: _chunkController,
      selectionOverlayController: _selectionOverlayController,
      behavior: HitTestBehavior.translucent,
      editorKey: _editorKey,
      child: editable
    );
    final Widget child;
    if (kIsAndroid || kIsIOS) {
      child = Focus(
        autofocus: autofocus,
        focusNode: _focusNode,
        onKey: (node, event) {
          if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
            _editingController.deleteBackward();
            return KeyEventResult.handled;
          } else if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
            _editingController.applyNewLine();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        includeSemantics: false,
        debugLabel: 'CodeEditor',
        child: detector
      );
    } else {
      child = _CodeShortcuts(
        builder: widget.shortcutsActivatorsBuilder ?? const DefaultCodeShortcutsActivatorsBuilder(),
        child: _CodeShortcutActions(
          editingController: _editingController,
          findController: find != null ? _findController : null,
          commentFormatter: widget.commentFormatter,
          overrideActions: widget.shortcutOverrideActions,
          readOnly: readOnly,
          child: Focus(
            autofocus: autofocus,
            focusNode: _focusNode,
            includeSemantics: false,
            debugLabel: 'CodeEditor',
            child: detector
          )
        ),
      );
    }
    return Stack(
      children: [
        child,
        if (find != null)
          find,
      ],
    );
  }

  void _updateWidget() {
    setState(() {
    });
  }

}

/// A [TapRegion] that adds its children to the tap region group for widgets
/// based on the [CodeEditor] widget.
///
/// Widgets that are wrapped with a [CodeEditorTapRegion] are considered to be
/// part of the editor for purposes of unfocus behavior. So, when the user
/// taps on them, the currently focused editor won't be unfocused by
/// default.
///
/// See also:
///
///  * [TapRegion], the widget that this widget uses to add widgets to the group
///    of text fields.
class CodeEditorTapRegion extends TapRegion {

  /// Creates a const [CodeEditorTapRegion].
  ///
  /// The [child] field is required.
  const CodeEditorTapRegion({
    super.key,
    required super.child,
    super.enabled = true,
    super.behavior = HitTestBehavior.deferToChild,
    super.onTapOutside,
    super.onTapInside,
  }) : super(groupId: CodeEditor);

}