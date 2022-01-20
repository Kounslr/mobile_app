import 'package:kounslr_design_system/kounslr_design_system.dart';

class SignInViewHeader extends StatelessWidget {
  const SignInViewHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
