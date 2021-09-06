import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/providers/authentication_providers/authentication_service_provider.dart';

final authenticationStreamProvider = StreamProvider<User?>((ref) {
  return ref.watch(authenticationServiceProvider).authStateChanges;
});
