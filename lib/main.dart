/*
Kounslr iOS & Android App
Copyright (C) 2021 Kounslr

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kounslr/src/config/constants.dart';
import 'package:kounslr/src/services/authentication/authentication_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  /// Comment this line out in production
  /// or when merging to [master]
  // await _useLocalEmulator();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  /// Lock screen orientation to vertical
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(Phoenix(child: const ProviderScope(child: MyApp())));
  });
}

// ignore: unused_element
Future<void> _useLocalEmulator() async {
  var host = 'localhost';
  var firestorePort = 8080;
  var authPort = 9099;

  await FirebaseAuth.instance.useAuthEmulator(host, authPort);
  FirebaseFirestore.instance.useFirestoreEmulator(host, firestorePort);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return CantonApp(
          title: kAppTitle,
          primaryLightColor: CantonColors.orange[500],
          primaryDarkColor: CupertinoColors.systemOrange,
          primaryLightVariantColor: CantonColors.orange[300]!,
          primaryDarkVariantColor: CantonDarkColors.orange[200]!,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
          ],
          home: const AuthenticationWrapper(),
        );
      },
    );
  }
}
