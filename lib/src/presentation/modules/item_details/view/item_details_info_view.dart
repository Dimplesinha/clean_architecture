import 'package:flutter/foundation.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/models/dynamic_listing_detail_model.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/view/add_listing_form_view.dart';
import 'package:workapp/src/presentation/modules/item_details/cubit/item_details_cubit.dart';
import 'package:workapp/src/presentation/modules/item_details/view/about_us_view.dart';
import 'package:workapp/src/presentation/modules/item_details/view/shop_view.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/review_screen/view/write_review_screen.dart';
import 'package:workapp/src/presentation/style/style.dart';
import 'package:workapp/src/presentation/widgets/in_app_web_view.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 16-09-2024
/// @Message : [ItemDetailsInfoView]

///This `ItemDetailsInfoView` is used for displaying all items related details in UI.
///This UI is placed below slider of item details screen
///It contains all liked and review related data when clicked on ratings
///on the second part it contains like button, bookmark button, fav button, more button, report button and share
///button which is icons and when u click on them all has there different click event.
///
/// It has call option, email option, message option and website option for viewer side and it you are the creator of
/// the item than instead of message button it will display edit button,
/// The website button would be only enable in case of if the user is have workapp premium plan subscription.
/// it will display on top of app bar right corner.
/// It displays values, type of type (i.e if its for sale or not), location, time of item creation, original price
/// and discounted price. and about us and other items to shop for.
class ItemDetailsInfoView extends StatefulWidget {
  final bool isPremium;
  final ItemDetailsLoadedState state;
  final ItemDetailsCubit cubit;
  final int? itemId;
  final int? formId;
  final String? categoryName;
  final MyListingCubit? myListingCubit;
  final ScrollController scrollController;
  final Function(String, String action)? callback;
  final bool? isDraft;
  final bool? isAvailableHistory;

  const ItemDetailsInfoView({
    super.key,
    this.isPremium = false,
    required this.state,
    required this.cubit,
    required this.itemId,
    required this.formId,
    required this.categoryName,
    required this.scrollController,
    this.myListingCubit,
    this.callback,
    this.isDraft,
    this.isAvailableHistory,
  });

  @override
  State<ItemDetailsInfoView> createState() => _ItemDetailsInfoViewState();
}

class _ItemDetailsInfoViewState extends State<ItemDetailsInfoView> with SingleTickerProviderStateMixin {
  ///Tab controller for managing about us ,shop and etc. tabs.
  late TabController _tabController;
  DynamicListingDetailModel? itemDetails;
  bool isAuthor = true;
  String? timeDuration;
  int? businessCategoryId;
  int? ratingId;
  int? ratingThumbsUp;
  String? ratingComment;
  late List<String?> dynamicKeys;
  late List<String> dynamicOtherKeys;

  ///Tab controller initialing value for total tab length.
  @override
  void initState() {
    super.initState();
    categoryId();
    bool categoryType =
        widget.categoryName == AppConstants.businessStr || widget.categoryName == AppConstants.communityStr;
    int length = categoryType == true ? 2 : 1;
    _tabController = TabController(length: length, vsync: this);
  }

