import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/ui/providers/student_repository_provider.dart';
import 'package:kounslr/src/ui/styled_components/journal_entry_card.dart';

class JournalEntryTagCard extends StatefulWidget {
  const JournalEntryTagCard(this.entries, this.tag);

  final List<JournalEntry> entries;
  final Tag tag;

  @override
  _JournalEntryTagCardState createState() => _JournalEntryTagCardState();
}

class _JournalEntryTagCardState extends State<JournalEntryTagCard> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    for (var entry in widget.entries) {
      children.add(JournalEntryCard(entry));
    }

    return Slidable(
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
        _changeTagNameAction(context),
      ],
      child: Card(
        child: CantonExpansionTile(
          childrenPadding: const EdgeInsets.all(8.0),
          iconColor: Theme.of(context).primaryColor,
          title: Text(
            widget.tag.name!,
            style: Theme.of(context).textTheme.headline6,
          ),
          children: children,
        ),
      ),
    );
  }

  Widget _changeTagNameAction(
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 5),
      child: Material(
        color: Theme.of(context).colorScheme.secondary,
        shape: SquircleBorder(
          radius: BorderRadius.circular(35),
        ),
        child: SlideAction(
          child: IconlyIcon(
            IconlyBold.EditSquare,
            size: 27,
            color: Theme.of(context).colorScheme.secondaryVariant,
          ),
          onTap: () => _showTagRenameBottomSheet(),
        ),
      ),
    );
  }

  Future<void> _showTagRenameBottomSheet() async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      useRootNavigator: true,
      builder: (context) {
        return Consumer(
          builder: (context, watch, child) {
            var _tagRenameController = TextEditingController();
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 27),
              child: FractionallySizedBox(
                heightFactor: 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Rename Tag',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(height: 20),
                    CantonTextInput(
                      formatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      isTextFormField: true,
                      obscureText: false,
                      hintText: 'Name...',
                      controller: _tagRenameController,
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        watch(studentRepositoryProvider).renameJournalEntryTags(
                          widget.entries,
                          widget.tag,
                          Tag(name: _tagRenameController.text),
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Done',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
