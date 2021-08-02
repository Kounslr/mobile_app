import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/authentication_service_provider.dart';

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Theme.of(context).colorScheme.secondaryVariant,
                ),
          ),
          SizedBox(height: 20),
          CantonPrimaryButton(
            buttonText: 'Sign out',
            textColor: CantonColors.white,
            containerColor: Theme.of(context).primaryColor,
            containerWidth: MediaQuery.of(context).size.width / 2 - 34,
            onPressed: () {
              context.read(authenticationServiceProvider).signOut();
            },
          ),
        ],
      ),
    );
  }
}
