import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../vn.edu.fpt.model/auth_response.dart';

class AuthService {
  // Android Emulator -> host PC. On a real phone, use your PC's LAN IP.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:401',
  );

  static const _storage = FlutterSecureStorage();

  Future<AuthResponse> login(String email, String password) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/api/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email.trim(), 'password': password}),
        )
        .timeout(const Duration(seconds: 15));

    final body = _decode(response);
    if (response.statusCode != 200) {
      throw AuthException(body['message'] as String? ?? 'Đăng nhập thất bại');
    }

    final auth = AuthResponse.fromJson(body);
    await saveSession(auth);
    return auth;
  }

  Future<AuthResponse> refresh() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    if (refreshToken == null) throw AuthException('Phiên đăng nhập đã hết hạn');
    final response = await http
        .post(
          Uri.parse('$baseUrl/api/auth/refresh'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        )
        .timeout(const Duration(seconds: 15));
    final body = _decode(response);
    if (response.statusCode != 200) {
      await clearSession();
      throw AuthException(body['message'] as String? ?? 'Phiên đăng nhập đã hết hạn');
    }
    final auth = AuthResponse.fromJson(body);
    await saveSession(auth);
    return auth;
  }

  Future<void> logout() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    try {
      if (refreshToken != null) {
        await http.post(
          Uri.parse('$baseUrl/api/auth/logout'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        ).timeout(const Duration(seconds: 8));
      }
    } catch (_) {
      // Clear local tokens even when the device is offline.
    } finally {
      await clearSession();
    }
  }

  Future<void> saveSession(AuthResponse auth) async {
    await _storage.write(key: 'accessToken', value: auth.accessToken);
    await _storage.write(key: 'refreshToken', value: auth.refreshToken);
    await _storage.write(key: 'userId', value: auth.user.id);
    await _storage.write(key: 'userEmail', value: auth.user.email);
    if (auth.user.name != null) {
      await _storage.write(key: 'userName', value: auth.user.name);
    }
  }

  Future<void> clearSession() async => _storage.deleteAll();

  Map<String, dynamic> _decode(http.Response response) {
    try {
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } catch (_) {
      throw AuthException('Không đọc được phản hồi từ máy chủ');
    }
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}
