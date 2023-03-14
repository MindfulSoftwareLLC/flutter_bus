import 'package:flutter/material.dart';
import 'package:flutter_bus/flutter_bus.dart';

import 'theme_changed_event.dart';

/// A decoupled widget that knows how to rebuild itself
/// when a ThemeChangedEvent is published on the FlutterBus
class CurrentThemeText extends StatelessWidget {
  const CurrentThemeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterBusBuilder<ThemeChangedEvent>(builder: (context, themeEvent) {
      if (themeEvent == null) {
        ///only on the initial build since no initialData is provided
        return const Text('');
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Theme ${themeEvent.themeName}'),
          ],
        );
      }
    });
  }
}
