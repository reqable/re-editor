part of re_editor;

class _CodeFloatingCursorController extends ValueNotifier<_FloatingCursorPosition> {
  late final _CodeCursorBlinkController _blinkController;

  _CodeFloatingCursorController(): super(const _FloatingCursorPosition());

  void setFloatingCursorPosition(Offset? floatingCursorOffset, Offset? previewCursorOffset) {
    if (value.floatingCursorOffset != null && floatingCursorOffset == null) {
      // Starting the floating cursor
      _blinkController.startBlink();
    }
    else if (value.floatingCursorOffset == null && floatingCursorOffset != null) {
      // Stopping the floating cursor
      _blinkController.stopBlink();
    }

    value = _FloatingCursorPosition(floatingCursorOffset: floatingCursorOffset, previewCursorOffset: previewCursorOffset);
  }

  set blinkController(_CodeCursorBlinkController value) {
    _blinkController = value;
  } 

  Offset? get previewCursorOffset => value.floatingCursorOffset;

  Offset? get floatingCursorOffset => value.floatingCursorOffset;
}

class _FloatingCursorPosition {
  final Offset? floatingCursorOffset;
  final Offset? previewCursorOffset;

  const _FloatingCursorPosition({this.floatingCursorOffset, this.previewCursorOffset});

  _FloatingCursorPosition copyWith({
    Offset? floatingCursorOffset,
    Offset? previewCursorOffset,
  }) {
    return _FloatingCursorPosition(
      floatingCursorOffset: floatingCursorOffset ?? this.floatingCursorOffset,
      previewCursorOffset: previewCursorOffset ?? this.previewCursorOffset,
    );
  }

  bool isActive() {
    return floatingCursorOffset != null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! _FloatingCursorPosition) return false;

    return floatingCursorOffset == other.floatingCursorOffset && previewCursorOffset == other.previewCursorOffset;
  }

  @override
  int get hashCode => floatingCursorOffset.hashCode ^ previewCursorOffset.hashCode;
  
  @override
  String toString() {
    return 'FloatingCursorOffset: $floatingCursorOffset, PreviewCursorOffset: $previewCursorOffset';
  }
}