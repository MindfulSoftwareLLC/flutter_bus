# Flutter Bus

FlutterBus is a static EventBus for Flutter apps. 

Brought you with :green_heart: love by [Mindful Software](https://mindfulsoftware.com)'s Michael Bushe :blue_heart:, the maker of the widely-used [Swing EventBus](https://repo1.maven.org/maven2/org/bushe/eventbus/1.4/).

<img src="https://user-images.githubusercontent.com/168178/224985990-480a1f94-d6dc-4382-acb0-da8ab11240bb.png"  width="151" height="142">

This is beta API, subject to change.  It's small and simple but
feedback is particularly welcome on a few issues:
1) Should initialData be a property of FlutterBusBuilder?
It's nice that it looks like FutureBuilder and sometimes you wish 
you had an initial event.  However "publishing" to one widget
goes against the pub/sub pattern.
2) Should a SteamSubscription be returned from on()?  It may
be too leaky but pause/resume/cancel are obviously useful.
Another smaller interface could be returned.
3) Subjects are often useful in EventBuses.  For example, it would
be nice to publish the ThemeChangedEvent on app start, replacing
the need for initialData in FlutterBusBuilder.  The event could
saved as the last event of that type and new subscribers can be
sent the previous value, that way the correct default theme could 
be set by the event, not the widget.

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

Two examples are provided examples in the /examples directory, 
the running demos are shown here.
1. FlutterBus counter


https://user-images.githubusercontent.com/168178/224986621-cc32d1a4-231b-40aa-a95d-1ca59092e944.mov

Notice how decoupled the CounterText is from the rest of the app.
It only has three imports:
import 'package:flutter/material.dart';
import 'package:flutter_bus/flutter_bus.dart';
import 'counter_increment_event.dart';

It knows the event it's interested in.  
It knows the FlutterBus.
It knows how to draw itseld in Material.
It doesn't know much and that's a great acheivement for a widget.

It doesn't need anything object provided to it.
It doesn't need a Locator.
The widget can be moved around without having to worry about 
which parents it has.

2. FlutterBus theme switcher

The second demo shows the usage of the FlutterBusBuilder.
FlutterBusBuilder builds a widget on each new publication of
an event of the interested type.

```
  @override
  Widget build(BuildContext context) {
    return FlutterBusBuilder<ThemeChangedEvent>(
      builder: (context, themeEvent) {
        //Since no initialData is supplied,
        // the event will be null for the first build() only
        ThemeData lightTheme;
        ThemeData darkTheme;
        if (themeEvent == null) {
          lightTheme = ThemeData.light();
          darkTheme = ThemeData.dark();
        } else {
          lightTheme = themeEvent.lightTheme;
          darkTheme = themeEvent.darkTheme;
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlutterBus ThemeChangedEvent Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const MyHomePage(title: 'FlutterBus ThemeChangedEvent Demo'),
        );
      },
    );
  }

```

https://user-images.githubusercontent.com/168178/224986921-ea6e1c4e-fa59-4312-9ee1-3de2835a59d2.mov



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
I stole the key one or two lines for FlutterBus from it.
