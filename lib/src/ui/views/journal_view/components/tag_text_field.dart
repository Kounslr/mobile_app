import 'package:canton_design_system/canton_design_system.dart';

class TagTextField extends StatelessWidget {
  const TagTextField({required this.tags});

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    var initTags = <String>[];

    for (final tag in tags) {
      initTags.add(tag.name!);
    }

    return CantonTagTextInput(
      initialTags: initTags,
      maxCharactersPerTag: 13,
      maxTags: 3,
      textFieldStyler: TagTextInputStyler(
        cursorColor: Theme.of(context).primaryColor,
        hintText: 'Tags',
        textFieldFilledColor: Theme.of(context).colorScheme.onSecondary,
        textFieldFilled: true,
        textFieldEnabledBorder: SquircleInputBorder(
          radius: BorderRadius.all(Radius.circular(35)),
          side: BorderSide(
            color: CantonColors.transparent,
            width: 1.5,
          ),
        ),
        textFieldBorder: SquircleInputBorder(
          radius: BorderRadius.all(Radius.circular(35)),
          side: BorderSide(
            color: CantonColors.transparent,
            width: 1.5,
          ),
        ),
        textFieldFocusedBorder: SquircleInputBorder(
          radius: BorderRadius.all(Radius.circular(35)),
          side: BorderSide(
            color: CantonColors.transparent,
            width: 1.5,
          ),
        ),
        textFieldDisabledBorder: SquircleInputBorder(
          radius: BorderRadius.all(Radius.circular(35)),
          side: BorderSide(
            color: CantonColors.transparent,
            width: 1.5,
          ),
        ),
      ),
      tagsStyler: TagsStyler(
        tagCancelIcon: Icon(FeatherIcons.x, color: CantonColors.white),
        tagDecoration: ShapeDecoration(
            color: Theme.of(context).primaryColor,
            shape: SquircleBorder(radius: BorderRadius.circular(20))),
        tagTextStyle: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: CantonColors.white),
      ),
      onDelete: (name) {
        tags.remove(Tag(name: name));
      },
      onTag: (name) {
        tags.add(Tag(name: name));
      },
    );
  }
}
