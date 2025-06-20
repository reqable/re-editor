import 'package:flutter/foundation.dart';

class ReEditor {
  ReEditor(this.foo, this.bar);

  final String foo;
  final String bar;

  void hello(String name) {
    if (kDebugMode) {
      print('hello $name');
    }
  }
}
