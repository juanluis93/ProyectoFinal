import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/common_widgets.dart';
import '../../models/voluntario.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class VoluntariadoScreen extends StatefulWidget {
  const VoluntariadoScreen({Key? key}) : super(key: key);

  @override
  State<VoluntariadoScreen> createState() => _VoluntariadoScreenState();
}

class _VoluntariadoScreenState extends State<VoluntariadoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  List<Voluntario>? _voluntarios;
  List<Map<String, dynamic>>? _actividades;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Cargar voluntarios y actividades en paralelo
      final results = await Future.wait([
        _loadVoluntarios(),
        _loadActividades(),
      ]);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadVoluntarios() async {
    try {
      // Simulamos datos de voluntarios ya que la API puede no tener este endpoint
      _voluntarios = [
        Voluntario(
          id: 1,
          cedula: '001-0123456-7',
          nombre: 'Ana',
          apellido: 'Rodriguez',
          email: 'ana.rodriguez@email.com',
          password: '',
          telefono: '(809) 555-0101',
          direccion: 'Santo Domingo',
          areaInteres: 'Conservación de Bosques',
          disponibilidad: 'Fines de semana',
          motivacion: 'Quiero contribuir a la preservación del medio ambiente.',
          fechaRegistro: DateTime.now().subtract(const Duration(days: 15)),
          estado: 'Activo',
        ),
        Voluntario(
          id: 2,
          cedula: '001-0234567-8',
          nombre: 'Juan',
          apellido: 'Pérez',
          email: 'juan.perez@email.com',
          password: '',
          telefono: '(809) 555-0102',
          direccion: 'Santiago',
          areaInteres: 'Educación Ambiental',
          disponibilidad: 'Entre semana (tardes)',
          motivacion: 'Me apasiona educar sobre temas ambientales.',
          fechaRegistro: DateTime.now().subtract(const Duration(days: 8)),
          estado: 'Activo',
        ),
        Voluntario(
          id: 3,
          cedula: '001-0345678-9',
          nombre: 'Ana',
          apellido: 'Rodríguez',
          email: 'ana.rodriguez@email.com',
          password: '',
          telefono: '(809) 555-0103',
          direccion: 'La Vega',
          areaInteres: 'Protección Marina',
          disponibilidad: 'Flexible',
          motivacion: 'Quiero proteger nuestros océanos y costas.',
          fechaRegistro: DateTime.now().subtract(const Duration(days: 3)),
          estado: 'Pendiente',
        ),
      ];
    } catch (e) {
      print('Error loading voluntarios: $e');
    }
  }

  Future<void> _loadActividades() async {
    try {
      // Simulamos actividades/eventos de voluntariado
      _actividades = [
        {
          'id': 1,
          'titulo': 'Limpieza de Playa Boca Chica',
          'descripcion':
              'Jornada de limpieza y concienciación en la playa de Boca Chica',
          'fecha': DateTime.now().add(const Duration(days: 7)),
          'ubicacion': 'Playa Boca Chica, Santo Domingo',
          'participantes': 25,
          'maxParticipantes': 50,
          'categoria': 'Protección Marina',
          'duracion': '4 horas',
        },
        {
          'id': 2,
          'titulo': 'Reforestación en Jarabacoa',
          'descripcion':
              'Plantación de árboles nativos en la zona montañosa de Jarabacoa',
          'fecha': DateTime.now().add(const Duration(days: 14)),
          'ubicacion': 'Jarabacoa, La Vega',
          'participantes': 18,
          'maxParticipantes': 30,
          'categoria': 'Conservación de Bosques',
          'duracion': '6 horas',
        },
        {
          'id': 3,
          'titulo': 'Taller de Reciclaje Comunitario',
          'descripcion':
              'Enseñanza de técnicas de reciclaje y reutilización en comunidades',
          'fecha': DateTime.now().add(const Duration(days: 21)),
          'ubicacion': 'Centro Comunitario Los Alcarrizos',
          'participantes': 12,
          'maxParticipantes': 20,
          'categoria': 'Reciclaje y Residuos',
          'duracion': '3 horas',
        },
        {
          'id': 4,
          'titulo': 'Monitoreo de Biodiversidad',
          'descripcion':
              'Censo y documentación de especies en el Parque Nacional Los Haitises',
          'fecha': DateTime.now().add(const Duration(days: 28)),
          'ubicacion': 'Parque Nacional Los Haitises',
          'participantes': 8,
          'maxParticipantes': 15,
          'categoria': 'Biodiversidad',
          'duracion': '8 horas',
        },
      ];
    } catch (e) {
      print('Error loading actividades: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          // Header personalizado
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.volunteer_activism,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Voluntariado Ambiental',
                        style: AppTextStyles.heading2.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.eco, color: Colors.white.withOpacity(0.9)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Únete a la misión de proteger nuestro medio ambiente',
                          style: AppTextStyles.body2.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Pestañas
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(icon: Icon(Icons.how_to_reg), text: 'Registro'),
                Tab(icon: Icon(Icons.event), text: 'Actividades'),
                Tab(icon: Icon(Icons.people), text: 'Comunidad'),
              ],
            ),
          ),

          // Contenido de las pestañas
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRegistroTab(),
                _buildActividadesTab(),
                _buildComunidadTab(authProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Pestaña de Registro
  Widget _buildRegistroTab() {
    return _RegistroVoluntarioWidget();
  }

  // Pestaña de Actividades
  Widget _buildActividadesTab() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando actividades...');
    }

    if (_actividades == null || _actividades!.isEmpty) {
      return const EmptyStateWidget(
        message: 'No hay actividades disponibles en este momento',
        icon: Icons.event_busy,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadActividades,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _actividades!.length,
        itemBuilder: (context, index) {
          final actividad = _actividades![index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: _buildActividadCard(actividad),
          );
        },
      ),
    );
  }

  // Pestaña de Comunidad
  Widget _buildComunidadTab(AuthProvider authProvider) {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando voluntarios...');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estadísticas
          _buildEstadisticas(),

          const SizedBox(height: 24),

          // Lista de voluntarios activos
          Text('Voluntarios Activos', style: AppTextStyles.heading3),

          const SizedBox(height: 16),

          if (_voluntarios != null)
            ..._voluntarios!
                .where((v) => v.estado == 'Activo')
                .map(
                  (voluntario) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: _buildVoluntarioCard(voluntario),
                  ),
                )
                .toList()
          else
            const EmptyStateWidget(
              message: 'No hay voluntarios registrados',
              icon: Icons.people_outline,
            ),
        ],
      ),
    );
  }

  // Tarjeta de actividad
  Widget _buildActividadCard(Map<String, dynamic> actividad) {
    final DateTime fecha = actividad['fecha'];
    final bool isProxima = fecha.isAfter(DateTime.now());

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono de categoría
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.defaultBorderRadius),
                topRight: Radius.circular(AppConstants.defaultBorderRadius),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getCategoriaColor(actividad['categoria']).withOpacity(0.8),
                  _getCategoriaColor(actividad['categoria']),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getCategoriaIcon(actividad['categoria']),
                  size: 50,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    actividad['categoria'],
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y categoría
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        actividad['titulo'],
                        style: AppTextStyles.subtitle1,
                      ),
                    ),
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
                        actividad['categoria'],
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(actividad['descripcion'], style: AppTextStyles.body2),

                const SizedBox(height: 12),

                // Fecha y ubicación
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${fecha.day}/${fecha.month}/${fecha.year}',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(actividad['duracion'], style: AppTextStyles.caption),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        actividad['ubicacion'],
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Participantes
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Participantes: ${actividad['participantes']}/${actividad['maxParticipantes']}',
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value:
                                actividad['participantes'] /
                                actividad['maxParticipantes'],
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    CustomButton(
                      text: isProxima ? 'Unirse' : 'Finalizada',
                      onPressed: isProxima
                          ? () => _unirseActividad(actividad)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tarjeta de voluntario
  Widget _buildVoluntarioCard(Voluntario voluntario) {
    return CustomCard(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(Icons.person, color: AppColors.primary),
        ),
        title: Text('${voluntario.nombre} ${voluntario.apellido}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(voluntario.areaInteres ?? ''),
            Text(
              '${voluntario.direccion} • ${voluntario.disponibilidad}',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            voluntario.estado ?? '',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Estadísticas de la comunidad
  Widget _buildEstadisticas() {
    final totalVoluntarios = _voluntarios?.length ?? 0;
    final voluntariosActivos =
        _voluntarios?.where((v) => v.estado == 'Activo').length ?? 0;
    final proximasActividades =
        _actividades
            ?.where((a) => (a['fecha'] as DateTime).isAfter(DateTime.now()))
            .length ??
        0;

    return Row(
      children: [
        Expanded(
          child: _buildEstadisticaCard(
            'Total Voluntarios',
            totalVoluntarios.toString(),
            Icons.people,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildEstadisticaCard(
            'Activos',
            voluntariosActivos.toString(),
            Icons.check_circle,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildEstadisticaCard(
            'Próximas Actividades',
            proximasActividades.toString(),
            Icons.event,
            AppColors.info,
          ),
        ),
      ],
    );
  }

  Widget _buildEstadisticaCard(
    String titulo,
    String valor,
    IconData icon,
    Color color,
  ) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(valor, style: AppTextStyles.heading3.copyWith(color: color)),
            Text(
              titulo,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoriaIcon(String categoria) {
    switch (categoria) {
      case 'Protección Marina':
        return Icons.waves;
      case 'Conservación de Bosques':
        return Icons.forest;
      case 'Reciclaje y Residuos':
        return Icons.recycling;
      case 'Biodiversidad':
        return Icons.pets;
      case 'Educación Ambiental':
        return Icons.school;
      default:
        return Icons.eco;
    }
  }

  Color _getCategoriaColor(String categoria) {
    switch (categoria) {
      case 'Protección Marina':
        return Colors.blue;
      case 'Conservación de Bosques':
        return Colors.green;
      case 'Reciclaje y Residuos':
        return Colors.orange;
      case 'Biodiversidad':
        return Colors.purple;
      case 'Educación Ambiental':
        return Colors.teal;
      default:
        return AppColors.primary;
    }
  }

  void _unirseActividad(Map<String, dynamic> actividad) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unirse a Actividad'),
        content: Text(
          '¿Deseas unirte a "${actividad['titulo']}"?\n\n'
          'Fecha: ${(actividad['fecha'] as DateTime).day}/${(actividad['fecha'] as DateTime).month}/${(actividad['fecha'] as DateTime).year}\n'
          'Ubicación: ${actividad['ubicacion']}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          CustomButton(
            text: 'Confirmar',
            onPressed: () {
              Navigator.pop(context);
              _confirmarParticipacion(actividad);
            },
          ),
        ],
      ),
    );
  }

  void _confirmarParticipacion(Map<String, dynamic> actividad) {
    // Simular confirmación de participación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Te has unido a "${actividad['titulo']}"!'),
        backgroundColor: AppColors.success,
      ),
    );

    // Incrementar participantes localmente
    setState(() {
      actividad['participantes']++;
    });
  }
}

