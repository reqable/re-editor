part of re_editor;

const Duration floatingCursorSnapDuration = Duration(milliseconds: 150);

class _CodeFloatingCursorController extends ValueNotifier<_FloatingCursorPosition> {
  late final _CodeCursorBlinkController _blinkController;
  late final AnimationController _animationController;

  _CodeFloatingCursorController(): super(const _FloatingCursorPosition());

  void setFloatingCursorPosition(Offset? floatingCursorOffset, Offset? previewCursorOffset, Offset? finalCursorOffset) {
    if (value.floatingCursorOffset != null && floatingCursorOffset == null) {
      // Starting the floating cursor
      _blinkController.startBlink();
    }
    else if (value.floatingCursorOffset == null && floatingCursorOffset != null) {
      // Stopping the floating cursor
      _blinkController.stopBlink();
    }

    value = _FloatingCursorPosition(floatingCursorOffset: floatingCursorOffset, previewCursorOffset: previewCursorOffset, finalCursorOffset: finalCursorOffset);
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
  final Offset? floatingCursorOffset;
  final Offset? previewCursorOffset;
  final Offset? finalCursorOffset;

  const _FloatingCursorPosition({this.floatingCursorOffset, this.previewCursorOffset, this.finalCursorOffset});

  _FloatingCursorPosition copyWith({
    Offset? floatingCursorOffset,
    Offset? previewCursorOffset,
    Offset? finalCursorOffset,
  }) {
    return _FloatingCursorPosition(
      floatingCursorOffset: floatingCursorOffset ?? this.floatingCursorOffset,
      previewCursorOffset: previewCursorOffset ?? this.previewCursorOffset,
      finalCursorOffset: finalCursorOffset ?? this.finalCursorOffset,
    );
  }

  bool isActive() {
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
  
  @override
  String toString() {
    return 'FloatingCursorOffset: $floatingCursorOffset, PreviewCursorOffset: $previewCursorOffset';
  }
}