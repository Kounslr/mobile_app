import 'package:canton_design_system/canton_design_system.dart';

class ViewCard extends StatelessWidget {
  const ViewCard({required this.view, required this.text});

  final Widget view;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CantonMethods.viewTransition(context, view),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.headline6!.copyWith(),
              ),
              Spacer(),
              IconlyIcon(
                IconlyBold.ArrowRight1,
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
