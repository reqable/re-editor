part of re_editor;

typedef IsolateRunnable<Req, Res> = Res Function(Req req);
typedef IsolateCallback<Res> = void Function(Res res);

class _IsolateTasker<Req, Res> {
  final String name;
  late bool _closed;

  late IsolateManager<Res, Req>? _isolateManager;

  final _controller = StreamController<(String, Res)>.broadcast();
  Stream<(String, Res)> get resultStream => _controller.stream;

  _IsolateTasker(this.name, IsolateRunnable<Req, Res> runnable) {
    _closed = false;
    _isolateManager = IsolateManager.create(
      runnable,
      concurrent: 1, // one is enough
    );
  }

  void run1(Req req, IsolateCallback<Res> callback) async {
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

  void run(Req req, String name) async {
    if (_closed) {
      return;
    }
    try {
      _isolateManager?.compute(req, callback: (message) async {
        if (!_controller.isClosed) {
          _controller.add((name, message));
          return true;
        }

        return false;
      });
    } catch (e) {
      print("线程提交出错：$e");
      _controller.addError(e);
    }
  }

  void close() {
    _closed = true;
    _controller.close();
    _isolateManager?.stop();
    _isolateManager = null;
  }
}
