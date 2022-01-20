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

import 'package:kounslr_design_system/kounslr_design_system.dart';

import 'package:kounslr/src/ui/components/show_sign_in_with_studentvue_bottomsheet.dart';
import 'package:kounslr/src/ui/components/sign_out_button.dart';

class SignInWithStudentVueCard extends StatefulWidget {
  const SignInWithStudentVueCard({Key? key}) : super(key: key);

  @override
  _SignInWithStudentVueCardState createState() => _SignInWithStudentVueCardState();
}

class _SignInWithStudentVueCardState extends State<SignInWithStudentVueCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
            text: 'Sign in with ',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Theme.of(context).colorScheme.secondaryVariant,
                ),
            children: [
              TextSpan(
                text: 'StudentVue ',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const TextSpan(text: 'to take full advantage of Kounslr'),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        KounslrPrimaryButton(
          buttonText: 'Sign in',
          color: Theme.of(context).primaryColor,
          containerWidth: MediaQuery.of(context).size.width / 2 - 34,
          onPressed: () => showStudentVueSignInBottomSheet(context),
        ),
        const SizedBox(height: 20),
        const SignOutButton(),
      ],
    );
  }
}
