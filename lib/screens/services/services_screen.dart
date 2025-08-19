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

  Widget _buildServiceCard(Servicio servicio) {
    return InkWell(
      onTap: () => _showServiceDetail(servicio),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade100,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.green.shade100),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (servicio.imagen != null && servicio.imagen!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: NetworkImageWidget(
                  imageUrl: servicio.imagen!,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
            if (servicio.imagen != null && servicio.imagen!.isNotEmpty)
              const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    servicio.nombre,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    servicio.descripcion,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade700,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.green.shade700,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header con logo y nombre institucional
              SizedBox(height: 24),
              SizedBox(
                height: 80,
                child: Image.asset("assets/logo.png", fit: BoxFit.contain),
              ),
              const SizedBox(height: 12),
              Text(
                "Ministerio de Medio Ambiente",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.green.shade900,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Servicios",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _isLoading
                    ? const LoadingWidget(message: 'Cargando servicios...')
                    : _servicios.isEmpty
                    ? EmptyStateWidget(
                        message: 'No hay servicios disponibles',
                        onRetry: _loadServicios,
                      )
                    : RefreshIndicator(
                        onRefresh: _loadServicios,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: _servicios.length,
                          itemBuilder: (context, index) {
                            final servicio = _servicios[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildServiceCard(servicio),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
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
