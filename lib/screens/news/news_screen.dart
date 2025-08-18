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

  Widget _buildNewsCard(Noticia noticia) {
    return InkWell(
      onTap: () => _showNewsDetail(noticia),
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
            if (noticia.imagen != null && noticia.imagen!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: NetworkImageWidget(
                  imageUrl: noticia.imagen!,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
            if (noticia.imagen != null && noticia.imagen!.isNotEmpty)
              const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    noticia.titulo,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    noticia.fecha,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    noticia.contenido,
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
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: _noticias.length,
                itemBuilder: (context, index) {
                  final noticia = _noticias[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildNewsCard(noticia),
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
