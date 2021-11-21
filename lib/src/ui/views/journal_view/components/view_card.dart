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

class ViewCard extends StatelessWidget {
  const ViewCard({required this.view, required this.text, Key? key}) : super(key: key);

  final Widget view;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CantonMethods.viewTransition(context, view),
      child: Container(
        padding: const EdgeInsets.only(top: 17, left: 17, right: 17),
        child: Card(
          color: Theme.of(context).colorScheme.secondary,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.headline6!.copyWith(),
                ),
                const Spacer(),
                Icon(
                  Iconsax.arrow_right_3,
                  size: 20,
                  color: Theme.of(context).colorScheme.secondaryVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
