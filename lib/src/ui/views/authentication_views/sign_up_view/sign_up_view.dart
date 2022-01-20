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

import 'package:kounslr_design_system/kounslr_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kounslr/src/providers/authentication_providers/authentication_service_provider.dart';
import 'package:kounslr/src/ui/components/error_text.dart';
import 'package:kounslr/src/ui/views/authentication_views/components/email_text_input.dart';
import 'package:kounslr/src/ui/views/authentication_views/components/password_text_input.dart';
import 'package:kounslr/src/ui/views/authentication_views/sign_up_view/components/sign_up_view_header.dart';

class SignUpView extends StatefulWidget {
  final Function? toggleView;
  const SignUpView({this.toggleView, Key? key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  String _errorMessage = '';
  bool _hasError = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KounslrScaffold(
      resizeToAvoidBottomInset: true,
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 34),
      backgroundColor: KounslrMethods.alternateCanvasColorType2(context),
      body: _content(
        context,
        _emailController,
        _passwordController,
      ),
    );
  }

  Widget _content(
      BuildContext context, TextEditingController _emailController, TextEditingController _passwordController) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 75),
          const SignUpViewHeader(),
          const SizedBox(height: 50),
          EmailTextInput(_emailController),
          const SizedBox(height: 15),
          PasswordTextInput(_passwordController),
          const SizedBox(height: 15),
          KounslrPrimaryButton(
            buttonText: 'Sign Up',
            color: Theme.of(context).primaryColor,
            containerWidth: 140,
            containerHeight: 40,
            padding: EdgeInsets.zero,
            borderRadius: const SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 12, cornerSmoothing: 1),
            ),
            onPressed: () async {
              var res = await context.read(authenticationServiceProvider).signUp(
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
          ),
          _hasError ? const SizedBox(height: 15) : Container(),
          _hasError ? ErrorText(_errorMessage) : Container(),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Or Sign In ',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Theme.of(context).colorScheme.secondaryVariant,
                    ),
              ),
              GestureDetector(
                onTap: () => widget.toggleView!(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Here',
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
}
