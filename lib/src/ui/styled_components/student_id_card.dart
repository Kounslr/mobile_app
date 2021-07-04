// ignore: import_of_legacy_library_into_null_safe
import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/student.dart';

class StudentIDCard extends StatelessWidget {
  final Student student;

  const StudentIDCard(this.student);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: SquircleBorder(radius: BorderRadius.circular(65)),
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                ClipSquircleBorder(
                  radius: BorderRadius.circular(40),
                  child: Container(
                    height: 80,
                    width: 80,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  // child: Image.network(student.photo, width: 80, height: 80)
                ),
                SizedBox(width: 15),
                Text(
                  student.currentSchool!,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: CantonColors.white),
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleUserText(context, 'Name', student.name!),
                _titleUserText(context, 'Grade', student.grade!),
                _titleUserText(context, 'ID', student.studentId!)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleUserText(
    BuildContext context,
    String title,
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
        ),
        Text(
          description,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: CantonColors.white,
              ),
        ),
      ],
    );
  }
}