  /// This view has all details which are related to item and which are displayed in UI with use of column
  @override
  Widget build(BuildContext context) {
    widget.myListingCubit?.isClickedOnLike = false;
    itemDetails = widget.state.getDetails;
    isAuthor = itemDetails?.result.userUUID == AppUtils.loginUserModel?.uuid;
    timeDuration = AppUtils.timeAgo(widget.isDraft ?? false ? itemDetails?.result.dateModified ?? '' : itemDetails?.result.boostDate ?? '');
    return BlocBuilder<MyListingCubit, MyListingState>(
      bloc: widget.myListingCubit,
      builder: (context, state) {
        if (state is MyListingLoadedState) {
          itemDetails?.result.totalLikeCount = widget.cubit.totalLikeCount!;
          if (widget.myListingCubit?.isClickedOnLike == true) {
            widget.myListingCubit?.isClickedOnLike = false;
            if (itemDetails?.result.selfLike == false) {
              if (itemDetails?.result.totalLikeCount == null || itemDetails?.result.totalLikeCount == 0) {
                itemDetails?.result.totalLikeCount = (itemDetails?.result.totalLikeCount ?? 0) + 1;
              } else {
                itemDetails?.result.totalLikeCount = (itemDetails?.result.totalLikeCount ?? 0) + 1;
              }
            } else {
              if (itemDetails?.result.totalLikeCount == null || itemDetails?.result.totalLikeCount == 1) {
                itemDetails?.result.totalLikeCount = (itemDetails?.result.totalLikeCount ?? 0) - 1;
              } else {
                itemDetails?.result.totalLikeCount = (itemDetails?.result.totalLikeCount ?? 0) - 1;
              }
            }
          }

          widget.cubit.totalLikeCount = itemDetails?.result.totalLikeCount;

          if (state.isBookMarkClicked == true) {
            itemDetails?.result.selfBookMark = state.isBookMarked;
          }
          if (state.isSelfLikeClicked == true) {
            itemDetails?.result.selfLike = state.isSelfLike;
          }
          if (state.isRated == true) {
            itemDetails?.result.selfReview = state.isRated;
          }

          return Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _likeReviewView(state),
                  _horizontalDivider(),
                  _reachOutRow(),
                  _horizontalDivider(),
                  sizedBox10Height(),
                  _textWithSaleTag(),
                  _itemName(),
                  _locationTimeDetails(),
                  _dynamicDataDisplay(),
                  sizedBox15Height(),
                  Container(
                    height: 40.0,
                    decoration: BoxDecoration(color: AppColors.itemDetailsContainerColor),
                    child: _tabBar(),
                  ),
                  itemDetailsTabBody(selectedTab: widget.state.selectedTabIndex)
                ],
              ),
              if (state.loader) const LoaderView() else const SizedBox.shrink(),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  ///Like and review view that displays total number of likes and total number of review and ratings.
  Widget _likeReviewView(MyListingLoadedState state) {
    var reviewCount = itemDetails?.result.totalReviewCount ?? 0;
    var reviewText = reviewCount > 1 ? AppConstants.reviewScreenStr : AppConstants.reviewCapitalStr;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 13.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Opacity(
                          opacity: (itemDetails?.result.userUUID != AppUtils.loginUserModel?.uuid) ? 1.0 : 0.3,
                          child: _activityRow(
                            assetPath:
                                (itemDetails?.result.selfLike == false) ? AssetPath.redOutlineLikeIcon : AssetPath.redLikeIcon,
                            onTap: () {
                              if (AppUtils.loginUserModel == null) {
                                ReusableWidgets.showConfirmationWithTwoFuncDialog(
                                    AppConstants.appTitleStr, AppConstants.signInAlertStr,
                                    option1: AppConstants.yesStr, option2: AppConstants.noStr, funcYes: () {
                                  navigatorKey.currentState?.pop();
                                  AppRouter.pushRemoveUntil(AppRoutes.signInViewRoute);
                                }, funcNo: () {
                                  navigatorKey.currentState?.pop();
                                });
                                return;
                              }else{
                              itemDetails?.result.userUUID != AppUtils.loginUserModel?.uuid
                                  ? widget.myListingCubit?.onLikePress(
                                      itemId: widget.itemId,
                                      categoryName: widget.categoryName,
                                      isSelfLike: itemDetails?.result.selfLike ?? false)
                                  : null;}
                            },
                          ),
                        ),
                      ],
                    ),
                    Opacity(
                      opacity: (itemDetails?.result.userUUID != AppUtils.loginUserModel?.uuid) ? 1.0 : 0.3,
                      child: _activityRow(
                        assetPath: (itemDetails?.result.selfBookMark ?? false)
                            ? AssetPath.bookmarkFilledIcon
                            : AssetPath.bookmarkIcon,
                        onTap: () {
                          if (AppUtils.loginUserModel == null) {
                            ReusableWidgets.showConfirmationWithTwoFuncDialog(
                                AppConstants.appTitleStr, AppConstants.signInAlertStr,
                                option1: AppConstants.yesStr, option2: AppConstants.noStr, funcYes: () {
                              navigatorKey.currentState?.pop();
                              AppRouter.pushRemoveUntil(AppRoutes.signInViewRoute);
                            }, funcNo: () {
                              navigatorKey.currentState?.pop();
                            });
                            return;
                          }else{
                          itemDetails?.result.userUUID != AppUtils.loginUserModel?.uuid
                              ? widget.myListingCubit?.onBookmarkPressed(
                                  itemId: widget.itemId,
                                  categoryName: widget.categoryName,
                                  isBookMarked: itemDetails?.result.selfBookMark ?? false)
                              : null;}
                        },
                      ),
                    ),
                    Opacity(
                      opacity: (itemDetails?.result.userUUID != AppUtils.loginUserModel?.uuid) ? 1.0 : 0.3,
                      child: _activityRow(
                          assetPath:
                              itemDetails?.result.selfReview ?? false ? AssetPath.yellowStarIcon : AssetPath.starIcon,
                          onTap: () async {
                            // Retrieve item ID and category ID
                            if (AppUtils.loginUserModel == null) {
                              ReusableWidgets.showConfirmationWithTwoFuncDialog(
                                  AppConstants.appTitleStr, AppConstants.signInAlertStr,
                                  option1: AppConstants.yesStr, option2: AppConstants.noStr, funcYes: () {
                                navigatorKey.currentState?.pop();
                                AppRouter.pushRemoveUntil(AppRoutes.signInViewRoute);
                              }, funcNo: () {
                                navigatorKey.currentState?.pop();
                              });
                              return;
                            }else {
                              var itemID = itemDetails?.result.id;

                              var categoryId = businessCategoryId;
                              bool? isEditable =
                              AppUtils.instance.dateCheck(itemDetails?.result.myRating?.isNotEmpty == true
                                  ? itemDetails!.result.myRating!.first.dateCreated
                                  : '');

                              if (itemDetails?.result.userUUID != AppUtils.loginUserModel?.uuid) {
                                // Show the bottom sheet to write a review
                                Map<String, dynamic>? res = await AppUtils.showBottomSheet(
                                  context,
                                  child: WriteReviewScreen(
                                    isFromReview: true,
                                    itemId: itemID,
                                    categoryId: categoryId,
                                    ratingId: ratingId ?? (itemDetails?.result.myRating?.isNotEmpty == true
                                        ? itemDetails!.result.myRating!.first.ratingId
                                        : null),
                                    myRatingCount: ratingThumbsUp ??
                                        (itemDetails?.result.myRating?.isNotEmpty == true
                                            ? itemDetails!.result.myRating!.first.ratingThumbsUp
                                            : 0),
                                    ratingComment: ratingComment ?? (itemDetails?.result.myRating?.isNotEmpty == true
                                        ? itemDetails!.result.myRating!.first.ratingComment
                                        : null),
                                    isEditable: isEditable,
                                  ),
                                );
                                if (res != null) {
                                  ratingId = res[ModelKeys.ratingId];
                                  ratingThumbsUp = res[ModelKeys.ratingThumbsUp];
                                  ratingComment = res[ModelKeys.ratingComment];
                                  widget.myListingCubit?.isRated();
                                  widget.cubit.getDynamicItemDetails(
                                    itemId: widget.itemId,
                                    apiPath: widget.categoryName,
                                    formId: widget.formId,
                                  );
                                }
                              }
                            }
                          }),
                    ),
                    Visibility(
                        visible: itemDetails?.result.isPremiumUserListing ?? false,
                        child: _activityRow(assetPath: AssetPath.diamondIcon, onTap: () {})),
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    height: 12.0,
                    width: 12.0,
                    child: ReusableWidgets.createSvg(path: AssetPath.yellowStarIcon, size: 40.0),
                  ),
                  sizedBox3Width(),
                  Visibility(
                    visible: itemDetails?.result.avgRating != '0.0',
                    replacement: Text(
                      AppConstants.noRatingsStr,
                      style: FontTypography.itemRatingTxtStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    child: Text(
                      '${itemDetails?.result.avgRating ?? 0.0}',
                      style: FontTypography.itemRatingTxtStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Visibility(
                    visible: itemDetails?.result.avgRating != '0.0',
                    child: Row(
                      children: [
                        SizedBox(
                          height: 26,
                          child: VerticalDivider(
                            color: AppColors.borderColor,
                            indent: 6.0,
                            endIndent: 6.0,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            AppRouter.push(AppRoutes.reviewScreenRoute, args: {
                              ModelKeys.itemId: itemDetails?.result.id,
                              ModelKeys.categoryId: businessCategoryId,
                              ModelKeys.itemName: itemDetails?.result.dynamicJson
                                  .firstWhere((item) => item.key == ModelKeys.listingTitle)
                                  .value,
                            });
                          },
                          child: Text(
                            '($reviewCount $reviewText)',
                            style: FontTypography.itemRatingTxtStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 2.0,
            ),
            child: Row(
              children: [
                Visibility(
                  visible: itemDetails?.result.totalLikeCount != 0,
                  child: SizedBox(
                      width: 24, // Set max width
                      child: Text(
                        '${itemDetails?.result.totalLikeCount ?? 0}',
                        style: FontTypography.likeCountStyle,
                        textAlign: TextAlign.center,
                      )),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///Horizontal divider for UI dividing
  Widget _horizontalDivider({Color? dividerColor}) {
    return Divider(
      height: 0.0,
      color: dividerColor ?? AppColors.borderColor.withOpacity(0.5),
    );
  }

  /// ClassifiedTypeView
  Widget _categoryTypeView() {
    final String? typeName = dynamicKeys.contains(ModelKeys.listingType)
        ? itemDetails?.result.dynamicJson.firstWhere((item) => item.key == ModelKeys.listingType).value
        : '';
    return Padding(
      padding: const EdgeInsets.only(
        left: 3.0,
      ),
      child: Visibility(
        visible: typeName.isNullOrEmpty() == false ? true : false,
        child: Text(
          typeName ?? '',
          style: FontTypography.forSaleTagTxtStyle,
        ),
      ),
    );
  }

  ///Vertical divider for UI used in parting calls, email,message and website.
  Widget _verticalDivider() {
    return Padding(
      padding: EdgeInsets.zero,
      child: VerticalDivider(
        color: AppColors.borderColor.withOpacity(0.5),
        endIndent: 0.0,
        indent: 0.0,
      ),
    );
  }

  ///Reach out row is used for managing call and other contacting related items to reach out creator of item with
  ///custom column which has icon name and its own click event.
  Widget _reachOutRow() {
    var requiredOpacityPhone = false;
    if (itemDetails?.result.dynamicJson.any((item) => item.key == ModelKeys.listingPhoneNumber) == true &&
    itemDetails?.result.dynamicJson
            .firstWhere((item) => item.key == ModelKeys.listingPhoneNumber)
            .value.isNullOrEmpty() ==
        false) {
      requiredOpacityPhone = false;
    } else {
      requiredOpacityPhone = true;
    }

    var requiredOpacityEmail = false;
    if (itemDetails?.result.dynamicJson.any((item) => item.key == ModelKeys.listingContactEmail) == true &&
    itemDetails?.result.dynamicJson
            .firstWhere((item) => item.key == ModelKeys.listingContactEmail)
            .value
            ?.isNotEmpty ==
        true) {
      requiredOpacityEmail = false;
    } else {
      requiredOpacityEmail = true;
    }

    var requiredOpacityWebsite = false;
    if (itemDetails?.result.dynamicJson.any((item) => item.key == ModelKeys.listingBusinessWebsite) == true &&
    itemDetails?.result.dynamicJson
            .firstWhere((item) => item.key == ModelKeys.listingBusinessWebsite)
            .value
            ?.isNullOrEmpty() ==
        false) {
      requiredOpacityWebsite = false;
    } else {
      requiredOpacityWebsite = true;
    }

    return SizedBox(
      height: 60.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Opacity(
            opacity: requiredOpacityPhone == false ? 1.0 : 0.8,
            child: _reachOutColumn(
              onTap: () {
                if (AppUtils.loginUserModel == null) {
                  ReusableWidgets.showConfirmationWithTwoFuncDialog(
                      AppConstants.appTitleStr, AppConstants.signInAlertStr,
                      option1: AppConstants.yesStr, option2: AppConstants.noStr, funcYes: () {
                    navigatorKey.currentState?.pop();
                    AppRouter.pushRemoveUntil(AppRoutes.signInViewRoute);
                  }, funcNo: () {
                    navigatorKey.currentState?.pop();
                  });
                  return;
                }
                else if (itemDetails?.result.dynamicJson.any((item) => item.key == ModelKeys.listingPhoneNumber) == true &&
                itemDetails?.result.dynamicJson
                        .firstWhere((item) => item.key == ModelKeys.listingPhoneNumber)
                        .value
                        .isNullOrEmpty() ==
                    false) {
                  itemDetails?.result.userUUID != AppUtils.loginUserModel?.uuid
                      ? _makePhoneCall(itemDetails?.result.dynamicJson
                              .firstWhere((item) => item.key == ModelKeys.listingPhoneNumber)
                              .value ??
                          '')
                      : null;
                } else {
                  AppUtils.showSnackBar(AppConstants.phoneValidationAlertMessage, SnackBarType.alert);
                }
              },
              title: AppConstants.callStr,
              assetPath: AssetPath.callIcon,
            ),
          ),
          _verticalDivider(),
          Opacity(
            opacity: requiredOpacityEmail == false ? 1.0 : 0.8,
            child: _reachOutColumn(
              onTap: () {
                if (AppUtils.loginUserModel == null) {
                  ReusableWidgets.showConfirmationWithTwoFuncDialog(
                      AppConstants.appTitleStr, AppConstants.signInAlertStr,
                      option1: AppConstants.yesStr, option2: AppConstants.noStr, funcYes: () {
                    navigatorKey.currentState?.pop();
                    AppRouter.pushRemoveUntil(
                      AppRoutes.signInViewRoute,
                    );
                  }, funcNo: () {
                    navigatorKey.currentState?.pop();
                  });
                  return;
                } else if (itemDetails?.result.dynamicJson
                        .firstWhere((item) => item.key == ModelKeys.listingContactEmail)
                        .value
                        .isNullOrEmpty() ==
                    false) {
                  itemDetails?.result.userUUID != AppUtils.loginUserModel?.uuid
                      ? sendEmail(
                          itemDetails?.result.dynamicJson
                                  .firstWhere((item) => item.key == ModelKeys.listingContactEmail)
                                  .value ??
                              '',
                          '${AppConstants.email_subject} ${itemDetails?.result.dynamicJson.firstWhere((item) => item.key == ModelKeys.listingTitle).value ?? ''}')
                      : null;
                } else {
                  AppUtils.showSnackBar(AppConstants.emailValidationAlertMessage, SnackBarType.alert);
                }
              },
              title: AppConstants.emailStr,
              assetPath: AssetPath.itemDetailsEmailIcon,
            ),
          ),
          _verticalDivider(),
          Visibility(
            visible: isAuthor,
            replacement: _reachOutColumn(
              onTap: () async {
                if (AppUtils.loginUserModel == null) {
                  ReusableWidgets.showConfirmationWithTwoFuncDialog(
                      AppConstants.appTitleStr, AppConstants.signInAlertStr,
                      option1: AppConstants.yesStr, option2: AppConstants.noStr, funcYes: () {
                    navigatorKey.currentState?.pop();
                    AppRouter.pushRemoveUntil(
                      AppRoutes.signInViewRoute,
                    );
                  }, funcNo: () {
                    handleActivityTracking(
                      activityTypeId: AppUtils.getActivityId(activityType: AppConstants.messageStr),
                    );
                    navigatorKey.currentState?.pop();
                  });
                  return;
                } else {
                  if (itemDetails?.result.userUUID != AppUtils.loginUserModel?.uuid) {
                    PreferenceHelper preferenceHelper = PreferenceHelper.instance;
                    LoginResponse userData = await preferenceHelper.getUserData();

                    var listTitle = itemDetails!.result.dynamicJson.firstWhere((item) => item.key == ModelKeys.listingTitle).value ?? '';
                    final String userName = itemDetails?.result.userName ?? 'N/A';
                    final String senderName = '${userData.result?.firstName ?? ''} ${userData.result?.lastName ?? ''}';
                    final String createdDate = DateFormat('d/MM/yyyy HH:mm').format(DateTime.now());

                final String initialMessageText = AppConstants.enquireMessageDetailText
                        .replaceFirst('%1\$s', userName)
                        .replaceFirst('%2\$s', senderName)
                        .replaceFirst('%3\$s', listTitle)
                        .replaceFirst('%4\$s', createdDate);

                    AppRouter.push(AppRoutes.messageChatScreenRoute, args: {
                      ModelKeys.receiverId: int.tryParse(itemDetails?.result.userId ?? '0'),
                      ModelKeys.lastMessageId: 0,
                      ModelKeys.senderName: listTitle,
                      ModelKeys.messageListId: 0,
                      ModelKeys.itemId: widget.itemId,
                      ModelKeys.itemListId:itemDetails?.result.id,
                      ModelKeys.categoryId: businessCategoryId,
                      ModelKeys.initialMessageText: initialMessageText,
                    });
                  }
                }
              },
              title: AppConstants.messageStr,
              assetPath: AssetPath.messageOutlineIcon,
            ),
            child: _reachOutColumn(
              assetPath: AssetPath.editIcon,
              iconColor: AppColors.primaryColor,
              style: FontTypography.editTextStyle,
              onTap: () {
                CategoriesListResponse category = CategoriesListResponse(formName: widget.categoryName);
                AppRouter.pushWithCallBack(
                  AppRoutes.addListingFormView,
                  args: AddListingFormView(
                    category: category,
                    itemId: itemDetails?.result.id,
                    formId: itemDetails?.result.categoryId,
                    myListingCubit: widget.myListingCubit,
                    isListingEditing: true,
                    isDraft: widget.isDraft,
                    recordStatus:itemDetails?.result.recordStatus,
                    recordStatusID:itemDetails?.result.recordStatusID,
                    isAvailableHistory:widget.isAvailableHistory,
                    accountType: AppUtils.loginUserModel?.accountTypeValue,
                  ),
                  callback: (action) {
                    widget.callback?.call(widget.categoryName!, action);
                  },
                );
              },
              title: AppConstants.editStr,
            ),
          ),
          _verticalDivider(),
          Opacity(
            opacity: requiredOpacityWebsite == false ? 1.0 : 0.8,
            child: _reachOutColumn(
                onTap: () async {
                  // if (AppUtils.loginUserModel == null) {
                  //   ReusableWidgets.showConfirmationWithTwoFuncDialog(
                  //       AppConstants.appTitleStr, AppConstants.signInAlertStr,
                  //       option1: AppConstants.yesStr, option2: AppConstants.noStr, funcYes: () {
                  //     navigatorKey.currentState?.pop(); // Close the loading dialog
                  //     AppRouter.pushRemoveUntil(
                  //       AppRoutes.signInViewRoute,
                  //     );
                  //   }, funcNo: () {
                  //     navigatorKey.currentState?.pop(); // Close the loading dialog
                  //   });
                  // } else {
                    if (itemDetails?.result.userUUID != AppUtils.loginUserModel?.uuid) {
                      String url = itemDetails?.result.dynamicJson
                          .firstWhere((item) => item.key == ModelKeys.listingBusinessWebsite)
                          .value ??
                          ''; // Add the scheme

                      if (url.isNotEmpty) {
                        final uri = Uri.parse(url);

                        if (await canLaunchUrl(uri)) {
                          handleActivityTracking(
                            activityTypeId: AppUtils.getActivityId(activityType: AppConstants.websiteStr),
                          );
                          await launchUrl(uri);
                        }
                      } else {
                        AppUtils.showSnackBar(AppConstants.websiteValidationAlertMessage, SnackBarType.alert);
                      }
                    }
                  // }
                },
                title: AppConstants.websiteStr,
                assetPath: AssetPath.linkIcon,
                iconColor: itemDetails?.result.dynamicJson.any((item) => item.key == ModelKeys.listingBusinessWebsite) == true &&
                itemDetails?.result.dynamicJson
                            .firstWhere((item) => item.key == ModelKeys.listingBusinessWebsite)
                            .value
                            ?.isNotEmpty ==
                        true
                    ? AppColors.blackColor
                    : AppColors.hintStyle),
          ),
        ],
      ),
    );
  }

  /// It is custom activity row which is used in _activityRowView with icon path and its color and a sized box in
  /// width for spacing.
  Widget _activityRow({required String assetPath, required Function() onTap, Color? iconColor}) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: 18.0,
            height: 18.0,
            child: ReusableWidgets.createSvg(path: assetPath, color: iconColor),
          ),
        ),
        sizedBox20Width(),
      ],
    );
  }


  Widget _dynamicRowLabelAndValue(String label, String value, String icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBox15Height(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!icon.isNullOrEmpty())
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: SvgPicture.network(
                  icon,
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  placeholderBuilder: (context) => const CircularProgressIndicator(), // Loading placeholder
                ),
              ),
            Text(label, style: FontTypography.aboutUsTxtStyle.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(width: 8),
            Flexible(child: Text(AppUtils.formatDateInServerFormat(value)??'', style: FontTypography.subDetailsTxtStyle)),
          ],
        )
      ],
    );
  }

  Widget _dynamicDateValue(String label, String value, String icon) {
    return Column(
      children: [
        sizedBox15Height(),
        Row(
          children: [
            if (!icon.isNullOrEmpty())
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: SvgPicture.network(
                  icon,
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  placeholderBuilder: (context) => const CircularProgressIndicator(), // Loading placeholder
                ),
              ),
            Text(label, style: FontTypography.aboutUsTxtStyle),
            const SizedBox(width: 8),
            Text(AppUtils.formatDateInServerFormat(value) ?? '', style: FontTypography.subDetailsTxtStyle),
          ],
        )
      ],
    );
  }

  Widget _dynamicTimeValue(String label, String value, String icon) {
    return Column(
      children: [
        sizedBox15Height(),
        Row(
          children: [
            if (!icon.isNullOrEmpty())
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: SvgPicture.network(
                  icon,
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  placeholderBuilder: (context) => const CircularProgressIndicator(), // Loading placeholder
                ),
              ),
            Text(label, style: FontTypography.aboutUsTxtStyle),
            const SizedBox(width: 8),
            Text(AppUtils.formatTimeRangeDisplay(value), style: FontTypography.subDetailsTxtStyle),
          ],
        )
      ],
    );
  }

  /// It is custom reach out column which is used in _reachOutRow with icon path and its color and a sized box in
  /// height for spacing and text to define the activity.
  Widget _reachOutColumn({
    required String assetPath,
    required Function() onTap,
    required String title,
    TextStyle? style,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4.8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 15.0,
                height: 15.0,
                child: ReusableWidgets.createSvg(path: assetPath, color: iconColor ?? AppColors.blackColor, size: 18.0),
              ),
              sizedBox5Height(),
              Flexible(
                child: Text(
                  title,
                  style: style ?? FontTypography.reachOutTxtStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///Widget to display name of item.
  Widget _itemName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: Column(
        children: [
          Text(
            //itemDetails?.result.getListingIdOrLogo(categoryName: widget.categoryName).itemName ?? '',
            itemDetails!.result.dynamicJson.firstWhere((item) => item.key == ModelKeys.listingTitle).value ?? '',
            style: FontTypography.profileHeading.copyWith(fontWeight: FontWeight.w700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          //sizedBox18Height(),
        ],
      ),
    );
  }

  ///this is row for displaying location and date time when item was created
  Widget _locationTimeDetails() {
    final locationName = dynamicKeys.contains(ModelKeys.listingLocation)
        ? itemDetails!.result.dynamicJson.firstWhere((item) => item.key == ModelKeys.listingLocation).value
        : '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0, top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(visible: locationName?.isNotEmpty ?? false, child: _locationDetails(locationName!)),
          Visibility(visible: itemDetails?.result.recordStatusID != RecordStatus.waitingForApproval.value && itemDetails?.result.recordStatusID != RecordStatus.disapproved.value, child: _timeDetails()),
        ],
      ),
    );
  }

  Widget _dynamicWebsite(DynamicJsonItem model) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0, 20, 0),
      child: InkWell(
        onTap: () async {
          String url = model.value ?? ''; // Add the scheme
          final uri = Uri.parse(url);

          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: Column(
          children: [
            sizedBox15Height(),
            IntrinsicWidth(
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReusableWidgets.createSvg(
                          path: AssetPath.websiteEarthIcon,
                          color: AppColors.whiteColor,
                          size: 16,
                        ),
                        sizedBox5Width(),
                        Text(
                          model.displayLabel ?? '',
                          style: FontTypography.purchaseStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///This view has location icon and location name
  Widget _locationDetails(String location) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: [
            SizedBox(
              height: 15.0,
              width: 12.0,
              child: ReusableWidgets.createSvg(
                path: AssetPath.locationPinIcon,
                size: 15.0,
                color: AppColors.jetBlackColor,
              ),
            ),
            sizedBox5Width(),
            Flexible(
              child: InkWell(
                onTap: () {
                  _openMap(location);
                },
                child: Text(
                  maxLines: 2,
                  location,
                  style: FontTypography.categoryTagTxtStyle.copyWith(
                    color: AppColors.jetBlackColor,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2.0,
                  ),
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///This view has time icon and date and time of item creating
  Widget _timeDetails() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 15.0,
                width: 15.0,
                child: ReusableWidgets.createSvg(
                  path: AssetPath.watchLaterIcon,
                  size: 15.0,
                  color: AppColors.jetBlackColor,
                ),
              ),
              sizedBox5Width(),
              Text(
                timeDuration ?? '',
                style: FontTypography.categoryTagTxtStyle.copyWith(
                  color: AppColors.jetBlackColor,
                  decorationThickness: 2.0,
                ),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ],
      ),
    );
  }


  ///formatting price using commas.
  String formatWithCommas(double amount) {
    final formatter = NumberFormat('#,##,##0'); // Indian comma pattern
    return formatter.format(amount);
  }

  ///Tab bar view which is displayed below price for about us and shops and jobs of same creator details
  Widget _tabBar() {
    var isAllListingNotEmpty = widget.state.updatedListingItems?.isNotEmpty;
    return Container(
      height: 40.0,
      decoration: BoxDecoration(color: AppColors.itemDetailsContainerColor),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primaryColor,
        labelStyle: FontTypography.aboutUsTxtStyle,
        labelColor: AppColors.primaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        unselectedLabelColor: AppColors.jetBlackColor,
        unselectedLabelStyle: FontTypography.subDetailsTxtStyle,
        onTap: (index) {
          widget.cubit.onTabSelected(index);
        },
        tabs: isAllListingNotEmpty!
            ? const [Tab(text: AppConstants.descriptionStr), Tab(text: AppConstants.allListing)]
            : const [
                Tab(text: AppConstants.descriptionStr),
              ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      handleActivityTracking(activityTypeId: AppUtils.getActivityId(activityType: AppConstants.callStr));
      await launchUrl(url);
    } else {
      // Handle the error, e.g., show a message to the user
      if (kDebugMode) {
        print('Could not launch $url');
      }
    }
  }

  Future<void> _openMap(String location) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$location');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> sendEmail(String email, String subject) async {
    final Uri url = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${Uri.encodeComponent(subject)}', // Encode the subject to handle special characters
    );

    if (await canLaunchUrl(url)) {
      handleActivityTracking(activityTypeId: AppUtils.getActivityId(activityType: AppConstants.emailStr));
      await launchUrl(url);
    } else {
      // Handle the error, e.g., show a message to the user
      if (kDebugMode) {
        print('Could not launch $url');
      }
    }
  }

  void handleActivityTracking({required int activityTypeId}) {
    widget.myListingCubit?.manageActivityTracking(
      listingId: widget.itemId,
      categoryId: businessCategoryId,
      activityTypeId: activityTypeId,
      deviceTypeId: AppUtils.getDeviceTypeId(),
    );
  }

  Future<void> categoryId() async {
    String? categoryName = widget.categoryName ?? '';
    var categoryData = await PreferenceHelper.instance.getCategoryList();
    var matchedCategory = categoryData.result?.firstWhere(
      (category) => category.formName?.toLowerCase().toString() == categoryName.toLowerCase(),
    );
    businessCategoryId = matchedCategory?.formId ?? 0;
  }

  Widget itemDetailsTabBody({required int selectedTab}) {
    String? itemDescription =
        itemDetails?.result.dynamicJson.firstWhere((item) => item.key == ModelKeys.listingDescription).value ?? '';

    switch (selectedTab) {
      case 0:
        return AboutUsView(description: itemDescription);
      case 1:
        return ShopView(
          state: widget.state,
          cubit: widget.cubit,
          categoryName: widget.categoryName ?? '',
          itemId: widget.itemId ?? 0,
          scrollController: widget.scrollController,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  ///used to dispose tab controller
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _textWithSaleTag() {
    dynamicKeys = itemDetails?.result.dynamicJson.map((item) => item.key).toList() ?? [];
    List<Map<String, dynamic>> filteredList = itemDetails?.result.dynamicJson
            .where((item) =>
                !ModelKeys.dynamicMasterKeys.contains(item.key) && item.view == 1 && item.dropdownBindType != 3 && !item.value.isNullOrEmpty())
            .map((item) => {'key': item.key, 'orderValue': item.orderValue})
            .toList() ??
        [];
    filteredList.sort((a, b) => (a['orderValue'] as int).compareTo(b['orderValue'] as int));
    dynamicOtherKeys = filteredList.map((item) => item['key'] as String).toList();

    final price = dynamicKeys.contains(ModelKeys.listingPrice)
        ? itemDetails?.result.dynamicJson.firstWhere((item) => item.key == ModelKeys.listingPrice).value
        : '';

    final estimateSalary = dynamicKeys.contains(ModelKeys.estimatedSalary)
        ? itemDetails?.result.dynamicJson.firstWhere((item) => item.key == ModelKeys.estimatedSalary).value
        : '';

    final priceRange = dynamicKeys.contains(ModelKeys.listingPriceRange)
        ? itemDetails?.result.dynamicJson.firstWhere((item) => item.key == ModelKeys.listingPriceRange).value
        : estimateSalary??'';

    final businessOrCommunityList = itemDetails?.result.dynamicJson.where((item) => item.dropdownBindType == 3);
    final isBusinessOrCommunity = businessOrCommunityList!.isNotEmpty ? true : false;

    List<String?> nonNullValues = businessOrCommunityList
        .where((item) => item.value != null && item.value!.isNotEmpty)
        .map((item) => item.value)
        .toList();

    List<int?> businessOrCommunityIDValues = businessOrCommunityList
        .where((item) => item.inheritId != null && item.inheritId!=0)
        .map((item) => item.inheritId)
        .toList();

    var businessOrCommunityName = nonNullValues.isNotEmpty ? nonNullValues[0] : '';
    var businessOrCommunityID = businessOrCommunityIDValues.isNotEmpty ? businessOrCommunityIDValues[0] : 0;
    businessOrCommunityName =
        businessOrCommunityName.isNullOrEmpty() == false ? businessOrCommunityName : AppConstants.privateListing;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row( // Grouping left-aligned widgets
                children: [
                  Visibility(
                    visible: itemDetails?.result.recordStatusID == RecordStatus.waitingForApproval.value,
                    child: Container(
                      width: 90,
                      decoration: BoxDecoration(
                        color: AppColors.approvalWaitingColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Center(
                        child: Text(
                          itemDetails?.result.recordStatus ?? '',
                          style: FontTypography.locationTextStyle
                              .copyWith(color: AppColors.lightBlackColor),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: itemDetails?.result.recordStatusID == RecordStatus.disapproved.value,
                    child: InkWell(
                      onTap: () {
                        ///Add draft logic
                      },
                      child: disApproveStatus(
                        backgroundColor: AppColors.whiteColor,
                        title: itemDetails?.result.recordStatus ?? '',
                        containerSize:110,
                        assetPath: AssetPath.draftIcon,
                        iconColor: AppColors.deleteColor,
                        textStyle: FontTypography.snackBarButtonStyle
                            .copyWith(color: AppColors.deleteColor),
                        assetSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              _categoryTypeView(), // Right-aligned
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Visibility(
                    visible: isBusinessOrCommunity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          businessOrCommunityName == AppConstants.privateListing
                              ? Text(
                            businessOrCommunityName ?? '',
                            style: FontTypography.aboutUsTxtStyle,
                          )
                              : GestureDetector(
                            onTap: () {
                              AppRouter.push(AppRoutes.itemDetailsViewRoute, args: {
                                ModelKeys.itemId: businessOrCommunityID,
                                ModelKeys.category: '',
                                ModelKeys.formId:widget.formId,
                                ModelKeys.communityId:widget.formId,
                                ModelKeys.isDraft: widget.isDraft,
                              });
                            },
                            child: Text(
                              businessOrCommunityName ?? '',
                              style: FontTypography.aboutUsTxtStyle.copyWith(
                                decoration: TextDecoration.underline, // optional: looks more like a link
                              ),
                            ),
                          ),

                          Visibility(
                            visible: (price.isNullOrEmpty() == false || priceRange.isNullOrEmpty() == false) ? true : false,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Wrap(
                                alignment: WrapAlignment.end,
                                crossAxisAlignment: WrapCrossAlignment.end,
                                runAlignment: WrapAlignment.end,
                                direction: Axis.horizontal,
                                children: [
                                  Visibility(
                                    visible: price.isNullOrEmpty() == false ? true : false,
                                    child: Text(price==AppConstants.toBeDiscuss?
                                      '${AppConstants.priceStr}: ${price??''}':price??'',textAlign: TextAlign.end,
                                      style: FontTypography.priceStyle,
                                    ),
                                  ),
                            Visibility(
                              visible: priceRange?.isNotEmpty == true,
                              child: Text(
                                priceRange==AppConstants.toBeDiscuss
                                    ? '${AppConstants.priceRangeStr} $priceRange'
                                    : priceRange??'',
                                textAlign: TextAlign.end,
                                style: FontTypography.priceStyle,
                              ),
                            ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget disApproveStatus({
    required Color backgroundColor,
    required TextStyle textStyle,
    required Color iconColor,
    required String assetPath,
    required double assetSize,
    required double containerSize,
    required String title,
  }) {
    return Container(
      width: containerSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.deleteColor), // Added border
        boxShadow: [
          BoxShadow(
            color: AppColors.borderColor,
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ReusableWidgets.createSvg(
            path: assetPath,
            size: assetSize,
            color: iconColor,
          ),
          sizedBox5Width(),
          Text(
            title,
            style: textStyle,
          ),
        ],
      ),
    );
  }


  Widget _dynamicDataDisplay() {
    List<Widget> rows = [];

    for (var key in dynamicOtherKeys) {
      var model = itemDetails?.result.dynamicJson.firstWhere((item) => item.key == key);

      if (model != null) {
        var value = model.value ?? '';
        if (model.fieldType == ModelKeys.checkbox || model.fieldType == ModelKeys.select || model.fieldType == ModelKeys.tagInput) {
          rows.add(_dynamicSkills(model));
        } else if (model.fieldType == ModelKeys.file) {
          rows.add(_dynamicFileAdd(model));
        } else if (model.fieldType == ModelKeys.website) {
          if(!model.value.isNullOrEmpty()) {
            rows.add(_dynamicWebsite(model));
          }
        } else if (model.fieldType == ModelKeys.date) {
          if (!value.isNullOrEmpty()) {
            rows.add(_dynamicDateValue(model.displayLabel ?? '', value, model.icon ?? ''));
          }
        } else if (model.fieldType == ModelKeys.time ||model.fieldType == FormFieldType.timeRange.value) {
          if (!value.isNullOrEmpty()) {
            rows.add(_dynamicTimeValue(model.displayLabel ?? '', value, model.icon ?? ''));
          }
        } else {
            if (!value.isNullOrEmpty()) {
              rows.add(_dynamicRowLabelAndValue(model.displayLabel ?? '', value, model.icon ?? ''));
            }
        }
      }
    }

    // If no data is found, return an empty SizedBox
    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }

    // Wrap the rows in a Padding and Column widget
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows,
      ),
    );
  }

  Widget _dynamicSkills(DynamicJsonItem model) {
    final skills = model.value ?? '';
    print('Skills--> $skills');
    List<String> skillsList = skills.split(',') ?? [];

    if (skills.contains(',')) {
      return Visibility(
        visible: (skillsList.isNotEmpty),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedBox15Height(),
            Text(
              model.displayLabel ?? '',
              style: FontTypography.aboutUsTxtStyle,
            ),
            sizedBox10Height(),
            Wrap(
              runSpacing: 5.0,
              children: skillsList.map((skill) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•', // Bullet point
                      style: FontTypography.aboutUsTxtStyle,
                    ),
                    sizedBox10Width(),
                    Expanded(
                      child: Text(
                        skill ?? '',
                        style: FontTypography.advanceScreenSortByStyle,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      );
    } else {
      return _dynamicRowLabelAndValue(model.displayLabel ?? '', model.value ?? '', model.icon ?? '');
    }
  }

  Widget _dynamicFileAdd(DynamicJsonItem model) {
    return Visibility(
      visible: !model.value.isNullOrEmpty(),
      child: SizedBox(
        height: 81,
        child: Visibility(
          visible: !model.value.isNullOrEmpty(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBox15Height(),
              Text(
                model.displayLabel ?? '',
                style: FontTypography.aboutUsTxtStyle,
              ),
              InkWell(
                onTap: () {
                  AppRouter.push(
                    AppRoutes.inAppWebView,
                    args: WorkAppWebView(
                      url: model.value ?? '',
                    ),
                  );
                },
                child: Chip(
                  label: Text(
                    (model.value!.isNotEmpty && model.value!.contains('/')) ? model.value!.split('/').last : '',
                    style: FontTypography.cvStyle,
                  ),
                  backgroundColor: AppColors.whiteColor,
                  side: BorderSide(color: AppColors.jetBlackColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
