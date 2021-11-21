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
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/providers/student_repository_provider.dart';
import 'package:kounslr/src/ui/styled_components/journal_entry_card.dart';

class JournalEntryTagCard extends StatefulWidget {
  const JournalEntryTagCard(this.entries, this.tag, {Key? key}) : super(key: key);

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
        _changeTagNameAction(context),
      ],
      child: Column(
        children: [
          const Divider(),
          CantonExpansionTile(
            childrenPadding: const EdgeInsets.all(8.0),
            iconColor: Theme.of(context).primaryColor,
            title: Text(
              widget.tag.name!,
              style: Theme.of(context).textTheme.headline6,
            ),
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _changeTagNameAction(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(),
      color: Theme.of(context).colorScheme.secondary,
      child: SlideAction(
        child: IconlyIcon(
          IconlyBold.EditSquare,
          size: 27,
          color: Theme.of(context).colorScheme.secondaryVariant,
        ),
        onTap: () => _showTagRenameBottomSheet(),
      ),
    );
  }

  Future<void> _showTagRenameBottomSheet() async {
    var _tagRenameController = TextEditingController();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      useRootNavigator: true,
      builder: (context) {
        return Consumer(
          builder: (context, watch, child) {
            return StatefulBuilder(builder: (context, setState) {
              return GestureDetector(
                onTap: () {
                  CantonMethods.defocusTextfield(context);
                },
                child: Container(
                  padding: MediaQuery.of(context).viewInsets,
                  decoration: ShapeDecoration(
                    color: MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? Theme.of(context).colorScheme.onSecondary
                        : Theme.of(context).canvasColor,
                    shape: SquircleBorder(
                      radius: BorderRadius.circular(50),
                    ),
                  ),
                  child: FractionallySizedBox(
                    heightFactor: 0.45,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 5,
                            width: 50,
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            'Rename Tag',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          const SizedBox(height: 7.5),
                          const Divider(),
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 17),
                            child: CantonTextInput(
                              formatters: [
                                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                LengthLimitingTextInputFormatter(10),
                              ],
                              textInputType: TextInputType.text,
                              isTextFormField: true,
                              obscureText: false,
                              hintText: 'Name...',
                              controller: _tagRenameController,
                            ),
                          ),
                          const SizedBox(height: 15),
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
                  ),
                ),
              );
            });
          },
        );
      },
    );
  }
}
