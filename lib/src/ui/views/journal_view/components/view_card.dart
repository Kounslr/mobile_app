import 'package:canton_design_system/canton_design_system.dart';

class ViewCard extends StatelessWidget {
  const ViewCard({required this.view, required this.text, Key? key}) : super(key: key);

  final Widget view;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CantonMethods.viewTransition(context, view),
      child: Container(
        padding: const EdgeInsets.only(top: 17, left: 17, right: 17),
        child: Card(
          color: Theme.of(context).colorScheme.secondary,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.headline6!.copyWith(),
                ),
                const Spacer(),
                Icon(
                  Iconsax.arrow_right_3,
                  size: 20,
                  color: Theme.of(context).colorScheme.secondaryVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
