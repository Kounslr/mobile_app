import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/providers/authentication_providers/authentication_stream_provider.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/authentication_views/sign_in_view.dart';
import 'package:kounslr/src/ui/views/authentication_views/sign_up_view.dart';
import 'package:kounslr/src/ui/views/current_view.dart';

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final _authState = watch(authenticationStreamProvider);

        return _authState.when(
          error: (e, s) {
            return const SomethingWentWrong();
          },
          loading: () => Loading(),
          data: (user) {
            if (user == null) {
              if (showSignIn) {
                return SignInView(toggleView: toggleView);
              } else {
                return SignUpView(toggleView: toggleView);
              }
            } else {
              return const CurrentView();
            }
          },
        );
      },
    );
  }
}
