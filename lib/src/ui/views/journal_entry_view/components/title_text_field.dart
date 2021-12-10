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

class TitleTextField extends StatelessWidget {
  const TitleTextField({required this.focus, required this.controller, Key? key}) : super(key: key);

  final FocusNode focus;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focus,
      cursorColor: Theme.of(context).primaryColor,
      controller: controller,
      maxLines: null,
      scrollController: ScrollController(),
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
        hintStyle:
            Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).colorScheme.secondaryVariant),
      ),
    );
  }
}
