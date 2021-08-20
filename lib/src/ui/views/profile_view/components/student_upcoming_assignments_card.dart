import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/ui/views/upcoming_assignments_view.dart';

class StudentUpcomingAssignmentsCard extends StatelessWidget {
  const StudentUpcomingAssignmentsCard(
      {required this.school, required this.student});

  final Student student;
  final School school;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CantonMethods.viewTransition(context, UpcomingAssignmentView());
      },
      child: Card(
        margin: EdgeInsets.zero,
        shape: SquircleBorder(
          radius: BorderRadius.vertical(
            bottom: Radius.circular(37),
          ),
          side: BorderSide(
            width: 0.5,
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Text(
                'Upcoming Assignments',
                style: Theme.of(context).textTheme.headline6,
              ),
              Spacer(),
              IconlyIcon(
                IconlyBold.Paper,
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
