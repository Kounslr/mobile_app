import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/ui/providers/school_blocks_future_provider.dart';
import 'package:kounslr/src/ui/providers/school_repository_provider.dart';
import 'package:kounslr/src/ui/providers/student_classes_future_provider.dart';
import 'package:kounslr/src/ui/styled_components/class_card.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView();

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
        _header(context),
        const SizedBox(height: 10),
        _body(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: ViewHeaderTwo(
        title: 'Schedule',
        backButton: true,
        isBackButtonClear: true,
      ),
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
            return SomethingWentWrong();
          },
          data: (classes) {
            if (classes.length <= 0) {
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
                return SomethingWentWrong();
              },
              data: (blocks) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: blocks.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<StaffMember>(
                        future: context
                            .read(schoolRepositoryProvider)
                            .getTeacherByTeacherId(
                              classes[blocks[index].period! - 1].teacherId!,
                            ),
                        builder: (context, teacherSnapshot) {
                          futureIsDone = teacherSnapshot.data != null;
                          if (!futureIsDone && index == 0) {
                            return Loading();
                          } else if (!futureIsDone && index != 0) {
                            return Container();
                          } else if (futureIsDone &&
                              index == 0 &&
                              classes.length <= 0) {
                            return Center(
                              child: Text(
                                'No Classes',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryVariant,
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
                              if (index == blocks.length - 1) Divider(),
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
