import 'package:canton_design_system/canton_design_system.dart';

class AddStudentsSearchBar extends StatelessWidget {
  const AddStudentsSearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: CantonTextInput(
        hintText: 'Search in Students',
        textInputType: TextInputType.text,
        isTextFormField: false,
        obscureText: false,
        prefixIcon: IconlyIcon(
          IconlyBold.Search,
          color: Theme.of(context).colorScheme.secondaryVariant,
        ),
      ),
    );
  }
}
