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

import 'package:kounslr_design_system/kounslr_design_system.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import 'package:kounslr/src/providers/student_classes_stream_provider.dart';
import 'package:kounslr/src/providers/student_stream_provider.dart';
import 'package:kounslr/src/ui/components/assignment_card.dart';
import 'package:kounslr/src/ui/components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/home_view/components/date_card.dart';
import 'package:kounslr/src/ui/views/home_view/components/home_view_header.dart';
import 'package:kounslr/src/ui/views/home_view/components/next_class_card.dart';
import 'package:kounslr/src/ui/views/upcoming_assignments_view/upcoming_assignments_view.dart';

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

  Widget _content(
    BuildContext context,
    School school,
    Student student,
    List<Class> classes,
    List<Assignment> assignments,
    Class nextClass,
    Block nextBlock,
    StaffMember teacher,
  ) {
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
      const SizedBox(height: 15),
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
                    KounslrColors.transparent,
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
                onPressed: () => KounslrMethods.viewTransition(context, const UpcomingAssignmentView()),
              ),
              KounslrActionButton(
                icon: Icon(
                  Iconsax.arrow_right_2,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => KounslrMethods.viewTransition(context, const UpcomingAssignmentView()),
              ),
            ],
          ),
        ),
      );

      for (var i = 0; i < ((assignments.length < 7) ? assignments.length : 7); i++) {
        const defRadii = 10.0;
        BorderRadius radiiByIndex() {
          if (assignments.length == 1) {
            return BorderRadius.circular(defRadii);
          } else if (assignments.length == 2) {
            if (i == 0) {
              return const BorderRadius.vertical(top: Radius.circular(defRadii));
            } else {
              return const BorderRadius.vertical(bottom: Radius.circular(defRadii));
            }
          } else {
            if (i == 0) {
              return const BorderRadius.vertical(top: Radius.circular(defRadii));
            } else if (i == assignments.length - 1) {
              return const BorderRadius.vertical(bottom: Radius.circular(defRadii));
            } else {
              return BorderRadius.zero;
            }
          }
        }

        children.add(
          Column(
            children: [
              AssignmentCard(
                classes.where((element) => element.id == assignments[i].classId).toList()[0],
                assignments[i],
                radius: radiiByIndex(),
              ),
              i != assignments.length - 1
                  ? Container(padding: const EdgeInsets.symmetric(horizontal: 17), child: const Divider())
                  : Container(),
              i == assignments.length - 1 ? const SizedBox(height: 17) : Container(),
            ],
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
