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
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/ui/views/journal_entry_view/journal_entry_view.dart';

class JournalViewHeader extends StatelessWidget {
  const JournalViewHeader(this.allEntries, {Key? key}) : super(key: key);

  final Map<String?, int?> allEntries;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 17, left: 17, right: 17),
      child: ViewHeaderOne(
        title: 'Journal',
        button: CantonHeaderButton(
            isClear: true,
            icon: Icon(
              Iconsax.message_edit,
              color: Theme.of(context).primaryColor,
              size: 27,
            ),
            onPressed: () {
              CantonMethods.viewTransition(context, JournalEntryView(JournalEntry(), allEntries));
            }),
      ),
    );
  }
}
