import 'dart:async';

/// Function def for functions that use the Flutter Bus
typedef FlutterBusFunction<T> = void Function(T);

/// A universal FlutterBus pub/sub for Flutter Apps.
/// Use like so
/// FlutterBus.on<Foo>(foo -> print(foo));
/// FlutterBus.fire(Foo());
///
class FlutterBus {
  // ignore: strict_raw_type
  static final StreamController _streamController =
      StreamController.broadcast();

  /// Publishes a new event on the event bus with the specified [event].
  static void publish(Object event) {
    _streamController.add(event);
  }

  /// Listens for events of Type [T] and its subtypes.
  ///
  /// The method is called like this:
  /// FlutterBus.on<MyType>((myInstance) -> print(myInstance));
  ///
  /// To listen to all events, call this method without a type parameter.
  ///
  /// The returned [StreamSubscription] must be used to unsubscribe when
  /// appropriate.
  ///
  /// Each listener is handled independently, and if they pause, only the
  /// pausing listener is affected. A paused listener will buffer events
  /// internally until unpaused or canceled. So it's usually better to just
  /// cancel and later subscribe again (avoids memory leak).
  static StreamSubscription<T> on<T>(void Function(T event) on) {
    final Stream<T> stream;
    if (T == dynamic) {
      stream = _streamController.stream as Stream<T>;
    } else {
      stream = _streamController.stream.where((event) => event is T).cast<T>();
    }
    return stream.listen(on);
  }

  /// Destroy this [FlutterBus]. This is generally only in a testing context.
  static void destroy() {
    _streamController.close();
  }
}
