import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/common_widgets.dart';
import '../../models/noticia.dart';
import '../../services/api_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final ApiService _apiService = ApiService();
  List<Noticia> _noticias = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNoticias();
  }

  Future<void> _loadNoticias() async {
    try {
      final noticias = await _apiService.getNoticias();
      if (mounted) {
        setState(() {
          _noticias = noticias;
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
      appBar: const CustomAppBar(title: 'Noticias Ambientales'),
      body: _isLoading
          ? const LoadingWidget(message: 'Cargando noticias...')
          : _noticias.isEmpty
          ? EmptyStateWidget(
              message: 'No hay noticias disponibles',
              onRetry: _loadNoticias,
            )
          : RefreshIndicator(
              onRefresh: _loadNoticias,
              child: ListView.builder(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                itemCount: _noticias.length,
                itemBuilder: (context, index) {
                  final noticia = _noticias[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InfoCard(
                      title: noticia.titulo,
                      subtitle: noticia.fecha,
                      description: noticia.contenido,
                      imageUrl: noticia.imagen,
                      onTap: () => _showNewsDetail(noticia),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _showNewsDetail(Noticia noticia) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(noticia: noticia),
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final Noticia noticia;

  const NewsDetailScreen({Key? key, required this.noticia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Noticia'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (noticia.imagen != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppConstants.defaultBorderRadius,
                ),
                child: NetworkImageWidget(
                  imageUrl: noticia.imagen!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(noticia.titulo, style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppColors.grey),
                const SizedBox(width: 4),
                Text(noticia.fecha, style: AppTextStyles.caption),
                if (noticia.autor != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.person, size: 16, color: AppColors.grey),
                  const SizedBox(width: 4),
                  Text(noticia.autor!, style: AppTextStyles.caption),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text(noticia.contenido, style: AppTextStyles.body1),
          ],
        ),
      ),
    );
  }
}
