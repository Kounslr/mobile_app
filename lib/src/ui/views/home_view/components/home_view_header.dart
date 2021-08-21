import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/student.dart';

class HomeViewHeader extends StatelessWidget {
  const HomeViewHeader({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 17, right: 17, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hey,',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Theme.of(context).colorScheme.secondaryVariant,
                ),
          ),
          Text(
            _studentNameInHeader(student) + ' 👋',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  String _studentNameInHeader(Student student) {
    if (![null, ''].contains(student.nickname)) {
      return student.nickname!;
    }
    return student.name!.substring(0, student.name!.indexOf(' '));
  }
}
