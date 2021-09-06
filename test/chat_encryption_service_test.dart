import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kounslr/src/config/encryption_contract.dart';
import 'package:kounslr/src/services/repositories/chat_repository/chat_encryption_service.dart';

void main() {
  IEncryption? sut;

  setUp(() {
    final encrypter = Encrypter(AES(Key.fromLength(32)));
    sut = ChatEncryptionService(encrypter);
  });

  test('it encrypts plain text', () {
    final text = 'this is a message';
    final base64 = RegExp(
        r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$');

    final encrypted = sut!.encrypt(text);

    expect(base64.hasMatch(encrypted), true);
  });

  test('it decrypts the encrypted text', () {
    final text = 'Br';
    final encrypted = sut!.encrypt(text);
    final decrypted = sut!.decrypt(encrypted);
    expect(decrypted, text);
  });
}
