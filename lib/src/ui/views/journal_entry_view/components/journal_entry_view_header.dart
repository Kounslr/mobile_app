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
            KounslrBackButton(
              isClear: true,
              onPressed: () async {
                await completeEntry();
                Navigator.of(context).pop();
              },
            ),
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: Theme.of(context).textTheme.headline5,
            ),
            KounslrPrimaryButton(
              padding: EdgeInsets.zero,
              containerWidth: 70,
              containerHeight: 30,
              color: Theme.of(context).primaryColor,
              buttonText: 'Save',
              onPressed: () async {
                await completeEntry();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
