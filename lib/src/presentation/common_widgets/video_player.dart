import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    addListener();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
        leading: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.rectangle),
          child: const BackButton(
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: _videoPlayerController.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: Chewie(
                  controller: chewieController,
                ),
              )
            : const LoaderView(),
      ),
    );
  }

  void addListener() async {
    _videoPlayerController.addListener(() {
      setState(() {});
    });

    chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: false,
    );
  }
}
