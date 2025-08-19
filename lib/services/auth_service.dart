import 'local_auth_service.dart';
import 'api_service.dart';
import '../models/user.dart';

class AuthService {
  final LocalAuthService _localAuthService = LocalAuthService();
  final ApiService _apiService = ApiService();

  Future<User?> login(String email, String password) async {
    // Intentar login con la API real
    try {
      final user = await _apiService.login(email, password);
      if (user != null && user.token != null && user.token!.isNotEmpty) {
        // Login exitoso con token dinámico
        return user;
      }
    } catch (e) {
      print('Error al hacer login con API: $e');
    }
    // Si falla la API, usar el sistema local como fallback
    return _localAuthService.login(email, password);
  }

  Future<bool> register(User user) async {
    // Intentar registro con la API real
    try {
      // Aquí deberías tener un método en ApiService para registrar usuario
      // Por ejemplo: await _apiService.register(user);
      // Si la API responde correctamente, hacer login automático
      final registroExitoso = await _apiService.register(user);
      if (registroExitoso) {
        final userLogueado = await _apiService.login(user.email, user.password);
        if (userLogueado != null &&
            userLogueado.token != null &&
            userLogueado.token!.isNotEmpty) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error al registrar usuario con API: $e');
      // Si falla la API, usar el sistema local como fallback
      return await _localAuthService.register(user);
    }
  }

  Future<void> logout() async {
    // No necesitas hacer nada para logout local
  }

  Future<User?> getCurrentUser() async {
    // Opcional: puedes implementar persistencia de sesión si quieres
    return null;
  }
}
