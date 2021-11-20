import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/providers/authentication_providers/authentication_service_provider.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CantonPrimaryButton(
      buttonText: 'Sign Out',
      textColor: Theme.of(context).primaryColor,
      color: CantonColors.transparent,
      alignment: MainAxisAlignment.center,
      containerWidth: MediaQuery.of(context).size.width / 2 - 5,
      onPressed: () {
        context.read(authenticationServiceProvider).signOut();
      },
    );
  }
}
