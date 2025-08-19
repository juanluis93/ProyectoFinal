import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../widgets/common_widgets.dart';
import '../../models/normativa.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';
import '../Login/login_screen.dart';

class NormativasScreen extends StatefulWidget {
  const NormativasScreen({Key? key}) : super(key: key);

  @override
  State<NormativasScreen> createState() => _NormativasScreenState();
}

class _NormativasScreenState extends State<NormativasScreen> {
  final ApiService _apiService = ApiService();
  List<Normativa> _normativas = [];
  List<Normativa> _filteredNormativas = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNormativas();
    _searchController.addListener(_filterNormativas);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNormativas() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAuthenticated) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Necesitamos el token del usuario autenticado
      final token = authProvider.user?.token ?? '';

      List<Normativa> normativas = [];

      if (token.isNotEmpty) {
        try {
          normativas = await _apiService.getNormativas(token);
        } catch (e) {
          print('Error al obtener normativas de API: $e');
          // Si falla la API, usar datos de ejemplo
          normativas = _getMockNormativas();
        }
      } else {
        // Si no hay token, usar datos de ejemplo
        normativas = _getMockNormativas();
      }

      if (mounted) {
        setState(() {
          _normativas = normativas;
          _filteredNormativas = normativas;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error cargando normativas: $e');
      if (mounted) {
        setState(() {
          _normativas = _getMockNormativas();
          _filteredNormativas = _getMockNormativas();
          _isLoading = false;
        });
      }
    }
  }

  List<Normativa> _getMockNormativas() {
    return [
      Normativa(
        id: 1,
        titulo: 'Ley General sobre Medio Ambiente y Recursos Naturales',
        descripcion:
            'Ley No. 64-00 que establece el marco normativo para la gestión del medio ambiente y los recursos naturales.',
        categoria: 'Ley Nacional',
        fecha: '2000-08-18',
        estado: 'Vigente',
        documento: 'https://example.com/ley-64-00.pdf',
      ),
      Normativa(
        id: 2,
        titulo: 'Reglamento sobre Evaluación Ambiental',
        descripcion:
            'Norma que regula los procedimientos para la evaluación de impacto ambiental de proyectos.',
        categoria: 'Reglamento',
        fecha: '2001-03-15',
        estado: 'Vigente',
        documento: 'https://example.com/reglamento-evaluacion.pdf',
      ),
      Normativa(
        id: 3,
        titulo: 'Norma sobre Calidad del Aire',
        descripcion:
            'Establecimiento de límites máximos permisibles para contaminantes atmosféricos.',
        categoria: 'Norma Técnica',
        fecha: '2003-11-22',
        estado: 'Vigente',
      ),
      Normativa(
        id: 4,
        titulo: 'Ley de Residuos Sólidos',
        descripcion:
            'Marco legal para la gestión integral de residuos sólidos urbanos e industriales.',
        categoria: 'Ley Nacional',
        fecha: '2004-07-10',
        estado: 'Vigente',
        documento: 'https://example.com/ley-residuos.pdf',
      ),
      Normativa(
        id: 5,
        titulo: 'Resolución sobre Áreas Protegidas',
        descripcion:
            'Normativa para la creación y gestión de áreas naturales protegidas.',
        categoria: 'Resolución',
        fecha: '2005-09-30',
        estado: 'Vigente',
      ),
    ];
  }

  void _filterNormativas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNormativas = _normativas.where((normativa) {
        return normativa.titulo.toLowerCase().contains(query) ||
            normativa.descripcion.toLowerCase().contains(query) ||
            normativa.categoria.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: !authProvider.isAuthenticated
          ? _buildLoginRequired()
          : _isLoading
          ? const LoadingWidget(message: 'Cargando normativas...')
          : Column(
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
                    'Normativas Ambientales',
                    style: AppTextStyles.heading1,
                    textAlign: TextAlign.center,
                  ),
                ),

                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                  ),
                  child: CustomTextField(
                    label: 'Buscar normativas',
                    hint: 'Título, descripción o categoría...',
                    controller: _searchController,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),

                const SizedBox(height: 16),

                // Lista de normativas
                Expanded(
                  child: _filteredNormativas.isEmpty
                      ? const EmptyStateWidget(
                          message: 'No se encontraron normativas',
                          icon: Icons.gavel_outlined,
                        )
                      : RefreshIndicator(
                          onRefresh: _loadNormativas,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.defaultPadding,
                            ),
                            itemCount: _filteredNormativas.length,
                            itemBuilder: (context, index) {
                              final normativa = _filteredNormativas[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: NormativaCard(
                                  normativa: normativa,
                                  onTap: () => _showNormativaDetail(normativa),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildLoginRequired() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 80, color: AppColors.grey),
            const SizedBox(height: 24),
            Text(
              'Acceso Restringido',
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Debes iniciar sesión para acceder a las normativas ambientales.',
              style: AppTextStyles.body1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Iniciar Sesión',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNormativaDetail(Normativa normativa) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NormativaDetailScreen(normativa: normativa),
      ),
    );
  }
}

class NormativaCard extends StatelessWidget {
  final Normativa normativa;
  final VoidCallback onTap;

  const NormativaCard({Key? key, required this.normativa, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    normativa.categoria,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
              ],
            ),
            const SizedBox(height: 12),
            Text(normativa.titulo, style: AppTextStyles.subtitle1),
            const SizedBox(height: 8),
            Text(
              normativa.descripcion,
              style: AppTextStyles.body2.copyWith(color: AppColors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (normativa.fecha.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: AppColors.grey),
                  const SizedBox(width: 4),
                  Text(
                    normativa.fecha,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NormativaDetailScreen extends StatelessWidget {
  final Normativa normativa;

  const NormativaDetailScreen({Key? key, required this.normativa})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Normativa'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categoría
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                normativa.categoria,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Título
            Text(normativa.titulo, style: AppTextStyles.heading2),

            const SizedBox(height: 16),

            // Fecha de publicación
            if (normativa.fecha.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: AppColors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Publicado: ${normativa.fecha}',
                    style: AppTextStyles.body2.copyWith(color: AppColors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            // Contenido
            Text('Descripción', style: AppTextStyles.subtitle1),
            const SizedBox(height: 8),
            Text(normativa.descripcion, style: AppTextStyles.body1),

            // Botón de descarga si hay documento
            if (normativa.documento != null &&
                normativa.documento!.isNotEmpty) ...[
              const SizedBox(height: 32),
              CustomButton(
                text: 'Ver Documento',
                onPressed: () {
                  // Implementar descarga o abrir en navegador
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abriendo documento...')),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
