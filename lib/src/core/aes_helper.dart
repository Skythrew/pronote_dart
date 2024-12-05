import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:hex/hex.dart';

class AESHelper {
  static String decrypt(Uint8List data, Uint8List key, Uint8List iv) {
    final aesKey = Key(md5.convert(key).bytes as Uint8List);
    final aesIv = iv.isNotEmpty
        ? IV.fromBase16(md5.convert(iv).toString())
        : IV.allZerosOfLength(16);

    final encrypter = Encrypter(AES(aesKey, mode: AESMode.cbc));

    final decrypted = encrypter.decrypt(Encrypted(data), iv: aesIv);

    return decrypted;
  }

  static String encrypt(
      Uint8List data, Uint8List key, Uint8List iv, bool emptyIv) {
    final aesKey = Key(md5.convert(key).bytes as Uint8List);

    final aesIv = !emptyIv
        ? IV.fromBase16(md5.convert(iv).toString())
        : IV.allZerosOfLength(16);

    final encrypter = Encrypter(AES(aesKey, mode: AESMode.cbc));
    final encrypted = encrypter.encryptBytes(data, iv: aesIv);

    return HEX.encode(encrypted.bytes);
  }
}
