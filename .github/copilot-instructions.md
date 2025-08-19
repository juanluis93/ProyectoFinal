<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Copilot Instructions para Ministerio de Medio Ambiente App

Este es un proyecto de aplicación Flutter para el Ministerio de Medio Ambiente de República Dominicana.

## Contexto del Proyecto
- **Framework**: Flutter 3.8.1+
- **Lenguaje**: Dart
- **Gestión de Estado**: Provider
- **API Base**: https://adamix.net/medioambiente/

## Arquitectura y Patrones
- Sigue el patrón de arquitectura MVVM con Provider
- Separa la lógica de negocio en servicios
- Usa modelos de datos bien definidos
- Implementa widgets reutilizables

## Convenciones de Código
- Usa nombres descriptivos en español para variables relacionadas con el dominio
- Sigue las convenciones de Dart para nombres de clases, métodos y variables
- Mantén consistencia en el manejo de errores con try-catch
- Usa const constructors cuando sea posible para optimizar rendimiento

## Estructura de Carpetas
```
lib/
├── models/          # Modelos de datos
├── services/        # Servicios de API y autenticación
├── providers/       # Providers para gestión de estado
├── screens/         # Pantallas de la aplicación
├── widgets/         # Widgets reutilizables
└── utils/           # Constantes y utilidades
```

## Temas Específicos
- **Colores**: Usa AppColors.primary (#2E7D32) como color principal
- **Tema**: El tema está definido en AppTheme.lightTheme
- **API**: Todos los endpoints están centralizados en ApiService
- **Autenticación**: Gestión con AuthProvider y AuthService

## Requisitos Especiales
- La app debe funcionar sin autenticación para módulos públicos
- Los módulos privados requieren login
- Implementar manejo de errores amigable al usuario
- Usar LoadingWidget y EmptyStateWidget para estados de carga y vacío
- Integrar Google Maps para áreas protegidas
- Manejar permisos de cámara y ubicación

## Buenas Prácticas
- Siempre verifica si el widget está montado antes de llamar setState
- Usa CustomCard, CustomButton y otros widgets comunes para consistencia
- Implementa pull-to-refresh en listas
- Usa NetworkImageWidget para imágenes de red con placeholder
- Maneja estados de carga, error y éxito en todas las pantallas

## APIs y Endpoints
- Servicios públicos: no requieren autenticación
- Servicios privados: requieren token Bearer
- Usar ApiService para todas las llamadas HTTP
- Manejar códigos de respuesta HTTP apropiadamente

## Consideraciones de UX
- Mostrar mensajes informativos al usuario
- Usar animaciones sutiles y transiciones suaves
- Implementar navegación intuitiva
- Mantener consistencia visual en toda la app
