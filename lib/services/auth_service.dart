import 'local_auth_service.dart';
import 'api_service.dart';
import '../models/user.dart';

class AuthService {
  final LocalAuthService _localAuthService = LocalAuthService();
  final ApiService _apiService = ApiService();

  Future<User?> login(String email, String password) async {
    // Primero intentar con la API real
    try {
      final user = await _apiService.login(email, password);
      if (user != null) {
        return user;
      }
    } catch (e) {
      print('Error al hacer login con API: $e');
    }

    // Si falla la API, usar el sistema local como fallback
    return _localAuthService.login(email, password);
  }

  Future<bool> register(User user) {
    // Usar solo sistema local para registro
    return _localAuthService.register(user);
  }

  Future<void> logout() async {
    // No necesitas hacer nada para logout local
  }

  Future<User?> getCurrentUser() async {
    // Opcional: puedes implementar persistencia de sesión si quieres
    return null;
  }
}
