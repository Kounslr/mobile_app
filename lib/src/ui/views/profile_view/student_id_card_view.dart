import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/ui/styled_components/student_id_card.dart';
import 'package:kounslr/src/ui/views/profile_view/components/student_id_card_view_header.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudentIDCardView extends StatelessWidget {
  final Student student;
  final School school;

  const StudentIDCardView(this.student, this.school, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return CantonScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const StudentIdCardViewHeader(),
          _body(context, student),
          Container(height: 70),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, Student student) {
    return Column(
      children: [
        StudentIDCard(student, school),
        const SizedBox(height: 80),
        QrImage(
          data: 'https://www.kounslr.com',
          version: QrVersions.auto,
          backgroundColor: CantonColors.bgPrimary,
          size: 100,
        ),
      ],
    );
  }
}
