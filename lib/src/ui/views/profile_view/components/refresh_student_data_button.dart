import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/ui/components/show_sign_in_with_studentvue_bottomsheet.dart';

class RefreshStudentDataButton extends StatefulWidget {
  const RefreshStudentDataButton({Key? key}) : super(key: key);

  @override
  State<RefreshStudentDataButton> createState() => _RefreshStudentDataButtonState();
}

class _RefreshStudentDataButtonState extends State<RefreshStudentDataButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showStudentVueSignInBottomSheet(context);
      },
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Text(
                'Refresh Student Data',
                style: Theme.of(context).textTheme.headline6,
              ),
              const Spacer(),
              Icon(
                Iconsax.refresh,
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
