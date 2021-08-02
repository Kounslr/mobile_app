import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';

class SignInWithStudentVueCard extends StatefulWidget {
  const SignInWithStudentVueCard({Key? key}) : super(key: key);

  @override
  _SignInWithStudentVueCardState createState() =>
      _SignInWithStudentVueCardState();
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
              TextSpan(text: 'to take full advantage of Kounslr')
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        CantonPrimaryButton(
          buttonText: 'Sign in',
          textColor: CantonColors.white,
          containerColor: Theme.of(context).primaryColor,
          containerWidth: MediaQuery.of(context).size.width / 2 - 34,
          onPressed: () => _showStudentVueSignInBottomSheet(),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            context.read(authenticationServiceProvider).signOut();
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Sign out',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _showStudentVueSignInBottomSheet() async {
    var _emailController = TextEditingController();
    var _passwordController = TextEditingController();
    var hasResult = true;
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
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 27),
                  child: FractionallySizedBox(
                    heightFactor: 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 5,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Sign in to StudentVue',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(height: 20),
                        CantonTextInput(
                          isTextFormField: true,
                          obscureText: false,
                          hintText: 'Email',
                          textInputType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                        SizedBox(height: 15),
                        CantonTextInput(
                          isTextFormField: true,
                          obscureText: true,
                          hintText: 'Password',
                          textInputType: TextInputType.visiblePassword,
                          controller: _passwordController,
                        ),
                        SizedBox(height: 15),
                        CantonPrimaryButton(
                          onPressed: () async {
                            await watch(authenticationServiceProvider)
                                .studentVueSignIn(
                              email: _emailController.text,
                              password: _passwordController.text,
                            )
                                .then((value) {
                              if (value != 'success') {
                                setState(() {
                                  hasResult = false;
                                });
                              } else {
                                hasResult = true;
                              }

                              if (hasResult) {
                                Phoenix.rebirth(context);
                              }
                            });
                          },
                          buttonText: 'Sign in',
                          textColor: CantonColors.white,
                          containerWidth: MediaQuery.of(context).size.width / 4,
                          containerHeight: 47,
                          radius: BorderRadius.circular(37),
                          containerPadding: const EdgeInsets.all(10),
                        ),
                        SizedBox(height: 20),
                        hasResult == false
                            ? Text(
                                'Incorrect email or password',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                              )
                            : Container(),
                      ],
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
