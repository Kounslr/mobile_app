import 'package:canton_design_system/canton_design_system.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/config/constants.dart';
import 'package:kounslr/src/services/authentication/authentication_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  /// Lock screen orientation to vertical
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(ProviderScope(child: MyApp()));
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
          primaryLightVariantColor: CantonColors.orange[400],
          primaryDarkVariantColor: CantonDarkColors.orange[400],
          home: AuthenticationWrapper(),
        );
      },
    );
  }
}
