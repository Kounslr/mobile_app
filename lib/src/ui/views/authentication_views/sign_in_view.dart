import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';

class SignInView extends ConsumerWidget {
  final Function toggleView;
  const SignInView({this.toggleView});
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
          isTextFormField: true,
          obscureText: false,
          controller: _emailController,
          border: BorderSide.none,
          radius: BorderRadius.circular(45),
        ),
        SizedBox(height: 15),
        CantonTextInput(
          hintText: 'Password',
          isTextFormField: true,
          obscureText: true,
          controller: _passwordController,
          border: BorderSide.none,
          radius: BorderRadius.all(Radius.circular(45)),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            CantonPrimaryButton(
              buttonText: 'Sign Up',
              containerWidth: MediaQuery.of(context).size.width / 2 - 34,
              containerColor: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.secondaryVariant,
              onPressed: () => toggleView(),
            ),
            Spacer(),
            CantonPrimaryButton(
              buttonText: 'Sign In',
              containerWidth: MediaQuery.of(context).size.width / 2 - 34,
              containerColor: Theme.of(context).primaryColor,
              textColor: CantonColors.white,
              onPressed: () {
                context.read(authenticationServiceProvider).signIn(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Text(
          'Sign In',
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ],
    );
  }
}
