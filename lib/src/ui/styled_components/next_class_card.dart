import 'package:canton_design_system/canton_design_system.dart';

class NextClassCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('Next Class', style: Theme.of(context).textTheme.headline6),
            const Spacer(),
            TextButton(
              style: ButtonStyle(
                alignment: Alignment.centerRight,
                animationDuration: Duration.zero,
                elevation: MaterialStateProperty.all<double>(0),
                overlayColor: MaterialStateProperty.all<Color>(
                  CantonColors.transparent,
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.zero,
                ),
              ),
              child: Text(
                'View Full Schedule',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor),
              ),
              onPressed: () {},
            ),
            CantonActionButton(
              icon: IconlyIcon(
                IconlyBold.ArrowRight2,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CLASS',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        IconlyIcon(
                          IconlyBold.Location,
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          size: 17,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'LOCATION',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryVariant,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconlyIcon(
                          IconlyBold.Profile,
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          size: 17,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'TEACHER',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryVariant,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  'TIME',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
