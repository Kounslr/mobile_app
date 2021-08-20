import 'package:canton_design_system/canton_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/ui/providers/all_students_stream_provider.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/chat_view/components/add_student_card.dart';
import 'package:kounslr/src/ui/views/chat_view/components/add_students_search_bar.dart';
import 'package:kounslr/src/ui/views/chat_view/components/add_users_to_chat_view_header.dart';

class AddUsersToChatView extends StatefulWidget {
  const AddUsersToChatView({Key? key}) : super(key: key);

  @override
  _AddUsersToChatViewState createState() => _AddUsersToChatViewState();
}

class _AddUsersToChatViewState extends State<AddUsersToChatView> {
  List<Student> selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      resizeToAvoidBottomInset: true,
      padding: EdgeInsets.zero,
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        AddUsersToChatViewHeader(students: selectedUsers),
        SizedBox(height: 5),
        _body(context),
      ],
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
            students.removeWhere((element) =>
                element.id == FirebaseAuth.instance.currentUser?.uid);

            return Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      if (index == 0)
                        Column(
                          children: [
                            AddStudentsSearchBar(),
                            SizedBox(height: 12),
                          ],
                        ),
                      AddStudentCard(
                        student: students[index],
                        onChanged: (value) {
                          if (value) {
                            selectedUsers.add(students[index]);
                          }
                        },
                      ),
                      if (index == students.length - 1) Divider(),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
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
