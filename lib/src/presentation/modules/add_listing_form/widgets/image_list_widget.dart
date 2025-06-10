import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/core/constants/assets_constants.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/domain/models/business_profile_detail_resp.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/image_preview.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/listing_form_image_picker.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/utils/add_listing_form_utils/listing_form_utils.dart';
import 'package:workapp/src/utils/app_utils.dart';

class CreateGalleryWidget extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;
  final Map<DateTime, String>? filesMap;
  final List<BusinessImagesModel?>? mediaListModel;
  final int maxSelectionLimit;
  final int? imageControlID;
  final String? imageControlLabel;

  const CreateGalleryWidget(
      {Key? key,
      this.imageControlID,
      this.imageControlLabel,
      required this.filesMap,
      required this.addListingFormCubit,
      required this.state,
      this.mediaListModel,
      this.maxSelectionLimit = 15})
      : super(key: key);

  @override
  State<CreateGalleryWidget> createState() => _CreateGalleryWidgetState();
}

class _CreateGalleryWidgetState extends State<CreateGalleryWidget> {
  List<BusinessImagesModel?> galleryFilesMap = [];

  late int maxFilesCount;

  @override
  void initState() {
    maxFilesCount = AddListingFormUtils.getBusinessImagesMaximumCount(categoryName: widget.state.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaListModel?.isEmpty ?? true) {
      return addListingCameraButton();
    }

    /// creating list of files we have from the map.
    galleryFilesMap = widget.mediaListModel ?? [];
    // galleryFilesMap = widget.filesMap?.values.toList() ?? [];
    return ReorderableGridView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      onReorder: (int oldIndex, int newIndex) {
        widget.addListingFormCubit.onGalleryReordered(
          filesMap: widget.filesMap,
          oldIndex: oldIndex,
          newIndex: newIndex,
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        if (index == galleryFilesMap.length && index < maxFilesCount) {
          return GestureDetector(
            key: UniqueKey(),
            onLongPress: () {},
            child: addListingCameraButton(),
          );
        }
        return _mediaItemView(index);
      },

      /// Checking for the maximum number of file are allowed for this form
      /// if galleryFilesMap.length is not equal to max file count then adding one more item in length for showing the camera icon
      /// and if it equal to the length of the max file count then showing all the files of the map.
      itemCount: galleryFilesMap.length < maxFilesCount ? galleryFilesMap.length + 1 : galleryFilesMap.length,
      // children: galleryItems,
    );
  }

  Widget _mediaItemView(int index) {
    String filePath = galleryFilesMap[index]?.fileName ?? '';
    (CurrentFileType, CurrentFileOrigin) fileDetails = AppUtils.getFileTypeAndOrigin(filePath: filePath);

    List<String> imgList = [];
    for (var model in widget.mediaListModel!) {
      imgList.add(model?.fileName ?? '');
    }

    return Stack(
      fit: StackFit.expand,
      key: ValueKey(filePath),
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              barrierDismissible: false,
              context: navigatorKey.currentState!.context,
              builder: (BuildContext context) {
                return ImagePreview(imageList: imgList, selectedIndex: index);
              },
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: fileDetails.$1 == CurrentFileType.image
                ? Visibility(
                    visible: fileDetails.$2 == CurrentFileOrigin.local,
                    replacement: LoadNetworkImage(url: filePath, fit: BoxFit.cover),
                    child: Image.file(File(filePath), fit: BoxFit.cover),
                  )
                : fileDetails.$1 == CurrentFileType.video
                    ? FutureBuilder(
                        future: AppUtils.generateThumbnail(filePath),
                        builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return Image.file(snapshot.data!, fit: BoxFit.cover);
                            }
                            // Fallback widget with black background
                            return Container(
                              color: Colors.black,
                              child: const Center(),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      )
                    : const SizedBox.shrink(),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: AppUtils.elevatedCircleAvatar(
              height: 25,
              width: 25,
              backgroundColor: AppColors.whiteColor,
              path: AssetPath.deleteIcon,
              iconColor: AppColors.jetBlackColor,
              onPressed: () {
                widget.addListingFormCubit.onFieldsImageDeleted(
                  key: AddListingFormConstants.uploadPhotosAndVideos,
                  imagePath: filePath,
                  multiImageSupported: true,
                );
              },
              iconSize: 16,
            ),
          ),
        ),
        Visibility(
          visible: fileDetails.$1 == CurrentFileType.video,
          child: Align(
            alignment: Alignment.center,
            child: AppUtils.elevatedCircleAvatar(
              size: 40,
              backgroundColor: Colors.transparent,
              path: AssetPath.videoPlayIcon,
              onPressed: () {},
              iconSize: 30,
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget addListingCameraButton() {
    return ListingFormImagePicker(
      imageControlID: widget.imageControlID,
      imageControlLabel: widget.imageControlLabel,
      from: AppConstants.gallery,
      selectedMediaSize: widget.mediaListModel?.length ?? 0,
      addListingFormCubit: widget.addListingFormCubit,
      state: widget.state,
      label: AddListingFormConstants.uploadPhotosAndVideos,
      multiFileSupport: true,
      maxMediaCount: maxFilesCount,
    );
  }
}
