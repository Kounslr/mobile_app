import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/ui/providers/school_future_provider.dart';
import 'package:kounslr/src/ui/providers/student_stream_provider.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/profile_view/components/profile_card.dart';
import 'package:kounslr/src/ui/views/profile_view/components/profile_view_header.dart';
import 'package:kounslr/src/ui/styled_components/sign_out_button.dart';
import 'package:kounslr/src/ui/views/profile_view/components/student_id_card.dart';
import 'package:kounslr/src/ui/views/profile_view/components/student_schedule_card.dart';
import 'package:kounslr/src/ui/views/profile_view/components/student_upcoming_assignments_card.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return CantonScaffold(body: _content(context, watch));
  }

  Widget _content(BuildContext context, ScopedReader watch) {
    return Column(
      children: [
        ProfileViewHeader(),
        _body(context),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final schoolRepo = watch(schoolFutureProvider);
        final studentRepo = watch(studentStreamProvider);

        return schoolRepo.when(
          loading: () => Loading(),
          error: (e, s) {
            return SomethingWentWrong();
          },
          data: (school) {
            return studentRepo.when(
              error: (e, s) {
                return SomethingWentWrong();
              },
              loading: () => Loading(),
              data: (student) {
                return Column(
                  children: [
                    ProfileCard(school: school, student: student),
                    const SizedBox(height: 30),
                    StudentIdCard(school: school, student: student),
                    StudentScheduleCard(school: school, student: student),
                    StudentUpcomingAssignmentsCard(
                        school: school, student: student),
                    const SizedBox(height: 30),
                    SignOutButton(),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
