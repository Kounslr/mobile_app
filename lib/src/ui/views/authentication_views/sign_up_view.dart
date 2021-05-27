import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_service_provider.dart';

class SignUpView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    return CantonScaffold(
      body: _content(context, _emailController, _passwordController),
    );
  }

  Widget _content(
    BuildContext context,
    TextEditingController _emailController,
    TextEditingController _passwordController,
  ) {
    return Column(
      children: [
        _header(context),
        SizedBox(height: 50),
        CantonTextInput(
          hintText: 'Email',
          isTextInputTwo: true,
          isTextFormField: true,
          obscureText: false,
          controller: _emailController,
        ),
        SizedBox(height: 15),
        CantonTextInput(
          hintText: 'Password',
          isTextInputTwo: true,
          isTextFormField: true,
          obscureText: true,
          controller: _passwordController,
        ),
        SizedBox(height: 20),
        CantonPrimaryButton(
          buttonText: 'Sign Up',
          containerColor: Theme.of(context).primaryColor,
          textColor: CantonColors.white,
          onPressed: () {
            context.read(authenticationServiceProvider).signUp(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );
          },
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Text(
          'Sign Up',
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ],
    );
  }
}
