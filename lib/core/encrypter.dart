import 'package:encrypt/encrypt.dart' as encrypt;

var encryptor = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromLength(32)));
