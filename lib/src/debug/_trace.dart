part of re_editor;

class _Trace {

  static final Map<String, DateTime> _timestamps = {};

  static void begin(String name) {
    _timestamps[name] = DateTime.now();
  }

  static void end(String name, [bool microsecond = false]) {
    final DateTime? time = _timestamps.remove(name);
    if (time != null) {
      if (microsecond) {
        print('[${DateTime.now()}] $name costs ${DateTime.now().microsecondsSinceEpoch - time.microsecondsSinceEpoch} us');
      } else {
        print('[${DateTime.now()}] $name costs ${DateTime.now().millisecondsSinceEpoch - time.millisecondsSinceEpoch} ms');
      }
    }
  }

}