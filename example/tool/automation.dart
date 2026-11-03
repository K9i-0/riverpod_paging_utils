import 'dart:async';

import 'package:example/main.dart' as app;
import 'package:flutter/foundation.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

/// Starts the regular example with native debug-only automation extensions.
void main() {
  if (!kDebugMode || kIsWeb) {
    app.main();
    return;
  }

  final collector = PrintLogCollector();
  runZoned<void>(
    () {
      // The binding and runApp must be initialized in the same zone.
      MarionetteBinding.ensureInitialized(
        MarionetteConfiguration(
          logCollector: collector,
          enableSessionReports: true,
        ),
      );
      final previousErrorHandler = FlutterError.onError;
      FlutterError.onError = (details) {
        collector.addLog(
          '[FlutterError] ${details.exceptionAsString()}\n${details.stack ?? ''}',
        );
        previousErrorHandler?.call(details);
      };
      collector.addLog('Riverpod Paging Utils automation initialized.');
      app.main();
    },
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        collector.addLog(line);
        parent.print(zone, line);
      },
      handleUncaughtError: (self, parent, zone, error, stack) {
        collector.addLog('Uncaught error: $error\n$stack');
        parent.handleUncaughtError(zone, error, stack);
      },
    ),
  );
}
