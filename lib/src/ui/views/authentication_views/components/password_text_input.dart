import 'package:kounslr_design_system/kounslr_design_system.dart';

class PasswordTextInput extends StatelessWidget {
  const PasswordTextInput(this.controller, {Key? key}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return KounslrTextInput(
      hintText: 'Password',
      isTextFormField: true,
      obscureText: true,
      controller: controller,
      textInputType: TextInputType.visiblePassword,
      prefixIcon: Icon(
        Iconsax.lock,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
    );
  }
}
