import 'dart:async';
import 'dart:isolate';

import '../model/lattice.dart';
import '../service/repository.dart';

class ViewModel {
  final StreamController<Point> _pointStreamController;
  final StreamController<int> _sizeStreamController;
  final StreamController<bool> _runningStreamController;
  final ReceivePort _receivePort;
  late final SendPort _sendPort;
  // ignore: unused_field
  late final Isolate _repository;

  late bool _running;

  Stream<Point> get pointStream => _pointStreamController.stream;

  Stream<int> get sizeStream => _sizeStreamController.stream;

  Stream<bool> get runningStream => _runningStreamController.stream;

  ViewModel()
      : _pointStreamController = StreamController<Point>(),
        _sizeStreamController = StreamController<int>(),
        _runningStreamController = StreamController<bool>(),
        _receivePort = ReceivePort() {
    _running = false;
    _receivePort.listen(_listen);
    Isolate.spawn(Accumulator.start, _receivePort.sendPort)
        .then((isolate) => _repository = isolate);
  }

  void reset() {
    _sendPort.send({'reset': null});
  }

  void seed(Point point) {
    _sendPort.send({'seed': point});
  }

  void pause() {
    _running = false;
    _runningStreamController.add(_running);
  }

  void resume() {
    _running = true;
    _runningStreamController.add(_running);
    accumulate();
  }

  void accumulate() {
    _sendPort.send({'accumulate': null});
  }

  void _listen(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
    } else if (message is Map<String, Object?>) {
      if (message.containsKey('size')) {
        _sizeStreamController.add(message['size'] as int);
      } else if (message.containsKey('point')) {
        Point? point = message['point'] as Point?;
        if (point != null) {
          _pointStreamController.add(point);
          if (_running) {
            accumulate();
          }
        } else {
          _running = false;
        }
      }
    }
  }
}
