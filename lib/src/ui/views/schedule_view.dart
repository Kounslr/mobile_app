import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/student_classes_stream_provider.dart';
import 'package:kounslr/src/ui/styled_components/class_card.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';

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
    return Consumer(
      builder: (context, watch, child) {
        final studentClassesRepo = watch(studentClassesFutureProvider);

        return studentClassesRepo.when(
          data: (classes) {
            return Expanded(
              child: ListView.builder(
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  return ClassCard(
                    schoolClass: classes[index],
                  );
                },
              ),
            );
          },
          loading: () => Loading(),
          error: (e, s) {
            return SomethingWentWrong();
          },
        );
      },
    );
  }
}
