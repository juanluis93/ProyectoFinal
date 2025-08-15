import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';
import '../normativas/normativas_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Column(
            children: [
              // Agregar padding superior para el status bar
              SizedBox(height: MediaQuery.of(context).padding.top),

              // Título de la pantalla
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                  vertical: 16,
                ),
                child: Text(
                  'Perfil',
                  style: AppTextStyles.heading1,
                  textAlign: TextAlign.center,
                ),
              ),

              // Contenido del perfil
              Expanded(
                child: authProvider.isAuthenticated
                    ? _buildAuthenticatedProfile(context, authProvider)
                    : _buildGuestProfile(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAuthenticatedProfile(
    BuildContext context,
    AuthProvider authProvider,
  ) {
    final user = authProvider.user!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          // Header del usuario
          CustomCard(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user.nombre.isNotEmpty ? user.nombre[0].toUpperCase() : 'U',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(user.fullName, style: AppTextStyles.heading3),
                const SizedBox(height: 4),
                Text(user.email, style: AppTextStyles.body2),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Opciones del usuario autenticado
          _buildMenuSection('Mi Cuenta', [
            _buildMenuItem(
              Icons.report,
              'Mis Reportes',
              'Ver mis reportes ambientales',
              () => _showComingSoon(context),
            ),
            _buildMenuItem(
              Icons.map,
              'Mapa de Reportes',
              'Ver mis reportes en el mapa',
              () => _showComingSoon(context),
            ),
            _buildMenuItem(
              Icons.gavel,
              'Normativas',
              'Marco legal ambiental',
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NormativasScreen(),
                  ),
                );
              },
            ),
          ]),

          const SizedBox(height: 24),

          _buildMenuSection('Configuración', [
            _buildMenuItem(
              Icons.lock,
              'Cambiar Contraseña',
              'Actualizar contraseña',
              () => _showComingSoon(context),
            ),
            _buildMenuItem(
              Icons.logout,
              'Cerrar Sesión',
              'Salir de la aplicación',
              () => _showLogoutDialog(context, authProvider),
              textColor: AppColors.error,
            ),
          ]),

          const SizedBox(height: 24),

          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildGuestProfile(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          // Header para invitados
          CustomCard(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.greyLight,
                  child: Icon(Icons.person, size: 60, color: AppColors.grey),
                ),
                const SizedBox(height: 16),
                Text('Usuario Invitado', style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                Text(
                  'Inicia sesión para acceder a todas las funciones',
                  style: AppTextStyles.body2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Iniciar Sesión',
                  onPressed: () => _showComingSoon(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Opciones para invitados
          _buildMenuSection('General', [
            _buildMenuItem(
              Icons.volunteer_activism,
              'Ser Voluntario',
              'Únete a nuestro programa',
              () => _showComingSoon(context),
            ),
            _buildMenuItem(
              Icons.group,
              'Equipo del Ministerio',
              'Conoce nuestro personal',
              () => _showComingSoon(context),
            ),
            _buildMenuItem(
              Icons.play_circle,
              'Videos Educativos',
              'Contenido ambiental',
              () => _showComingSoon(context),
            ),
            _buildMenuItem(
              Icons.eco,
              'Medidas Ambientales',
              'Cómo cuidar el medio ambiente',
              () => _showComingSoon(context),
            ),
          ]),

          const SizedBox(height: 24),

          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(title, style: AppTextStyles.subtitle1),
        ),
        CustomCard(
          padding: EdgeInsets.zero,
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.subtitle1.copyWith(color: textColor),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildMenuSection('Acerca de', [
      _buildMenuItem(
        Icons.info,
        'Sobre la Aplicación',
        'Información del desarrollo',
        () => _showAboutDialog(context),
      ),
      _buildMenuItem(
        Icons.phone,
        'Emergencias',
        '*462 (MAMB)',
        () => _launchPhone('*462'),
      ),
      _buildMenuItem(
        Icons.language,
        'Sitio Web',
        'ambiente.gob.do',
        () => _launchUrl('https://ambiente.gob.do'),
      ),
    ]);
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Próximamente'),
        content: const Text('Esta funcionalidad estará disponible pronto.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              authProvider.logout();
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Equipo de Desarrollo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppConstants.equipoDesarrollo.map((developer) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        developer['nombre']![0],
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            developer['nombre']!,
                            style: AppTextStyles.subtitle1,
                          ),
                          Text(
                            'Matrícula: ${developer['matricula']}',
                            style: AppTextStyles.caption,
                          ),
                          if (developer['biografia'] != null &&
                              developer['biografia']!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              developer['biografia']!,
                              style: AppTextStyles.body2,
                            ),
                          ],
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _launchPhone(developer['telefono']!),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Llamar',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () => _launchUrl(
                                  'https://t.me/${developer['telegram']!.substring(1)}',
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.telegram,
                                      size: 16,
                                      color: AppColors.info,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      developer['telegram']!,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.info,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
