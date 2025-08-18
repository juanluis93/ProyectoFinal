import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _initialized = false;
  String? _token;

  bool get initialized => _initialized;
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;
  String? get token => _token;

  AuthProvider() {
    _initializeAuth();
  }

  /// Inicializa la sesión leyendo datos guardados y haciendo login automático si es posible
  Future<void> _initializeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('email');
    final storedPassword = prefs.getString('password');
    final storedToken = prefs.getString('auth_token');

    // Si tenemos token guardado, lo usamos
    if (storedToken != null) {
      _token = storedToken;
    }

    if (storedEmail != null && storedPassword != null) {
      try {
        _user = await _authService.login(storedEmail, storedPassword);
        // Si no tenemos token pero el usuario existe, usar token por defecto
        if (_token == null && _user != null) {
          _token =
              'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMDAwMDE3IiwiZW1haWwiOiJqdWFuTEBleGFtcGxlLmNvbSIsImV4cCI6MTc1NTc3MjgxM30=.jYamdSa5aS+aKIbelluXUNZ2KQK6HUFnAPArpuvBXsI=';
          await prefs.setString('auth_token', _token!);
        }
      } catch (e) {
        _user = null; // Login automático falló, limpiar usuario
        _token = null;
        _clearSession(); // Limpia session corrupta
      }
    }
    _initialized = true;
    notifyListeners();
  }

  /// Login con email y password
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      _user = await _authService.login(email, password);

      if (_user != null && _user!.token != null && _user!.token!.isNotEmpty) {
        // Guardar el token real devuelto por la API
        _token = _user!.token;
        await _saveSession(_user!, password);
        _setLoading(false);
        return true;
      } else {
        _setError('Credenciales incorrectas. Verifica tu email y contraseña.');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Error al iniciar sesión: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Registro de usuario nuevo
  Future<bool> register(User user) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authService.register(user);
      if (!success) {
        _setError('El correo ya está registrado');
        _setLoading(false);
        return false;
      }
      // Login automático después de registro
      _user = await _authService.login(user.email, user.password);
      if (_user != null && _user!.token != null && _user!.token!.isNotEmpty) {
        _token = _user!.token;
        await _saveSession(_user!, user.password);
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Error en el registro: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _authService.logout();
    await _clearSession();
    _user = null;
    _token = null;
    notifyListeners();
  }

  // Funciones no implementadas en modo local
  Future<bool> recuperarPassword(String email) async {
    _setError('Funcionalidad no implementada en modo local');
    return false;
  }

  Future<bool> cambiarPassword(String actual, String nueva) async {
    _setError('Funcionalidad no implementada en modo local');
    return false;
  }

  // Guarda sesión localmente
  Future<void> _saveSession(User user, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', user.email);
    await prefs.setString('password', password);
    if (_token != null) {
      await prefs.setString('auth_token', _token!);
    }
  }

  // Limpia sesión local
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('auth_token');
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
