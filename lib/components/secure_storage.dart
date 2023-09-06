import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  late FlutterSecureStorage secureStorage;

  SecureStorage() {
    secureStorage = const FlutterSecureStorage();
  }

  final String _keyUserName = 'email';
  final String _keyPassword = 'password';

  Future setUserName(String userName) async {
    await secureStorage.write(key: _keyUserName, value: userName);
  }

  Future setUserPassword(String password) async {
    await secureStorage.write(key: _keyPassword, value: password);
  }

  Future<String?> getUserEmail() async {
    return await secureStorage.read(key: _keyUserName);
  }

  Future<String?> getUserPassword() async {
    return await secureStorage.read(key: _keyPassword) ?? '';
  }
}
