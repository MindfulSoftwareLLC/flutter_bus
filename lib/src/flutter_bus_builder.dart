import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bus/flutter_bus.dart';

class FlutterBusBuilder<T> extends StatefulWidget {
  FlutterBusBuilder({
    required this.child,
    required this.on,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final void Function(T) on;
  late StreamSubscription<T> eventStreamSubscription;
  //
  // Type get eventType => T.runtimeType;

  @override
  State<StatefulWidget> createState() {
    return FlutterBusBuilderState<T>();
  }
}

class FlutterBusBuilderState<T> extends State<FlutterBusBuilder> {
  @override
  void initState() {
    super.initState();
    widget.eventStreamSubscription = FlutterBus.on<T>(widget.on);
  }

  @override
  void activate() {
    super.activate();
    widget.eventStreamSubscription.resume();
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.eventStreamSubscription.pause();
  }

  @override
  void dispose() {
    super.dispose();
    widget.eventStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
