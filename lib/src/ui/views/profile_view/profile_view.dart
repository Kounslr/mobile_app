import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';
import 'package:kounslr/src/ui/providers/school_future_provider.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/schedule_view.dart';
import 'package:kounslr/src/ui/views/profile_view/student_id_card_view.dart';
import 'package:kounslr/src/ui/views/upcoming_assignments_view.dart';

class ProfileView extends ConsumerWidget {
  final Student student;

  const ProfileView(this.student);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return CantonScaffold(body: _content(context, watch));
  }

  Widget _content(BuildContext context, ScopedReader watch) {
    return Column(
      children: [
        _header(context),
        _body(context, student),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return ViewHeaderTwo(
      title: 'Profile',
      backButton: true,
      isBackButtonClear: true,
    );
  }

  Widget _body(BuildContext context, Student student) {
    return Consumer(
      builder: (context, watch, child) {
        final schoolRepo = watch(schoolFutureProvider);
        return schoolRepo.when(
          loading: () => Loading(),
          error: (e, s) {
            return SomethingWentWrong();
          },
          data: (school) {
            return Column(
              children: [
                _profileCard(context, student, school),
                SizedBox(height: 30),
                _studentIDCard(context, student, school),
                _studentScheduleCard(context),
                _studentUpcomingAssignmentsCard(context),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    context.read(authenticationServiceProvider).signOut();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sign Out',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget _profileCard(BuildContext context, Student student, School school) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _contentText(student.name!) + ' (' + student.studentId! + ')',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  student.email!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  school.name!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            Spacer(),
            IconlyIcon(
              IconlyBold.Profile,
              size: 40,
              color: Theme.of(context).colorScheme.secondaryVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _studentIDCard(BuildContext context, Student student, School school) {
    return GestureDetector(
      onTap: () {
        CantonMethods.viewTransition(
            context, StudentIDCardView(student, school));
      },
      child: Card(
        margin: EdgeInsets.zero,
        shape: SquircleBorder(
          radius: BorderRadius.vertical(
            top: Radius.circular(37),
          ),
          side: BorderSide(
            width: 1.5,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Text(
                'ID Card',
                style: Theme.of(context).textTheme.headline6,
              ),
              Spacer(),
              IconlyIcon(
                IconlyBold.Wallet,
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _studentScheduleCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CantonMethods.viewTransition(context, ScheduleView());
      },
      child: Card(
        margin: EdgeInsets.zero,
        shape: Border(
          left: BorderSide(
            width: 1.5,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          right: BorderSide(
            width: 1.5,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Text(
                'Schedule',
                style: Theme.of(context).textTheme.headline6,
              ),
              Spacer(),
              IconlyIcon(
                IconlyBold.Calendar,
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _studentUpcomingAssignmentsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CantonMethods.viewTransition(context, UpcomingAssignmentView());
      },
      child: Card(
        margin: EdgeInsets.zero,
        shape: SquircleBorder(
          radius: BorderRadius.vertical(
            bottom: Radius.circular(37),
          ),
          side: BorderSide(
            width: 1.5,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Text(
                'Upcoming Assignments',
                style: Theme.of(context).textTheme.headline6,
              ),
              Spacer(),
              IconlyIcon(
                IconlyBold.Paper,
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _contentText(String string) {
    if (string.length > 23) {
      return string.substring(0, 20) + '...';
    }
    return string;
  }
}
