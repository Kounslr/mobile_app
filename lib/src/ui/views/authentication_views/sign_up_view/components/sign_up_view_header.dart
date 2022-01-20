import 'package:kounslr_design_system/kounslr_design_system.dart';

class SignUpViewHeader extends StatelessWidget {
  const SignUpViewHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
