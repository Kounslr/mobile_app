import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class SignInView extends StatefulWidget {
  final Function? toggleView;
  const SignInView({this.toggleView});

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String _errorMessage = '';
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    return CantonScaffold(
      padding: EdgeInsets.symmetric(vertical: 17, horizontal: 34),
      body: _content(context, _emailController, _passwordController),
    );
  }

  Widget _content(BuildContext context, TextEditingController _emailController,
      TextEditingController _passwordController) {
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
        _signInWithGoogleButton(context, _emailController, _passwordController),
        _hasError ? SizedBox(height: 15) : Container(),
        _hasError ? _errorText(context, _errorMessage) : Container(),
        SizedBox(height: 15),
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
      radius: BorderRadius.circular(37),
      containerColor: Theme.of(context).primaryColor,
      textColor: CantonColors.white,
      onPressed: () async {
        await context
            .read(authenticationServiceProvider)
            .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            )
            .then((value) {
          if (!['success', 'new', null].contains(value)) {
            print('q');

            // setState(() {
            //   _hasError = true;
            //   _errorMessage = value;
            // });
          } else if (value == 'success') {
            print('m');

            // Phoenix.rebirth(context);
          } else {
            print('n');
            DoNothingAction();
          }
        });
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
      border: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
        width: 1.7,
      ),
      textColor: Theme.of(context).colorScheme.secondaryVariant,
      prefixIcon: Container(
        margin: EdgeInsets.all(10),
        child: FaIcon(
          FontAwesomeIcons.google,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onPressed: () async {
        await context
            .read(authenticationServiceProvider)
            .signInWithGoogle()
            .then((value) {
          if (value == 'failed') {
            setState(() {
              _hasError = true;
              _errorMessage = value;
            });
          } else if (value == 'success') {
            Phoenix.rebirth(context);
          }
        });
      },
    );
  }

  Widget _errorText(BuildContext context, String error) {
    return Text(
      error,
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            color: Theme.of(context).errorColor,
          ),
    );
  }
}
