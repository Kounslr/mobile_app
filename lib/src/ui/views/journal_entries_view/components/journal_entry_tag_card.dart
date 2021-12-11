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
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/ui/views/journal_entries_view/components/journal_entry_card.dart';
import 'package:kounslr/src/ui/views/journal_entries_view/components/show_tag_rename_bottom_sheet.dart';

class JournalEntryTagCard extends StatefulWidget {
  const JournalEntryTagCard(this.entries, this.tag, {this.radius, required this.allEntries, Key? key})
      : super(key: key);

  final List<JournalEntry> entries;
  final Map<String?, int?> allEntries;
  final Tag tag;
  final BorderRadius? radius;

  @override
  _JournalEntryTagCardState createState() => _JournalEntryTagCardState();
}

class _JournalEntryTagCardState extends State<JournalEntryTagCard> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    for (var entry in widget.entries) {
      children.add(JournalEntryCard(entry, widget.allEntries));
    }

    Widget _changeTagNameAction(BuildContext context) {
      return Container(
        margin: EdgeInsets.zero,
        color: Theme.of(context).colorScheme.onSecondary,
        child: SlideAction(
          child: Icon(
            Iconsax.edit,
            size: 27,
            color: Theme.of(context).colorScheme.secondaryVariant,
          ),
          onTap: () => showTagRenameBottomSheet(context, widget.entries, widget.tag),
        ),
      );
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
      child: CantonExpansionTile(
        iconColor: Theme.of(context).primaryColor,
        decoration: ShapeDecoration(
          color: CantonMethods.alternateCanvasColorType2(context),
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.only(
              topLeft: SmoothRadius(cornerSmoothing: 1, cornerRadius: widget.radius!.topLeft.x),
              topRight: SmoothRadius(cornerSmoothing: 1, cornerRadius: widget.radius!.topRight.x),
              bottomLeft: SmoothRadius(cornerSmoothing: 1, cornerRadius: widget.radius!.bottomLeft.x),
              bottomRight: SmoothRadius(cornerSmoothing: 1, cornerRadius: widget.radius!.bottomRight.x),
            ),
          ),
        ),
        title: Text(
          widget.tag.name!,
          style: Theme.of(context).textTheme.headline6,
        ),
        children: [...children, const SizedBox(height: 5)],
      ),
    );
  }
}
