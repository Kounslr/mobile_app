/*
Kounslr iOS & Android App
Copyright (C) 2021 Kounslr

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/providers/student_assignments_provider.dart';
import 'package:kounslr/src/providers/student_classes_stream_provider.dart';
import 'package:kounslr/src/ui/components/assignment_card.dart';
import 'package:kounslr/src/ui/components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/upcoming_assignments_view/components/upcoming_assignments_view_header.dart';

class UpcomingAssignmentView extends StatelessWidget {
  const UpcomingAssignmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      padding: const EdgeInsets.all(0),
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
                    const UpcomingAssignmentsViewHeader(),
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

          BorderRadius radiiByIndex() {
            if (assignments.length == 1) {
              return BorderRadius.circular(37);
            } else if (assignments.length == 2) {
              if (index == 0) {
                return const BorderRadius.vertical(top: Radius.circular(37));
              } else {
                return const BorderRadius.vertical(bottom: Radius.circular(37));
              }
            } else {
              if (index == 0) {
                return const BorderRadius.vertical(top: Radius.circular(37));
              } else if (index == assignments.length - 1) {
                return const BorderRadius.vertical(bottom: Radius.circular(37));
              } else {
                return BorderRadius.zero;
              }
            }
          }

          return Column(
            children: [
              AssignmentCard(
                classes.where((element) => element.id == assignments[index].classId).toList()[0],
                assignments[index],
                radius: radiiByIndex(),
              ),
              index != assignments.length - 1
                  ? Container(padding: const EdgeInsets.symmetric(horizontal: 17), child: const Divider())
                  : Container(),
              index == assignments.length - 1 ? const SizedBox(height: 17) : Container(),
            ],
          );
        },
      ),
    );
  }
}
