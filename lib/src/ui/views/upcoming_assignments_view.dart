import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/providers/student_assignments_provider.dart';
import 'package:kounslr/src/providers/student_classes_future_provider.dart';
import 'package:kounslr/src/ui/styled_components/assignment_card.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';

class UpcomingAssignmentView extends StatelessWidget {
  const UpcomingAssignmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      padding: const EdgeInsets.all(0),
      backgroundColor: CantonMethods.alternateCanvasColor(context),
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final upcomingAssignmentsRepo = watch(upcomingAssignmentsStreamProvider);
        final classesRepo = watch(studentClassesStreamProvider);

        return classesRepo.when(
          error: (e, s) {
            return const SomethingWentWrong();
          },
          loading: () => Loading(),
          data: (classes) {
            return upcomingAssignmentsRepo.when(
              loading: () => Loading(),
              error: (e, s) {
                return const SomethingWentWrong();
              },
              data: (assignments) {
                return Column(
                  children: [
                    _header(context),
                    _body(context, classes, assignments),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: const ViewHeaderTwo(
        title: 'Upcoming Assignments',
        backButton: true,
        isBackButtonClear: true,
      ),
    );
  }

  Widget _body(BuildContext context, List<Class> classes, List<Assignment> assignments) {
    if (assignments.isEmpty || classes.isEmpty) {
      return Expanded(
        child: Text(
          'No Upcoming Assignments',
          style: Theme.of(context).textTheme.headline4?.copyWith(
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          assignments.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
          return AssignmentCard(
            classes.where((element) => element.id == assignments[index].classId).toList()[0],
            assignments[index],
          );
        },
      ),
    );
  }
}
