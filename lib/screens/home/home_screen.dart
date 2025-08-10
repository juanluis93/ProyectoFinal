import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';
import '../videos/videos_screen.dart';
import '../medidas/medidas_screen.dart';
import '../equipo/equipo_screen.dart';
import '../voluntariado/voluntariado_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentSlide = 0;

  final List<Map<String, String>> _sliderItems = [
    {
      'image':
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
      'title': 'Protegemos Nuestros Bosques',
      'description':
          'Trabajamos para conservar la biodiversidad de República Dominicana',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800',
      'title': 'Agua Limpia Para Todos',
      'description':
          'Protegemos nuestras fuentes de agua para las futuras generaciones',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=800',
      'title': 'Energía Renovable',
      'description': 'Promovemos el uso de energías limpias y sostenibles',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1569163139394-de44cb5c4d32?w=800',
      'title': 'Educación Ambiental',
      'description': 'Formamos ciudadanos conscientes del medio ambiente',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        final nextPage = (_currentSlide + 1) % _sliderItems.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startAutoSlide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Ministerio Ambiente RD',
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isAuthenticated) {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => _showLogoutDialog(context, authProvider),
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () => _navigateToLogin(context),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider de imágenes
            _buildImageSlider(),

            const SizedBox(height: 24),

            // Sección de acceso rápido
            _buildQuickAccessSection(),

            const SizedBox(height: 24),

            // Sección de información
            _buildInfoSection(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _sliderItems.length,
            onPageChanged: (index) {
              setState(() {
                _currentSlide = index;
              });
            },
            itemBuilder: (context, index) {
              final item = _sliderItems[index];
              return _buildSliderItem(item);
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _sliderItems.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _pageController.animateToPage(
                entry.key,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentSlide == entry.key
                      ? AppColors.primary
                      : AppColors.greyLight,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSliderItem(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Stack(
          children: [
            NetworkImageWidget(
              imageUrl: item['image']!,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['description']!,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Acceso Rápido', style: AppTextStyles.heading2),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildQuickAccessCard(
                'Videos Educativos',
                Icons.play_circle_fill,
                AppColors.info,
                () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const VideosScreen()),
                ),
              ),
              _buildQuickAccessCard(
                'Medidas Ambientales',
                Icons.eco,
                AppColors.success,
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MedidasScreen(),
                  ),
                ),
              ),
              _buildQuickAccessCard(
                'Equipo',
                Icons.group,
                AppColors.warning,
                () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const EquipoScreen()),
                ),
              ),
              _buildQuickAccessCard(
                'Voluntariado',
                Icons.volunteer_activism,
                AppColors.error,
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const VoluntariadoScreen(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.subtitle1,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Información', style: AppTextStyles.heading2),
          const SizedBox(height: 16),
          InfoCard(
            title: 'Sobre Nosotros',
            description: 'Conoce la historia, misión y visión del Ministerio',
            onTap: () => _showAboutUs(context),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const SizedBox(height: 12),
          InfoCard(
            title: 'Emergencias Ambientales',
            description: 'Línea directa: *462 (MAMB)',
            trailing: const Icon(Icons.phone, color: AppColors.error),
          ),
          const SizedBox(height: 12),
          InfoCard(
            title: 'Horario de Atención',
            description: 'Lunes a Viernes: 8:00 AM - 4:00 PM',
            trailing: const Icon(Icons.schedule, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  void _showAboutUs(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre Nosotros'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Misión', style: AppTextStyles.subtitle1),
              const SizedBox(height: 8),
              const Text(
                'Proteger y conservar el medio ambiente y los recursos naturales de República Dominicana para las generaciones presentes y futuras.',
              ),
              const SizedBox(height: 16),
              Text('Visión', style: AppTextStyles.subtitle1),
              const SizedBox(height: 8),
              const Text(
                'Ser la institución líder en la gestión ambiental del país, promoviendo el desarrollo sostenible y la conciencia ecológica.',
              ),
              const SizedBox(height: 16),
              Text('Valores', style: AppTextStyles.subtitle1),
              const SizedBox(height: 8),
              const Text(
                '• Responsabilidad ambiental\n'
                '• Transparencia\n'
                '• Sostenibilidad\n'
                '• Participación ciudadana\n'
                '• Innovación',
              ),
            ],
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

  void _navigateToLogin(BuildContext context) {
    _showComingSoon(context);
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
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
