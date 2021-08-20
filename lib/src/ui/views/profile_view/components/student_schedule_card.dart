import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/ui/views/schedule_view.dart';

class StudentScheduleCard extends StatelessWidget {
  const StudentScheduleCard({required this.school, required this.student});

  final Student student;
  final School school;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CantonMethods.viewTransition(context, ScheduleView());
      },
      child: Card(
        margin: EdgeInsets.zero,
        shape: Border(
          left: BorderSide(
            width: 0.5,
            color: Theme.of(context).dividerColor,
          ),
          right: BorderSide(
            width: 0.5,
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Text(
                'Schedule',
                style: Theme.of(context).textTheme.headline6,
              ),
              Spacer(),
              IconlyIcon(
                IconlyBold.Calendar,
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
