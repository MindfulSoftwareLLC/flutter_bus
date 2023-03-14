import 'package:flutter_bus/flutter_bus.dart';
import 'package:flutter_test/flutter_test.dart';

import 'counter_increment_event.dart';
import 'counter_text.dart';

void main() {
  testWidgets('FlutterBus works on widgets', (tester) async {
    await tester.pumpWidget(const CounterText());
    final counter0Finder = find.text('0');
    final counter1Finder = find.text('1');
    final counter2Finder = find.text('2');
    expect(counter0Finder, findsOneWidget);
    expect(counter1Finder, findsNothing);
    expect(counter2Finder, findsNothing);
    FlutterBus.publish(CounterIncrementEvent());
    await tester.pump();
    expect(counter0Finder, findsNothing);
    expect(counter1Finder, findsOneWidget);
    expect(counter2Finder, findsNothing);
    FlutterBus.publish(CounterIncrementEvent());
    await tester.pump(const Duration(microseconds: 1));
    expect(counter0Finder, findsNothing);
    expect(counter1Finder, findsNothing);
    expect(counter2Finder, findsOneWidget);
  });
}
