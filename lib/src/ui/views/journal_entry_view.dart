import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/models/journal_entry_tag.dart';
import 'package:kounslr/src/services/repositories/student_repository.dart';
import 'package:kounslr/src/ui/providers/student_provider.dart';
import 'package:kounslr/src/ui/styled_components/journal_entry_tags/journal_entry_tags.dart';

class JournalEntryView extends StatefulWidget {
  final JournalEntry entry;
  const JournalEntryView(this.entry);

  @override
  _JournalEntryViewState createState() => _JournalEntryViewState();
}

class _JournalEntryViewState extends State<JournalEntryView> {
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _titleFocus = FocusNode();
  final _summaryFocus = FocusNode();
  List<JournalEntryTag> _tags = [];

  void _newEntryFunction() {
    if (widget.entry.id != null) {
      _titleController.text = widget.entry.title;
      _summaryController.text = widget.entry.summary;
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
        _header(context),
        _body(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final repo = watch(studentProvider);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CantonBackButton(
            isClear: true,
            onPressed: () {
              _completeJournalEntry(repo);
              Navigator.of(context).pop();
            },
          ),
          Text(
            DateFormat.yMMMMd().format(
              DateTime.now(),
            ),
            style: Theme.of(context).textTheme.headline5.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
          Material(
            color: Theme.of(context).primaryColor,
            shape: SquircleBorder(
              radius: BorderRadius.circular(30),
            ),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  CantonColors.transparent,
                ),
                alignment: Alignment.center,
                animationDuration: Duration.zero,
                elevation: MaterialStateProperty.all<double>(0),
                overlayColor: MaterialStateProperty.all<Color>(
                  CantonColors.transparent,
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.zero,
                ),
              ),
              child: Text(
                'Save',
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w500, color: CantonColors.white),
              ),
              onPressed: () => {
                _completeJournalEntry(repo),
                Navigator.of(context).pop(),
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _body(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _titleTextField(context),
          _tagTextField(context),
          _summaryTextField(context),
        ],
      ),
    );
  }

  Widget _titleTextField(BuildContext context) {
    return TextField(
      focusNode: _titleFocus,
      cursorColor: Theme.of(context).primaryColor,
      controller: _titleController,
      maxLines: null,
      scrollController: new ScrollController(),
      onChanged: (_) {},
      style: Theme.of(context).textTheme.headline3,
      decoration: InputDecoration(
        hintText: 'Title',
        fillColor: CantonColors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintStyle: Theme.of(context)
            .textTheme
            .headline3
            .copyWith(color: Theme.of(context).colorScheme.secondaryVariant),
      ),
    );
  }

  Widget _tagTextField(BuildContext context) {
    return TextFieldTags(
      initialTags: [],
      textFieldStyler: TextFieldStyler(
        cursorColor: Theme.of(context).primaryColor,
        hintText: 'Tags',
        textFieldFilledColor: Theme.of(context).colorScheme.onSecondary,
        textFieldFilled: true,
        textFieldEnabledBorder: SquircleInputBorder(
          radius: BorderRadius.all(Radius.circular(35)),
          side: BorderSide(
            color: CantonColors.transparent,
            width: 1.5,
          ),
        ),
        textFieldBorder: SquircleInputBorder(
          radius: BorderRadius.all(Radius.circular(35)),
          side: BorderSide(
            color: CantonColors.transparent,
            width: 1.5,
          ),
        ),
        textFieldFocusedBorder: SquircleInputBorder(
          radius: BorderRadius.all(Radius.circular(35)),
          side: BorderSide(
            color: CantonColors.transparent,
            width: 1.5,
          ),
        ),
        textFieldDisabledBorder: SquircleInputBorder(
          radius: BorderRadius.all(Radius.circular(35)),
          side: BorderSide(
            color: CantonColors.transparent,
            width: 1.5,
          ),
        ),
      ),
      tagsStyler: TagsStyler(
        tagCancelIcon: Icon(FeatherIcons.x, color: CantonColors.white),
        tagDecoration: ShapeDecoration(
            color: Theme.of(context).primaryColor,
            shape: SquircleBorder(radius: BorderRadius.circular(20))),
        tagTextStyle: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: CantonColors.white),
      ),
      onDelete: (_) {},
      onTag: (name) {
        _tags.add(JournalEntryTag(name: name));
      },
    );
  }

  Widget _summaryTextField(BuildContext context) {
    return TextField(
      focusNode: _summaryFocus,
      cursorColor: Theme.of(context).primaryColor,
      controller: _summaryController,
      maxLines: null,
      scrollController: new ScrollController(),
      onChanged: (_) {},
      style: Theme.of(context).textTheme.headline6,
      decoration: InputDecoration(
        fillColor: CantonColors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintText: 'Summary',
      ),
    );
  }

  void _completeJournalEntry(StudentRepository repo) {
    if (widget.entry.id == null) {
      repo.addJournalEntry(JournalEntry(
        creationDate: DateTime.now(),
        lastEditDate: DateTime.now(),
        title: _titleController.text,
        summary: _summaryController.text,
        tags: _tags,
      ));
    } else {
      repo.updateJournalEntry(
        entry: widget.entry,
        title: _titleController.text,
        summary: _summaryController.text,
        tags: _tags,
      );
    }
  }
}
