import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/models/chat/report_type_list.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/common_widgets/image_preview.dart';
import 'package:workapp/src/presentation/modules/item_details/cubit/item_details_cubit.dart';
import 'package:workapp/src/presentation/modules/item_details/repo/item_details_repo.dart';
import 'package:workapp/src/presentation/modules/item_details/view/item_details_info_view.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/my_listing/repo/my_listing_repo.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 16-09-2024
/// @Message : [ItemDetailsScreen]

///This view is Item detail main view where slider and item detail info view is added
///the slider view contains of images and video of item and seller.
///It also checks is the user has workapp premium plan subscription or not which would allow to redirect to website.
class ItemDetailsScreen extends StatefulWidget {
  final bool isPremium;
  final int? itemId;
  String? categoryName;
  final int? formId;
  final bool? isDraft;
  final bool? isAvailableHistory;

  ItemDetailsScreen({
    super.key,
    this.isPremium = false,
    this.itemId,
    this.formId,
    this.categoryName,
    this.isDraft,
    this.isAvailableHistory,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  String? currentAction;

  ///Carousel controller for managing swipe and index
  final CarouselSliderController _controller = CarouselSliderController();

  ///Cubit declaration with Item details repo instance
  ItemDetailsCubit itemDetailsCubit = ItemDetailsCubit(itemDetailsRepo: ItemDetailsRepo.instance);
  final scrollController = ScrollController();
  MyListingCubit myListingCubit = MyListingCubit(myListingRepo: MyListingRepo.instance);

  ///Initializing cubit and loading UI
  @override
  void initState() {
    // super.initState();
    myListingCubit.init(true);
    itemDetailsCubit.getDynamicItemDetails(
      itemId: widget.itemId,
      apiPath: widget.categoryName,
      formId: widget.formId,
    );

  }

  ///View for main scaffold with layout builder and displaying app bar with icon on right corner for subscription
  ///check.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
        bloc: itemDetailsCubit,
        builder: (context, state) {
          if (state is ItemDetailsLoadedState) {
            if (widget.categoryName == null || widget.categoryName == '') {
              widget.categoryName = state.getDetails?.result.category ?? '';
            }
            return SafeArea(
              bottom: false,
              child: Scaffold(
                appBar: MyAppBar(
                  title: widget.categoryName ?? '',
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  backBtn: true,
                  elevation: 0.0,
                  actionList: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _handleSharing(context, state,itemDetailsCubit);
                            },
                            child: ReusableWidgets.createSvg(
                              path: AssetPath.shareItemIcon,
                              size: 20,
                              color: AppColors.jetBlackColor,
                            ),
                          ),
                          sizedBox20Width(),
                          Opacity(
                            opacity: (state.getDetails?.result.userUUID != AppUtils.loginUserModel?.uuid) &&
                                    state.getDetails != null
                                ? 1.0
                                : 0.3,
                            child: Builder(
                              builder: (context) {
                                return InkWell(
                                  onTap: () async {
                                    if (state.getDetails == null) return;

                                    if (AppUtils.loginUserModel == null) {
                                      ReusableWidgets.showConfirmationWithTwoFuncDialog(
                                        AppConstants.appTitleStr,
                                        AppConstants.signInAlertStr,
                                        option1: AppConstants.yesStr,
                                        option2: AppConstants.noStr,
                                        funcYes: () {
                                          navigatorKey.currentState?.pop();
                                          AppRouter.pushRemoveUntil(AppRoutes.signInViewRoute);
                                        },
                                        funcNo: () {
                                          navigatorKey.currentState?.pop();
                                        },
                                      );
                                    } else {
                                      final RenderBox overlay =
                                          Overlay.of(context).context.findRenderObject() as RenderBox;
                                      final RenderBox box = context.findRenderObject() as RenderBox;
                                      final Offset position = box.localToGlobal(Offset.zero, ancestor: overlay);

                                      final selected = await showMenu<String>(
                                        context: context,
                                        color: AppColors.whiteColor,
                                        position: RelativeRect.fromLTRB(
                                          position.dx,
                                          position.dy + box.size.height,
                                          overlay.size.width - position.dx - box.size.width,
                                          0,
                                        ),
                                        items: [
                                          const PopupMenuItem<String>(
                                            value: AppConstants.userAsSpam,
                                            child: Text(AppConstants.userAsSpam),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: AppConstants.listingAsSpam,
                                            child: Text(AppConstants.listingAsSpam),
                                          ),
                                        ],
                                      );

                                      switch (selected) {
                                        case AppConstants.userAsSpam:
                                          showSpamReportDialog(
                                              context, itemDetailsCubit, widget.itemId, widget.formId ?? 1,true ,state);
                                          break;
                                        case AppConstants.listingAsSpam:
                                          showSpamReportDialog(
                                              context, itemDetailsCubit, widget.itemId, widget.formId ?? 1,false, state );
                                          break;
                                      }
                                    }
                                  },
                                  child: ReusableWidgets.createSvg(
                                    path: AssetPath.infoIcon,
                                    size: 20,
                                    color: AppColors.jetBlackColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  requirePop: false,
                  backBtnCallback: () {
                    Navigator.of(context).pop(currentAction);
                  },
                ),
                body: Stack(
                  children: [
                    Visibility(
                      visible: state.getDetails != null,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return _mobileView(state);
                        }),
                      ),
                    ),
                    state.isLoading ? const LoaderView() : const SizedBox.shrink()
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  ///This view is having slider and ItemDetailsInfoView in column form and all the values that are need to pass for
  ///accessing and displaying data
  Widget _mobileView(ItemDetailsLoadedState state) {
    return Column(
      children: [
        _sliderView(state),
        ItemDetailsInfoView(
          isPremium: widget.isPremium,
          state: state,
          cubit: itemDetailsCubit,
          categoryName: widget.categoryName,
          itemId: widget.itemId,
          formId: widget.formId,
          myListingCubit: myListingCubit,
          scrollController: scrollController,
          isDraft: widget.isDraft,
          isAvailableHistory: widget.isAvailableHistory,
          callback: (categoryName, action) {
            currentAction = action;
            itemDetailsCubit.getDynamicItemDetails(
              itemId: widget.itemId,
              apiPath: widget.categoryName,
              formId: widget.formId,
            );
          },
        )
      ],
    );
  }

  ///Carousel slider view with its aspect ratio and its tap which redirects to image preview screen,and this view is
  ///customized as per need for scroll height, auto play etc. and also has its dot indicator.
  Widget _sliderView(ItemDetailsLoadedState state) {
    // Default image if no attachments are available
    String defaultImageUrl = AssetPath.dummyPlaceholderImage;

    // Item logo as per category.
    String? itemLogo = state.getDetails?.result.businessLogo;

    List<String>? imageUrls = state.getDetails?.result.images?.isNotEmpty == true
        ? state.getDetails?.result.images?.map((item) => item.fileName).toList()
        : itemLogo?.isNotEmpty ?? false
            ? [itemLogo ?? '']
            : [defaultImageUrl];

    List<Widget> imageItems = imageUrls!.map((itemImage) {
      return isVideo(itemImage)
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              child: VideoPlayerWidget(
                  videoUrl: itemImage,
                  imageUrls: imageUrls,
                  currentPosition: state.currentIndex)) // Custom Video Player widget
          : LoadNetworkImage(url: itemImage, height: 140.0);
    }).toList();

    return InkWell(
      onTap: () {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (BuildContext context) {
            return ImagePreview(
              imageList: imageUrls,
              selectedIndex: state.currentIndex,
            );
          },
        );
      },
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.width, // 1:1 aspect ratio
            color: AppColors.borderColor,
            child: CarouselSlider(
              items: imageItems,
              carouselController: _controller,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.width,
                // Match the container height
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: false,
                autoPlayCurve: Curves.ease,
                scrollPhysics: const ClampingScrollPhysics(),
                onPageChanged: (int index, reason) => itemDetailsCubit.currentImageIndex(index),
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
          // Counter Positioned Top-Right
          if (state.getDetails?.result.images?.isNotEmpty == true)
            Positioned(
              top: 10.0,
              right: 10.0,
              child: Container(
                height: 29,
                width: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                ),
                child: Center(
                  child: Text(
                    '${state.currentIndex + 1}/${state.getDetails?.result.images?.length ?? 0}',
                    style: FontTypography.aboutUsTxtStyle,
                  ),
                ),
              ),
            ),
          // Dots Indicator
          if (state.getDetails?.result.images?.isNotEmpty == true)
            Positioned(
              bottom: 5.0,
              right: 0.0,
              left: 0.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: (state.getDetails?.result.images ?? []).map<Widget>((url) {
                    int index = state.getDetails?.result.images?.indexOf(url) ?? 0;
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state.currentIndex == index ? AppColors.whiteColor : const Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList()),
            ),
        ],
      ),
    );
  }

  /// Helper function to check if the URL is a video
  bool isVideo(String url) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.wmv', '.flv', '.mkv'];
    return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }

  Future<void> _handleSharing(BuildContext context, ItemDetailsLoadedState state, ItemDetailsCubit itemDetailsCubit) async {
    String encryptedItemId = encryptId(widget.itemId.toString());

    // String baseUrl;
    // baseUrl = ApiConstant.shareItemLinkDev;

    String shareLink = await itemDetailsCubit.encodeLink(listingID: widget.itemId);

    if (shareLink.isEmpty) {
        shareLink = 'https://workappdynamic-2-web.azurewebsites.net/listing-detail/${widget.itemId}';
    }

    String link = '''Hey,

Exciting news! We have something special just for you in our app. 📱✨

Click the link below to:
🌟 Discover Item Details.

👉 $shareLink
''';
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(link,subject: 'You really need to be on WorkApp', sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  String encryptId(String id) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encodedItem = stringToBase64.encode(id);
    return encodedItem;
  }
}

/// Spam Report Dialog
void showSpamReportDialog(BuildContext context, ItemDetailsCubit itemDetailsCubit, int? itemId, int categoryID,bool? userAsSpam, ItemDetailsLoadedState state) async {
  List<ReportTypeModelList> reasons = await itemDetailsCubit.getSpamList();
  String? userId = state.getDetails?.result.userId;
  if (reasons.isEmpty) {
    AppUtils.showFormErrorSnackBar(msg: 'No spam reasons found.');
    return;
  }

  int? selectedId;
  String? reportType;
  TextEditingController commentController = TextEditingController();
  bool isReportTypeError = false;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(12.0),
            backgroundColor: AppColors.whiteColor,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            title: Text(userAsSpam??false?AppConstants.spamUserAlertBoxHeading:AppConstants.spamAlertBoxHeading, style: FontTypography.bottomSheetHeading),
            content: Scrollbar(
              thumbVisibility: true,
              child: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(right: 15),
                  children: [
                    Text(userAsSpam??false?AppConstants.whyUserSpam:AppConstants.whySpam, style: FontTypography.textFieldBlackStyle),
                    sizedBox10Height(),
                    ...reasons.map((entry) {
                      return RadioListTile<int>(
                        title: Text(entry.reportType ?? ''),
                        value: entry.reportTypeId ?? 0,
                        activeColor: AppColors.primaryColor,
                        contentPadding: EdgeInsets.zero,
                        groupValue: selectedId,
                        onChanged: (int? value) {
                          setState(() {
                            selectedId = value;
                            isReportTypeError = false;
                           reportType = entry.reportType??'';
                          });
                        },
                      );
                    }).toList(),
                    sizedBox10Height(),
                    if (isReportTypeError)
                      Text(
                        AppConstants.reportTypeRequired,
                        style: FontTypography.defaultTextStyle.copyWith(color: AppColors.errorColor),
                      ),
                    sizedBox10Height(),
                    Text(AppConstants.reasonStr, style: FontTypography.textFieldBlackStyle),
                    sizedBox10Height(),
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
                          borderSide: BorderSide(color: AppColors.blackColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
                          borderSide: BorderSide(color: AppColors.borderColor),
                        ),
                        errorText: reportType == 'Other' && commentController.text.trim().isEmpty
                            ? 'Comment Required'
                            : null,
                      ),
                    ),
                    sizedBox20Height(),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => AppRouter.pop(),
                    child: Text(AppConstants.cancelStr, style: FontTypography.defaultTextStyle.copyWith(color: AppColors.errorColor)),
                  ),
                  TextButton(
                    onPressed: () {
                      if (selectedId == null) {
                        setState(() {
                          isReportTypeError = true;
                        });
                      } else if (reportType == 'Other' && commentController.text.trim().isEmpty) {
                      } else {
                        ReusableWidgets.showLoaderDialog();
                        if(userAsSpam== true){
                          itemDetailsCubit.spamUserReport(
                            userId: userId??'',
                            reportType: selectedId,
                            comment: commentController.text.trim(),
                          );
                        }else {
                          itemDetailsCubit.spamItemReport(
                          recordId: itemId,
                          categoryId: categoryID,
                          reportType: selectedId,
                          comment: commentController.text.trim(),
                        );
                        }
                      }
                    },
                    child: Text(AppConstants.submitStr, style: FontTypography.defaultTextStyle.copyWith(color: AppColors.primaryColor)),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}


class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final List<String>? imageUrls;
  final int currentPosition;

  const VideoPlayerWidget({super.key, required this.videoUrl, this.imageUrls, this.currentPosition = 0});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _showPlayButton = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Refresh to show the initialized video
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _showPlayButton = true;
      } else {
        _controller.play();
        _showPlayButton = false;
      }
    });
  }

  void _openFullScreen() {
    showDialog(
      barrierDismissible: false,
      context: context, // Use the local context here
      builder: (BuildContext context) {
        return ImagePreview(
          imageList: widget.imageUrls ?? [],
          selectedIndex: widget.currentPosition,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video player
          AspectRatio(
            aspectRatio: _controller.value.isInitialized ? _controller.value.aspectRatio : 16 / 9,
            child: _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : Center(
                    child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  )),
          ),
          // Play button overlay
          if (_showPlayButton)
            IconButton(
              icon: const Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
              onPressed: _togglePlayPause,
            ),
          Positioned(
            left: 10,
            top: 10,
            child: IconButton(
              icon: const Icon(Icons.fullscreen, size: 40, color: Colors.white),
              onPressed: _openFullScreen, // Pass the function reference
            ),
          ),
        ],
      ),
    );
  }
}
