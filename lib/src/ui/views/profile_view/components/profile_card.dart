import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/student.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({required this.school, required this.student});

  final Student student;
  final School school;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _contentText(student.name!) + ' (' + student.studentId! + ')',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  student.email!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  school.name!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            Spacer(),
            IconlyIcon(
              IconlyBold.Profile,
              size: 40,
              color: Theme.of(context).colorScheme.secondaryVariant,
            ),
          ],
        ),
      ),
    );
  }

  String _contentText(String string) {
    if (string.length > 23) {
      return string.substring(0, 20) + '...';
    }
    return string;
  }
}
