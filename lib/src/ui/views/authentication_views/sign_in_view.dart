import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInView extends ConsumerWidget {
  final Function? toggleView;
  const SignInView({this.toggleView});
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    return CantonScaffold(
      padding: EdgeInsets.symmetric(vertical: 17, horizontal: 34),
      body: _content(context, _emailController, _passwordController),
    );
  }

  Widget _content(
    BuildContext context,
    TextEditingController _emailController,
    TextEditingController _passwordController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 75),
        _header(context),
        SizedBox(height: 40),
        _emailTextInput(context, _emailController),
        SizedBox(height: 15),
        _passwordTextInput(context, _passwordController),
        SizedBox(height: 50),
        _signInButton(context, _emailController, _passwordController),
        SizedBox(height: 15),
        Text(
          'Or continue with',
          style: Theme.of(context).textTheme.headline6?.copyWith(
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
        ),
        SizedBox(height: 15),
        _signInWithGoogleButton(context, _emailController, _passwordController)
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        Text(
          'Welcome!',
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          'Please sign in to Kounslr',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
        ),
      ],
    );
  }

  Widget _emailTextInput(
      BuildContext context, TextEditingController _emailController) {
    return CantonTextInput(
      hintText: 'Email',
      isTextFormField: true,
      obscureText: false,
      controller: _emailController,
      prefixIcon: IconlyIcon(
        IconlyBold.Message,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
      border: BorderSide.none,
      radius: BorderRadius.circular(45),
    );
  }

  Widget _passwordTextInput(
      BuildContext context, TextEditingController _passwordController) {
    return CantonTextInput(
      hintText: 'Password',
      isTextFormField: true,
      obscureText: true,
      controller: _passwordController,
      prefixIcon: IconlyIcon(
        IconlyBold.Lock,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
      border: BorderSide.none,
      radius: BorderRadius.all(Radius.circular(45)),
    );
  }

  Widget _signInButton(
      BuildContext context,
      TextEditingController _emailController,
      TextEditingController _passwordController) {
    return CantonPrimaryButton(
      buttonText: 'Sign In',
      radius: BorderRadius.circular(37),
      containerColor: Theme.of(context).primaryColor,
      textColor: CantonColors.white,
      onPressed: () async {
        await context
            .read(authenticationServiceProvider)
            .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
      },
    );
  }

  Widget _signInWithGoogleButton(
      BuildContext context,
      TextEditingController _emailController,
      TextEditingController _passwordController) {
    return CantonPrimaryButton(
      buttonText: 'Google',
      alignment: MainAxisAlignment.center,
      containerColor: Theme.of(context).canvasColor,
      radius: BorderRadius.circular(37),
      border:
          BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
      textColor: Theme.of(context).colorScheme.secondaryVariant,
      prefixIcon: Container(
        margin: EdgeInsets.all(10),
        child: FaIcon(
          FontAwesomeIcons.google,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onPressed: () async {
        await context.read(authenticationServiceProvider).signInWithGoogle();
      },
    );
  }

  // ignore: unused_element
  Widget _signInAndSignUpButtons(
      BuildContext context,
      TextEditingController _emailController,
      TextEditingController _passwordController) {
    return Row(
      children: [
        CantonPrimaryButton(
          buttonText: 'Sign Up',
          containerWidth: MediaQuery.of(context).size.width / 2 - 34,
          containerColor: Theme.of(context).colorScheme.secondary,
          textColor: Theme.of(context).colorScheme.secondaryVariant,
          onPressed: () => toggleView!(),
        ),
        Spacer(),
        _signInButton(context, _emailController, _passwordController),
      ],
    );
  }
}
