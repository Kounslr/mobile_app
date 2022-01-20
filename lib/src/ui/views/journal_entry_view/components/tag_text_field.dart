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

import 'package:kounslr/src/providers/student_repository_provider.dart';
import 'package:kounslr/src/ui/views/journal_entry_view/components/tag_text_input/tag_text_input.dart' as input;

class TagTextField extends StatelessWidget {
  const TagTextField({required this.tags, this.onTag, this.controller, Key? key}) : super(key: key);

  final List<Tag> tags;
  final TextEditingController? controller;
  final Function(String)? onTag;

  @override
  Widget build(BuildContext context) {
    var initTags = <String>[];

    for (final tag in tags) {
      initTags.add(tag.name!);
    }

    return Consumer(
      builder: (context, watch, child) {
        final repo = watch(studentRepositoryProvider).getAllJournalEntryTags;

        return input.CantonTagTextInput(
          initialTags: initTags,
          maxCharactersPerTag: 13,
          maxTags: 3,
          key: key,
          controller: controller,
          suggestedTags: repo,
          textFieldStyler: TagTextInputStyler(
            cursorColor: Theme.of(context).primaryColor,
            hintText: 'science, economics, basketball...',
            textFieldFilled: true,
            textFieldEnabledBorder: const SquircleInputBorder(
              radius: SmoothBorderRadius.all(SmoothRadius(cornerSmoothing: 1, cornerRadius: 21)),
              side: BorderSide(
                color: CantonColors.transparent,
                width: 1.5,
              ),
            ),
            textFieldBorder: const SquircleInputBorder(
              radius: SmoothBorderRadius.all(SmoothRadius(cornerSmoothing: 1, cornerRadius: 21)),
              side: BorderSide(
                color: CantonColors.transparent,
                width: 1.5,
              ),
            ),
            textFieldFocusedBorder: const SquircleInputBorder(
              radius: SmoothBorderRadius.all(SmoothRadius(cornerSmoothing: 1, cornerRadius: 21)),
              side: BorderSide(
                color: CantonColors.transparent,
                width: 1.5,
              ),
            ),
            textFieldDisabledBorder: const SquircleInputBorder(
              radius: SmoothBorderRadius.all(SmoothRadius(cornerSmoothing: 1, cornerRadius: 21)),
              side: BorderSide(
                color: CantonColors.transparent,
                width: 1.5,
              ),
            ),
          ),
          tagsStyler: TagsStyler(
            tagCancelIcon: const Icon(FeatherIcons.x, color: CantonColors.white),
            tagDecoration: ShapeDecoration(
                color: Theme.of(context).primaryColor, shape: SquircleBorder(radius: BorderRadius.circular(20))),
            tagTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(color: CantonColors.white),
          ),
          onDelete: (name) {
            tags.remove(Tag(name: name));
          },
          onTag: (name) {
            if (onTag != null) {
              onTag!(name);
            }

            tags.add(Tag(name: name));
          },
        );
      },
    );
  }
}
