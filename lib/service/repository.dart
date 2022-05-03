import 'dart:isolate';

import '../model/lattice.dart';

class Accumulator {
  final SendPort _sendPort;
  final ReceivePort _receivePort;
  final Lattice _lattice;


  Accumulator(this._sendPort)
      : _receivePort = ReceivePort(),
        _lattice = Lattice() {
    _receivePort.listen(_listen);
    _sendPort.send(_receivePort.sendPort);
    _sendPort.send({'size': _lattice.size});
  }

  static void start(dynamic message) {
    Accumulator(message as SendPort);
  }

  void _listen(dynamic message) {
    final Map<String, Object?> payload = message as Map<String, Object?>;
    if (payload.containsKey('seed')) {
      Point p = payload['seed'] as Point;
      _lattice.set(p.x, p.y);
      _sendPort.send({'point': p, 'mass': _lattice.mass});
    } else if (payload.containsKey('accumulate')) {
      _sendPort.send({'point': _lattice.accumulate(), 'mass': _lattice.mass});
    } else if (payload.containsKey('reset')) {
      _lattice.clear();
    }
  }
}