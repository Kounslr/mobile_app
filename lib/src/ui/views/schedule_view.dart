import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/ui/providers/student_provider.dart';
import 'package:kounslr/src/ui/styled_components/class_card.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView();

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        _header(context),
        SizedBox(height: 10),
        _body(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return ViewHeaderTwo(
      title: 'Schedule',
      backButton: true,
      isBackButtonClear: true,
    );
  }

  Widget _body(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: context.read(studentProvider).getStudentClasses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return Expanded(
            child: ListView(
              children: _getClasses(snapshot.data!.docs),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }

  List<Widget> _getClasses(List<QueryDocumentSnapshot> snapshots) {
    List<ClassCard> classes = [];

    for (var item in snapshots) {
      classes.add(
        ClassCard(
          schoolClass: Class.fromMap(item.data() as Map<String, dynamic>),
        ),
      );
    }

    return classes;
  }
}
