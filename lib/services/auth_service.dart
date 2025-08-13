import 'local_auth_service.dart';
import '../models/user.dart';

class AuthService {
  final LocalAuthService _localAuthService = LocalAuthService();

  Future<User?> login(String email, String password) {
    return _localAuthService.login(email, password);
  }

  Future<bool> register(User user) {
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
