import 'package:canton_design_system/canton_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_service_provider.dart';
import 'package:kounslr/src/ui/styled_components/profile_card.dart';

class ProfileView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return _content(context, watch);
  }

  Widget _content(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser.email;
    String username = email.substring(0,email.indexOf('@'));

    return Column(
      children: [
        ProfileCard(),
        Center(
          child: CantonPrimaryButton(
            buttonText: 'Sign out',
            textColor: CantonColors.white,
            containerColor: Theme.of(context).primaryColor,
            containerWidth: 180,
            onPressed: () {
              context.read(authenticationServiceProvider).signOut();
            },
          ),
        ),
      ],
    );
  }
}
