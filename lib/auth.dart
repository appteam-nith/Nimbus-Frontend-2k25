import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nimbus_2K25/login.dart';

class AuthService {
  static final _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true), // ✅ Android
    iOptions:
        IOSOptions(accessibility: KeychainAccessibility.first_unlock), // ✅ iOS
  );
//
  static Future<void> storeToken(String token, String role) async {
    try {
      await _storage.write(key: 'jwt_token', value: token);
      await _storage.write(key: 'role', value: role);
      print("✅ Token stored successfully: $token , $role");
    } catch (e) {
      print("❌ Error storing token: $e");
    }
  }

  static Future<String?> getName() async {
    try {
      String? name = await _storage.read(key: 'name');
      print("🔍 Retrieved Name");
      print(name);
      return name;
    } catch (e) {
      print("❌ Error retrieving Id: $e");
      return null;
    }
  }

  static Future<String?> getEmail() async {
    try {
      String? email = await _storage.read(key: 'email');
      print("🔍 Retrieved Email");
      print(email);
      return email;
    } catch (e) {
      print("❌ Error retrieving Id: $e");
      return null;
    }
  }

  static Future<void> storeName(String name) async {
    try {
      await _storage.write(key: 'name', value: name);

      print("✅ Token stored successfully: $name ");
    } catch (e) {
      print("❌ Error storing token: $e");
    }
  }

  static Future<void> storeId(String id) async {
    try {
      await _storage.write(key: 'id', value: id);
      print("✅ Id Stored Succesfully : $id ");
    } catch (e) {
      print("❌ Error storing token: $e");
    }
  }

  static Future<void> storebalance(String balance) async {
    try {
      await _storage.write(key: 'balance', value: balance);
      print("✅ Id Stored Succesfully : $balance ");
    } catch (e) {
      print("❌ Error storing token: $e");
    }
  }

  static Future<String?> getbalance() async {
    try {
      String? balance = await _storage.read(key: 'balance');
      print("🔍 Retrieved balance");
      print(balance);
      return balance;
    } catch (e) {
      print("❌ Error retrieving Id: $e");
      return null;
    }
  }

  static Future<void> storeEmail(String email) async {
    try {
      await _storage.write(key: 'email', value: email);
      print("✅ Email Stored Succesfully : $email ");
    } catch (e) {
      print("❌ Error storing token: $e");
    }
  }

  static Future<String?> getId() async {
    try {
      String? id = await _storage.read(key: 'id');
      print("🔍 Retrieved Id");
      print(id);
      return id;
    } catch (e) {
      print("❌ Error retrieving Id: $e");
      return null;
    }
  }

  static Future<String?> getToken() async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      print("🔍 Retrieved token");
      return token;
    } catch (e) {
      print("❌ Error retrieving token: $e");
      return null;
    }
  }

  static Future<String?> getRole() async {
    try {
      String? role = await _storage.read(key: 'role');
      print("🔍 Retrieved role");
      return role;
    } catch (e) {
      print("❌ Error retrieving role: $e");
      return null;
    }
  }

  static Future<void> clearToken(BuildContext context) async {
    try {
      await _storage.delete(key: 'jwt_token');
      print("🗑 Token cleared.");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    } catch (e) {
      print("❌ Error clearing token: $e");
    }
  }
}
