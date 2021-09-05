import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/providers/authentication_providers/firebaseauth_provider.dart';
import 'package:kounslr/src/services/authentication/authentication_repository.dart';

final authenticationServiceProvider = Provider<AuthenticationRepository>((ref) {
  return AuthenticationRepository(ref.read(firebaseAuthProvider));
});
