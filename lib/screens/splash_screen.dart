import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'main_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToHome();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  Future<void> _navigateToHome() async {
  // Esperar animación
  await Future.delayed(const Duration(seconds: 3));

  if (!mounted) return;

  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  // Esperar hasta que termine la inicialización si quieres
  while (!authProvider.initialized) {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  if (authProvider.isAuthenticated) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  } else {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo del Ministerio
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.eco,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Título de la app
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Ministerio de',
                          style: AppTextStyles.heading2.copyWith(
                            color: AppColors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Medio Ambiente',
                          style: AppTextStyles.heading1.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'República Dominicana',
                          style: AppTextStyles.subtitle1.copyWith(
                            color: AppColors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                 
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Cargando...',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
