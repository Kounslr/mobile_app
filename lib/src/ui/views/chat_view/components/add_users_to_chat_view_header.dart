import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/room.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/services/repositories/chat_repository/chat_repository.dart';
import 'package:kounslr/src/ui/views/chat_view/chat_view.dart';
import 'package:uuid/uuid.dart';

class AddUsersToChatViewHeader extends StatelessWidget {
  const AddUsersToChatViewHeader({required this.students});

  final List<Student> students;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        children: [
          ViewHeaderTwo(
            backButton: true,
            title: 'New Message',
            buttonTwo: GestureDetector(
              onTap: () async {
                if (students.length == 1) {
                  final user = Student(id: students.first.id!);
                  final roomId = Uuid().v4();
                  Room room = await ChatRepository.instance
                      .createRoom(user, groupId: roomId);

                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: ChatView(room),
                      type: PageTransitionType.rightToLeft,
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 300),
                    ),
                  );
                }
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
}
