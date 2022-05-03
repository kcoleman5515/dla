import 'package:flutter/material.dart';
import '../viewmodel/lattice_viewmodel.dart';
import '../model/lattice.dart';

class DlaHomePage extends StatefulWidget {
  const DlaHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<DlaHomePage> createState() => _DlaHomePageState();
}

class _DlaHomePageState extends State<DlaHomePage> {
  final ViewModel _viewModel = ViewModel();
  late final Stream<bool> _runningStream;
  late final Stream<int> _sizeStream;

  bool _running = false;

  _DlaHomePageState() {
    _sizeStream = _viewModel.sizeStream;
    _sizeStream.listen((event) => _viewModel.seed(Point(124, 124)));
    _runningStream = _viewModel.runningStream;
    _runningStream.listen((event) {
      if (event) {
        _resume();
      } else {
        _pause();
      }
    });
  }

  void _resume() {
    setState(() => _running = true);
  }

  void _pause() {
    setState(() => _running = false);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          if (!_running)
            IconButton(
              icon: const Icon(Icons.restart_alt),
              onPressed: () {},
              tooltip: 'Clear aggregate & seed points',
            ),
          if (!_running)
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: _viewModel.resume,
              tooltip: 'Begin or resume accumulation of the aggregate',
            )
          else
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: _viewModel.pause,
              tooltip: 'Pause accumulation of the aggregate',
            )
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: StreamBuilder<Point>(
          stream: _viewModel.pointStream,
          builder: (context, event) {
            Point p = event.data as Point;
            return Text(
              '[${p.x}, ${p.y}]'
            );
          }
        ),
      ),
    );
  }
}
