import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/ui/providers/all_students_stream_provider.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';

class AddUsersToChatView extends StatefulWidget {
  const AddUsersToChatView({Key? key}) : super(key: key);

  @override
  _AddUsersToChatViewState createState() => _AddUsersToChatViewState();
}

class _AddUsersToChatViewState extends State<AddUsersToChatView> {
  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      padding: EdgeInsets.zero,
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        _header(context),
        SizedBox(height: 5),
        _body(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        children: [
          ViewHeaderTwo(
            backButton: true,
            title: 'New Message',
            buttonTwo: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: SquircleBorder(
                    radius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Chat',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w500, color: CantonColors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final studentsRepo = watch(allStudentsStreamProvider);
        return studentsRepo.when(
          error: (e, s) {
            print(e);
            return Expanded(child: SomethingWentWrong());
          },
          loading: () => Expanded(child: Loading()),
          data: (students) {
            List<Widget> children = [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: CantonTextInput(
                  hintText: 'Search in Students',
                  textInputType: TextInputType.text,
                  isTextFormField: false,
                  obscureText: false,
                  prefixIcon: IconlyIcon(
                    IconlyBold.Search,
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
                ),
              ),
              SizedBox(height: 12),
            ];

            for (int i = 0; i < students.length; i++) {
              var item = students[i];
              children.add(_studentCard(context, item));
              if (i == students.length - 1) children.add(Divider());
            }

            return Expanded(
              child: ListView(
                children: children,
              ),
            );
          },
        );
      },
    );
  }

  Widget _studentCard(BuildContext context, Student student) {
    return Card(
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
            SizedBox(width: 10),
            Column(
              children: [
                Text(
                  student.name!,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  student.email!,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context).colorScheme.secondaryVariant,
                      ),
                ),
              ],
            ),
            Spacer(),
//             Transform.scale(
//   scale: 1.3,
//   child: Checkbox(
//     value: true,
//     onChanged: (value) {},
//     shape: const CircleBorder(),
//     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//   ),
// ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _tab(BuildContext context, String name) {
    return Column(
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(),
        )
      ],
    );
  }
}
