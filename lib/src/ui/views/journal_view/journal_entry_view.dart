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
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/providers/student_repository_provider.dart';
import 'package:kounslr/src/ui/views/journal_view/components/journal_entry_view_header.dart';
import 'package:kounslr/src/ui/views/journal_view/components/summary_text_field.dart';
import 'package:kounslr/src/ui/views/journal_view/components/tag_text_field.dart';
import 'package:kounslr/src/ui/views/journal_view/components/title_text_field.dart';

class JournalEntryView extends StatefulWidget {
  final JournalEntry entry;
  const JournalEntryView(this.entry, {Key? key}) : super(key: key);

  @override
  _JournalEntryViewState createState() => _JournalEntryViewState();
}

class _JournalEntryViewState extends State<JournalEntryView> {
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _titleFocus = FocusNode();
  final _summaryFocus = FocusNode();
  List<Tag>? _tags = [];

  void _newEntryFunction() {
    if (widget.entry.id != null) {
      _titleController.text = widget.entry.title!;
      _summaryController.text = widget.entry.summary!;
      _tags = widget.entry.tags;
    } else {
      _titleFocus.requestFocus();
    }
  }

  @override
  void initState() {
    _newEntryFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        JournalEntryViewHeader(completeEntry: _completeJournalEntry),
        _body(context),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TagTextField(tags: _tags!),
          TitleTextField(focus: _titleFocus, controller: _titleController),
          SummaryTextField(focus: _summaryFocus, controller: _summaryController),
        ],
      ),
    );
  }

  Future<void> _completeJournalEntry() async {
    final repo = context.read(studentRepositoryProvider);

    await repo.completeJournalEntry(
      entry: widget.entry,
      title: _titleController.text,
      summary: _summaryController.text,
      tags: _tags,
    );
  }
}
