import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/item_details/cubit/item_details_cubit.dart';
import 'package:workapp/src/presentation/widgets/video_player_view.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 17-09-2024
/// @Message : [ImagePreviewView]

/// This `ImagePreviewView` is for image preview where you can can zoom in and zoom out image
/// This is opened when you click on image from slider of item details screen.
/// It needs list or image url, the image clicked index, item details cubit for calling the image on index.
class ImagePreviewView extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final ItemDetailsCubit itemDetailsCubit;
  final CategoriesListResponse? category;


  ImagePreviewView({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
    required this.itemDetailsCubit, this.category,
  });

  final PageController controller = PageController();

  ///This view has PageView builder for swiping image in preview screen and its child for photo view which has
  ///imageProvider for calling image using network image widget and adding url using index.
  ///it also has pagecontroller for changing initial page index.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: MyAppBar(
            title: '',
            backBtn: false,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backGroundColor: AppColors.jetBlackColor,
            actionList: [
              Positioned(
                right: 0.0,
                top: 10.0,
                child: IconButton(
                  onPressed: () {
                    AppRouter.pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
          body: PageView.builder(
            itemCount: imageUrls.length,
            onPageChanged: (i) => itemDetailsCubit.currentImageIndex(i),
            itemBuilder: (context, index) {
              final url = imageUrls[index];
              return Stack(
                children: [
                  Center(
                    child: isVideo(url)
                        ? VideoPlayerView( filePath: imageUrls.first, fileOrigin:CurrentFileOrigin.network, isFromPlay: true ,) // Custom Video Player widget
                        :PhotoView(
                      backgroundDecoration: BoxDecoration(
                        color: AppColors.jetBlackColor,
                      ),
                      imageProvider: NetworkImage(imageUrls[index]),
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 2,
                      initialScale: PhotoViewComputedScale.contained,
                      loadingBuilder: (context, event) {
                        if (event == null) return Container(); // If there's no progress event, don't show anything
                        return const LoaderView();
                      },
                    ),
                  ),
                ],
              );
            },
            controller: PageController(initialPage: initialIndex),
          ),
        ),
      ),
    );
  }
  /// Helper function to check if the URL is a video
  bool isVideo(String url) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.wmv', '.flv', '.mkv'];
    return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }
}
