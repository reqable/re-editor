part of re_editor;

// The time the animation of the floating cursor snapping to the final cursor position will take.
const Duration floatingCursorSnapDuration = Duration(milliseconds: 200);

// Class containing the floating cursor control logic.
//
class _CodeFloatingCursorController extends ValueNotifier<_FloatingCursorPosition> {
  late final _CodeCursorBlinkController _blinkController;
  late final AnimationController _animationController;

  _CodeFloatingCursorController(): super(const _FloatingCursorPosition());

  // Sets the offsets of the floating cursor, preview cursor, and final cursor. Setting either one of these offsets
  // to zero is equivalent to turning off the corresponding cursor.
  void setFloatingCursorPosition(Offset? floatingCursorOffset, Offset? previewCursorOffset, Offset? finalCursorOffset) {
    if (value.floatingCursorOffset != null && floatingCursorOffset == null) {
      // Starting the floating cursor, stop blinking of the normal cursor
      _blinkController.startBlink();
    }
    else if (value.floatingCursorOffset == null && floatingCursorOffset != null) {
      // Stopping the floating cursor, resume blinking of the normal cursor
      _blinkController.stopBlink();
    }

    value = _FloatingCursorPosition(
      floatingCursorOffset: floatingCursorOffset, 
      previewCursorOffset: previewCursorOffset, 
      finalCursorOffset: finalCursorOffset,
    );
  }

  void _onFloatingCursorResetAnimationTick() {
    if (_animationController.isCompleted) {
      setFloatingCursorPosition(null, null, null);
    } else {
      final double lerpValue = _animationController.value;
      final double lerpX = ui.lerpDouble(value.floatingCursorOffset!.dx, value.finalCursorOffset!.dx, lerpValue)!;
      final double lerpY = ui.lerpDouble(value.floatingCursorOffset!.dy, value.finalCursorOffset!.dy, lerpValue)!;

      setFloatingCursorPosition(Offset(lerpX, lerpY), value.previewCursorOffset, value.finalCursorOffset);
    }
  }

  /// The two methods below are meant to only be used for property injection. Both [_blinkController] and [_animationController]
  /// have to be set before calling any of the other methods for the [_CodeFloatingCursorController] to work properly.

  set blinkController(_CodeCursorBlinkController value) {
    _blinkController = value;
  }

  set animationController(AnimationController value) {
    value.addListener(_onFloatingCursorResetAnimationTick);
    _animationController = value;
  }

  AnimationController get animationController => _animationController;

  Offset? get previewCursorOffset => value.previewCursorOffset;

  Offset? get floatingCursorOffset => value.floatingCursorOffset;
}

class _FloatingCursorPosition {
  // The offset of the floating cursor
  final Offset? floatingCursorOffset;

  // The offset of the preview cursor. The preview cursor is only visible when the floating cursor is hovering to the right of
  // the end of the line, where no text is present. It shows where the actual cursor would end up if the floating cursor would
  // be stoped in that moment.
  final Offset? previewCursorOffset;

  // The offset where the actual cursor would be placed if floating cursor would be stopped.
  final Offset? finalCursorOffset;

  const _FloatingCursorPosition({this.floatingCursorOffset, this.previewCursorOffset, this.finalCursorOffset});

  bool isActive() {
    // Floating cursor is active only if its offset is not null.
    return floatingCursorOffset != null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! _FloatingCursorPosition) return false;

    return floatingCursorOffset == other.floatingCursorOffset && previewCursorOffset == other.previewCursorOffset && finalCursorOffset == other.finalCursorOffset;
  }

  @override
  int get hashCode => floatingCursorOffset.hashCode ^ previewCursorOffset.hashCode ^ finalCursorOffset.hashCode;
}