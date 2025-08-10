import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  final ApiService _apiService = ApiService();

  // Login
  Future<User?> login(String email, String password) async {
    try {
      final user = await _apiService.login(email, password);
      if (user != null) {
        await _saveUserData(user);
        return user;
      }
      return null;
    } catch (e) {
      print('Error en AuthService login: $e');
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _secureStorage.delete(key: _userKey);
      await _secureStorage.delete(key: _tokenKey);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      print('Error en logout: $e');
    }
  }

  // Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    try {
      final userData = await _secureStorage.read(key: _userKey);
      return userData != null;
    } catch (e) {
      print('Error verificando autenticación: $e');
      return false;
    }
  }

  // Obtener usuario actual
  Future<User?> getCurrentUser() async {
    try {
      final userData = await _secureStorage.read(key: _userKey);
      if (userData != null) {
        final userMap = json.decode(userData);
        return User.fromJson(userMap);
      }
      return null;
    } catch (e) {
      print('Error obteniendo usuario actual: $e');
      return null;
    }
  }

  // Obtener token
  Future<String?> getToken() async {
    try {
      final user = await getCurrentUser();
      return user?.token;
    } catch (e) {
      print('Error obteniendo token: $e');
      return null;
    }
  }

  // Guardar datos del usuario
  Future<void> _saveUserData(User user) async {
    try {
      final userData = json.encode(user.toJson());
      await _secureStorage.write(key: _userKey, value: userData);

      if (user.token != null) {
        await _secureStorage.write(key: _tokenKey, value: user.token!);
      }
    } catch (e) {
      print('Error guardando datos del usuario: $e');
    }
  }

  // Recuperar contraseña
  Future<bool> recuperarPassword(String email) async {
    return await _apiService.recuperarPassword(email);
  }

  // Cambiar contraseña
  Future<bool> cambiarPassword(
    String passwordActual,
    String passwordNueva,
  ) async {
    try {
      final user = await getCurrentUser();
      if (user == null) return false;

      return await _apiService.cambiarPassword(
        user.id,
        passwordActual,
        passwordNueva,
      );
    } catch (e) {
      print('Error cambiando contraseña: $e');
      return false;
    }
  }
}
