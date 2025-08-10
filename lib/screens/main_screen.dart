import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/auth_provider.dart';
import 'home/home_screen.dart';
import 'services/services_screen.dart';
import 'news/news_screen.dart';
import 'areas/areas_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Pantallas públicas
        final List<Widget> publicScreens = [
          const HomeScreen(),
          const ServicesScreen(),
          const NewsScreen(),
          const AreasScreen(),
          const ProfileScreen(),
        ];

        // Etiquetas de navegación pública
        final List<String> publicLabels = [
          'Inicio',
          'Servicios',
          'Noticias',
          'Áreas',
          'Perfil',
        ];

        // Iconos de navegación pública
        final List<IconData> publicIcons = [
          Icons.home,
          Icons.business,
          Icons.article,
          Icons.nature,
          Icons.person,
        ];

        return Scaffold(
          body: IndexedStack(index: _selectedIndex, children: publicScreens),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.1)),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 8,
                ),
                child: GNav(
                  rippleColor: AppColors.secondary.withOpacity(0.3),
                  hoverColor: AppColors.secondary.withOpacity(0.1),
                  gap: 8,
                  activeColor: AppColors.primary,
                  iconSize: 24,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: AppColors.secondary.withOpacity(0.1),
                  color: AppColors.grey,
                  tabs: List.generate(
                    publicLabels.length,
                    (index) => GButton(
                      icon: publicIcons[index],
                      text: publicLabels[index],
                    ),
                  ),
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
