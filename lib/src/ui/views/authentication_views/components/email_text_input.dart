import 'package:canton_design_system/canton_design_system.dart';

class EmailTextInput extends StatelessWidget {
  const EmailTextInput(this.controller, {Key? key}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CantonTextInput(
      hintText: 'Email',
      isTextFormField: true,
      obscureText: false,
      controller: controller,
      textInputType: TextInputType.emailAddress,
      prefixIcon: Icon(
        Iconsax.message,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
    );
  }
}
