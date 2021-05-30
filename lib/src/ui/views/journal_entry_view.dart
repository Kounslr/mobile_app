import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JournalEntryView extends ConsumerWidget {
  final Function toggleView;
  const JournalEntryView({this.toggleView});
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _titleController = TextEditingController();
    final _summaryController = TextEditingController();

    return CantonScaffold(
      body: _content(context, _titleController, _summaryController),
    );
  }

  Widget _content(
    BuildContext context,
    TextEditingController _titleController,
    TextEditingController _summaryController,
  ) {
    return Column(
      children: [
        _header(context),
        SizedBox(height: 10),
        CantonTextInput(
          hintText: 'Title',
          isTextInputTwo: true,
          isTextFormField: true,
          obscureText: false,
          controller: _titleController,
        ),
        SizedBox(height: 15),
        CantonTextInput(
          textInputType: TextInputType.multiline,
          custom: true,
          hintText: 'Summary',
          isTextInputTwo: true,
          //isTextFormField: true,
          controller: _summaryController,
          maxLines: null,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CantonBackButton(isClear: true),
        Text(
          'New Entry',
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
        CantonHeaderButton(
          icon: Icon(
            FeatherIcons.checkCircle,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {},
          backgroundColor: CantonColors.transparent,
        ),
      ],
    );
  }
}
