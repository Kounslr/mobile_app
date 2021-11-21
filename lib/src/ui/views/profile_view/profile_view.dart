/*
Kounslr iOS & Android App
Copyright (C) 2021 Kounslr

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/providers/school_future_provider.dart';
import 'package:kounslr/src/providers/student_stream_provider.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/profile_view/components/profile_card.dart';
import 'package:kounslr/src/ui/views/profile_view/components/profile_view_header.dart';
import 'package:kounslr/src/ui/styled_components/sign_out_button.dart';
import 'package:kounslr/src/ui/views/profile_view/components/student_id_card.dart';
import 'package:kounslr/src/ui/views/profile_view/components/student_schedule_card.dart';
import 'package:kounslr/src/ui/views/profile_view/components/student_upcoming_assignments_card.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return CantonScaffold(padding: EdgeInsets.zero, body: _content(context, watch));
  }

  Widget _content(BuildContext context, ScopedReader watch) {
    return Column(
      children: [
        const ProfileViewHeader(),
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
            return const SomethingWentWrong();
          },
          data: (school) {
            return studentRepo.when(
              error: (e, s) {
                return const SomethingWentWrong();
              },
              loading: () => Loading(),
              data: (student) {
                return Column(
                  children: [
                    ProfileCard(school: school, student: student),
                    const SizedBox(height: 30),
                    StudentIdCard(school: school, student: student),
                    StudentScheduleCard(school: school, student: student),
                    StudentUpcomingAssignmentsCard(school: school, student: student),
                    const SizedBox(height: 30),
                    const SignOutButton(),
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
