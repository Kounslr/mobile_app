/*
Kounslr iOS & Android App
Copyright (C) 2021 Kounslr

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/providers/authentication_providers/authentication_service_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kounslr/src/ui/components/error_text.dart';
import 'package:kounslr/src/ui/views/authentication_views/components/email_text_input.dart';
import 'package:kounslr/src/ui/views/authentication_views/components/password_text_input.dart';
import 'package:kounslr/src/ui/views/authentication_views/sign_in_view/components/sign_in_view_header.dart';

class SignInView extends StatefulWidget {
  final Function? toggleView;
  const SignInView({this.toggleView, Key? key}) : super(key: key);

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

  Widget _content(
    BuildContext context,
    TextEditingController _emailController,
    TextEditingController _passwordController,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 75),
          const SignInViewHeader(),
          const SizedBox(height: 40),
          EmailTextInput(_emailController),
          const SizedBox(height: 15),
          PasswordTextInput(_passwordController),
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

  Widget _signInButton(
    BuildContext context,
    TextEditingController _emailController,
    TextEditingController _passwordController,
  ) {
    return CantonPrimaryButton(
      buttonText: 'Sign In',
      color: Theme.of(context).primaryColor,
      onPressed: () async {
        var res = await context.read(authenticationServiceProvider).signInWithEmailAndPassword(
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
      color: Theme.of(context).colorScheme.onSecondary,
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
        var res = await context.read(authenticationServiceProvider).signInWithGoogle();

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
