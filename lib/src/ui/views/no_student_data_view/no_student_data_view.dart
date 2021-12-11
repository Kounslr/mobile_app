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

import 'package:kounslr/src/ui/components/sign_in_with_studentvue_card.dart';
import 'package:kounslr/src/ui/views/no_student_data_view/components/no_student_data_view_header.dart';

class NoStudentDataView extends StatelessWidget {
  const NoStudentDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(body: _content(context));
  }

  Widget _content(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      child: Column(
        children: const [NoStudentDataViewHeader(), Expanded(child: SignInWithStudentVueCard())],
      ),
    );
  }
}
