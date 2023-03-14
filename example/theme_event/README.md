# FlutterBus ThemedChangedEvent Demo

This app demonstrated the use of FlutterBus and the FlutterBusBuilder
to change the theme of an app.  Note that the Text and the Main App 
are decoupled from each other and from an AppData or similar state
that's usually used in these cases, which tie the widget to the 
app.

The default theme is the Material default. When the FloatingActionButton 
is pressed, it cycles through three predefined themes and publishes 
a ThemeChangedEvent on the FlutterBus.

MyApp's FlutterBusBuilder subscribes to the ThemeChangedEvent and 
it's builder builds a new Material app with the new theme.
.
