import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kounslr/src/ui/styled_components/error_text.dart';

class SignInView extends StatefulWidget {
  final Function? toggleView;
  const SignInView({this.toggleView});

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String _errorMessage = '';
  bool _hasError = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      resizeToAvoidBottomInset: true,
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 34),
      body: _content(context, _emailController, _passwordController),
    );
  }

  Widget _content(BuildContext context, TextEditingController _emailController,
      TextEditingController _passwordController) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 75),
          _header(context),
          const SizedBox(height: 40),
          _emailTextInput(context, _emailController),
          const SizedBox(height: 15),
          _passwordTextInput(context, _passwordController),
          const SizedBox(height: 30),
          _signInButton(context, _emailController, _passwordController),
          const SizedBox(height: 15),
          Text(
            'Or continue with',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: Theme.of(context).colorScheme.secondaryVariant,
                ),
          ),
          const SizedBox(height: 15),
          _signInWithGoogleButton(context),
          _hasError ? const SizedBox(height: 15) : Container(),
          _hasError ? ErrorText(_errorMessage) : Container(),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account? ',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Theme.of(context).colorScheme.secondaryVariant,
                    ),
              ),
              GestureDetector(
                onTap: () => widget.toggleView!(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sign up',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
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
      textInputType: TextInputType.emailAddress,
      prefixIcon: IconlyIcon(
        IconlyBold.Message,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
    );
  }

  Widget _passwordTextInput(
      BuildContext context, TextEditingController _passwordController) {
    return CantonTextInput(
      hintText: 'Password',
      isTextFormField: true,
      obscureText: true,
      controller: _passwordController,
      textInputType: TextInputType.visiblePassword,
      prefixIcon: IconlyIcon(
        IconlyBold.Lock,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
    );
  }

  Widget _signInButton(
      BuildContext context,
      TextEditingController _emailController,
      TextEditingController _passwordController) {
    return CantonPrimaryButton(
      buttonText: 'Sign In',
      color: Theme.of(context).primaryColor,
      onPressed: () async {
        var res = await context
            .read(authenticationServiceProvider)
            .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        if (res != 'success') {
          setState(() {
            _hasError = true;
            _errorMessage = res;
          });
        }
      },
    );
  }

  Widget _signInWithGoogleButton(BuildContext context) {
    return CantonPrimaryButton(
      buttonText: 'Google',
      alignment: MainAxisAlignment.center,
      color: Theme.of(context).canvasColor,
      border: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
        width: 1.7,
      ),
      textColor: Theme.of(context).colorScheme.secondaryVariant,
      prefixIcon: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: FaIcon(
          FontAwesomeIcons.google,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onPressed: () async {
        var res = await context
            .read(authenticationServiceProvider)
            .signInWithGoogle();

        if (res == 'failed') {
          setState(() {
            _hasError = true;
            _errorMessage = res;
          });
        }
      },
    );
  }
}
