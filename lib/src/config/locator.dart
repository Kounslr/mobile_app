import 'package:get_it/get_it.dart';
import 'package:kounslr/src/services/repositories/firestore_repository.dart';
import 'package:kounslr/src/services/repositories/student_repository.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => FirestoreRepository('customers'));
  locator.registerLazySingleton(() => StudentRepository());
}
