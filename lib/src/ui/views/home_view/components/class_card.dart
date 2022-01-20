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
import 'package:intl/intl.dart';

import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/models/staff_member.dart';

class ClassCard extends StatelessWidget {
  const ClassCard({required this.schoolClass, required this.block, required this.teacher, Key? key}) : super(key: key);

  final Class schoolClass;
  final Block block;
  final StaffMember teacher;

  @override
  Widget build(BuildContext context) {
    String _className(String? string) {
      if (string == null) {
        return 'Class Name';
      }

      // if (string.length > 21) {
      //   return string.substring(0, 21) + '...';
      // }

      return string;
    }

    String _teacherName(StaffMember teacher) {
      if (teacher.gender != null) {
        String string = teacher.name!.substring(teacher.name!.indexOf(' '));
        if (teacher.gender == 'Male') {
          return 'Mr.' + string;
        }
        return 'Ms.' + string;
      }
      return teacher.name!;
    }

    String _nextClassTime(DateTime date) {
      return DateFormat("h:mm a").format(date).toString();
    }

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _className(schoolClass.name),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Iconsax.clock, size: 17),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    _nextClassTime(block.time!.toLocal()),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Iconsax.location, color: Theme.of(context).colorScheme.secondaryVariant, size: 17),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    schoolClass.roomNumber ?? 'LOCATION',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context).colorScheme.secondaryVariant,
                        ),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Iconsax.user, color: Theme.of(context).colorScheme.secondaryVariant, size: 17),
                const SizedBox(width: 7),
                Flexible(
                  flex: 2,
                  child: Text(
                    _teacherName(teacher),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context).colorScheme.secondaryVariant,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
