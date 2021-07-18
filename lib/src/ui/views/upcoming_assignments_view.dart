import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/ui/providers/student_assignments_provider.dart';
import 'package:kounslr/src/ui/providers/student_classes_stream_provider.dart';
import 'package:kounslr/src/ui/styled_components/assignment_card.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';

class UpcomingAssignmentView extends StatelessWidget {
  const UpcomingAssignmentView();

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final upcomingAssignmentsRepo =
            watch(upcomingAssignmentsFutureProvider);
        final classesRepo = watch(studentClassesFutureProvider);

        return classesRepo.when(
          error: (e, s) {
            return SomethingWentWrong();
          },
          loading: () => Loading(),
          data: (classes) {
            return upcomingAssignmentsRepo.when(
              loading: () => Loading(),
              error: (e, s) {
                return SomethingWentWrong();
              },
              data: (assignments) {
                return Column(
                  children: [
                    _header(context),
                    SizedBox(height: 10),
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
    return ViewHeaderTwo(
      title: 'Upcoming Assignments',
      backButton: true,
      isBackButtonClear: true,
    );
  }

  Widget _body(
      BuildContext context, List<Class> classes, List<Assignment> assignments) {
    return Expanded(
      child: ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          return AssignmentCard(
            classes
                .where((element) => element.id == assignments[index].classId)
                .toList()[0],
            assignments[index],
          );
        },
      ),
    );
  }
}
