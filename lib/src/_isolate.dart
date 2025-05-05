part of 're_editor.dart';

typedef IsolateRunnable<Req, Res> = Res Function(Req req);
typedef IsolateCallback<Res> = void Function(Res res);

class _IsolateTasker<Req, Res> {
  _IsolateTasker(this.name, this.runnable) {
    _closed = false;
    // _isolateManager = IsolateManager.create(runnable);
  }
  final String name;
  late bool _closed;

  // late IsolateManager<Res, Req> _isolateManager;
  IsolateRunnable<Req, Res> runnable;

  Future<void> run(Req req, IsolateCallback<Res> callback) async {
    if (_closed) {
      return;
    }

    final duh = runnable(req);

    if (_closed) {
      return;
    }
    callback(duh);
  }

  void close() {
    _closed = true;
    // _isolateManager?.stop();
    // _isolateManager = null;
  }
}
