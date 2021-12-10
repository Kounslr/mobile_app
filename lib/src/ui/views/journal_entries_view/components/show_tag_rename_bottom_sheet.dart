import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/providers/student_repository_provider.dart';

Future<void> showTagRenameBottomSheet(BuildContext context, List<JournalEntry> entries, Tag tag) async {
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
                  color: CantonMethods.alternateCanvasColor(context),
                  shape: const SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.vertical(
                      top: SmoothRadius(cornerRadius: 12, cornerSmoothing: 1),
                    ),
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
                        Column(
                          children: [
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
                            CantonPrimaryButton(
                              textColor: Theme.of(context).primaryColor,
                              buttonText: 'Save',
                              containerWidth: MediaQuery.of(context).size.width / 2 - 34,
                              color: CantonColors.transparent,
                              onPressed: () {
                                watch(studentRepositoryProvider).renameJournalEntryTags(
                                  entries,
                                  tag,
                                  Tag(name: _tagRenameController.text),
                                );
                                Navigator.pop(context);
                              },
                            ),
                          ],
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
