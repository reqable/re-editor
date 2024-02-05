part of re_editor;

class _CodeLineSegmentQuckLineCount extends CodeLineSegment {

  late int _lineCount;

  _CodeLineSegmentQuckLineCount({
    required super.codeLines,
    required super.dirty,
  }) {
    _lineCount = super.lineCount;
  }

  @override
  int get lineCount => _lineCount;

  @override
  set length(int newLength) {
    super.length = newLength;
    _lineCount = super.lineCount;
  }

  @override
  void add(CodeLine element) {
    super.add(element);
    _lineCount = super.lineCount;
  }

  @override
  void operator []=(int index, CodeLine value) {
    super[index] = value;
    _lineCount = super.lineCount;
  }
  
}

