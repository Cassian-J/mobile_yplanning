import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashHelper {
  static String hashString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha512.convert(bytes);
    return digest.toString();
  }
}