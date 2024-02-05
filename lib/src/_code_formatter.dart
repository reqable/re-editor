part of re_editor;

class _DefaultCodeCommentFormatter implements DefaultCodeCommentFormatter {

  final String? singleLinePrefix;
  final String? multiLinePrefix;

  const _DefaultCodeCommentFormatter({
    this.singleLinePrefix,
    this.multiLinePrefix
  });

  @override
  CodeLineEditingValue format(CodeLineEditingValue value, String indent, bool single) {
    if (single && (singleLinePrefix == null || singleLinePrefix!.isEmpty)) {
      return value;
    }
    if (!single && (multiLinePrefix == null || multiLinePrefix!.isEmpty)) {
      return value;
    }
    final _DefaultCommentFormatter formatter;
    if (single) {
      formatter = _DefaultSingleLineCommentFormatter(singleLinePrefix!);
    } else {
      formatter = _DefaultMultiLineCommentFormatter(multiLinePrefix!);
    }
    return formatter.format(value, indent);
  }

}

abstract class _DefaultCommentFormatter {

  final String symbol;

  const _DefaultCommentFormatter(this.symbol);

  CodeLineEditingValue format(CodeLineEditingValue value, String indent);

}

class _DefaultSingleLineCommentFormatter extends _DefaultCommentFormatter {

  const _DefaultSingleLineCommentFormatter(super.symbol);

  @override
  CodeLineEditingValue format(CodeLineEditingValue value, String indent) {
    final CodeLineSelection selection = value.selection;
    if (selection.isSameLine) {
      return _formatSelectedCodeLine(value, indent);
    } else {
      return _formatSelectedCodeLines(value, indent);
    }
  }

  CodeLineEditingValue _formatSelectedCodeLine(CodeLineEditingValue value, String indent) {
    final String trimCode = value.codeLines[value.selection.baseIndex].text.trimLeft();
    if (trimCode.startsWith('$symbol ')) {
      return _uncommentSelectedCodeLine(value, '$symbol ');
    } else if (trimCode.startsWith(symbol)) {
      return _uncommentSelectedCodeLine(value, symbol);
    } else {
      return _commentSelectedCodeLine(value, indent, '$symbol ');
    }
  }

  CodeLineEditingValue _uncommentSelectedCodeLine(CodeLineEditingValue value, String prefix) {
    final CodeLineSelection selection = value.selection;
    final CodeLines codeLines = value.codeLines;
    final int lineIndex = selection.baseIndex;
    final CodeLine codeLine = codeLines[lineIndex];
    final int index = codeLine.text.indexOf(prefix);
    final CodeLines newCodeLines = CodeLines.from(codeLines);
    newCodeLines[lineIndex] = codeLine.copyWith(
      text: codeLine.text.substring(0, index) + codeLine.text.substring(index + prefix.length)
    );
    int relocation(int offset) {
      if (offset <= index) {
        return offset;
      } else {
        return max(index, offset - prefix.length);
      }
    }
    return value.copyWith(
      codeLines: newCodeLines,
      selection: selection.copyWith(
        baseOffset: relocation(selection.baseOffset),
        extentOffset: relocation(selection.extentOffset),
      )
    );
  }

  CodeLineEditingValue _commentSelectedCodeLine(CodeLineEditingValue value, String indent, String prefix) {
    final CodeLineSelection selection = value.selection;
    final CodeLines codeLines = value.codeLines;
    final int lineIndex = selection.baseIndex;
    final CodeLine codeLine = codeLines[lineIndex];
    final int index = codeLine.text.getOffsetWithoutIndent(indent);
    final CodeLines newCodeLines = CodeLines.from(codeLines);
    newCodeLines[lineIndex] = codeLine.copyWith(
      text: codeLine.text.insert(prefix, index)
    );
    final int baseOffset;
    final int extentOffset;
    if (selection.isCollapsed) {
      if (selection.baseOffset < index) {
        baseOffset = extentOffset = selection.baseOffset;
      } else {
        baseOffset = extentOffset = selection.baseOffset + prefix.length;
      }
    } else {
      if (selection.startOffset < index && selection.endOffset > index) {
        if (selection.baseOffset < index) {
          baseOffset = selection.baseOffset;
          extentOffset = selection.extentOffset + prefix.length;
        } else {
          extentOffset = selection.extentOffset;
          baseOffset = selection.baseOffset + prefix.length;
        }
      } else if (selection.startOffset >= index) {
        baseOffset = selection.baseOffset + prefix.length;
        extentOffset = selection.extentOffset + prefix.length;
      } else {
        baseOffset = selection.baseOffset;
        extentOffset = selection.extentOffset;
      }
    }
    return value.copyWith(
      codeLines: newCodeLines,
      selection: selection.copyWith(
        baseOffset: baseOffset,
        extentOffset: extentOffset,
      )
    );
  }

