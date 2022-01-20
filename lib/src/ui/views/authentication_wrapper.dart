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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kounslr/src/providers/authentication_providers/authentication_stream_provider.dart';
import 'package:kounslr/src/ui/components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/authentication_views/sign_in_view/sign_in_view.dart';
import 'package:kounslr/src/ui/views/authentication_views/sign_up_view/sign_up_view.dart';
import 'package:kounslr/src/ui/views/current_view.dart';
import 'package:kounslr/src/ui/views/no_student_data_view/no_student_data_view.dart';

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool showSignIn = true;

  bool studentHasData = true;

  Future<bool> _checkIfStudentIsSignedIntoStudentVue() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final user = FirebaseFirestore.instance.doc('students/${FirebaseAuth.instance.currentUser!.uid}');
      var student = await user.get();

      if (!student.exists || [null, false].contains(student.data()!['hasData'])) {
        return false;
      }
      return true;
    }
    return false;
  }

  void _toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final _authState = watch(authenticationStreamProvider);

        return _authState.when(
          error: (e, s) {
            return const SomethingWentWrong();
          },
          loading: () => Loading(),
          data: (user) {
            if (user == null) {
              if (showSignIn) {
                return SignInView(toggleView: _toggleView);
              } else {
                return SignUpView(toggleView: _toggleView);
              }
            } else {
              return FutureBuilder<bool>(
                future: _checkIfStudentIsSignedIntoStudentVue(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) return CantonScaffold(body: Loading());

                  if (snapshot.data!) {
                    return const CurrentView();
                  }
                  return const NoStudentDataView();
                },
              );
            }
          },
        );
      },
    );
  }
}
