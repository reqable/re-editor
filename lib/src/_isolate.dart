part of 're_editor.dart';

typedef IsolateRunnable<Req, Res> = Res Function(Req req);
typedef IsolateCallback<Res> = void Function(Res res);

class _IsolateTasker<Req, Res> {
  _IsolateTasker(this.name, this.runnable) {
    _closed = false;
  }
  final String name;
  late bool _closed;
  IsolateRunnable<Req, Res> runnable;

  Future<void> run(Req req, IsolateCallback<Res> callback) async {
    if (_closed) {
      return;
    }
    final res = runnable(req);
    if (_closed) {
      return;
    }
    print('IsolateTasker: $name');
    callback(res);
  }

  void close() {
    _closed = true;
  }
}
