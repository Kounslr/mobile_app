import 'package:canton_design_system/canton_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';
import 'package:kounslr/src/ui/views/student_id_card_view.dart';

class ProfileView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return CantonScaffold(body: _content(context, watch));
  }

  Widget _content(BuildContext context, ScopedReader watch) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _header(context),
        _body(context),

        // Null widget so UI will format properly
        CantonHeaderButton(
          onPressed: () {},
          backgroundColor: CantonColors.transparent,
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CantonBackButton(isClear: true),
        Text(
          'Profile',
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Theme.of(context).primaryColor),
        ),
        CantonHeaderButton(
          onPressed: () {},
          backgroundColor: CantonColors.transparent,
        ),
      ],
    );
  }
}

Widget _body(BuildContext context) {
  return Column(
    children: [
      _profileCard(context),
      SizedBox(height: 10),
      _studentIDCard(context),
      SizedBox(height: 10),
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
  );
}

Widget _studentIDCard(BuildContext context) {
  return GestureDetector(
    onTap: () {
      CantonMethods.viewTransition(context, StudentIDCardView());
    },
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Text(
              'ID Card',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            Spacer(),
            IconlyIcon(
              IconlyBold.Wallet,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _profileCard(BuildContext context) {
  String email = FirebaseAuth.instance.currentUser.email;
  String username = email.substring(0, email.indexOf('@'));

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STUDENT NAME' + ' (' + username + ')',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                email,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                'SCHOOL DISTRICT NAME',
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
