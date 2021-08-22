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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).colorScheme.secondaryVariant,
        selectedLabelStyle: Theme.of(context).textTheme.bodyText2,
        unselectedLabelStyle: Theme.of(context).textTheme.bodyText2,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            tooltip: '',
            activeIcon: Icon(CupertinoIcons.home, size: 24),
            icon: Icon(CupertinoIcons.home, size: 24),
          ),
          // BottomNavigationBarItem(
          //   label: 'Chat',
          //   tooltip: '',
          //   activeIcon: Icon(Iconsax.message2, size: 24),
          //   icon: Icon(Iconsax.message2, size: 24),
          // ),
          BottomNavigationBarItem(
            label: 'Journal',
            tooltip: '',
            activeIcon: Icon(CupertinoIcons.book_fill, size: 24),
            icon: Icon(CupertinoIcons.book_fill, size: 24),
          ),

          BottomNavigationBarItem(
            label: 'Profile',
            tooltip: '',
            activeIcon: Icon(CupertinoIcons.profile_circled, size: 24),
            icon: Icon(CupertinoIcons.profile_circled, size: 24),
          ),
        ],
      ),
    );
  }
}
