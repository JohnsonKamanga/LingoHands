import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart' as pc;
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

class EncryptionService {
  late Key _aesKey;
  late IV _aesIv;
  late Encrypter _aesEncrypter;

  // RSA Keys
  pc.RSAPrivateKey? _rsaPrivateKey;
  pc.RSAPublicKey? _rsaPublicKey;

  EncryptionService() {
    _aesIv = IV.fromLength(16);
  }

  // --- AES Symmetric Methods ---

  void setKey(String keyString) {
    final bytes = utf8.encode(keyString);
    final keyBytes = List<int>.filled(32, 0);
    for (var i = 0; i < min(bytes.length, 32); i++) {
      keyBytes[i] = bytes[i];
    }
    _aesKey = Key(Uint8List.fromList(keyBytes));
    _aesEncrypter = Encrypter(AES(_aesKey));
  }

  String encrypt(String plainText) {
    final encrypted = _aesEncrypter.encrypt(plainText, iv: _aesIv);
    return encrypted.base64;
  }

  String decrypt(String encryptedBase64) {
    return _aesEncrypter.decrypt64(encryptedBase64, iv: _aesIv);
  }

  static String generateRandomKey() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(32, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  // --- RSA Asymmetric Methods ---

  /// Generates an RSA Key Pair (2048-bit).
  void generateRSAKeyPair() {
    final keyParams = pc.RSAKeyGeneratorParameters(
      BigInt.parse('65537'),
      2048,
      64,
    );
    final secureRandom = _getSecureRandom();
    final generator = pc.RSAKeyGenerator();
    generator.init(pc.ParametersWithRandom(keyParams, secureRandom));

    final pair = generator.generateKeyPair();
    _rsaPublicKey = pair.publicKey as pc.RSAPublicKey;
    _rsaPrivateKey = pair.privateKey as pc.RSAPrivateKey;
  }

  /// Returns the current public key in PEM (or similar) format for transmission.
  /// For simplicity in local transport, we'll encode the modulus and exponent.
  String getPublicKeyEncoded() {
    if (_rsaPublicKey == null) {
      return '';
    }
    final map = {
      'modulus': _rsaPublicKey!.modulus.toString(),
      'exponent': _rsaPublicKey!.publicExponent.toString(),
    };
    return jsonEncode(map);
  }

  /// Decrypts a symmetric key using the private RSA key.
  String decryptAESKeyWithRSA(String encryptedAESKeyBase64) {
    if (_rsaPrivateKey == null)
      throw Exception('RSA Private Key not generated');

    final rsa = RSA(privateKey: _rsaPrivateKey);
    final encrypter = Encrypter(rsa);

    return encrypter.decrypt64(encryptedAESKeyBase64);
  }

  /// Encrypts a symmetric key using a provided public RSA key encoded string.
  static String encryptAESKeyWithRSA(String aesKey, String encodedPublicKey) {
    final map = jsonDecode(encodedPublicKey);
    final publicKey = pc.RSAPublicKey(
      BigInt.parse(map['modulus']),
      BigInt.parse(map['exponent']),
    );

    final rsa = RSA(publicKey: publicKey);
    final encrypter = Encrypter(rsa);

    return encrypter.encrypt(aesKey).base64;
  }

  pc.SecureRandom _getSecureRandom() {
    final secureRandom = pc.FortunaRandom();
    final seedSource = Random.secure();
    final seeds = List<int>.generate(32, (_) => seedSource.nextInt(256));
    secureRandom.seed(pc.KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }
}
