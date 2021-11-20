import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/ui/views/profile_view/student_id_card_view.dart';

class StudentIdCard extends StatelessWidget {
  const StudentIdCard({required this.school, required this.student, Key? key}) : super(key: key);

  final Student student;
  final School school;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CantonMethods.viewTransition(context, StudentIDCardView(student, school));
      },
      child: Card(
        margin: EdgeInsets.zero,
        shape: SquircleBorder(
          radius: const BorderRadius.vertical(
            top: Radius.circular(37),
          ),
          side: BorderSide(
            width: 0.5,
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Text(
                'ID Card',
                style: Theme.of(context).textTheme.headline6,
              ),
              const Spacer(),
              IconlyIcon(
                IconlyBold.Wallet,
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
