import 'package:canton_design_system/canton_design_system.dart';

class PasswordTextInput extends StatelessWidget {
  const PasswordTextInput(this.controller, {Key? key}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CantonTextInput(
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
