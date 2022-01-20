import 'package:kounslr_design_system/kounslr_design_system.dart';

class EmailTextInput extends StatelessWidget {
  const EmailTextInput(this.controller, {Key? key}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return KounslrTextInput(
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
