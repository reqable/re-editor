import 'package:flutter/foundation.dart';

class ReEditor {

  final String foo;
  final String bar;

  ReEditor(this.foo, this.bar);

  void hello(String name) {
    if (kDebugMode) {
      print('hello $name');
    }
  }

}