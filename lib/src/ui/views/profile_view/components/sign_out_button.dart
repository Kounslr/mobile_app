import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
