import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class LocalAuthService {
  static const _usersKey = 'users_json';

  // Obtener lista de usuarios desde SharedPreferences
  Future<List<User>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString(_usersKey);
    if (usersString == null) return [];
    final List<dynamic> usersJson = jsonDecode(usersString);
    return usersJson.map((u) => User.fromJson(u)).toList();
  }

  // Guardar lista de usuarios
  Future<void> _saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = jsonEncode(users.map((u) => u.toJson()).toList());
    await prefs.setString(_usersKey, usersString);
  }

  // Registrar usuario
  Future<bool> register(User user) async {
    final users = await _getUsers();
    final exists = users.any((u) => u.email == user.email);
    if (exists) {
      return false; // Usuario ya existe
    }
    users.add(user);
    await _saveUsers(users);
    return true;
  }

  // Login usuario
  Future<User?> login(String email, String password) async {
    final users = await _getUsers();
    try {
      final user = users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      return user;
    } catch (e) {
      return null; // No encontrado o password incorrecto
    }
  }
}
