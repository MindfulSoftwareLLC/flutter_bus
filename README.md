# Flutter Bus

FlutterBus is a single EventBus for Flutter apps. From the maker of the popular [Swing EventBus](https://repo1.maven.org/maven2/org/bushe/eventbus/1.4/).

## Examples

Somewhere deep in a service...
`
FlutterBus.publish(TickerUpdateEvent('GOOG', 91.66))
`

In the Widget Tree...

````
FlutterBusBuilder<TickerUpdateEvent>(
  builder: (context, tickerUpdateEvent) {
    return TickerWidget(tickerUpdateEvent.ticker, 
                       tickerUpdateEvent.price)};
}
````

Also see the two provided examples in the /examples directory.
1. FlutterBus counter


2. FlutterBus theme switcher


## Why FlutterBus?

Use FlutterBus to keep components decoupled.  The EventBus
pattern is common in UIs but perhaps not common enough.

There are other EventBus libraries for Dart and Flutter, why FlutterBus?
Pretty simply, because FlutterBus is one instance of a stream (a bus)
for a single Flutter app with a FlutterBusBuilder to help widgets use
the FlutterBus.  Other EventBus libraries are more general purpose and
not quite so simple.

Apply the FlutterBus pattern judiciously. It's not for everything 
(at least not without considerable thought and design).

FlutterBus is best used to encapsulate UI actions into an event API.
ThemeChangedEvent and CounterChangedEvent and are good examples.
ThemeChangedEvent is a widget-to-widget event, it encapsulates an UI API.
CounterChangedEvent is a "business logic" event - for the Counter app the
business is changing the counter.

There is just one stream for all events types, so it's quite efficient.

Consider architecting two streams for Events with two EventBuses.
1) Use FlutterBus for events going from Widget to Widget or UI Service to Widget.
2) Use [EventBus](https://pub.dev/packages/event_bus) or 
   [Dart Event Bus](https://github.com/marcojakob/dart-event-bus)
   for events going from UI service layer
   to the service layer from user interaction or network responses which .
   in turn uses the FlutterBus to announce changes.

These two buses are near exactly the same, the difference is merely that
FlutterBus is a single static bus accessible anywhere in a Flutter app.
It doesn't make sense to have two FlutterBus'es when there is on one UI
running in a process at once so FlutterBus is easier than provideing
the bus in a widget tree.

FlutterBus is terse and more fit to the purpose of Flutter apps:
Compare:
```
EventBus eventBus = (Provider provides it, GetIt gets it)
_themeStreamSub = eventBus.on<ThemeChangeEvent>().listen((event) {
```
With:
```
_themeStreamSub = FlutterBus.on<ThemeChangeEvent>((event) {
```

Kudos to [Dart Event Bus](https://github.com/marcojakob/dart-event-bus) since
I stole the key one or two lines for FLutterBus from it.