import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/constants.dart';
import '../../widgets/common_widgets.dart';
import '../../models/area_protegida.dart';
import '../../services/api_service.dart';

class AreasScreen extends StatefulWidget {
  const AreasScreen({Key? key}) : super(key: key);

  @override
  State<AreasScreen> createState() => _AreasScreenState();
}

class _AreasScreenState extends State<AreasScreen>
    with TickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  List<AreaProtegida> _areas = [];
  List<AreaProtegida> _filteredAreas = [];
  bool _isLoading = true;
  bool _isMapView = false;
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAreas();
    _searchController.addListener(_filterAreas);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAreas() async {
    try {
      final areas = await _apiService.getAreasProtegidas();
      if (mounted) {
        setState(() {
          _areas = areas;
          _filteredAreas = areas;
          _isLoading = false;
        });
        _updateMarkers();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterAreas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAreas = _areas.where((area) {
        return area.nombre.toLowerCase().contains(query) ||
            area.categoria.toLowerCase().contains(query) ||
            (area.ubicacion?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  void _updateMarkers() {
    _markers = _areas.map((area) {
      return Marker(
        markerId: MarkerId(area.id.toString()),
        position: LatLng(area.latitud, area.longitud),
        infoWindow: InfoWindow(
          title: area.nombre,
          snippet: area.categoria,
          onTap: () => _showAreaDetail(area),
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Áreas Protegidas',
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                _isMapView = !_isMapView;
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Cargando áreas protegidas...')
          : Column(
              children: [
                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: CustomTextField(
                    label: 'Buscar área protegida',
                    hint: 'Nombre, categoría o ubicación...',
                    controller: _searchController,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),

                // Contenido
                Expanded(
                  child: _isMapView ? _buildMapView() : _buildListView(),
                ),
              ],
            ),
    );
  }

  Widget _buildListView() {
    if (_filteredAreas.isEmpty) {
      return const EmptyStateWidget(
        message: 'No se encontraron áreas protegidas',
        icon: Icons.nature_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAreas,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
        ),
        itemCount: _filteredAreas.length,
        itemBuilder: (context, index) {
          final area = _filteredAreas[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InfoCard(
              title: area.nombre,
              subtitle: area.categoria,
              description: area.descripcion,
              imageUrl: area.imagen,
              onTap: () => _showAreaDetail(area),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.place, color: AppColors.primary, size: 20),
                  if (area.ubicacion != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      area.ubicacion!,
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapView() {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      initialCameraPosition: const CameraPosition(
        target: LatLng(
          AppConstants.defaultLatitude,
          AppConstants.defaultLongitude,
        ),
        zoom: AppConstants.defaultZoom,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      mapToolbarEnabled: false,
    );
  }

  void _showAreaDetail(AreaProtegida area) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AreaDetailScreen(area: area)),
    );
  }
}

class AreaDetailScreen extends StatelessWidget {
  final AreaProtegida area;

  const AreaDetailScreen({Key? key, required this.area}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: area.nombre),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            if (area.imagen != null)
              NetworkImageWidget(
                imageUrl: area.imagen!,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),

            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y categoría
                  Text(area.nombre, style: AppTextStyles.heading2),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      area.categoria,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Descripción
                  Text('Descripción', style: AppTextStyles.subtitle1),
                  const SizedBox(height: 8),
                  Text(area.descripcion, style: AppTextStyles.body1),

                  const SizedBox(height: 24),

                  // Información adicional
                  if (area.ubicacion != null) ...[
                    _buildInfoRow(Icons.place, 'Ubicación', area.ubicacion!),
                    const SizedBox(height: 12),
                  ],
                  if (area.telefono != null) ...[
                    _buildInfoRow(Icons.phone, 'Teléfono', area.telefono!),
                    const SizedBox(height: 12),
                  ],
                  if (area.horario != null) ...[
                    _buildInfoRow(Icons.schedule, 'Horario', area.horario!),
                    const SizedBox(height: 24),
                  ],

                  // Mapa
                  Text('Ubicación en el mapa', style: AppTextStyles.subtitle1),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppConstants.defaultBorderRadius,
                      ),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(area.latitud, area.longitud),
                          zoom: 12,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId(area.id.toString()),
                            position: LatLng(area.latitud, area.longitud),
                            infoWindow: InfoWindow(
                              title: area.nombre,
                              snippet: area.categoria,
                            ),
                          ),
                        },
                        zoomControlsEnabled: false,
                        scrollGesturesEnabled: false,
                        rotateGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                      ),
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.subtitle2),
              Text(value, style: AppTextStyles.body1),
            ],
          ),
        ),
      ],
    );
  }
}
