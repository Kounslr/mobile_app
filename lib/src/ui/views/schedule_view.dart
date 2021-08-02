import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/ui/providers/school_repository_provider.dart';
import 'package:kounslr/src/ui/providers/student_classes_future_provider.dart';
import 'package:kounslr/src/ui/styled_components/class_card.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView();

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        _header(context),
        SizedBox(height: 10),
        _body(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return ViewHeaderTwo(
      title: 'Schedule',
      backButton: true,
      isBackButtonClear: true,
    );
  }

  Widget _body(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final studentClassesRepo = watch(studentClassesStreamProvider);
        var futuresAreDone = false;

        return studentClassesRepo.when(
          loading: () => Loading(),
          error: (e, s) {
            return SomethingWentWrong();
          },
          data: (classes) {
            if (classes.length == 0) {
              return Expanded(
                child: Text(
                  'No Classes',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Theme.of(context).colorScheme.secondaryVariant,
                      ),
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<Block>(
                    future: context
                        .read(schoolRepositoryProvider)
                        .getBlockByPeriod(classes[index].block!),
                    builder: (context, blockSnapshot) {
                      return FutureBuilder<StaffMember>(
                        future: context
                            .read(schoolRepositoryProvider)
                            .getTeacherByTeacherId(classes[index].teacherId!),
                        builder: (context, teacherSnapshot) {
                          futuresAreDone = blockSnapshot.data != null &&
                              teacherSnapshot.data != null;
                          if (!futuresAreDone && index == 0) {
                            return Loading();
                          } else if (!futuresAreDone && index != 0) {
                            return Container();
                          } else if (futuresAreDone &&
                              index == 0 &&
                              classes.length < 1) {
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
                          return ClassCard(
                            schoolClass: classes[index],
                            block: blockSnapshot.data!,
                            teacher: teacherSnapshot.data!,
                          );
                        },
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
  }
}
