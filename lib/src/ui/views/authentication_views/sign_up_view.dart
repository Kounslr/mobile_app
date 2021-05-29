import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';

class SignUpView extends ConsumerWidget {
  final Function toggleView;
  const SignUpView({this.toggleView});
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _domainController = TextEditingController(text: 'portal.lcps.org');

    return CantonScaffold(
      body: _content(
        context,
        watch,
        _emailController,
        _passwordController,
        _domainController,
      ),
    );
  }

  Widget _content(
    BuildContext context,
    ScopedReader watch,
    TextEditingController _emailController,
    TextEditingController _passwordController,
    TextEditingController _domainController,
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
        SizedBox(height: 15),
        CantonTextInput(
          hintText: 'Domain',
          isTextInputTwo: true,
          isTextFormField: true,
          obscureText: false,
          controller: _domainController,
        ),
        SizedBox(height: 15),
        Row(
          children: [
            CantonPrimaryButton(
              buttonText: 'Sign In',
              containerWidth: MediaQuery.of(context).size.width / 2 - 34,
              containerColor: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.secondaryVariant,
              onPressed: () => toggleView(),
            ),
            Spacer(),
            CantonPrimaryButton(
              buttonText: 'Sign Up',
              containerWidth: MediaQuery.of(context).size.width / 2 - 34,
              containerColor: Theme.of(context).primaryColor,
              textColor: CantonColors.white,
              onPressed: () {
                context.read(authenticationServiceProvider).signUp(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      domain: _domainController.text.trim(),
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
          'Sign Up',
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ],
    );
  }
}
