import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';
import 'package:kounslr/src/ui/providers/next_class_providers/next_block_stream_provider.dart';
import 'package:kounslr/src/ui/providers/next_class_providers/next_class_stream_provider.dart';
import 'package:kounslr/src/ui/providers/next_class_providers/next_class_teacher_stream_provider.dart';
import 'package:kounslr/src/ui/providers/school_stream_provider.dart';
import 'package:kounslr/src/ui/providers/student_assignments_provider.dart';
import 'package:kounslr/src/ui/providers/student_classes_stream_provider.dart';
import 'package:kounslr/src/ui/providers/student_stream_provider.dart';
import 'package:kounslr/src/ui/styled_components/assignment_card.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/profile_view.dart';
import 'package:kounslr/src/ui/views/schedule_view.dart';
import 'package:kounslr/src/ui/views/upcoming_assignments_view.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

// Fix Next Class Card

class _HomeViewState extends State<HomeView> {
  final CollectionReference user = FirebaseFirestore.instance
      .collection('customers')
      .doc('lcps')
      .collection('schools')
      .doc('independence')
      .collection('students');

  bool studentHasData = true;

  Future<void> _checkIfStudentHasData() async {
    var student = await user.doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      studentHasData = student.exists;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkIfStudentHasData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        // General Student info variables
        final schoolStream = watch(schoolStreamProvider);
        final studentStream = watch(studentStreamProvider);
        final studentClassesFuture = watch(studentClassesFutureProvider);
        final studentAssignmentsFuture =
            watch(upcomingAssignmentsFutureProvider);

        // Next class variables
        final nextClassStream = watch(nextClassStreamProvider);
        final nextBlockStream = watch(nextBlockStreamProvider);
        final nextClassTeacherStream = watch(nextClassTeacherStreamProvider);

        if (!studentHasData) {
          return Column(
            children: [
              _header(
                context,
                Student(
                  name: '',
                  id: '',
                  studentId: '',
                  grade: '',
                  gender: '',
                  address: '',
                  nickname: '',
                  birthdate: '',
                  phone: '',
                  photo: '',
                  email: FirebaseAuth.instance.currentUser?.email,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Sign in with ',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryVariant,
                            ),
                        children: [
                          TextSpan(
                            text: 'StudentVue ',
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                          ),
                          TextSpan(text: 'to take full advantage of Kounslr')
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    CantonPrimaryButton(
                      buttonText: 'Sign in',
                      textColor: CantonColors.white,
                      containerColor: Theme.of(context).primaryColor,
                      containerWidth:
                          MediaQuery.of(context).size.width / 2 - 34,
                      onPressed: () => _showStudentVueSignInBottomSheet(),
                    ),
                  ],
                ),
              )
            ],
          );
        }

