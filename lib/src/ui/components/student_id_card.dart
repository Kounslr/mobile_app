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

import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/student.dart';

class StudentIDCard extends StatelessWidget {
  final Student student;
  final School school;

  const StudentIDCard(this.student, this.school, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  // ClipSquircleBorder(
                  //   radius: BorderRadius.circular(40),
                  //   child: Container(
                  //     height: 80,
                  //     width: 80,
                  //     color: Theme.of(context).colorScheme.secondary,
                  //   ),
                  // ),
                  // const SizedBox(width: 15),
                  Text(
                    school.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline5!.copyWith(color: KounslrColors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleUserText(context, 'Name', student.name!),
                _titleUserText(context, 'Grade', student.grade!),
                _titleUserText(context, 'ID', student.studentId!)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleUserText(
    BuildContext context,
    String title,
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
        ),
        Text(
          _contentText(description),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: KounslrColors.white,
              ),
        ),
      ],
    );
  }

  String _contentText(String string) {
    if (string.length > 23) {
      return string.substring(0, 20) + '...';
    }
    return string;
  }
}
