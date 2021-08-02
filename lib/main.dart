import 'package:canton_design_system/canton_design_system.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kounslr/src/config/constants.dart';
import 'package:kounslr/src/services/authentication/authentication_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  /// Lock screen orientation to vertical
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(Phoenix(child: ProviderScope(child: MyApp())));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return CantonApp(
          title: kAppTitle,
          primaryLightColor: CantonColors.orange,
          primaryDarkColor: CantonDarkColors.orange,
          primaryLightVariantColor: CantonColors.orange[400]!,
          primaryDarkVariantColor: CantonDarkColors.orange[400]!,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
          ],
          home: AuthenticationWrapper(),
        );
      },
    );
  }
}