        return schoolStream.when(
          error: (e, s) {
            return SomethingWentWrong();
          },
          loading: () => Loading(),
          data: (school) {
            return studentStream.when(
              error: (e, s) {
                return SomethingWentWrong();
              },
              loading: () => Loading(),
              data: (student) {
                return studentClassesFuture.when(
                  error: (e, s) {
                    return SomethingWentWrong();
                  },
                  loading: () => Loading(),
                  data: (classes) {
                    // if (classes.length == 0) {
                    //   return Loading();
                    // }
                    return studentAssignmentsFuture.when(
                      error: (e, s) {
                        return SomethingWentWrong();
                      },
                      loading: () => Loading(),
                      data: (assignments) {
                        // if (assignments.length == 0) {
                        //   return Loading();
                        // }
                        return nextBlockStream.when(
                          loading: () => Loading(),
                          error: (e, s) {
                            return SomethingWentWrong();
                          },
                          data: (nextBlock) {
                            return nextClassStream.when(
                              error: (e, s) {
                                return SomethingWentWrong();
                              },
                              loading: () => Loading(),
                              data: (nextClass) {
                                return nextClassTeacherStream.when(
                                  error: (e, s) {
                                    return SomethingWentWrong();
                                  },
                                  loading: () => Loading(),
                                  data: (nextClassTeacher) {
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
      StaffMember teacher) {
    return ListView(
      shrinkWrap: false,
      children: _contentChildren(context, school, student, classes, assignments,
          nextClass, nextBlock, teacher),
    );
  }

  List<Widget> _contentChildren(
      BuildContext context,
      School school,
      Student student,
      List<Class> classes,
      List<Assignment> assignments,
      Class nextClass,
      Block nextBlock,
      StaffMember teacher) {
    List<Widget> children = [
      _header(context, student),
      const SizedBox(height: 10),
      _dateCard(context, school),
      _nextClassCard(context, nextClass, nextBlock, teacher),

      // ListView controls
    ];

    List<Assignment> upcomingAssignments = assignments
        .where((element) => element.dueDate!.isAfter(DateTime.now()))
        .toList();

    if (upcomingAssignments.length > 0) {
      children.add(
        Row(
          children: [
            Text(
              'Upcoming Assignments',
              style: Theme.of(context).textTheme.headline6,
            ),
            Spacer(),
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
              onPressed: () => CantonMethods.viewTransition(
                  context, UpcomingAssignmentView()),
            ),
            CantonActionButton(
              icon: IconlyIcon(
                IconlyBold.ArrowRight2,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => CantonMethods.viewTransition(
                  context, UpcomingAssignmentView()),
            ),
          ],
        ),
      );
      for (var i = 0;
          i <
              ((upcomingAssignments.length < 7)
                  ? upcomingAssignments.length
                  : 7);
          i++) {
        children.add(AssignmentCard(
            classes
                .where((element) => element.id == assignments[i].classId)
                .toList()[0],
            assignments[i]));
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

  Widget _header(BuildContext context, Student student) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hey,',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
            ),
            Text(
              _studentNameInHeader(student),
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        Spacer(),
        CantonHeaderButton(
          icon: IconlyIcon(
            IconlyBold.Profile,
            color: Theme.of(context).colorScheme.secondaryVariant,
          ),
          onPressed: () => CantonMethods.viewTransition(
            context,
            ProfileView(student),
          ),
        ),
      ],
    );
  }

  Widget _dateCard(BuildContext context, School school) {
    return Row(
      children: [
        ![6, 7].contains(DateTime.now().weekday)
            ? Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 7.5 * 2.5, vertical: 7.5),
                decoration: ShapeDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: SquircleBorder(radius: BorderRadius.circular(30)),
                ),
                child: Column(
                  children: [
                    Text(
                      school.currentDay?.dayType ?? 'M',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: CantonColors.white,
                          ),
                    ),
                    Text(
                      'Day',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: CantonColors.white,
                          ),
                    ),
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 7.5),
              ),
        ![6, 7].contains(DateTime.now().weekday)
            ? SizedBox(width: 15)
            : Container(),
        Text(
          DateFormat.yMMMMEEEEd().format(
            DateTime.now(),
          ),
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }

  Widget _nextClassCard(BuildContext context, Class schoolClass, Block block,
      StaffMember teacher) {
    if ([DateTime.saturday, DateTime.sunday].contains(DateTime.now().weekday)) {
      return Card(
        margin: EdgeInsets.only(top: 15),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enjoy your weekend!',
                  style: Theme.of(context).textTheme.headline4),
            ],
          ),
        ),
      );
    } else if ((schoolClass.id == 'done') || (block.period == 0)) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No more classes for today! 😃',
                  style: Theme.of(context).textTheme.headline4),
            ],
          ),
        ),
      );
    } else if (schoolClass.id == null) {
      return Card(
        margin: EdgeInsets.only(top: 15),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sorry! We couldn\'t figure out your next class',
                  style: Theme.of(context).textTheme.headline6),
            ],
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Text('Next Class', style: Theme.of(context).textTheme.headline6),
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
                  'View Full Schedule',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                onPressed: () {
                  CantonMethods.viewTransition(context, ScheduleView());
                },
              ),
              CantonActionButton(
                icon: IconlyIcon(
                  IconlyBold.ArrowRight2,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  CantonMethods.viewTransition(context, ScheduleView());
                },
              ),
            ],
          ),
          _classCard(schoolClass, teacher, block)
        ],
      );
    }
  }

  Widget _classCard(
      Class schoolClass, StaffMember teacher, Block currentBlock) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schoolClass.name ?? 'CLASS',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconlyIcon(
                      IconlyBold.Location,
                      color: Theme.of(context).colorScheme.secondaryVariant,
                      size: 17,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      schoolClass.roomNumber ?? 'LOCATION',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color:
                                Theme.of(context).colorScheme.secondaryVariant,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconlyIcon(
                      IconlyBold.Profile,
                      color: Theme.of(context).colorScheme.secondaryVariant,
                      size: 17,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      _teacherName(teacher),
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color:
                                Theme.of(context).colorScheme.secondaryVariant,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Text(
              _nextClassTime(currentBlock.time!.toLocal()),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  String _teacherName(StaffMember teacher) {
    String string = teacher.name!.substring(teacher.name!.indexOf(' '));
    if (teacher.gender == 'Male') {
      return 'Mr.' + string;
    }
    return 'Ms.' + string;
  }

  String _nextClassTime(DateTime date) {
    return DateFormat("h:mm a").format(date).toString();
  }

  String _studentNameInHeader(Student student) {
    if (![null, ''].contains(student.nickname)) {
      return student.nickname!;
    } else if (student.name == '') {
      return 'There 👋';
    }
    return student.name!.substring(0, student.name!.indexOf(' '));
  }

  Future<void> _showStudentVueSignInBottomSheet() async {
    var _emailController = TextEditingController();
    var _passwordController = TextEditingController();
    var hasResult = true;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      useRootNavigator: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Consumer(
              builder: (context, watch, child) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 27),
                  child: FractionallySizedBox(
                    heightFactor: 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 5,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Sign in to StudentVue',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(height: 20),
                        CantonTextInput(
                          isTextFormField: true,
                          obscureText: false,
                          hintText: 'Email',
                          textInputType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                        SizedBox(height: 15),
                        CantonTextInput(
                          isTextFormField: true,
                          obscureText: true,
                          hintText: 'Password',
                          textInputType: TextInputType.visiblePassword,
                          controller: _passwordController,
                        ),
                        SizedBox(height: 15),
                        CantonPrimaryButton(
                          onPressed: () async {
                            String res =
                                await watch(authenticationServiceProvider)
                                    .studentVueSignIn(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            if (res == 'failed') {
                              setState(() {
                                hasResult = false;
                              });
                            } else {
                              hasResult = true;
                            }

                            if (hasResult) {
                              Phoenix.rebirth(context);
                            }
                          },
                          buttonText: 'Sign in',
                          textColor: CantonColors.white,
                          containerWidth: MediaQuery.of(context).size.width / 4,
                          containerPadding: EdgeInsets.all(10),
                        ),
                        SizedBox(height: 20),
                        hasResult == false
                            ? Text(
                                'Incorrect email or password',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                              )
                            : Container(),
                      ],
                    ),
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
