import 'package:kounslr_design_system/kounslr_design_system.dart';

class UpcomingAssignmentsViewHeader extends StatelessWidget {
  const UpcomingAssignmentsViewHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: const ViewHeaderTwo(
        title: 'Upcoming Assignments',
        backButton: true,
        isBackButtonClear: true,
      ),
    );
  }
}