  CodeLineEditingValue _formatSelectedCodeLines(CodeLineEditingValue value, String indent) {
    final CodeLineSelection selection = value.selection;
    final CodeLines codeLines = value.codeLines;
    final List<String> texts = [];
    for (int i = selection.startIndex; i <= selection.endIndex; i++) {
      texts.add(codeLines[i].text);
    }
    final bool willComment;
    texts.removeWhere((text) => text.isEmpty);
    if (texts.isEmpty) {
      willComment = true;
    } else {
      willComment = texts.any((text) => !text.trimLeft().startsWith(symbol));
    }
    if (willComment) {
      return _commentSelectedCodeLines(value, indent, '$symbol ');
    } else {
      return _uncommentSelectedCodeLines(value, indent, symbol);
    }
  }

  CodeLineEditingValue _commentSelectedCodeLines(CodeLineEditingValue value, String indent, String prefix) {
    // TODO Handle code chunks
    final CodeLineSelection selection = value.selection;
    final CodeLines codeLines = value.codeLines;
    int? index;
    for (int i = selection.startIndex; i <= selection.endIndex; i++) {
      final CodeLine codeLine = codeLines[i];
      if (codeLine.text.isEmpty) {
        continue;
      }
      final int offset = codeLine.text.getOffsetWithoutIndent(indent);
      if (index == null) {
        index = offset;
      } else {
        index = min(index, offset);
      }
    }
    if (index == null) {
      return value;
    }
    final CodeLines newCodeLines = CodeLines.from(codeLines);
    for (int i = selection.startIndex; i <= selection.endIndex; i++) {
      final CodeLine codeLine = newCodeLines[i];
      if (codeLine.text.isEmpty) {
        continue;
      }
      newCodeLines[i] = codeLine.copyWith(
        text: codeLine.text.insert(prefix, index)
      );
    }
    final int baseOffset;
    final int extentOffset;
    if (selection.baseIndex < selection.extentIndex) {
      if (selection.baseOffset < index || newCodeLines[selection.baseIndex].text.isEmpty) {
        baseOffset = selection.baseOffset;
      } else {
        baseOffset = selection.baseOffset + prefix.length;
      }
      if (selection.extentOffset <= index) {
        extentOffset = selection.extentOffset;
      } else {
        extentOffset = selection.extentOffset + prefix.length;
      }
    } else {
      if (selection.baseOffset <= index) {
        baseOffset = selection.baseOffset;
      } else {
        baseOffset = selection.baseOffset + prefix.length;
      }
      if (selection.extentOffset < index || newCodeLines[selection.extentIndex].text.isEmpty) {
        extentOffset = selection.extentOffset;
      } else {
        extentOffset = selection.extentOffset + prefix.length;
      }
    }
    return value.copyWith(
      codeLines: newCodeLines,
      selection: selection.copyWith(
        baseOffset: baseOffset,
        extentOffset: extentOffset,
      )
    );
  }

  CodeLineEditingValue _uncommentSelectedCodeLines(CodeLineEditingValue value, String indent, String prefix) {
    // TODO Handle code chunks
    final CodeLineSelection selection = value.selection;
    final CodeLines newCodeLines = CodeLines.from(value.codeLines);
    int? baseOffset;
    int? extentOffset;
    for (int i = selection.startIndex; i <= selection.endIndex; i++) {
      final CodeLine codeLine = newCodeLines[i];
      if (codeLine.text.isEmpty) {
        continue;
      }
      final String trimCode = codeLine.text.trimLeft();
      final String deletion;
      if (trimCode.startsWith('$prefix ')) {
        deletion = '$prefix ';
      } else {
        deletion = prefix;
      }
      final int index = codeLine.text.indexOf(deletion);
      newCodeLines[i] = codeLine.copyWith(
        text: codeLine.text.substring(0, index) + codeLine.text.substring(index + deletion.length)
      );
      if (i == selection.baseIndex) {
        if (selection.baseOffset > index) {
          baseOffset = max(index, selection.baseOffset - deletion.length);
        }
      }
      if (i == selection.extentIndex) {
        if (selection.extentOffset > index) {
          extentOffset = max(index, selection.extentOffset - deletion.length);
        }
      }
    }
    return value.copyWith(
      codeLines: newCodeLines,
      selection: selection.copyWith(
        baseOffset: baseOffset,
        extentOffset: extentOffset,
      )
    );
  }

}

class _DefaultMultiLineCommentFormatter extends _DefaultCommentFormatter {

  const _DefaultMultiLineCommentFormatter(super.symbol);

  @override
  CodeLineEditingValue format(CodeLineEditingValue value, String indent) {
    final CodeLineSelection selection = value.selection;
    if (selection.isSameLine) {
      return _formatSelectedCodeLine(value, indent);
    } else {
      return _formatSelectedCodeLines(value, indent);
    }
  }

  CodeLineEditingValue _formatSelectedCodeLine(CodeLineEditingValue value, String indent) {
    // TODO
    return value;
  }

  CodeLineEditingValue _formatSelectedCodeLines(CodeLineEditingValue value, String indent) {
    // TODO
    return value;
  }

}