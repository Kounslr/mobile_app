import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/ui/providers/student_repository_provider.dart';
import 'package:kounslr/src/ui/views/journal_view/journal_entry_view.dart';

class JournalEntryCard extends ConsumerWidget {
  final JournalEntry journalEntry;
  const JournalEntryCard(this.journalEntry);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return GestureDetector(
      onTap: () =>
          CantonMethods.viewTransition(context, JournalEntryView(journalEntry)),
      child: Slidable(
        key: UniqueKey(),
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        dismissal: SlidableDismissal(
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
                Spacer(),
                Container(),
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
