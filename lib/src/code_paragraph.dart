part of re_editor;

abstract class IParagraph {

  double get width;
  double get height;
  double get preferredLineHeight;
  int get length;
  int get lineCount;

  void draw(Canvas canvas, Offset offset);

  TextPosition getPosition(Offset offset);

  TextRange getWord(Offset offset);

  TextRange getLineBoundary(TextPosition position);

  Offset? getOffset(TextPosition position);

  List<Rect> getRangeRects(TextRange range);

}