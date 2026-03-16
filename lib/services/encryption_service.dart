import 'package:encrypt/encrypt.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

class EncryptionService {
  late Key _key;
  late IV _iv;
  late Encrypter _encrypter;

  EncryptionService() {
    // Default fixed IV for simplicity in local transport,
    // or we can generate it randomly per session.
    _iv = IV.fromLength(16);
  }

  /// Sets the key for encryption/decryption.
  /// Key should be 32 characters for AES-256.
  void setKey(String keyString) {
    // Ensure key is exactly 32 bytes
    final bytes = utf8.encode(keyString);
    final keyBytes = List<int>.filled(32, 0);
    for (var i = 0; i < min(bytes.length, 32); i++) {
      keyBytes[i] = bytes[i];
    }
    _key = Key(Uint8List.fromList(keyBytes));
    _encrypter = Encrypter(AES(_key));
  }

  String encrypt(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decrypt(String encryptedBase64) {
    return _encrypter.decrypt64(encryptedBase64, iv: _iv);
  }

  static String generateRandomKey() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(32, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }
}
