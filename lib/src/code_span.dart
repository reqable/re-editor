part of 're_editor.dart';

typedef PointerEnterEventWithRectListener =
    void Function(PointerEnterEvent event, int id, List<Rect> rects);

typedef PointerExitEventWithRectListener =
    void Function(PointerExitEvent event, int id, List<Rect> rects);

@immutable
class MouseTrackerAnnotationTextSpan extends TextSpan {
  const MouseTrackerAnnotationTextSpan({
    required this.onEnterWithRect,
    required this.onExitWithRect,
    super.text,
    super.children,
    super.style,
    super.recognizer,
    super.mouseCursor,
    super.semanticsLabel,
    super.locale,
    super.spellOut,
  });
  final PointerEnterEventWithRectListener onEnterWithRect;
  final PointerExitEventWithRectListener onExitWithRect;
}
