import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_service_provider.dart';

class ProfileView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return Center(
      child: CantonPrimaryButton(
        onPressed: () {
          context.read(authenticationServiceProvider).signOut();
        },
      ),
    );
  }
}
