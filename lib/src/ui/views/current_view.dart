import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/config/bottom_navigation_bar.dart';
import 'package:kounslr/src/ui/views/hall_pass_view.dart';
import 'package:kounslr/src/ui/views/home_view.dart';

class CurrentView extends StatefulWidget {
  @override
  _CurrentViewState createState() => _CurrentViewState();
}

class _CurrentViewState extends State<CurrentView> {
  int _currentIndex = 0;
  final List<Widget> _views = [
    HomeView(),
    HallPassView(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      bottomNavBar: BottomNavBar(_currentIndex, onTabTapped),
      body: _views[_currentIndex],
    );
  }
}
