import 'package:canton_design_system/canton_design_system.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField({required this.focus, required this.controller, Key? key}) : super(key: key);

  final FocusNode focus;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focus,
      cursorColor: Theme.of(context).primaryColor,
      controller: controller,
      maxLines: null,
      scrollController: ScrollController(),
      onChanged: (_) {},
      style: Theme.of(context).textTheme.headline3,
      decoration: InputDecoration(
        hintText: 'Title',
        fillColor: CantonColors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintStyle:
            Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).colorScheme.secondaryVariant),
      ),
    );
  }
}
