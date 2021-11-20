import 'package:canton_design_system/canton_design_system.dart';

class ProfileViewHeader extends StatelessWidget {
  const ProfileViewHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 17),
      child: const ViewHeaderOne(
        title: 'Profile',
      ),
    );
  }
}
