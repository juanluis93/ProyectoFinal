import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/reporte.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/common_widgets.dart';

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({Key? key}) : super(key: key);

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen>
    with TickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late TabController _tabController;

  List<Reporte> _misReportes = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cargarDatos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String token = '';
      if (authProvider.isAuthenticated && authProvider.token != null) {
        token = authProvider.token!;
      }
      final reportes = await _apiService.getReportesUsuario('', token);
      if (mounted) {
        setState(() {
          _misReportes = reportes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
          _misReportes = [];
        });
      }
    }
  }

  List<Reporte> _getReportesEjemplo() {
    return [
      Reporte(
        id: '1',
        codigo: 'RPT-001',
        titulo: 'Contaminación del Río Ozama',
        descripcion:
            'Se observa gran cantidad de desechos plásticos y contaminantes químicos en el río.',
        foto: 'https://picsum.photos/300/200?random=1',
        latitud: 18.4861,
        longitud: -69.9312,
        estado: 'en_proceso',
        comentarioMinisterio:
            'Hemos iniciado una investigación y se enviará un equipo de limpieza.',
        fecha: DateTime.now()
            .subtract(const Duration(days: 3))
            .toIso8601String(),
      ),
      Reporte(
        id: '2',
        codigo: 'RPT-002',
        titulo: 'Deforestación en Jarabacoa',
        descripcion:
            'Tala ilegal de árboles en zona protegida cerca del salto.',
        foto: 'https://picsum.photos/300/200?random=2',
        latitud: 19.1166,
        longitud: -70.6333,
        estado: 'resuelto',
        comentarioMinisterio:
            'Caso resuelto. Se aplicaron las sanciones correspondientes.',
        fecha: DateTime.now()
            .subtract(const Duration(days: 7))
            .toIso8601String(),
      ),
      Reporte(
        id: '3',
        codigo: 'RPT-003',
        titulo: 'Vertedero Clandestino',
        descripcion: 'Acumulación de basura en área verde del municipio.',
        foto: 'https://picsum.photos/300/200?random=3',
        latitud: 18.5204,
        longitud: -69.9442,
        estado: 'pendiente',
        fecha: DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Reportes Ambientales'),
      body: Column(
        children: [
          // Header con estadísticas
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.report_problem, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Sistema de Reportes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      'Total',
                      '${_misReportes.length}',
                      Icons.analytics,
                    ),
                    _buildStatCard(
                      'Pendientes',
                      '${_misReportes.where((r) => r.estado == 'Pendiente').length}',
                      Icons.pending,
                    ),
                    _buildStatCard(
                      'Completados',
                      '${_misReportes.where((r) => r.estado == 'Completado').length}',
                      Icons.check_circle,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            color: Colors.grey[100],
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(icon: Icon(Icons.list), text: 'Mis Reportes'),
                Tab(
                  icon: Icon(Icons.add_circle_outline),
                  text: 'Crear Reporte',
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildMisReportesTab(), _buildCrearReporteTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMisReportesTab() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando reportes...');
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error al cargar reportes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[300],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _cargarDatos,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_misReportes.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.report,
        message: 'Aún no has creado ningún reporte ambiental.',
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarDatos,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _misReportes.length,
        itemBuilder: (context, index) {
          final reporte = _misReportes[index];
          return _buildReporteCard(reporte);
        },
      ),
    );
  }

  Widget _buildReporteCard(Reporte reporte) {
    Color statusColor;
    IconData statusIcon;

    switch (reporte.estado.toLowerCase()) {
      case 'completado':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'en proceso':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.pending;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del reporte
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: reporte.foto != null && reporte.foto!.isNotEmpty
                        ? NetworkImageWidget(
                            imageUrl: reporte.foto!,
                            width: 80,
                            height: 80,
                          )
                        : Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[600],
                            size: 32,
                          ),
                  ),
                ),
                const SizedBox(width: 16),

                // Info del reporte
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reporte.titulo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (reporte.codigo != null)
                        Text(
                          'Código: ${reporte.codigo}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      const SizedBox(height: 8),

                      // Estado
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: statusColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(statusIcon, size: 14, color: statusColor),
                            const SizedBox(width: 4),
                            Text(
                              reporte.estado,
                              style: TextStyle(
                                fontSize: 12,
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Descripción
            Text(
              reporte.descripcion,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Fecha y ubicación
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatFecha(reporte.fecha),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${reporte.latitud.toStringAsFixed(4)}, ${reporte.longitud.toStringAsFixed(4)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),

            // Comentario del ministerio
            if (reporte.comentarioMinisterio != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.admin_panel_settings,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Respuesta del Ministerio',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reporte.comentarioMinisterio!,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatFecha(String fecha) {
    try {
      final dateTime = DateTime.parse(fecha);
      final now = DateTime.now();
      final difference = now.difference(dateTime).inDays;

      if (difference == 0) return 'Hoy';
      if (difference == 1) return 'Ayer';
      if (difference < 7) return 'Hace $difference días';

      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return fecha;
    }
  }

  String _formatEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return 'Pendiente';
      case 'en_proceso':
        return 'En Proceso';
      case 'resuelto':
        return 'Resuelto';
      case 'rechazado':
        return 'Rechazado';
      default:
        return estado;
    }
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'en_proceso':
        return Colors.blue;
      case 'resuelto':
        return Colors.green;
      case 'rechazado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getEstadoIcon(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return Icons.schedule;
      case 'en_proceso':
        return Icons.refresh;
      case 'resuelto':
        return Icons.check_circle;
      case 'rechazado':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildCrearReporteTab() {
    return const Center(child: CrearReporteForm());
  }
}

// Formulario para crear nuevo reporte
class CrearReporteForm extends StatefulWidget {
  const CrearReporteForm({Key? key}) : super(key: key);

  @override
  State<CrearReporteForm> createState() => _CrearReporteFormState();
}

class _CrearReporteFormState extends State<CrearReporteForm> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  bool _isLoading = false;
  double _latitud = 18.4861; // Santo Domingo por defecto
  double _longitud = -69.9312;
  String? _fotoUrl; // Para almacenar la URL de la foto (opcional)

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Reporta problemas ambientales para que nuestro equipo pueda tomar acción.',
                      style: TextStyle(color: AppColors.info, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Título
            CustomTextField(
              label: 'Título del Reporte',
              hint: 'Ej: Contaminación del río, Tala ilegal, etc.',
              controller: _tituloController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El título es requerido';
                }
                if (value.length < 10) {
                  return 'El título debe tener al menos 10 caracteres';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Descripción
            CustomTextField(
              label: 'Descripción Detallada',
              hint: 'Describe el problema ambiental que observaste...',
              controller: _descripcionController,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La descripción es requerida';
                }
                if (value.length < 20) {
                  return 'Proporciona más detalles (mínimo 20 caracteres)';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Ubicación
            Text('Ubicación', style: AppTextStyles.subtitle2),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Coordenadas Actuales',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Latitud: ${_latitud.toStringAsFixed(6)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    'Longitud: ${_longitud.toStringAsFixed(6)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _obtenerUbicacion,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Obtener Mi Ubicación'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Campo de foto opcional
            Text('Foto (Opcional)', style: AppTextStyles.subtitle2),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  if (_fotoUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _fotoUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.error,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _seleccionarFoto,
                          icon: const Icon(Icons.camera_alt),
                          label: Text(
                            _fotoUrl == null ? 'Agregar Foto' : 'Cambiar Foto',
                          ),
                        ),
                      ),
                      if (_fotoUrl != null) ...[
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _fotoUrl = null;
                            });
                          },
                          child: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Botón enviar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _enviarReporte,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(_isLoading ? 'Enviando...' : 'Enviar Reporte'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _obtenerUbicacion() {
    // Simulamos obtener ubicación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de geolocalización no implementada en demo'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _seleccionarFoto() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController urlController = TextEditingController();

        return AlertDialog(
          title: const Text('Agregar Foto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Puedes usar una imagen de ejemplo o ingresar tu propia URL:',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'URL de la imagen',
                  hintText: 'https://ejemplo.com/imagen.jpg',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _fotoUrl =
                      'https://picsum.photos/400/300?random=${DateTime.now().millisecondsSinceEpoch}';
                });
                Navigator.of(context).pop();
              },
              child: const Text('Imagen de Ejemplo'),
            ),
            ElevatedButton(
              onPressed: () {
                if (urlController.text.trim().isNotEmpty) {
                  setState(() {
                    _fotoUrl = urlController.text.trim();
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor ingresa una URL válida'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text('Usar URL'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _enviarReporte() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final reporte = Reporte(
        titulo: _tituloController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        latitud: _latitud,
        longitud: _longitud,
        fecha: DateTime.now().toIso8601String(),
        estado: 'pendiente',
        foto: _fotoUrl, // Incluir la foto si existe
      );

      bool success;
      if (authProvider.isAuthenticated && authProvider.token != null) {
        // Usar token JWT para autenticar la petición
        success = await ApiService().crearReporte(reporte, authProvider.token!);
      } else {
        // Simular éxito para usuarios no autenticados (demo)
        await Future.delayed(const Duration(seconds: 2));
        success = true;
      }

      if (mounted) {
        if (success) {
          _mostrarDialogoExito();
          _limpiarFormulario();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Error al enviar el reporte. Inténtalo nuevamente.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _mostrarDialogoExito() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            const Text('¡Reporte Enviado!'),
          ],
        ),
        content: const Text(
          'Tu reporte ha sido enviado exitosamente. Nuestro equipo lo revisará y tomará las acciones necesarias.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Cambiar a la pestaña de "Mis Reportes"
              if (context.findAncestorStateOfType<_ReportesScreenState>() !=
                  null) {
                context
                    .findAncestorStateOfType<_ReportesScreenState>()!
                    ._tabController
                    .animateTo(0);
              }
            },
            child: const Text('Ver Mis Reportes'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  void _limpiarFormulario() {
    _tituloController.clear();
    _descripcionController.clear();
    setState(() {
      _fotoUrl = null;
      _latitud = 18.4861; // Resetear a Santo Domingo
      _longitud = -69.9312;
    });
  }
}
