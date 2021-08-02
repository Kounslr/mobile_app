import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';

class SignUpView extends StatefulWidget {
  final Function? toggleView;
  const SignUpView({this.toggleView});

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    return CantonScaffold(
      resizeToAvoidBottomInset: true,
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 34),
      body: _content(
        context,
        _emailController,
        _passwordController,
      ),
    );
  }

  Widget _content(
    BuildContext context,
    TextEditingController _emailController,
    TextEditingController _passwordController,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 75),
          _header(context),
          SizedBox(height: 50),
          _emailTextInput(context, _emailController),
          SizedBox(height: 15),
          _passwordTextInput(context, _passwordController),
          SizedBox(height: 15),
          CantonPrimaryButton(
            buttonText: 'Sign Up',
            containerColor: Theme.of(context).primaryColor,
            textColor: CantonColors.white,
            onPressed: () async {
              await context.read(authenticationServiceProvider).signUp(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
            },
          ),
          SizedBox(height: 15),
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

  Widget _emailTextInput(
      BuildContext context, TextEditingController controller) {
    return CantonTextInput(
      hintText: 'Email',
      isTextFormField: true,
      obscureText: false,
      controller: controller,
      textInputType: TextInputType.emailAddress,
      prefixIcon: IconlyIcon(
        IconlyBold.Message,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
    );
  }

  Widget _passwordTextInput(
      BuildContext context, TextEditingController controller) {
    return CantonTextInput(
      hintText: 'Password',
      isTextFormField: true,
      obscureText: true,
      controller: controller,
      prefixIcon: IconlyIcon(
        IconlyBold.Lock,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sign Up',
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ],
    );
  }
}
