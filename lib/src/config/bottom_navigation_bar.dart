import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';

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
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTabTapped,
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.secondaryVariant,
      selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor, size: 24),
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          tooltip: '',
          activeIcon: Icon(Iconsax.home, size: 24),
          icon: Icon(Iconsax.home, size: 24),
        ),
        BottomNavigationBarItem(
          label: 'Journal',
          tooltip: '',
          activeIcon: Icon(Iconsax.book, size: 24),
          icon: Icon(Iconsax.book, size: 24),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          tooltip: '',
          activeIcon: Icon(Iconsax.user, size: 24),
          icon: Icon(Iconsax.user, size: 24),
        ),
      ],
    );
  }
}
