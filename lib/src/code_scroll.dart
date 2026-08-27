part of re_editor;

typedef CodeScrollbarBuilder = Widget Function(BuildContext context, Widget child, ScrollableDetails details);

class CodeScrollController {

  final ScrollController verticalScroller;
  final ScrollController horizontalScroller;
  final bool _ownsVerticalScroller;
  final bool _ownsHorizontalScroller;

  GlobalKey? _editorKey;

  CodeScrollController({
    ScrollController? verticalScroller,
    ScrollController? horizontalScroller,
  }) : _ownsVerticalScroller = verticalScroller == null,
    _ownsHorizontalScroller = horizontalScroller == null,
    verticalScroller = verticalScroller ?? ScrollController(),
    horizontalScroller = horizontalScroller ?? ScrollController();

  void makeCenterIfInvisible(CodeLinePosition position) {
    _render?.makePositionCenterIfInvisible(position);
  }

  void makeVisible(CodeLinePosition position) {
    _render?.makePositionVisible(position);
  }

  void bindEditor(GlobalKey key) {
    _editorKey = key;
  }

  _CodeFieldRender? get _render => _editorKey?.currentContext?.findRenderObject() as _CodeFieldRender?;

  void dispose() {
    _editorKey = null;
    // Only dispose controllers we allocated; caller-owned instances stay alive.
    if (_ownsVerticalScroller) {
      verticalScroller.dispose();
    }
    if (_ownsHorizontalScroller) {
      horizontalScroller.dispose();
    }
  }

}