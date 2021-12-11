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

import 'package:kounslr/src/ui/views/journal_entries_view/components/journal_entries_list_view.dart';
import 'package:kounslr/src/ui/views/journal_entries_view/components/journal_entries_view_header.dart';

class JournalEntriesView extends StatefulWidget {
  const JournalEntriesView(this.allEntries, {Key? key}) : super(key: key);

  final Map<String?, int?> allEntries;

  @override
  _JournalEntriesViewState createState() => _JournalEntriesViewState();
}

class _JournalEntriesViewState extends State<JournalEntriesView> {
  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        const JournalEntriesViewHeader(),
        const SizedBox(height: 10),
        Text(
          'Please enter text in all text fields of the Journal Entry to submit a valid entry.',
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        JournalEntriesListView(widget.allEntries)
      ],
    );
  }
}
