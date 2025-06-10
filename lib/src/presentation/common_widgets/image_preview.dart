import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';

class ImagePreview extends StatefulWidget {
  final List<String> imageList;
  final int selectedIndex;

  const ImagePreview({Key? key, required this.imageList, this.selectedIndex = 0}) : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  final PageController controller = PageController();
  late int selectedIndex;
  bool isLoading = false;
  late Future<String?> myFuture;
  late AsyncMemoizer asyncMemoizer;

  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.jumpToPage(selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    String filePath = widget.imageList[selectedIndex] ?? '';
    (CurrentFileType, CurrentFileOrigin) fileDetails = AppUtils.getFileTypeAndOrigin(filePath: filePath);
    return Dialog(
      shape: const RoundedRectangleBorder(),
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.transparent,
          surfaceTintColor: Colors.white,
          elevation: 3.0,
          actions: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '${selectedIndex + 1} /${widget.imageList.length}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
          leading: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(shape: BoxShape.rectangle),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
            ),
          ),
        ),
        body: Stack(
          fit: StackFit.loose,
          children: [
          PageView.builder(
          controller: controller,
          itemCount: widget.imageList.length,
          onPageChanged: (i) {
            setState(() => selectedIndex = i);
          },
          itemBuilder: (ctx, index) {
            var item = widget.imageList[index]; // Use the index directly here
            if (isVideo(item)) {
              return ThumbnailWidget(mediaData: item);
            }
            return PhotoView(
              backgroundDecoration: const BoxDecoration(color: Colors.white),
              imageProvider: CachedNetworkImageProvider(
                item,
              ),
            );
          },
        ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  /// Helper function to check if the URL is a video
  bool isVideo(String url) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.wmv', '.flv', '.mkv'];
    return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }
}

class ThumbnailWidget extends StatefulWidget {
  const ThumbnailWidget({super.key, required this.mediaData});

  final String mediaData;

  @override
  State<ThumbnailWidget> createState() => _ThumbnailWidgetState();
}

class _ThumbnailWidgetState extends State<ThumbnailWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.mediaData ?? ''),
    );

    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );

    setState(() {}); // Rebuild to reflect initialized player
  }

  @override
  Widget build(BuildContext context) {
    return _videoPlayerController.value.isInitialized
        ? Chewie(
            controller: _chewieController,
          )
        : const Center(
            child: LoaderView(),
          );
  }
}

/// URL Type
enum UrlType { image, video, unknown }

class MediaData {
  String? imageUrl;
  String? videoUrl;

  MediaData({this.imageUrl, this.videoUrl});
}
