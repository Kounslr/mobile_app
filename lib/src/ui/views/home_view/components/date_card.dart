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
import 'package:intl/intl.dart';
import 'package:kounslr/src/models/school.dart';

class DateCard extends StatelessWidget {
  const DateCard({required this.school, Key? key}) : super(key: key);

  final School school;

  @override
  Widget build(BuildContext context) {
    String dayType() {
      if (school.currentDay?.dayType == null || [6, 7].contains(DateTime.now().weekday)) return '';

      return (school.currentDay?.dayType ?? '') + ' Day';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Text.rich(
        TextSpan(
          text: DateFormat.yMMMMEEEEd().format(
            DateTime.now(),
          ),
          children: [
            TextSpan(
              text: dayType() != '' ? ' • ' : '',
            ),
            TextSpan(
                text: dayType(),
                style: Theme.of(context).textTheme.headline6?.copyWith(color: Theme.of(context).primaryColor)),
          ],
        ),
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
