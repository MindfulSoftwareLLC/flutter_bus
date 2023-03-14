import 'package:flutter/material.dart';
import 'package:flutter_bus/flutter_bus.dart';

import 'counter_increment_event.dart';

/// This button shows an Add icon and the text Increment and
/// when clicked, publishes a CounterIncrementEvent on the FlutterBus.
class CounterIncrementEventButton extends StatelessWidget {
  const CounterIncrementEventButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => FlutterBus.publish(CounterIncrementEvent()),
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}
