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
import 'login/login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    ServicesScreen(),
    NewsScreen(),
    AreasScreen(),
    ProfileScreen(),
  ];

  static const List<String> _labels = [
    'Inicio',
    'Servicios',
    'Noticias',
    'Áreas',
    'Perfil',
  ];

  static const List<IconData> _icons = [
    Icons.home,
    Icons.business,
    Icons.article,
    Icons.nature,
    Icons.person,
  ];

  void _onLogout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(_labels[_selectedIndex]),
        actions: [
          if (_selectedIndex == 4) // Mostrar logout solo en Perfil
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Cerrar sesión',
              onPressed: () => _onLogout(context),
            ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.1)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: AppColors.secondary.withOpacity(0.3),
              hoverColor: AppColors.secondary.withOpacity(0.1),
              gap: 8,
              activeColor: AppColors.primary,
              iconSize: 24,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.secondary.withOpacity(0.1),
              color: AppColors.grey,
              tabs: List.generate(
                _labels.length,
                (index) => GButton(
                  icon: _icons[index],
                  text: _labels[index],
                ),
              ),
              selectedIndex: _selectedIndex,
              onTabChange: (index) => setState(() => _selectedIndex = index),
            ),
          ),
        ),
      ),
    );
  }
}
