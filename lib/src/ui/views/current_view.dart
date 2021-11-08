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
    HomeView(),
    JournalView(),
    ProfileView(),
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
      return CantonScaffold(
        body: SomethingWentWrong(),
      );
    }

    return CantonScaffold(
      padding: EdgeInsets.zero,
      backgroundColor: CantonMethods.alternateCanvasColor(context, index: _currentIndex, targetIndexes: [0]),
      bottomNavBar: studentHasData ? BottomNavBar(_currentIndex, _onTabTapped) : null,
      body: !studentHasData
          ? NoStudentDataView()
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
