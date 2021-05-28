import 'package:canton_design_system/canton_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kounslr/src/ui/providers/authentication_service_provider.dart';
import 'package:flutter_riverpod/src/provider.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser.email;
    String username = email.substring(0,email.indexOf('@'));

    return Column(
      children: [
        Card(
          child: Row(
            children: [
              Column(

              )
            ],
          ),
        ),
        Text('STUDENT NAME' + ' (' + username + ')'),
        Text(email),
        Text('SCHOOL DISTRICT NAME'),
      ],
    );
  }
}
