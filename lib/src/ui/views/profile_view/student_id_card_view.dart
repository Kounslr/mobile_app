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

import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/ui/components/student_id_card.dart';
import 'package:kounslr/src/ui/views/profile_view/components/student_id_card_view_header.dart';

class StudentIDCardView extends StatelessWidget {
  final Student student;
  final School school;

  const StudentIDCardView(this.student, this.school, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CantonScaffold(backgroundColor: CantonMethods.alternateCanvasColor(context), body: _content(context));
  }

  Widget _content(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const StudentIdCardViewHeader(),
        _body(context, student),
        Container(height: 70),
      ],
    );
  }

  Widget _body(BuildContext context, Student student) {
    return Column(
      children: [
        StudentIDCard(student, school),
        // const SizedBox(height: 80),

        /// Implement Custom API with student Auth verification & QR Code capabilities
        // QrImage(
        //   data: 'https://www.kounslr.com',
        //   version: QrVersions.auto,
        //   backgroundColor: CantonColors.bgPrimary,
        //   size: 100,
        // ),
      ],
    );
  }
}
