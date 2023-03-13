import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bus/flutter_bus.dart';

/// Signature for strategies that build widgets based on FlutterBus data.
/// The widget gets the build context and the lastEvent published on the
/// FlutterBus.
/// The first build will use the builders' initialData and only for the
/// initialData can the event be null since initialData is not required.
typedef FlutterBusWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T? event,
);

/// Widget that builds itself based on the latest typed event published on
/// the [FlutterBus].
///
class FlutterBusBuilder<T> extends StatefulWidget {
  /// Creates a widget that builds itself based on the latest event
  /// published on the [FlutterBus].
  ///
  /// The [builder] must not be null.
  const FlutterBusBuilder({
    required this.builder,
    this.initialData,
    super.key,
  });

  /// The initial data for this widget.  It's like faking a publish
  /// but onbly to this widget.
  final T? initialData;

  /// The build strategy currently used by this builder.
  ///
  /// The builder is provided with an object published on the FlutterBus and
  /// must return a widget.
  ///
  /// This builder must only return a widget and should not have any side
  /// effects as it may be called multiple times.
  final FlutterBusWidgetBuilder<T> builder;

  @override
  State<StatefulWidget> createState() {
    return FlutterBusBuilderState<T>();
  }
}

/// State class to manager the FlutterBus subscription for a widget
class FlutterBusBuilderState<T> extends State<FlutterBusBuilder<T>> {
  /// Initially widget.initialData, then set to the last value published
  /// on the FlutterBus for type Ts
  T? lastEvent;

  /// The FlutterBus subscription to manage
  late StreamSubscription<T> eventStreamSubscription;

  @override
  void initState() {
    super.initState();
    lastEvent = widget.initialData;
    eventStreamSubscription =
        FlutterBus.on<T>((event) => {setState(() => lastEvent = event)});
  }

  @override
  void activate() {
    super.activate();
    eventStreamSubscription.resume();
  }

  @override
  void deactivate() {
    super.deactivate();
    eventStreamSubscription.pause();
  }

  @override
  void dispose() {
    super.dispose();
    eventStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, lastEvent);
  }
}
