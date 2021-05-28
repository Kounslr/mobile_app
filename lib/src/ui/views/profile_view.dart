import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';

class ProfileView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return _content(context, watch);
  }

  Widget _content(BuildContext context, ScopedReader watch) {
    final _auth = watch(authenticationServiceProvider);
    return Center(
      child: CantonPrimaryButton(
        buttonText: 'Sign out',
        textColor: CantonColors.white,
        containerColor: Theme.of(context).primaryColor,
        onPressed: () {
          _auth.signOut();
        },
      ),
    );
  }
}
