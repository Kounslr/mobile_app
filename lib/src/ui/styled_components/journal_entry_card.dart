import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kounslr/src/models/journal_entry.dart';

class JournalEntryCard extends ConsumerWidget {
  final JournalEntry journalEntry;
  const JournalEntryCard(this.journalEntry);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return GestureDetector(
      child: Slidable(
        key: UniqueKey(),
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        dismissal: SlidableDismissal(
          child: SlidableDrawerDismissal(),
          dismissThresholds: <SlideActionType, double>{
            SlideActionType.primary: 1.0
          },
          onDismissed: (direction) {
            if (direction == SlideActionType.secondary) {}
          },
          // DeleteNoteAction(repo, note);
        ),
        actions: <Widget>[
          // PinNoteAction(repo, note),
        ],
        secondaryActions: <Widget>[
          // DeleteNoteAction(repo, note),
        ],
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  journalEntry.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 7),
                Text(
                  journalEntry.summary,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
