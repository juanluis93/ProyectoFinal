import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/common_widgets.dart';
import '../../models/voluntario.dart';
import '../../services/api_service.dart';

class VoluntariadoScreen extends StatefulWidget {
  const VoluntariadoScreen({Key? key}) : super(key: key);

  @override
  State<VoluntariadoScreen> createState() => _VoluntariadoScreenState();
}

class _VoluntariadoScreenState extends State<VoluntariadoScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Controladores de los campos
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _motivacionController = TextEditingController();

  String? _selectedArea;
  String? _selectedDisponibilidad;
  bool _isLoading = false;

  final List<String> _areasInteres = [
    'Conservación de Bosques',
    'Protección Marina',
    'Educación Ambiental',
    'Reciclaje y Residuos',
    'Energías Renovables',
    'Cambio Climático',
    'Biodiversidad',
    'Recursos Hídricos',
  ];

  final List<String> _disponibilidades = [
    'Fines de semana',
    'Entre semana (mañanas)',
    'Entre semana (tardes)',
    'Flexible',
    'Solo eventos especiales',
  ];

  @override
  void dispose() {
    _cedulaController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _motivacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Únete como Voluntario'),
      body: SingleChildScrollView(
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
                        'Voluntariado Ambiental',
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

                  // Cédula
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

                  // Nombre
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

                  // Apellido
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

                  // Email
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

                  // Password
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

                  // Teléfono
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

                  const SizedBox(height: 16),

                  // Dirección
                  CustomTextField(
                    label: 'Dirección',
                    hint: 'Tu dirección',
                    controller: _direccionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu dirección';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Información de Voluntariado',
                    style: AppTextStyles.subtitle1,
                  ),

                  const SizedBox(height: 16),

                  // Área de interés
                  Text('Área de Interés', style: AppTextStyles.body1),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Selecciona un área',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.defaultBorderRadius,
                        ),
                      ),
                    ),
                    value: _selectedArea,
                    items: _areasInteres.map((area) {
                      return DropdownMenuItem(value: area, child: Text(area));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedArea = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor selecciona un área de interés';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Disponibilidad
                  Text('Disponibilidad', style: AppTextStyles.body1),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Selecciona tu disponibilidad',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.defaultBorderRadius,
                        ),
                      ),
                    ),
                    value: _selectedDisponibilidad,
                    items: _disponibilidades.map((disponibilidad) {
                      return DropdownMenuItem(
                        value: disponibilidad,
                        child: Text(disponibilidad),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDisponibilidad = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor selecciona tu disponibilidad';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Motivación
                  CustomTextField(
                    label: 'Motivación',
                    hint: '¿Por qué quieres ser voluntario?',
                    controller: _motivacionController,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor comparte tu motivación';
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
                      border: Border.all(
                        color: AppColors.info.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.info,
                          size: 20,
                        ),
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
      final voluntario = Voluntario(
        id: 0, // Se asignará en el servidor
        cedula: _cedulaController.text.trim(),
        nombre: _nombreController.text.trim(),
        apellido: _apellidoController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        telefono: _telefonoController.text.trim(),
        direccion: _direccionController.text.trim(),
        areaInteres: _selectedArea!,
        disponibilidad: _selectedDisponibilidad!,
        motivacion: _motivacionController.text.trim(),
        fechaRegistro: DateTime.now(),
        estado: 'Pendiente',
      );

      final success = await _apiService.registrarVoluntario(voluntario);

      if (mounted) {
        if (success) {
          _showSuccessDialog();
        } else {
          _showErrorDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          'Tu solicitud de voluntariado ha sido enviada exitosamente. '
          'Nuestro equipo se pondrá en contacto contigo pronto.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              Navigator.of(context).pop(); // Volver a la pantalla anterior
            },
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
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
        content: const Text(
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
