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
import 'package:kounslr/src/config/bottom_navigation_bar.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/home_view/home_view.dart';
import 'package:kounslr/src/ui/views/journal_view/journal_view.dart';
import 'package:kounslr/src/ui/views/no_student_data_view.dart';
import 'package:kounslr/src/ui/views/profile_view/profile_view.dart';

final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _journalNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();

class CurrentView extends StatefulWidget {
  const CurrentView({Key? key}) : super(key: key);

  @override
  _CurrentViewState createState() => _CurrentViewState();
}

class _CurrentViewState extends State<CurrentView> {
  final user = FirebaseFirestore.instance
      .collection('customers')
      .doc('lcps')
      .collection('schools')
      .doc('independence')
      .collection('students');

  bool studentHasData = true;

  Future<void> _checkIfStudentIsSignedIntoStudentVue() async {
    var student = await user.doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (student.data() == null || student.data()!['studentId'] == null) {
      setState(() {
        studentHasData = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfStudentIsSignedIntoStudentVue();
  }

  int _currentIndex = 0;
  final List<Widget> _views = [
    const HomeView(),
    const JournalView(),
    const ProfileView(),
  ];

  void _onTabTapped(int index) {
    if (index == _currentIndex && _currentIndex == 0 && _homeNavigatorKey.currentState!.canPop()) {
      _homeNavigatorKey.currentState!.pop();
    }
    if (index == _currentIndex && _currentIndex == 1 && _journalNavigatorKey.currentState!.canPop()) {
      _journalNavigatorKey.currentState!.pop();
    }
    if (index == _currentIndex && _currentIndex == 2 && _profileNavigatorKey.currentState!.canPop()) {
      _profileNavigatorKey.currentState!.pop();
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return const CantonScaffold(
        body: SomethingWentWrong(),
      );
    }

    return CantonScaffold(
      padding: EdgeInsets.zero,
      // backgroundColor: CantonMethods.alternateCanvasColor(context),
      bottomNavBar: studentHasData ? BottomNavBar(_currentIndex, _onTabTapped) : null,
      body: !studentHasData
          ? const NoStudentDataView()
          : IndexedStack(
              index: _currentIndex,
              children: [
                Navigator(
                  key: _homeNavigatorKey,
                  observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())],
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      settings: settings,
                      fullscreenDialog: true,
                      builder: (context) => SafeArea(child: _views[_currentIndex]),
                    );
                  },
                ),
                Navigator(
                  key: _journalNavigatorKey,
                  observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())],
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      settings: settings,
                      fullscreenDialog: true,
                      builder: (context) => SafeArea(child: _views[_currentIndex]),
                    );
                  },
                ),
                Navigator(
                  key: _profileNavigatorKey,
                  observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())],
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      settings: settings,
                      fullscreenDialog: true,
                      builder: (context) => SafeArea(child: _views[_currentIndex]),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
