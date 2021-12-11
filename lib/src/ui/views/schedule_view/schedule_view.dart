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

import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/providers/school_blocks_future_provider.dart';
import 'package:kounslr/src/providers/school_repository_provider.dart';
import 'package:kounslr/src/providers/student_classes_stream_provider.dart';
import 'package:kounslr/src/ui/components/class_card.dart';
import 'package:kounslr/src/ui/components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/schedule_view/components/schedule_view_header.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      padding: EdgeInsets.zero,
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        const ScheduleViewHeader(),
        const SizedBox(height: 10),
        _body(context),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final studentClassesRepo = watch(studentClassesStreamProvider);
        final schoolBlocksRepo = watch(schoolBlocksFutureProvider);
        var futureIsDone = false;

        return studentClassesRepo.when(
          loading: () => Loading(),
          error: (e, s) {
            return const SomethingWentWrong();
          },
          data: (classes) {
            if (classes.isEmpty) {
              return Expanded(
                child: Text(
                  'No Classes',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Theme.of(context).colorScheme.secondaryVariant,
                      ),
                ),
              );
            }
            return schoolBlocksRepo.when(
              loading: () => Loading(),
              error: (e, s) {
                return const SomethingWentWrong();
              },
              data: (blocks) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: blocks.length,
                    itemBuilder: (context, index) {
                      var getTeacherFuture = context.read(schoolRepositoryProvider).getTeacherByTeacherId(
                            classes[blocks[index].period! - 1].teacherId!,
                          );
                      final stopwatch = Stopwatch()..start();
                      return FutureBuilder<StaffMember>(
                        future: getTeacherFuture,
                        builder: (context, teacherSnapshot) {
                          futureIsDone = teacherSnapshot.data != null;
                          if (!futureIsDone && stopwatch.elapsed.inMilliseconds > 1500) {
                            return Loading();
                          } else if (!futureIsDone) {
                            return Container();
                          } else if (futureIsDone && index == 0 && classes.isEmpty) {
                            return Center(
                              child: Text(
                                'No Classes',
                                style: Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Theme.of(context).colorScheme.secondaryVariant,
                                    ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              ClassCard(
                                schoolClass: classes[blocks[index].period! - 1],
                                block: blocks[index],
                                teacher: teacherSnapshot.data!,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
