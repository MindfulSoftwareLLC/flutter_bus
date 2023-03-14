import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bus/flutter_bus.dart';

import 'counter_increment_event.dart';

class CounterText extends StatefulWidget {
  const CounterText({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return CounterTextState();
  }
}

class CounterTextState extends State<CounterText> {
  /// State is be better put in a service/riverpod, etc.,
  /// This is just a simple example. A real app would update the state
  /// from the click event and then send another event that
  /// the state was updated.
  int _counter = 0;

  /// Keep your subscription to cancel and avoid leaks.
  late StreamSubscription _subscription;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _subscription =
        FlutterBus.on<CounterIncrementEvent>((event) => _incrementCounter());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_counter',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
