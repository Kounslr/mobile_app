import 'package:canton_design_system/canton_design_system.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final void Function(int) onTabTapped;

  const BottomNavBar(this.currentIndex, this.onTabTapped);
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondaryVariant,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onTabTapped,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).colorScheme.secondaryVariant,
        items: [
          BottomNavigationBarItem(
            tooltip: '',
            label: 'Home',
            icon: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconlyIcon(
                IconlyBold.Home,
                size: 24,
                color: widget.currentIndex == 0
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondaryVariant,
              ),
            ),
          ),
          BottomNavigationBarItem(
            tooltip: '',
            label: 'Journal',
            icon: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconlyIcon(
                IconlyBold.Edit,
                size: 24,
                color: widget.currentIndex == 1
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondaryVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
