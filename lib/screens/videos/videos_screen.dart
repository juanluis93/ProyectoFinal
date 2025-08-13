import 'package:flutter/material.dart';
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
                    _formatDuration(video.duracion),
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

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.video.titulo),
      body: _isLoading
          ? const LoadingWidget(message: 'Cargando video...')
          : _hasError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: AppColors.error,
                  ),
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
            )
          : Column(
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
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.video.titulo,
                          style: AppTextStyles.heading2,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.video.categoria,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('Descripción', style: AppTextStyles.subtitle1),
                        const SizedBox(height: 8),
                        Text(
                          widget.video.descripcion,
                          style: AppTextStyles.body1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
