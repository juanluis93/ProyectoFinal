import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/common_widgets.dart';
import '../../models/medida_ambiental.dart';
import '../../services/api_service.dart';

class MedidasScreen extends StatefulWidget {
  const MedidasScreen({Key? key}) : super(key: key);

  @override
  State<MedidasScreen> createState() => _MedidasScreenState();
}

class _MedidasScreenState extends State<MedidasScreen> {
  final ApiService _apiService = ApiService();
  List<MedidaAmbiental> _medidas = [];
  List<MedidaAmbiental> _filteredMedidas = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMedidas();
    _searchController.addListener(_filterMedidas);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMedidas() async {
    try {
      final medidas = await _apiService.getMedidas();
      if (mounted) {
        setState(() {
          _medidas = medidas;
          _filteredMedidas = medidas;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error cargando medidas: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Mostrar mensaje de error al usuario
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar las medidas: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterMedidas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMedidas = _medidas.where((medida) {
        return medida.titulo.toLowerCase().contains(query) ||
            medida.descripcion.toLowerCase().contains(query) ||
            medida.categoria.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Medidas Ambientales'),
      body: _isLoading
          ? const LoadingWidget(message: 'Cargando medidas ambientales...')
          : Column(
              children: [
                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: CustomTextField(
                    label: 'Buscar medidas',
                    hint: 'Título, descripción o categoría...',
                    controller: _searchController,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),

                // Lista de medidas
                Expanded(
                  child: _filteredMedidas.isEmpty
                      ? const EmptyStateWidget(
                          message: 'No se encontraron medidas ambientales',
                          icon: Icons.eco_outlined,
                        )
                      : RefreshIndicator(
                          onRefresh: _loadMedidas,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.defaultPadding,
                            ),
                            itemCount: _filteredMedidas.length,
                            itemBuilder: (context, index) {
                              final medida = _filteredMedidas[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: MedidaCard(
                                  medida: medida,
                                  onTap: () => _showMedidaDetail(medida),
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

  void _showMedidaDetail(MedidaAmbiental medida) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MedidaDetailScreen(medida: medida),
      ),
    );
  }
}

class MedidaCard extends StatelessWidget {
  final MedidaAmbiental medida;
  final VoidCallback onTap;

  const MedidaCard({Key? key, required this.medida, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título y categoría
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(medida.titulo, style: AppTextStyles.subtitle1),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(medida.categoria).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    medida.categoria,
                    style: AppTextStyles.caption.copyWith(
                      color: _getCategoryColor(medida.categoria),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Descripción
            Text(
              medida.descripcion,
              style: AppTextStyles.body2,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Información adicional
            Row(
              children: [
                Icon(
                  _getCategoryIcon(medida.categoria),
                  size: 16,
                  color: AppColors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  medida.categoria,
                  style: AppTextStyles.caption.copyWith(color: AppColors.grey),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'conservación':
        return AppColors.success;
      case 'energía':
        return AppColors.warning;
      case 'agua':
        return AppColors.info;
      case 'residuos':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'conservación':
        return Icons.nature;
      case 'energía':
        return Icons.bolt;
      case 'agua':
        return Icons.water_drop;
      case 'residuos':
        return Icons.recycling;
      default:
        return Icons.eco;
    }
  }
}

class MedidaDetailScreen extends StatelessWidget {
  final MedidaAmbiental medida;

  const MedidaDetailScreen({Key? key, required this.medida}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Medida Ambiental'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título y categoría
            Text(medida.titulo, style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                medida.categoria,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Descripción
            Text('Descripción', style: AppTextStyles.subtitle1),
            const SizedBox(height: 8),
            Text(medida.descripcion, style: AppTextStyles.body1),

            const SizedBox(height: 24),

            // Consejos
            if (medida.consejos?.isNotEmpty == true) ...[
              Text('Consejos', style: AppTextStyles.subtitle1),
              const SizedBox(height: 8),
              Text(medida.consejos!, style: AppTextStyles.body1),
              const SizedBox(height: 24),
            ],

            // Imagen
            if (medida.imagen != null) ...[
              Text('Imagen de referencia', style: AppTextStyles.subtitle1),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppConstants.defaultBorderRadius,
                ),
                child: NetworkImageWidget(
                  imageUrl: medida.imagen!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
