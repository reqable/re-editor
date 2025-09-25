# Re-Editor

[![latest version](https://img.shields.io/pub/v/re_editor.svg?color=blue)](https://pub.dev/packages/re_editor)

`Re-Editor`是一个强大的轻量级文本和代码编辑器组件，是[Reqable](https://reqable.com)项目中的一个模块。`Re-Editor`既可以作为一个简单文本输入组件，也可以用来开发一个功能复杂的代码编辑器。和Flutter官方默认的`TextField`组件不一样的是，`Re-Editor`是专为多行文本的显示和输入量身定制，具备下面这些特性：

- 横向和纵向双向滚动。
- 文本语法高亮。
- 内容折叠和展开。
- 输入提示和自动补全。
- 搜索替换功能。
- 自定义上下文菜单。
- 快捷键支持。
- 大文本显示和编辑。
- 显示行号和焦点行。
- 智能输入。

`Re-Editor`并非基于`TextField`进行二次封装，而是自行实现了各项元素的布局、绘制、事件处理等，针对大文本进行了特定优化，因此具备极高的性能，同时解决了`TextField`的各项痛点。

`Re-Editor`提供了非常大的自由度，例如开发者可以控制是否横行滚动（Word Wrap），是否只读，是否显示行号，是否显示分析内容折叠，自定义快捷键，指定文本高亮语法等等。

您可以运行`example`项目进行体验各项功能。

![](arts/art01.gif)

## 开始使用

添加依赖到 `pubspec.yaml`.

```yaml
dependencies:
  re_editor: ^0.8.0
```

和`TextField`一样，`Re-Editor`使用`CodeLineEditingController`作为控制器，下面的示例代码创建了一个最简单的编辑器组件，在显示样式上和`TextField`并没有什么太大的区别。
```dart
Widget build(BuildContext context) {
  return CodeEditor(
    controller: CodeLineEditingController.fromText('Hello Reqable'),
  );
}
```

### 文本高亮

`Re-Editor`的文本高亮是基于[Re-Highlight](https://github.com/reqable/re-highlight)实现，支持近百种语言和主题样式，开发者可以自由选择并配置代码高亮。下面的代码就指定了`JSON`语法高亮规则以及应用了`Atom One Light`代码配色。
```dart
CodeEditor(
  style: CodeEditorStyle(
    codeTheme: CodeHighlightTheme(
      languages: {
        'json': CodeHighlightThemeMode(
          mode: langJson
        )
      },
      theme: atomOneLightTheme
    ),
  ),
);
```

### 行号以及折叠/展开标记

`Re-Editor`支持配置是否显示代码行号和代码折叠标记，也可以由开发者自行实现显示样式和排版。下面的示例代码显示了默认的样式，通过`indicatorBuilder`来构建。
```dart
CodeEditor(
  indicatorBuilder: (context, editingController, chunkController, notifier) {
    return Row(
      children: [
        DefaultCodeLineNumber(
          controller: editingController,
          notifier: notifier,
        ),
        DefaultCodeChunkIndicator(
          width: 20,
          controller: chunkController,
          notifier: notifier
        )
      ],
    );
  },
);
```

### 代码折叠展开检测

默认情况下，`Re-Editor`会自动检测`{}`和`[]`的折叠区域，开发者可以控制是否检测，也可以自行编写检测规则。`DefaultCodeChunkAnalyzer`是默认的检测器，如果希望禁用检测，可以使用`NonCodeChunkAnalyzer`。
```dart
CodeEditor(
  chunkAnalyzer: DefaultCodeChunkAnalyzer(),
);

```

如果希望自定义，实现`CodeChunkAnalyzer`接口即可。

```dart
abstract class CodeChunkAnalyzer {

  List<CodeChunk> run(CodeLines codeLines);

}
```

### 滚动控制

`Re-Editor`支持双向滚动，因此使用了两个`ScrollController`，开发者可以用`CodeScrollController`进行构造。
```dart
CodeEditor(
  scrollController: CodeScrollController(
    verticalScroller: ScrollController(),
    horizontalScroller: ScrollController(),
  )
);
```

### 搜索和替换

`Re-Editor`实现了持搜索和替换逻辑，但是并没有提供默认的样式。开发者需要根据自己项目的实际情况编写搜索面板的UI，使用`findBuilder`属性来设置自己实现的搜索和替换UI。

```dart
CodeEditor(
  findBuilder: (context, controller, readOnly) => CodeFindPanelView(controller: controller, readOnly: readOnly),
);
```

上面示例中的`CodeFindPanelView`由开发者自己实现，详细实现过程可以参考`example`中的代码。

### 上下文菜单

`Re-Editor`实现了桌面端右键菜单和移动端长按选中菜单的控制逻辑，但是并没有提供默认的样式。开发者需要实现`SelectionToolbarController`接口，并通过`toolbarController`进行配置。

```dart
CodeEditor(
  toolbarController: _MyToolbarController(),
);
```

### 快捷键

`Re-Editor`内置了默认的快捷键功能，开发者也可以使用`shortcutsActivatorsBuilder`来设置自定义的快捷热键。当然，快捷键功能仅在桌面端有效。

`Re-Editor`支持的快捷键功能如下：
- 全选（Control/Command + A）
- 剪切选中/当前行（Control/Command + V）
- 复制选中/当前行（Control/Command + C）
- 粘贴（Control/Command + V）
- 撤销（Control/Command + Z）
- 重做（Shift + Control/Command + Z）
- 选中当前行（Control/Command + L）
- 删除当前行（Control/Command + D）
- 移动当前行（Alt + ↑/↓）
- 连续选择（Shift + ↑/↓/←/→）
- 移动光标（↑/↓/←/→）
- 移动光标（单词边界） (Alt + ←/→)
- 移动到页首/页尾（Control/Command + ↑/↓）
- 缩进（Tab）
- 取消缩进（Shift + Tab）
- 注释/取消单行注释（Control/Command + /）
- 注释/取消多行注释（Shift + Control/Command + /）
- 字符转换（Control/Command + T）
- 搜索（Control/Command + F）
- 替换（Alt + Control/Command + F）
- 保存（Control/Command + S）

### 代码提示和补全

`Re-Editor`支持使用`CodeAutocomplete`组件来实现代码输入提示和自动补全。`Re-Editor`实现了基本的控制逻辑，但是代码提示内容、自动补全规则和显示样式需要由开发者来自行定义。

```dart
CodeAutocomplete(
  viewBuilder: (context, notifier, onSelected) {
    // 创建代码提示View
  },
  promptsBuilder: DefaultCodeAutocompletePromptsBuilder(
    language: langDart,
  ),
  child: CodeEditor()
);
```

注意，`Re-Editor`只是一个轻量级的编辑器，不具备IDE动态语法分析功能，因此代码提示和补全功能存在较多的局限性。您可以参考`example`中的代码实现一个简单的代码提示和补全功能。

## 实现范例

`Re-Editor`在Reqable项目中有着深度实践，欢迎下载 [Reqable](https://reqable.com/download) 进行体验。

![](arts/art02.png)

## 许可证

MIT License

## 赞助

如果您希望赞助本项目，可以通过购买[Reqable](https://reqable.com/pricing)的许可证来赞助我们。