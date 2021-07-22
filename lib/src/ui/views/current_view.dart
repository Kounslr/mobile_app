import 'package:canton_design_system/canton_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kounslr/src/config/bottom_navigation_bar.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/chat_view.dart';
import 'package:kounslr/src/ui/views/hall_pass_view.dart';
import 'package:kounslr/src/ui/views/home_view.dart';
import 'package:kounslr/src/ui/views/journal_view.dart';

class CurrentView extends StatefulWidget {
  @override
  _CurrentViewState createState() => _CurrentViewState();
}

class _CurrentViewState extends State<CurrentView> {
  int _currentIndex = 0;
  final List<Widget> _views = [
    HomeView(),
    HallPassView(),
    ChatView(),
    JournalView(),
  ];

  void onTabTapped(int index) {
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
      bottomNavBar: BottomNavBar(_currentIndex, onTabTapped),
      body: _views[_currentIndex],
    );
  }
}
