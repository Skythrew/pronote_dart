import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

import 'package:pronote_dart/src/models/enums/session_access_kind.dart';
import 'package:pronote_dart/src/models/enums/account_kind.dart';

const rsaModulo1024 =
    'B99B77A3D72D3A29B4271FC7B7300E2F791EB8948174BE7B8024667E915446D4EEA0C2424B8D1EBF7E2DDFF94691C6E994E839225C627D140A8F1146D1B0B5F18A09BBD3D8F421CA1E3E4796B301EEBCCF80D81A32A1580121B8294433C38377083C5517D5921E8A078CDC019B15775292EFDA2C30251B1CCABE812386C893E5';
const rsaExponent1024 =
    '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001';

class SessionInformation {
  final num id;
  final AccountKind accountKind;

  /// Whether the instance is demo or not.
  final bool demo;

  final String url;

  /// How the session is accessed.
  final SessionAccessKind accessKind;

  final String rsaModulus;
  final String rsaExponent;

  final bool rsaFromConstants;

  Uint8List aesKey;
  Uint8List aesIV;

  /// Whether we should skip request encryption or not.
  final bool skipEncryption;

  /// Whether we should skip request compression or not.
  final bool skipCompression;

  final bool http;

  final bool poll;

  num order;

  factory SessionInformation.fromJSON(Map<String, dynamic> json, String base) {
    final rsaFromConstants = !(json['MR'] ?? false) && !(json['ER'] ?? false);

    return SessionInformation(
        int.parse(json['h']),
        AccountKind.fromInt(json['a']),
        json['d'] ?? false,
        base,
        json['g'] ?? SessionAccessKind.account,
        rsaFromConstants ? rsaModulo1024 : json['MR'],
        rsaFromConstants ? rsaExponent1024 : json['ER'],
        rsaFromConstants,
        Uint8List(0),
        IV.fromSecureRandom(16).bytes,
        json['sCrA'] ?? false,
        json['sCoA'] ?? false,
        json['http'] ?? false,
        json['poll'] ?? false,
        0);
  }

  SessionInformation(
      this.id,
      this.accountKind,
      this.demo,
      this.url,
      this.accessKind,
      this.rsaModulus,
      this.rsaExponent,
      this.rsaFromConstants,
      this.aesKey,
      this.aesIV,
      this.skipEncryption,
      this.skipCompression,
      this.http,
      this.poll,
      this.order);
}
