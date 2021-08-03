import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/services/authentication/authentication_repository.dart';
import 'package:kounslr/src/ui/providers/authentication_providers/firebaseauth_provider.dart';

final authenticationServiceProvider = Provider<AuthenticationRepository>((ref) {
  return AuthenticationRepository(ref.read(firebaseAuthProvider));
});
