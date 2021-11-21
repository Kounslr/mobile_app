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
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/providers/authentication_providers/authentication_service_provider.dart';
import 'package:kounslr/src/ui/styled_components/sign_out_button.dart';

class SignInWithStudentVueCard extends StatefulWidget {
  const SignInWithStudentVueCard({Key? key}) : super(key: key);

  @override
  _SignInWithStudentVueCardState createState() => _SignInWithStudentVueCardState();
}

class _SignInWithStudentVueCardState extends State<SignInWithStudentVueCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
            text: 'Sign in with ',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Theme.of(context).colorScheme.secondaryVariant,
                ),
            children: [
              TextSpan(
                text: 'StudentVue ',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const TextSpan(text: 'to take full advantage of Kounslr')
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        CantonPrimaryButton(
          buttonText: 'Sign in',
          color: Theme.of(context).primaryColor,
          containerWidth: MediaQuery.of(context).size.width / 2 - 34,
          onPressed: () => _showStudentVueSignInBottomSheet(),
        ),
        const SizedBox(height: 20),
        const SignOutButton(),
      ],
    );
  }

  Future<void> _showStudentVueSignInBottomSheet() async {
    var _emailController = TextEditingController();
    var _passwordController = TextEditingController();
    var result = '';
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      useRootNavigator: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Consumer(
              builder: (context, watch, child) {
                return GestureDetector(
                  onTap: () {
                    CantonMethods.defocusTextfield(context);
                  },
                  child: Container(
                    decoration: ShapeDecoration(
                      color: MediaQuery.of(context).platformBrightness == Brightness.dark
                          ? Theme.of(context).colorScheme.onSecondary
                          : Theme.of(context).canvasColor,
                      shape: SquircleBorder(
                        radius: BorderRadius.circular(50),
                      ),
                    ),
                    padding: MediaQuery.of(context).viewInsets,
                    child: FractionallySizedBox(
                      heightFactor: 0.95,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 15),
                              child: Container(
                                height: 5,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 27),
                              child: Text(
                                'Sign in to StudentVue',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Divider(),
                            const SizedBox(height: 15),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 17),
                              child: CantonTextInput(
                                isTextFormField: true,
                                obscureText: false,
                                hintText: 'Email',
                                textInputType: TextInputType.emailAddress,
                                controller: _emailController,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 17),
                              child: CantonTextInput(
                                isTextFormField: true,
                                obscureText: true,
                                hintText: 'Password',
                                textInputType: TextInputType.visiblePassword,
                                controller: _passwordController,
                              ),
                            ),
                            const SizedBox(height: 15),
                            CantonPrimaryButton(
                              color: Theme.of(context).primaryColor,
                              buttonText: 'Sign in',
                              containerWidth: MediaQuery.of(context).size.width / 4,
                              containerHeight: 47,
                              padding: const EdgeInsets.all(10),
                              onPressed: () async {
                                setState(() {
                                  result = 'Loading...';
                                });

                                var res = await watch(authenticationServiceProvider).studentVueSignIn(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );

                                setState(() {
                                  result = res;
                                });

                                if (result == 'success') {
                                  Phoenix.rebirth(context);
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            result != ''
                                ? result == 'failed'
                                    ? Text(
                                        'Incorrect email or password',
                                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                              color: Theme.of(context).colorScheme.error,
                                            ),
                                      )
                                    : Text(
                                        result,
                                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                              color: Theme.of(context).colorScheme.background,
                                            ),
                                      )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
