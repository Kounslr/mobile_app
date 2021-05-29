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
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTabTapped,
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconlyIcon(
              IconlyBold.Home,
              size: 24,
              color: widget.currentIndex == 0
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.secondary,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconlyIcon(
              IconlyBold.Ticket,
              size: 24,
              color: widget.currentIndex == 1
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.secondary,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconlyIcon(
              IconlyBold.Edit,
              size: 24,
              color: widget.currentIndex == 2
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.secondary,
            ),
          ),
          label: '',
        ),
      ],
    );
  }
}
