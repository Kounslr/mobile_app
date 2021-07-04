import 'package:canton_design_system/canton_design_system.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/ui/styled_components/student_id_card.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudentIDCardView extends StatelessWidget {
  final Student student;

  const StudentIDCardView(this.student);
  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return CantonScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _header(context),
          _body(context, student),
          Container(height: 70),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        CantonBackButton(isClear: true),
        Spacer(),
        Text(
          'ID Card',
          style: Theme.of(context).textTheme.headline5?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
        Spacer(),
        CantonHeaderButton(
          backgroundColor: CantonColors.transparent,
          icon: Container(),
        ),
      ],
    );
  }

  Widget _body(BuildContext context, Student student) {
    return Column(
      children: [
        StudentIDCard(student),
        SizedBox(height: 20),
        QrImage(
          data: 'https://portal.lcps.org',
          version: QrVersions.auto,
          size: 100,
        ),
      ],
    );
  }
}
