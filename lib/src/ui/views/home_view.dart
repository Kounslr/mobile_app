import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/ui/providers/student_provider.dart';
import 'package:kounslr/src/ui/styled_components/assignment_card.dart';
import 'package:kounslr/src/ui/views/profile_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return _content(context, user);
  }

  Widget _content(BuildContext context, User user) {
    return Consumer(
      builder: (context, watch, child) {
        return StreamBuilder<DocumentSnapshot>(
          stream: context.read(studentProvider).getStudent(
                'lcps',
                'independence',
                user.uid,
              ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Something went wrong',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.secondaryVariant,
                      ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }

            return Column(
              children: [
                _header(context, user, Student.fromMap(snapshot.data.data())),
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
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
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

                // List View of assignments
                Expanded(
                  child: ListView.separated(
                    itemCount: 5,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 6);
                    },
                    itemBuilder: (context, index) {
                      return AssignmentCard();
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _header(
    BuildContext context,
    User user,
    Student student,
  ) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hey,',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
            ),
            Text(
              ![null, ''].contains(student.nickname)
                  ? student.nickname
                  : student.name.substring(0, student.name.indexOf(' ')),
              style: Theme.of(context).textTheme.headline1.copyWith(
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
            shape: SquircleBorder(radius: 30),
          ),
          child: Column(
            children: [
              Text(
                'X',
                style: Theme.of(context).textTheme.headline4.copyWith(
                      color: CantonColors.white,
                    ),
              ),
              Text(
                'Day',
                style: Theme.of(context).textTheme.caption.copyWith(
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
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor),
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
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          size: 17,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'LOCATION',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
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
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          size: 17,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'TEACHER',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
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
  }
}
