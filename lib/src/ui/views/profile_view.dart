import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';
import 'package:kounslr/src/ui/providers/school_future_provider.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/student_id_card_view.dart';

class ProfileView extends ConsumerWidget {
  final Student student;

  const ProfileView(this.student);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return CantonScaffold(body: _content(context, watch));
  }

  Widget _content(BuildContext context, ScopedReader watch) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _header(context),
        _body(context, student),

        // Invisible widget so UI will format properly
        CantonHeaderButton(
          onPressed: () {},
          backgroundColor: CantonColors.transparent,
        ),
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
                SizedBox(height: 10),
                _studentIDCard(context, student, school),
                SizedBox(height: 10),
                CantonPrimaryButton(
                  buttonText: 'Sign out',
                  textColor: CantonColors.white,
                  containerColor: Theme.of(context).primaryColor,
                  containerWidth: MediaQuery.of(context).size.width / 2 - 34,
                  onPressed: () {
                    context
                        .read(authenticationServiceProvider)
                        .signOut(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _studentIDCard(BuildContext context, Student student, School school) {
    return GestureDetector(
      onTap: () {
        CantonMethods.viewTransition(
            context, StudentIDCardView(student, school));
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Text(
                'ID Card',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).colorScheme.secondaryVariant,
                    ),
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

  String _contentText(String string) {
    if (string.length > 23) {
      return string.substring(0, 20) + '...';
    }
    return string;
  }
}
