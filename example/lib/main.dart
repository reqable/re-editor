import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:re_editor_exmaple/editor_autocomplete.dart';
import 'package:re_editor_exmaple/editor_basic_field.dart';
import 'package:re_editor_exmaple/editor_json.dart';
import 'package:re_editor_exmaple/editor_large_text.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Re-Editor',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 255, 140, 0),
        )
      ),
      home: const MyHomePage(title: 'Re-Editor Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const Map<String, Widget> _editors = {
    'Basic Field': BasicField(),
    'Json Editor': JsonEditor(),
    'Auto Complete': AutoCompleteEditor(),
    'Large Text': LargeTextEditor(),
    'Native Context Menu': NativeContextMenuExamplePage(),
  };

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final Widget child = _editors.values.elementAt(_index);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _editors.entries.mapIndexed((index, entry) {
                  return TextButton(
                    onPressed: () {
                      setState(() {
                        _index = index;
                      });
                    },
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: _index == index ? null : Colors.black
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey
                  )
                ),
                child: child,
              )
            )
          ],
        )
      ),
    );
  }
}

class NativeContextMenuExamplePage extends StatelessWidget {
  const NativeContextMenuExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CodeEditor(
      controller: CodeLineEditingController.fromText(
        '''
Press and hold (or right-click) to see the native context menu.
This example demonstrates the useNativeContextMenu: true feature.

Try selecting some text:
- Cut
- Copy
- Paste
        '''
      ),
      useNativeContextMenu: true,
      wordWrap: true, // Enable word wrap for better readability of sample text
    );
  }
}