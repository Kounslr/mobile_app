import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/ui/providers/school_repository_provider.dart';

class ClassCard extends StatefulWidget {
  const ClassCard({this.schoolClass});

  @required
  final ClassM? schoolClass;

  @override
  _ClassCardState createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  String teacherName = '';
  BlockM currentBlock = BlockM();

  @override
  void initState() {
    super.initState();
    _getDatabaseInfo(
        context: context,
        teacherId: widget.schoolClass!.teacherId!,
        period: widget.schoolClass!.block);
  }

  void _getDatabaseInfo({
    BuildContext? context,
    String? teacherId,
    int? period,
  }) async {
    var teacher = await context!
        .read(schoolRepositoryProvider)
        .getTeacherByTeacherId(teacherId!);
    var block =
        await context.read(schoolRepositoryProvider).getBlockByPeriod(period!);

    setState(() {
      teacherName = teacher.name!;
      currentBlock = block;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (teacherName == '' || currentBlock.period == null) {
      return Loading();
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.schoolClass?.name ?? 'CLASS',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconlyIcon(
                      IconlyBold.Location,
                      color: Theme.of(context).colorScheme.secondaryVariant,
                      size: 17,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      widget.schoolClass?.roomNumber ?? 'LOCATION',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color:
                                Theme.of(context).colorScheme.secondaryVariant,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconlyIcon(
                      IconlyBold.Profile,
                      color: Theme.of(context).colorScheme.secondaryVariant,
                      size: 17,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      teacherName,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color:
                                Theme.of(context).colorScheme.secondaryVariant,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Text(
              _nextClassTime(currentBlock.time.toString()),
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }

  String _nextClassTime(String string) {
    String time =
        string.substring(string.indexOf(' '), string.lastIndexOf(':')).trim();
    if (time.startsWith('0')) {
      time = time.substring(1);
    }

    return time;
  }
}
