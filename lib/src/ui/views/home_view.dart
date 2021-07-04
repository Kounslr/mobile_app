import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';
import 'package:kounslr/src/ui/providers/student_provider.dart';
import 'package:kounslr/src/ui/styled_components/assignment_card.dart';
import 'package:kounslr/src/ui/views/profile_view.dart';
import 'package:kounslr/src/ui/views/schedule_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: context.read(studentProvider).getStudent(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Loading();
            } else if (!snapshot.hasError &&
                snapshot.hasData &&
                snapshot.data?.data() != null) {
              return _content(context, snapshot);
            } else {
              return _somethingWentWrong(context);
            }
          },
        );
      },
    );
  }

  Widget _somethingWentWrong(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Theme.of(context).colorScheme.secondaryVariant,
                ),
          ),
          SizedBox(height: 20),
          CantonPrimaryButton(
            buttonText: 'Sign out',
            textColor: CantonColors.white,
            containerColor: Theme.of(context).primaryColor,
            containerWidth: MediaQuery.of(context).size.width / 2 - 34,
            onPressed: () {
              context.read(authenticationServiceProvider).signOut(context);
            },
          ),
        ],
      ),
    );
  }

  List<Assignment> assignments = [];

  Widget _content(BuildContext context, AsyncSnapshot snapshot) {
    Student student = Student.fromMap(snapshot.data?.data());
    return FutureBuilder<List<Assignment>>(
        future: context.read(studentProvider).getUpcomingAssignments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(
              shrinkWrap: false,
              children: _contentChildren(context, student, snapshot.data!),
            );
          } else {
            return Loading();
          }
        });
  }

  List<Widget> _contentChildren(
    BuildContext context,
    Student student,
    List<Assignment> list,
  ) {
    List<Widget> children = [
      _header(context, student),
      SizedBox(height: 10),
      _dateCard(context),
      _nextClassCard(context),

      // ListView controls
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
            onPressed: () {},
          ),
          CantonActionButton(
            icon: IconlyIcon(
              IconlyBold.ArrowRight2,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {},
          ),
        ],
      ),

      // List of upcoming assignments
      AssignmentCard(list[0]),
      AssignmentCard(list[1]),
      AssignmentCard(list[2]),
      AssignmentCard(list[3]),
      AssignmentCard(list[4]),
      AssignmentCard(list[5]),
      AssignmentCard(list[6]),
    ];

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
              ![null, ''].contains(student.nickname)
                  ? student.nickname!
                  : student.name!.substring(0, student.name!.indexOf(' ')),
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

  Widget _dateCard(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 7.5 * 2.5, vertical: 7.5),
          decoration: ShapeDecoration(
            color: Theme.of(context).primaryColor,
            shape: SquircleBorder(radius: BorderRadius.circular(30)),
          ),
          child: Column(
            children: [
              Text(
                'M',
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
        ),
        SizedBox(width: 15),
        Text(
          DateFormat.yMMMMEEEEd().format(
            DateTime.now(),
          ),
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }

  Widget _nextClassCard(BuildContext context) {
    if (![DateTime.saturday, DateTime.sunday]
        .contains(DateTime.now().weekday)) {
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CLASS',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          IconlyIcon(
                            IconlyBold.Location,
                            color:
                                Theme.of(context).colorScheme.secondaryVariant,
                            size: 17,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'LOCATION',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryVariant,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          IconlyIcon(
                            IconlyBold.Profile,
                            color:
                                Theme.of(context).colorScheme.secondaryVariant,
                            size: 17,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'TEACHER',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryVariant,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    'TIME',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
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
    }
  }
}
