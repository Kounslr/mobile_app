import 'package:encrypt/encrypt.dart' as enc;
import 'package:kounslr/src/config/encryption_contract.dart';

class ChatEncryptionService implements IEncryption {
  final enc.Encrypter _encrypter;
  final _iv = enc.IV.fromLength(16);

  ChatEncryptionService(this._encrypter);

  @override
  String encrypt(String text) {
    return _encrypter.encrypt(text, iv: this._iv).base64;
  }

  @override
  String decrypt(String text) {
    final encrypted = enc.Encrypted.fromBase64(text);
    return _encrypter.decrypt(encrypted, iv: this._iv);
  }
}
