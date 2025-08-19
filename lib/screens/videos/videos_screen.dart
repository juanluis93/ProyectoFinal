import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants.dart';
import '../../widgets/common_widgets.dart';
import '../../models/video_educativo.dart';
import '../../services/api_service.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  final ApiService _apiService = ApiService();
  List<VideoEducativo> _videos = [];
  List<VideoEducativo> _filteredVideos = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadVideos();
    _searchController.addListener(_filterVideos);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadVideos() async {
    try {
      final videos = await _apiService.getVideos();
      if (mounted) {
        setState(() {
          _videos = videos;
          _filteredVideos = videos;
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

  void _filterVideos() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredVideos = _videos.where((video) {
        return video.titulo.toLowerCase().contains(query) ||
            video.descripcion.toLowerCase().contains(query) ||
            video.categoria.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Videos Educativos'),
      body: _isLoading
          ? const LoadingWidget(message: 'Cargando videos...')
          : Column(
              children: [
                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: CustomTextField(
                    label: 'Buscar videos',
                    hint: 'Título, descripción o categoría...',
                    controller: _searchController,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),

                // Lista de videos
                Expanded(
                  child: _filteredVideos.isEmpty
                      ? const EmptyStateWidget(
                          message: 'No se encontraron videos',
                          icon: Icons.video_collection_outlined,
                        )
                      : RefreshIndicator(
                          onRefresh: _loadVideos,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.defaultPadding,
                            ),
                            itemCount: _filteredVideos.length,
                            itemBuilder: (context, index) {
                              final video = _filteredVideos[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: VideoCard(
                                  video: video,
                                  onTap: () => _playVideo(video),
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

  void _playVideo(VideoEducativo video) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => VideoPlayerScreen(video: video)),
    );
  }
}

class VideoCard extends StatelessWidget {
  final VideoEducativo video;
  final VoidCallback onTap;

  const VideoCard({Key? key, required this.video, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail del video
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppConstants.defaultBorderRadius),
                ),
                child: video.thumbnail != null
                    ? NetworkImageWidget(
                        imageUrl: video.thumbnail!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 180,
                        color: AppColors.greyLight,
                        child: const Icon(
                          Icons.video_library,
                          size: 60,
                          color: AppColors.grey,
                        ),
                      ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatDuration(_parseDuration(video.duracion)),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Icon(
                  Icons.play_circle_fill,
                  size: 60,
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  video.titulo,
                  style: AppTextStyles.subtitle1,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Descripción
                Text(
                  video.descripcion,
                  style: AppTextStyles.body2.copyWith(color: AppColors.grey),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Categoría y fecha
                Row(
                  children: [
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
                        video.categoria,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(video.fechaPublicacion),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey,
                      ),
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

  int? _parseDuration(String? durationStr) {
    if (durationStr == null || durationStr.isEmpty) return null;
    try {
      return int.parse(durationStr);
    } catch (e) {
      return null;
    }
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final VideoEducativo video;

  const VideoPlayerScreen({Key? key, required this.video}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isYouTubeVideo = false;

  @override
  void initState() {
    super.initState();
    _analyzeVideoUrl();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _analyzeVideoUrl() {
    final url = widget.video.url.toLowerCase();

    // Detectar si es un video de YouTube
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      setState(() {
        _isYouTubeVideo = true;
        _isLoading = false;
      });
      if (kIsWeb) {
        _initializeWebIframe();
      }
    } else {
      _initializeVideo();
    }
  }

  void _initializeWebIframe() {
    if (kIsWeb) {
      final youtubeId = _extractYouTubeId(widget.video.url);
      if (youtubeId != null) {
        // Video de YouTube detectado - en móvil se mostrará botón para abrir
        setState(() {
          _isYouTubeVideo = true;
        });
      }
    }
  }

  String? _extractYouTubeId(String url) {
    // Extraer ID de YouTube de diferentes formatos de URL
    RegExp regExp = RegExp(
      r"(?:(?:https?:)?\/\/)?(?:www\.)?(?:m\.)?(?:youtube\.com\/(?:(?:watch\?v=)|(?:embed\/))|youtu\.be\/)([a-zA-Z0-9_-]{11})",
      caseSensitive: false,
      multiLine: false,
    );

    Match? match = regExp.firstMatch(url);
    return match?.group(1);
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.video.url),
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error inicializando video: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  Future<void> _openExternalVideo() async {
    final url = Uri.parse(widget.video.url);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      Navigator.of(context).pop();
    } else {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _openYouTubeApp() async {
    final youtubeId = _extractYouTubeId(widget.video.url);
    if (youtubeId != null) {
      // Intentar abrir en la app de YouTube primero
      final youtubeAppUrl = Uri.parse('youtube://watch?v=$youtubeId');
      final youtubeWebUrl = Uri.parse(
        'https://www.youtube.com/watch?v=$youtubeId',
      );

      try {
        if (await canLaunchUrl(youtubeAppUrl)) {
          await launchUrl(youtubeAppUrl, mode: LaunchMode.externalApplication);
        } else {
          await launchUrl(youtubeWebUrl, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        // Si falla, abrir en navegador
        await launchUrl(youtubeWebUrl, mode: LaunchMode.externalApplication);
      }
    } else {
      _openExternalVideo();
    }
  }

  int? _parseDuration(String? durationStr) {
    if (durationStr == null || durationStr.isEmpty) return null;
    try {
      return int.parse(durationStr);
    } catch (e) {
      return null;
    }
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.video.titulo),
      body: _isLoading
          ? const LoadingWidget(message: 'Cargando video...')
          : _isYouTubeVideo
          ? _buildYouTubePlayer()
          : _hasError
          ? _buildErrorWidget()
          : _buildVideoPlayer(),
    );
  }

  Widget _buildYouTubePlayer() {
    final youtubeId = _extractYouTubeId(widget.video.url);

    if (youtubeId == null) {
      return _buildErrorWidget();
    }

    // Para móviles, mostraremos una interfaz nativa optimizada
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reproductor de YouTube mejorado para móviles
          Container(
            height: 250,
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.black,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Thumbnail del video como fondo
                  if (widget.video.thumbnail != null)
                    Positioned.fill(
                      child: NetworkImageWidget(
                        imageUrl: widget.video.thumbnail!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250,
                      ),
                    ),

                  // Overlay oscuro
                  Positioned.fill(
                    child: Container(color: AppColors.black.withOpacity(0.4)),
                  ),

                  // Botón de reproducción centrado
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _openYouTubeApp,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Tocar para reproducir',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Indicador de duración en esquina inferior derecha
                  if (widget.video.duracion != null &&
                      widget.video.duracion!.isNotEmpty)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatDuration(
                            _parseDuration(widget.video.duracion),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Información del video
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.video.titulo, style: AppTextStyles.heading2),
                const SizedBox(height: 12),
                Text(widget.video.descripcion, style: AppTextStyles.body1),
                const SizedBox(height: 16),

                // Categoría
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.video.categoria,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Ver en YouTube',
                        onPressed: _openYouTubeApp,
                        backgroundColor: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _openExternalVideo,
                        icon: const Icon(Icons.open_in_browser, size: 18),
                        label: const Text('Navegador'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
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

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: AppColors.error),
          const SizedBox(height: 16),
          const Text(
            'No se pudo cargar el video',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 8),
          const Text(
            'Intenta abrir en navegador externo',
            style: AppTextStyles.body1,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Abrir en Navegador',
            onPressed: _openExternalVideo,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Column(
      children: [
        // Video player
        if (_controller != null && _controller!.value.isInitialized)
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),

        // Controles del video
        if (_controller != null)
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _controller!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller!.value.isPlaying
                          ? _controller!.pause()
                          : _controller!.play();
                    });
                  },
                ),
                Expanded(
                  child: VideoProgressIndicator(
                    _controller!,
                    allowScrubbing: true,
                  ),
                ),
              ],
            ),
          ),

        // Información del video
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.video.titulo, style: AppTextStyles.heading2),
                const SizedBox(height: 8),
                Text(widget.video.descripcion, style: AppTextStyles.body1),
                const SizedBox(height: 16),
                Row(
                  children: [
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
                        widget.video.categoria,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
