import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true), // ✅ Android
    iOptions:
        IOSOptions(accessibility: KeychainAccessibility.first_unlock), // ✅ iOS
  );

  static Future<void> storeToken(String token) async {
    try {
      await _storage.write(key: 'jwt_token', value: token);
      print("✅ Token stored successfully: $token");
    } catch (e) {
      print("❌ Error storing token: $e");
    }
  }

  static Future<String?> getToken() async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      print("🔍 Retrieved token: $token");
      return token;
    } catch (e) {
      print("❌ Error retrieving token: $e");
      return null;
    }
  }

  static Future<void> clearToken() async {
    try {
      await _storage.delete(key: 'jwt_token');
      print("🗑 Token cleared.");
    } catch (e) {
      print("❌ Error clearing token: $e");
    }
  }
}
