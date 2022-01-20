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
import 'package:kounslr/src/ui/views/journal_entry_view/journal_entry_view.dart';

class JournalEntryCard extends ConsumerWidget {
  const JournalEntryCard(this.journalEntry, this.allEntries, {Key? key}) : super(key: key);

  final JournalEntry journalEntry;
  final Map<String?, int?> allEntries;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    String title() {
      if (['', null].contains(journalEntry.title)) {
        return 'Untitled Entry';
      }
      return journalEntry.title!;
    }

    String summary() {
      if (['', null].contains(journalEntry.summary)) {
        return 'No additional context.';
      }
      return journalEntry.summary!;
    }

    return GestureDetector(
      onTap: () => CantonMethods.viewTransition(context, JournalEntryView(journalEntry, allEntries)),
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
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title(),
                        style: Theme.of(context).textTheme.headline6,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        summary(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
      margin: const EdgeInsets.only(top: 7, bottom: 7, right: 12),
      child: Material(
        color: Theme.of(context).colorScheme.onError,
        shape: SquircleBorder(
          radius: BorderRadius.circular(35),
        ),
        child: SlideAction(
          child: Icon(
            Iconsax.trash,
            size: 27,
            color: Theme.of(context).colorScheme.error,
          ),
          onTap: () {
            context.read(studentRepositoryProvider).deleteJournalEntry(entry);
          },
        ),
      ),
    );
  }
}
