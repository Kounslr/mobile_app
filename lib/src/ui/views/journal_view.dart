import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';

class JournalView extends StatefulWidget {
  @override
  _JournalViewState createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Column(
          children: [
            _header(context),
            CantonPrimaryButton(
              buttonText: 'Sign out',
              textColor: CantonColors.white,
              containerColor: Theme.of(context).primaryColor,
              containerWidth: MediaQuery.of(context).size.width / 2 - 34,
              onPressed: () {
                context.read(authenticationServiceProvider).signOut(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Text(
          'Journal',
          style: Theme.of(context).textTheme.headline2.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
        Spacer(),
        CantonHeaderButton(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(
            FeatherIcons.plus,
            color: CantonColors.white,
            size: 24,
          ),
          onPressed: () => CantonMethods.viewTransition(
            context,
            JournalEntryView(),
          ),
        ),
      ],
    );
  }
}
