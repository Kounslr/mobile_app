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
