import 'dart:async';
import 'package:flutter/material.dart';
import 'package:game/resource_manager.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int _counter = 0;
  late Timer _timer;
  bool _isRunning = true;
  final _timeoutMilis = 1000;
  late ResourseManager _resourceManager;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _revertRunning() {
    setState(() {
      _isRunning = !_isRunning;
      if (!_isRunning) {
        _timer.cancel();
      } else {
        _timer = scheduleTimeout(_timeoutMilis);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _resourceManager = ResourseManager();
    _timer = scheduleTimeout(_timeoutMilis);
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  Timer scheduleTimeout([int milis = 1000]) {
    Duration oneSec = Duration(milliseconds: milis);
    return Timer.periodic(oneSec, _handleTimeout);
  }

  void _handleTimeout(Timer timer) {
    _incrementCounter();
    Resource? iron = _resourceManager.getResource('iron-ore');
    iron?.add(1);

    int irons = iron?.quantity ?? 0;
    if (irons > 5) {
      iron?.use(5);
      _resourceManager.getResource('iron-ingot')?.add(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have achieved',
          ),
          Text(
            '$_counter points ${_resourceManager.getResource('iron-ingot')?.quantity}',
            style: Theme.of(context).textTheme.headline4,
          ),
          TextButton(
            onPressed: _revertRunning,
            child: Text(
              _isRunning ? 'Pause' : 'Resume',
              style: const TextStyle(color: Colors.red),
            ),
          ),
          Column(
            children: _resourceManager.resources.values.map((resource) {
              return Row(
                children: <Widget>[
                  Text(
                    resource.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    '${resource.quantity}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
