import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_stream_provider.dart';
import 'package:kounslr/src/ui/views/authentication_views/sign_up_view.dart';
import 'package:kounslr/src/ui/views/current_view.dart';

class AuthenticationWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final firebaseUser = watch(authenticationStreamProvider);

    if (firebaseUser.data.value != null) {
      return CurrentView();
    }
    return SignUpView();
  }
}
