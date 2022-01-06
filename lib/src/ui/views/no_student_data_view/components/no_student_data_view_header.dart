import 'package:canton_design_system/canton_design_system.dart';

class NoStudentDataViewHeader extends StatelessWidget {
  const NoStudentDataViewHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hey,',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
            ),
            Text(
              'There 👋',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        const Spacer(),
        const CantonHeaderButton(backgroundColor: CantonColors.transparent),
      ],
    );
  }
}
