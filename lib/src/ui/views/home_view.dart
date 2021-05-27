import 'dart:math' as math;
// import 'dart:developer' as dev;

import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/ui/styled_components/assignment_card.dart';
import 'package:kounslr/src/ui/styled_components/current_date_card.dart';
import 'package:kounslr/src/ui/styled_components/next_class_card.dart';
import 'package:kounslr/src/ui/views/student_id_card_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        _header(context),
        SizedBox(height: 10),
        CurrentDateCard(),
        SizedBox(height: 10),
        NextClassCard(),
        SizedBox(height: 10),

        // ListView controls
        Row(
          children: [
            Text(
              'Upcoming Assignments',
              style: Theme.of(context).textTheme.headline6,
            ),
            Spacer(),
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
                'View All',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
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
        // List View of assignments
        Expanded(
          // flex: 10,
          //height: 375,
          child: ListView.separated(
            itemCount: 5,
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 6);
            },
            itemBuilder: (context, index) {
              return AssignmentCard();
            },
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hey,',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
            ),
            Text(
              'TEST',
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        Spacer(),
        CantonHeaderButton(
          icon: Transform(
            // Flips icon 180 degrees so it looks more like an info button
            transform: Matrix4.rotationZ(math.pi),
            alignment: FractionalOffset.center,
            child: IconlyIcon(
              IconlyBold.InfoCircle,
              color: Theme.of(context).colorScheme.secondaryVariant,
            ),
          ),
          onPressed: () => CantonMethods.viewTransition(
            context,
            StudentIDCardView(),
          ),
        ),
      ],
    );
  }
}
