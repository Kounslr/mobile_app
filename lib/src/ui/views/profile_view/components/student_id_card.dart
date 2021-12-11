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
import 'package:kounslr/src/ui/views/profile_view/student_id_card_view.dart';

class StudentIdCard extends StatelessWidget {
  const StudentIdCard({required this.school, required this.student, Key? key}) : super(key: key);

  final Student student;
  final School school;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CantonMethods.viewTransition(context, StudentIDCardView(student, school));
      },
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.zero,
            shape: const SquircleBorder(
              radius: BorderRadius.vertical(
                top: Radius.circular(37),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Text(
                    'ID Card',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const Spacer(),
                  Icon(
                    Iconsax.card,
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
