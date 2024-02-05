part of re_editor;

typedef IsolateRunnable<Req, Res> = Res Function(Req req);
typedef IsolateCallback<Res> = void Function(Res res);

class _IsolateTasker<Req, Res> {

  final String name;
  final ReceivePort _receivePort;
  late bool _closed;

  Isolate? _isolate;
  int _receivedMessageIndex;
  int _sentMessageIndex;
  SendPort? _sendPort;
  late List<_IsolateTask<Req, Res>> _taskQueue;

  _IsolateTasker(this.name, IsolateRunnable<Req, Res> runnable) :
    _receivePort = ReceivePort(name),
    _receivedMessageIndex = -1,
    _sentMessageIndex = 0 {
    _closed = false;
    _receivePort.listen((message) {
      _receivedMessageIndex++;
      if (_receivedMessageIndex == 0) {
        _sendPort = message;
        _runTaskQueue();
      } else {
        final int taskIndex = _taskQueue.indexWhere((element) => element.id == message.id);
        if (taskIndex < 0) {
          return;
        }
        final _IsolateTask<Req, Res> task = _taskQueue.removeAt(taskIndex);
        task.callback(message.response);
      }
    });
    _taskQueue = [];
    final _IsolateInitMessage<Req, Res> message = _IsolateInitMessage<Req, Res>(_receivePort.sendPort, runnable);
    Isolate.spawn<_IsolateInitMessage<Req, Res>>(_run, message).then((value) {
      _isolate = value;
    });
  }

  void run(Req req, IsolateCallback<Res> callback) async {
    if (_closed) {
      return;
    }
    _sentMessageIndex++;
    final _IsolateTask<Req, Res> task = _IsolateTask(
      _IsolateTaskRequestMessage<Req, Res>(_sentMessageIndex, req),
      callback
    );
    _taskQueue.add(task);
    if (_sendPort == null) {
      return;
    }
    _sendPort!.send(task.request);
  }

  void close() {
    _closed = true;
    _receivePort.close();
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _taskQueue.clear();
  }

  void _runTaskQueue() {
    for (final _IsolateTask<Req, Res> task in _taskQueue) {
      _sendPort!.send(task.request);
    }
  }

  static void _run<Req, Res>(_IsolateInitMessage<Req, Res> message) {
    final ReceivePort receivePort = ReceivePort();
    message.port.send(receivePort.sendPort);
    receivePort.listen((task) {
      message.port.send(_IsolateTaskResponseMessage(task.id, message.runnable(task.request)));
    });
  }

}

class _IsolateTask<Req, Res> {
  final _IsolateTaskRequestMessage<Req, Res> request;
  final IsolateCallback<Res> callback;

  _IsolateTask(this.request, this.callback);

  int get id => request.id;
}

class _IsolateTaskRequestMessage<Req, Res> {
  final int id;
  final Req request;

  const _IsolateTaskRequestMessage(this.id, this.request);
}

class _IsolateTaskResponseMessage<Res> {
  final int id;
  final Res response;

  const _IsolateTaskResponseMessage(this.id, this.response);
}

class _IsolateInitMessage<Req, Res> {

  final SendPort port;
  final IsolateRunnable<Req, Res> runnable;

  const _IsolateInitMessage(this.port, this.runnable);

}