part of re_editor;

typedef IsolateRunnable<Req, Res> = Res Function(Req req);
typedef IsolateCallback<Res> = void Function(Res res);

class _IsolateTasker<Req, Res> {
  final String name;
  late bool _closed;

  late IsolateManager<Res, Req>? _isolateManager;

  _IsolateTasker(this.name, IsolateRunnable<Req, Res> runnable) {
    _closed = false;
    _isolateManager = IsolateManager.create(
      runnable,
      concurrent: 1, // one is enough
    );
  }

  void run(Req req, IsolateCallback<Res> callback) async {
    if (_closed) {
      return;
    }
    try {
      _isolateManager?.compute(req, callback: (message) async {
        callback(message);
        return true;
      });
    } catch (e) {
      print("线程提交出错：${e}");
    }
  }

  void close() {
    _closed = true;
    _isolateManager?.stop();
    _isolateManager = null;
  }
}
