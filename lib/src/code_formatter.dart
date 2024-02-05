part of re_editor;

abstract class CodeCommentFormatter {

  CodeLineEditingValue format(CodeLineEditingValue value, String indent, bool single);

}

abstract class DefaultCodeCommentFormatter implements CodeCommentFormatter {

  factory DefaultCodeCommentFormatter({
    String? singleLinePrefix, 
    String? multiLinePrefix
  }) => _DefaultCodeCommentFormatter(
    singleLinePrefix: singleLinePrefix,
    multiLinePrefix: multiLinePrefix,
  );

}