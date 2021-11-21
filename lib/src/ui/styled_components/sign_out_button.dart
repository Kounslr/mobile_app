/*
Kounslr iOS & Android App
Copyright (C) 2021 Kounslr

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/providers/authentication_providers/authentication_service_provider.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CantonPrimaryButton(
      buttonText: 'Sign Out',
      textColor: Theme.of(context).primaryColor,
      color: CantonColors.transparent,
      alignment: MainAxisAlignment.center,
      containerWidth: MediaQuery.of(context).size.width / 2 - 5,
      onPressed: () {
        context.read(authenticationServiceProvider).signOut();
      },
    );
  }
}
