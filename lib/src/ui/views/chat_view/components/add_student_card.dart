import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/student.dart';

class AddStudentCard extends StatefulWidget {
  const AddStudentCard(
      {required this.student, this.isSelected, this.onChanged});

  final Student student;
  final bool? isSelected;
  final void Function(bool)? onChanged;

  @override
  _AddStudentCardState createState() => _AddStudentCardState();
}

class _AddStudentCardState extends State<AddStudentCard> {
  bool? _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected!;
          widget.onChanged!(_isSelected!);
        });
      },
      child: Card(
        margin: EdgeInsets.zero,
        shape: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onSecondary,
            width: 1.5,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.student.name!,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    widget.student.email!,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Theme.of(context).colorScheme.secondaryVariant,
                        ),
                  ),
                ],
              ),
              Spacer(),
              Transform.scale(
                scale: 1.3,
                child: Checkbox(
                  value: _isSelected,
                  activeColor: Theme.of(context).primaryColor,
                  shape: const CircleBorder(),
                  onChanged: (value) {
                    setState(() {
                      _isSelected = value!;
                      widget.onChanged!(value);
                    });
                  },
                  side: BorderSide(
                    width: 1.25,
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
