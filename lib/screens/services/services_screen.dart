import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/common_widgets.dart';
import '../../models/servicio.dart';
import '../../services/api_service.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final ApiService _apiService = ApiService();
  List<Servicio> _servicios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServicios();
  }

  Future<void> _loadServicios() async {
    try {
      final servicios = await _apiService.getServicios();
      if (mounted) {
        setState(() {
          _servicios = servicios;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Servicios'),
      body: _isLoading
          ? const LoadingWidget(message: 'Cargando servicios...')
          : _servicios.isEmpty
          ? EmptyStateWidget(
              message: 'No hay servicios disponibles',
              onRetry: _loadServicios,
            )
          : RefreshIndicator(
              onRefresh: _loadServicios,
              child: ListView.builder(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                itemCount: _servicios.length,
                itemBuilder: (context, index) {
                  final servicio = _servicios[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InfoCard(
                      title: servicio.nombre,
                      description: servicio.descripcion,
                      imageUrl: servicio.imagen,
                      onTap: () => _showServiceDetail(servicio),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _showServiceDetail(Servicio servicio) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(servicio.nombre),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (servicio.imagen != null) ...[
                NetworkImageWidget(
                  imageUrl: servicio.imagen!,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
              ],
              Text(servicio.descripcion, style: AppTextStyles.body1),
              if (servicio.url != null) ...[
                const SizedBox(height: 16),
                Text('Más información:', style: AppTextStyles.subtitle2),
                const SizedBox(height: 4),
                Text(
                  servicio.url!,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
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
}
