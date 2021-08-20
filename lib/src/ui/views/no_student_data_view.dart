import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/ui/styled_components/sign_in_with_studentvue_card.dart';

class NoStudentDataView extends StatelessWidget {
  const NoStudentDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        children: [
          _header(context),
          Expanded(
            child: SignInWithStudentVueCard(),
          )
        ],
      ),
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
        Spacer(),
        CantonHeaderButton(
          backgroundColor: CantonColors.transparent,
        ),
      ],
    );
  }
}
