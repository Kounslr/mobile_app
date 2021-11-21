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
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/providers/student_repository_provider.dart';
import 'package:kounslr/src/ui/views/journal_view/journal_entry_view.dart';

class JournalEntryCard extends ConsumerWidget {
  final JournalEntry journalEntry;
  const JournalEntryCard(this.journalEntry, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return GestureDetector(
      onTap: () => CantonMethods.viewTransition(context, JournalEntryView(journalEntry)),
      child: Slidable(
        key: UniqueKey(),
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        dismissal: const SlidableDismissal(
          child: SlidableDrawerDismissal(),
          dismissThresholds: <SlideActionType, double>{
            SlideActionType.primary: 1.0,
            SlideActionType.secondary: 1.0,
          },
        ),
        secondaryActions: <Widget>[
          _deleteEntryAction(context, journalEntry),
        ],
        child: Card(
          color: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        journalEntry.title!,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        journalEntry.summary!,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _deleteEntryAction(BuildContext context, JournalEntry entry) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 5),
      child: Material(
        color: Theme.of(context).colorScheme.onError,
        shape: SquircleBorder(
          radius: BorderRadius.circular(35),
        ),
        child: SlideAction(
          child: IconlyIcon(
            IconlyBold.Delete,
            size: 27,
            color: Theme.of(context).colorScheme.error,
          ),
          onTap: () => {
            context.read(studentRepositoryProvider).deleteJournalEntry(entry),
          },
        ),
      ),
    );
  }
}
