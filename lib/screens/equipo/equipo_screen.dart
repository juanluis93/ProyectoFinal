import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/common_widgets.dart';
import '../../models/personal.dart';
import '../../services/api_service.dart';

class EquipoScreen extends StatefulWidget {
  const EquipoScreen({Key? key}) : super(key: key);

  @override
  State<EquipoScreen> createState() => _EquipoScreenState();
}

class _EquipoScreenState extends State<EquipoScreen> {
  final ApiService _apiService = ApiService();
  List<Personal> _personal = [];
  List<Personal> _filteredPersonal = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _selectedDepartment = 'Todos';

  final List<String> _departments = [
    'Todos',
    'Dirección',
    'Conservación',
    'Fiscalización',
    'Educación Ambiental',
    'Recursos Naturales',
    'Cambio Climático',
  ];

  @override
  void initState() {
    super.initState();
    _loadPersonal();
    _searchController.addListener(_filterPersonal);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPersonal() async {
    try {
      final personal = await _apiService.getPersonal();
      if (mounted) {
        setState(() {
          _personal = personal;
          _filteredPersonal = personal;
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

  void _filterPersonal() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPersonal = _personal.where((person) {
        final matchesSearch =
            person.fullName.toLowerCase().contains(query) ||
            person.cargo.toLowerCase().contains(query) ||
            (person.departamento?.toLowerCase().contains(query) ?? false);

        final matchesDepartment =
            _selectedDepartment == 'Todos' ||
            person.departamento == _selectedDepartment;

        return matchesSearch && matchesDepartment;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Nuestro Equipo'),
      body: _isLoading
          ? const LoadingWidget(message: 'Cargando equipo...')
          : Column(
              children: [
                // Filtros
                Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    children: [
                      // Barra de búsqueda
                      CustomTextField(
                        label: 'Buscar personal',
                        hint: 'Nombre, cargo o departamento...',
                        controller: _searchController,
                        prefixIcon: const Icon(Icons.search),
                      ),

                      const SizedBox(height: 12),

                      // Filtro por departamento
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _departments.length,
                          itemBuilder: (context, index) {
                            final department = _departments[index];
                            final isSelected =
                                _selectedDepartment == department;

                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(department),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedDepartment = department;
                                  });
                                  _filterPersonal();
                                },
                                backgroundColor: AppColors.greyLight,
                                selectedColor: AppColors.primary.withOpacity(
                                  0.2,
                                ),
                                checkmarkColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Lista del personal
                Expanded(
                  child: _filteredPersonal.isEmpty
                      ? const EmptyStateWidget(
                          message: 'No se encontró personal',
                          icon: Icons.group_outlined,
                        )
                      : RefreshIndicator(
                          onRefresh: _loadPersonal,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.defaultPadding,
                            ),
                            itemCount: _filteredPersonal.length,
                            itemBuilder: (context, index) {
                              final person = _filteredPersonal[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: PersonCard(
                                  person: person,
                                  onTap: () => _showPersonDetail(person),
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

  void _showPersonDetail(Personal person) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PersonDetailScreen(person: person),
      ),
    );
  }
}

class PersonCard extends StatelessWidget {
  final Personal person;
  final VoidCallback onTap;

  const PersonCard({Key? key, required this.person, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Foto de perfil
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.greyLight,
              backgroundImage: person.foto != null
                  ? NetworkImage(person.foto!)
                  : null,
              child: person.foto == null
                  ? Text(
                      _getInitials(person.fullName),
                      style: AppTextStyles.subtitle1.copyWith(
                        color: AppColors.primary,
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 16),

            // Información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(person.fullName, style: AppTextStyles.subtitle1),
                  const SizedBox(height: 4),
                  Text(
                    person.cargo,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  if (person.departamento != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      person.departamento!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';

    for (int i = 0; i < names.length && i < 2; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0].toUpperCase();
      }
    }

    return initials;
  }
}

class PersonDetailScreen extends StatelessWidget {
  final Personal person;

  const PersonDetailScreen({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: person.fullName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            // Foto y información básica
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.greyLight,
                    backgroundImage: person.foto != null
                        ? NetworkImage(person.foto!)
                        : null,
                    child: person.foto == null
                        ? Text(
                            _getInitials(person.fullName),
                            style: AppTextStyles.heading1.copyWith(
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    person.fullName,
                    style: AppTextStyles.heading2,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    person.cargo,
                    style: AppTextStyles.subtitle1.copyWith(
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  if (person.departamento != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      person.departamento!,
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Información de contacto
            if (person.email != null || person.telefono != null) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Contacto', style: AppTextStyles.subtitle1),
              ),

              const SizedBox(height: 16),

              if (person.email != null)
                _buildContactItem(Icons.email, 'Email', person.email!),

              if (person.telefono != null) ...[
                const SizedBox(height: 12),
                _buildContactItem(Icons.phone, 'Teléfono', person.telefono!),
              ],

              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.grey),
              ),
              Text(value, style: AppTextStyles.body1),
            ],
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';

    for (int i = 0; i < names.length && i < 2; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0].toUpperCase();
      }
    }

    return initials;
  }
}
