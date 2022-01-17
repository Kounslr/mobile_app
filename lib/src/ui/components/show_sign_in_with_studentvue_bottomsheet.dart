import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/providers/authentication_providers/authentication_service_provider.dart';

var studentVueSignInResult = '';
Future<void> showStudentVueSignInBottomSheet(BuildContext context) async {
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  return await showModalBottomSheet(
    context: context,
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
                    color: CantonMethods.alternateCanvasColor(context),
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
                            padding: EdgeInsets.zero,
                            child: CantonTextInput(
                              isTextFormField: true,
                              obscureText: false,
                              hintText: 'Username',
                              textInputType: TextInputType.name,
                              controller: _usernameController,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 17),
                            padding: EdgeInsets.zero,
                            child: CantonTextInput(
                              isTextFormField: true,
                              obscureText: true,
                              hintText: 'Password',
                              textInputType: TextInputType.visiblePassword,
                              controller: _passwordController,
                            ),
                          ),
                          const SizedBox(height: 15),
                          studentVueSignInResult != ''
                              ? studentVueSignInResult != 'failed'
                                  ? const CupertinoActivityIndicator()
                                  : CantonPrimaryButton(
                                      color: Theme.of(context).primaryColor,
                                      buttonText: 'Sign in',
                                      containerWidth: MediaQuery.of(context).size.width / 4,
                                      containerHeight: 47,
                                      padding: const EdgeInsets.all(10),
                                      onPressed: () async {
                                        setState(() {
                                          studentVueSignInResult = 'Loading...';
                                        });

                                        var res = await watch(authenticationServiceProvider).studentVueSignIn(
                                          username: _usernameController.text,
                                          password: _passwordController.text,
                                          setState: setState,
                                        );

                                        setState(() {
                                          studentVueSignInResult = res;
                                        });

                                        if (studentVueSignInResult == 'success') {
                                          Phoenix.rebirth(context);
                                        }
                                      },
                                    )
                              : CantonPrimaryButton(
                                  color: Theme.of(context).primaryColor,
                                  buttonText: 'Sign in',
                                  containerWidth: MediaQuery.of(context).size.width / 4,
                                  containerHeight: 47,
                                  padding: const EdgeInsets.all(10),
                                  onPressed: () async {
                                    setState(() {
                                      studentVueSignInResult = 'Loading...';
                                    });

                                    var res = await watch(authenticationServiceProvider).studentVueSignIn(
                                      username: _usernameController.text,
                                      password: _passwordController.text,
                                      setState: setState,
                                    );

                                    setState(() {
                                      studentVueSignInResult = res;
                                    });

                                    if (studentVueSignInResult == 'success' ||
                                        studentVueSignInResult.contains('You\'re')) {
                                      Phoenix.rebirth(context);
                                    }
                                  },
                                ),
                          const SizedBox(height: 20),
                          studentVueSignInResult != 'success'
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 17),
                                  child: Text(
                                    studentVueSignInResult,
                                    style: Theme.of(context).textTheme.bodyText1,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Container(),
                          SizedBox(height: MediaQuery.of(context).viewInsets.bottom * 3),
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
