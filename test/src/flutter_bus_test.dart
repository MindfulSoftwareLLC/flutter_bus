// ignore_for_file: prefer_const_constructors

import 'package:flutter_bus/flutter_bus.dart';
import 'package:flutter_test/flutter_test.dart';

class TestEvent {
  TestEvent(this.name);
  final String name;
}

void main() {
  group('FlutterBus', () {
    var timesCalled = 0;
    TestEvent? lastEvent;

    setUp(() {
      timesCalled = 0;
      lastEvent = null;
    });
    test('pub/sub works', () async {
      FlutterBus.on<TestEvent>((event) {
        timesCalled++;
        lastEvent = event;
      });
      expect(timesCalled, 0);
      FlutterBus.publish(TestEvent('1'));
      await expectLater(timesCalled, 0, reason: 'Not seen in test yet.');
      expect(timesCalled, 1, reason: 'Subscriber should have been called.');
      expect(lastEvent, isNotNull,
          reason: 'Subscriber should have a non-null event.');
      expect(lastEvent!.name, '1',
          reason: 'Subscriber should have been called with the name 1.');
    });
    test('pub/sub second event', () async {
      FlutterBus.on<TestEvent>((event) {
        timesCalled++;
        lastEvent = event;
      });
      expect(timesCalled, 0);
      FlutterBus.publish(TestEvent('2'));
      await expectLater(timesCalled, 0, reason: 'Not seen in test yet.');
      expect(timesCalled, 2, reason: 'Subscriber should have been called.');
      expect(lastEvent, isNotNull,
          reason: 'Subscriber should have a non-null event.');
      expect(lastEvent!.name, '2',
          reason: 'Subscriber should have been called with the name 2.');
    });
  });
}
