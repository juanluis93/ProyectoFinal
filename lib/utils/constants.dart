import 'package:flutter/material.dart';

class AppColors {
  // Colores principales del Ministerio de Medio Ambiente
  static const Color primary = Color(0xFF2E7D32); // Verde oscuro
  static const Color primaryLight = Color(0xFF4CAF50); // Verde claro
  static const Color primaryDark = Color(0xFF1B5E20); // Verde muy oscuro

  // Colores secundarios
  static const Color secondary = Color(0xFF81C784); // Verde pastel
  static const Color accent = Color(0xFFFFEB3B); // Amarillo

  // Colores de estado
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Colores neutros
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF757575);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF424242);

  // Colores de fondo
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
}

class AppConstants {
  // URLs
  static const String baseUrl = 'https://adamix.net/medioambiente/';
  static const String apiUrl = 'https://adamix.net/medioambiente/def';

  // Configuración de la app
  static const String appName = 'Ministerio Ambiente RD';
  static const String appVersion = '1.0.0';

  // Configuración del mapa
  static const double defaultLatitude = 18.7357;
  static const double defaultLongitude = -70.1627;
  static const double defaultZoom = 8.0;

  // Configuración de imágenes
  static const String placeholderImage = 'assets/images/placeholder.png';
  static const String logoMinisterio = 'assets/images/logo_ministerio.png';

  // Dimensiones
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double cardElevation = 2.0;

  // Configuración de formularios
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxPhoneLength = 15;
  static const int maxCedulaLength = 11;

  // Mensajes
  static const String noInternetMessage = 'No hay conexión a internet';
  static const String genericErrorMessage =
      'Ha ocurrido un error. Intenta de nuevo';
  static const String loginRequiredMessage =
      'Debes iniciar sesión para continuar';
  static const String dataNotFoundMessage = 'No se encontraron datos';

  // Datos del equipo de desarrollo (placeholder)
  static const List<Map<String, String>> equipoDesarrollo = [
    {
      'nombre': 'Juan Pérez',
      'matricula': '2020-1234',
      'telefono': '809-123-4567',
      'telegram': '@juanperez',
      'foto': 'assets/images/developer1.jpg',
    },
    {
      'nombre': 'María García',
      'matricula': '2020-5678',
      'telefono': '809-987-6543',
      'telegram': '@mariagarcia',
      'foto': 'assets/images/developer2.jpg',
    },
  ];
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.grey,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    color: AppColors.black,
  );

  static const TextStyle body2 = TextStyle(fontSize: 14, color: AppColors.grey);

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.grey,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: MaterialColor(0xFF2E7D32, {
        50: Color(0xFFE8F5E8),
        100: Color(0xFFC8E6C9),
        200: Color(0xFFA5D6A7),
        300: Color(0xFF81C784),
        400: Color(0xFF66BB6A),
        500: Color(0xFF4CAF50),
        600: Color(0xFF43A047),
        700: Color(0xFF388E3C),
        800: Color(0xFF2E7D32),
        900: Color(0xFF1B5E20),
      }),
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.defaultBorderRadius,
            ),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