// Widget separado para el formulario de registro
class _RegistroVoluntarioWidget extends StatefulWidget {
  @override
  _RegistroVoluntarioWidgetState createState() =>
      _RegistroVoluntarioWidgetState();
}

class _RegistroVoluntarioWidgetState extends State<_RegistroVoluntarioWidget> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Solo los controladores para los campos que acepta la API
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _cedulaController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Introducción
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                AppConstants.defaultBorderRadius,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.volunteer_activism,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Únete como Voluntario',
                      style: AppTextStyles.subtitle1.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Únete a nuestra misión de proteger el medio ambiente de República Dominicana. Tu tiempo y dedicación pueden marcar la diferencia.',
                  style: AppTextStyles.body2,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Formulario
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Información Personal', style: AppTextStyles.subtitle1),
                const SizedBox(height: 16),

                // Campos del formulario - Solo los que acepta la API
                CustomTextField(
                  label: 'Cédula',
                  hint: '000-0000000-0',
                  controller: _cedulaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu cédula';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Nombre',
                  hint: 'Tu nombre',
                  controller: _nombreController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Apellido',
                  hint: 'Tu apellido',
                  controller: _apellidoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu apellido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Email',
                  hint: 'tu@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu email';
                    }
                    if (!value.contains('@')) {
                      return 'Por favor ingresa un email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Contraseña',
                  hint: 'Crea una contraseña',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor crea una contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Teléfono',
                  hint: '(809) 000-0000',
                  controller: _telefonoController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu teléfono';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Botón de envío
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: _isLoading
                        ? 'Enviando...'
                        : 'Registrarme como Voluntario',
                    onPressed: _isLoading ? null : _submitForm,
                    isLoading: _isLoading,
                  ),
                ),
                const SizedBox(height: 16),

                // Información adicional
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.defaultBorderRadius,
                    ),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.info, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Una vez enviado el formulario, nuestro equipo se pondrá en contacto contigo para coordinar tu participación.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.info,
                          ),
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
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Crear objeto voluntario solo con los campos que acepta la API
      final voluntario = Voluntario(
        id: 0, // Se asignará en el servidor
        cedula: _cedulaController.text.trim(),
        nombre: _nombreController.text.trim(),
        apellido: _apellidoController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        telefono: _telefonoController.text.trim(),
        // Campos requeridos por el modelo pero no por la API - usar valores por defecto
        direccion: '',
        areaInteres: '',
        disponibilidad: '',
        motivacion: '',
        fechaRegistro: DateTime.now(),
        estado: 'Activo',
      );

      print('Datos del voluntario a enviar: ${voluntario.toJson()}');

      // Intentar registrar en la API real
      bool success = false;
      String errorMessage = '';

      try {
        success = await _apiService.registrarVoluntario(voluntario);
        print('Resultado del registro: $success');
      } catch (e) {
        print('Error conectando con API: $e');
        errorMessage = e.toString().replaceAll('Exception: ', '');
        success = false;
      }

      if (mounted) {
        if (success) {
          _showSuccessDialog();
          _limpiarFormulario();
        } else {
          _showErrorDialog(
            errorMessage.isEmpty
                ? 'No se pudo procesar tu solicitud. Verifica que todos los campos estén completos e intenta nuevamente.'
                : errorMessage,
          );
        }
      }
    } catch (e) {
      print('Error general: $e');
      if (mounted) {
        _showErrorDialog('Error inesperado. Por favor intenta nuevamente.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _limpiarFormulario() {
    _cedulaController.clear();
    _nombreController.clear();
    _apellidoController.clear();
    _emailController.clear();
    _passwordController.clear();
    _telefonoController.clear();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: 8),
            const Text('¡Registro Exitoso!'),
          ],
        ),
        content: const Text(
          '¡Tu solicitud de voluntariado ha sido enviada exitosamente!\n\n'
          'Hemos registrado tu información y nuestro equipo se pondrá en contacto '
          'contigo pronto para coordinar tu participación en las actividades ambientales.\n\n'
          '¡Gracias por unirte a nuestra misión de proteger el medio ambiente de República Dominicana! 🌱',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
            },
            child: const Text('¡Excelente!'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog([String? mensaje]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: AppColors.error),
            const SizedBox(width: 8),
            const Text('Error'),
          ],
        ),
        content: Text(
          mensaje ??
              'No se pudo enviar tu solicitud. '
                  'Por favor, verifica tu conexión e intenta nuevamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
