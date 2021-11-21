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
import 'package:intl/intl.dart';

class JournalEntryViewHeader extends StatelessWidget {
  const JournalEntryViewHeader({required this.completeEntry, Key? key}) : super(key: key);

  final Future<void> Function() completeEntry;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CantonBackButton(isClear: true),
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: Theme.of(context).textTheme.headline5,
            ),
            GestureDetector(
              onTap: () {
                completeEntry();
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: SquircleBorder(
                    radius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Save',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.w500, color: CantonColors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
