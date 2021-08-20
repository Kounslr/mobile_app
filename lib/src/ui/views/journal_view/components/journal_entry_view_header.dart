import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class JournalEntryViewHeader extends StatelessWidget {
  const JournalEntryViewHeader({required this.completeEntry});

  final Future<void> Function() completeEntry;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CantonBackButton(isClear: true),
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: Theme.of(context).textTheme.headline5,
            ),
            GestureDetector(
              onTap: () {
                completeEntry();
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: SquircleBorder(
                    radius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Save',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w500, color: CantonColors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
