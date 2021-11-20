import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_performance/firebase_performance.dart';

import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/providers/next_class_providers/next_block_stream_provider.dart';
import 'package:kounslr/src/providers/next_class_providers/next_class_stream_provider.dart';
import 'package:kounslr/src/providers/next_class_providers/next_class_teacher_stream_provider.dart';
import 'package:kounslr/src/providers/school_stream_provider.dart';
import 'package:kounslr/src/providers/student_assignments_provider.dart';
import 'package:kounslr/src/providers/student_classes_future_provider.dart';
import 'package:kounslr/src/providers/student_stream_provider.dart';
import 'package:kounslr/src/ui/styled_components/assignment_card.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/home_view/components/home_view_components.dart';
import 'package:kounslr/src/ui/views/home_view/components/home_view_header.dart';
import 'package:kounslr/src/ui/views/upcoming_assignments_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    /// Measures how quickly the UI builds initially
    var trace = FirebasePerformance.instance.newTrace('home_view_performance');
    trace.start();

    return Consumer(
      builder: (context, watch, child) {
        // General Student info variables
        final schoolStream = watch(schoolStreamProvider);
        final studentStream = watch(studentStreamProvider);
        final studentClassesStream = watch(studentClassesStreamProvider);
        final studentAssignmentsStream = watch(upcomingAssignmentsStreamProvider);

        // Next class variables
        final nextClassStream = watch(nextClassStreamProvider);
        final nextBlockStream = watch(nextBlockStreamProvider);
        final nextClassTeacherStream = watch(nextClassTeacherStreamProvider);

        return schoolStream.when(
          error: (e, s) {
            return const SomethingWentWrong();
          },
          loading: () => Loading(),
          data: (school) {
            return studentStream.when(
              error: (e, s) {
                return const SomethingWentWrong();
              },
              loading: () => Loading(),
              data: (student) {
                return studentClassesStream.when(
                  error: (e, s) {
                    return const SomethingWentWrong();
                  },
                  loading: () => Loading(),
                  data: (classes) {
                    return studentAssignmentsStream.when(
                      error: (e, s) {
                        return const SomethingWentWrong();
                      },
                      loading: () => Loading(),
                      data: (assignments) {
                        return nextBlockStream.when(
                          loading: () => Loading(),
                          error: (e, s) {
                            return const SomethingWentWrong();
                          },
                          data: (nextBlock) {
                            return nextClassStream.when(
                              error: (e, s) {
                                return const SomethingWentWrong();
                              },
                              loading: () => Loading(),
                              data: (nextClass) {
                                return nextClassTeacherStream.when(
                                  error: (e, s) {
                                    return const SomethingWentWrong();
                                  },
                                  loading: () => Loading(),
                                  data: (nextClassTeacher) {
                                    trace.stop();

                                    return _content(
                                      context,
                                      school,
                                      student,
                                      classes,
                                      assignments,
                                      nextClass,
                                      nextBlock,
                                      nextClassTeacher,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _content(BuildContext context, School school, Student student, List<Class> classes,
      List<Assignment> assignments, Class nextClass, Block nextBlock, StaffMember teacher) {
    return ListView(
      shrinkWrap: false,
      children: _contentChildren(context, school, student, classes, assignments, nextClass, nextBlock, teacher),
    );
  }

  List<Widget> _contentChildren(BuildContext context, School school, Student student, List<Class> classes,
      List<Assignment> assignments, Class nextClass, Block nextBlock, StaffMember teacher) {
    List<Widget> children = [
      const SizedBox(height: 10),
      DateCard(school: school),
      HomeViewHeader(student: student),
      NextClassCard(schoolClass: nextClass, block: nextBlock, teacher: teacher),
    ];

    if (assignments.isNotEmpty) {
      children.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Row(
            children: [
              Text(
                'Upcoming Assignments',
                style: Theme.of(context).textTheme.headline6,
              ),
              const Spacer(),
              TextButton(
                style: ButtonStyle(
                  alignment: Alignment.centerRight,
                  animationDuration: Duration.zero,
                  elevation: MaterialStateProperty.all<double>(0),
                  overlayColor: MaterialStateProperty.all<Color>(
                    CantonColors.transparent,
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.zero,
                  ),
                ),
                child: Text(
                  'View All',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                onPressed: () => CantonMethods.viewTransition(context, const UpcomingAssignmentView()),
              ),
              CantonActionButton(
                icon: Icon(
                  Iconsax.arrow_right_2,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => CantonMethods.viewTransition(context, const UpcomingAssignmentView()),
              ),
            ],
          ),
        ),
      );

      for (var i = 0; i < ((assignments.length < 7) ? assignments.length : 7); i++) {
        children.add(
          AssignmentCard(
            classes.where((element) => element.id == assignments[i].classId).toList()[0],
            assignments[i],
          ),
        );
      }
    } else {
      children.add(
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Text(
              'No upcoming assignments',
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
            ),
          ),
        ),
      );
    }

    return children;
  }
}
