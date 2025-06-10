import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/my_contact_user_listing/cubit/my_contact_user_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 28/03/25
/// @Message : [MyContactUserPastListing]
///
/// The `MyContactUserPastListing` Provides past list of user.
class MyContactUserPastListing extends StatefulWidget {
  final MyContactUserListingCubit myContactUserListingCubit;
  final ScrollController scrollController;

  const MyContactUserPastListing({super.key, required this.myContactUserListingCubit, required this.scrollController});

  @override
  State<MyContactUserPastListing> createState() => _MyContactUserPastListingState();
}

class _MyContactUserPastListingState extends State<MyContactUserPastListing> with SingleTickerProviderStateMixin {
  /*@override
  void initState() {
    super.initState();
    widget.myContactUserListingCubit.setCategoryList();
  }*/

  @override
  Widget build(BuildContext context) {
    double imageSize = (MediaQuery.of(context).size.width - 30) / 2;
    return BlocBuilder<MyContactUserListingCubit, MyContactUserListingState>(
      bloc: widget.myContactUserListingCubit,
      builder: (context, state) {
        if (state is MyContactUserListingLoadedState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: state.contactUserPastListingItem == null || state.contactUserPastListingItem!.isEmpty
                  ? Center(
                      child: Text(AppConstants.noItemsStr, style: FontTypography.defaultTextStyle),
                    )
                  : GridView.builder(
                      controller: widget.scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.70,
                      ),
                      itemCount: state.contactUserPastListingItem?.length ?? 0,
                      itemBuilder: (context, index) {
                        MyListingItems item = state.contactUserPastListingItem?[index] ?? MyListingItems();
                        var isPriceFromEmpty = false;
                        var isPriceToEmpty = false;

                        if (item.priceFrom == null || item.priceFrom == '0.00' || item.priceFrom?.isEmpty == true) {
                          isPriceFromEmpty = true;
                        }
                        if (item.priceTo == null || item.priceTo == '0.00' || item.priceTo?.isEmpty == true) {
                          isPriceToEmpty = true;
                        }

                        String timeDuration = AppUtils.timeAgo(item.boostDate ?? '');
                        return InkWell(
                          onTap: () {
                            AppRouter.push(
                              AppRoutes.itemDetailsViewRoute,
                              args: {
                                ModelKeys.itemId: item.id,
                                ModelKeys.category: item.category,
                                ModelKeys.communityId: item.category,
                                ModelKeys.myListingCubit: widget.myContactUserListingCubit,
                                ModelKeys.isDraft: item.status == AppConstants.draftStr
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.listingCardsBgColor,
                              borderRadius: BorderRadius.circular(constBorderRadius),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: SizedBox(
                                            height: imageSize,
                                            width: imageSize,
                                            child: Stack(
                                              children: [
                                                Image.network(
                                                  /*(item.logo?.contains(ApiConstant.containerString) ?? false
                                                              ? item.logo!.replaceAll(ApiConstant.containerString,
                                                                  ApiConstant.containerLogoThumbString)
                                                              : item.logo?.replaceAll(ApiConstant.containerLogoString,
                                                                  ApiConstant.containerLogoThumbString)) ??
                                                          ''*/
                                                  item.logo ?? '',
                                                  fit: BoxFit.cover,
                                                  width: imageSize,
                                                  height: imageSize,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Padding(
                                                      padding: isPriceFromEmpty && isPriceToEmpty
                                                          ? const EdgeInsets.all(0.0)
                                                          : const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                                      child: Center(
                                                        child: ReusableWidgets.createSvg(
                                                          path: AssetPath.dummyPlaceholderSvg,
                                                          boxFit: BoxFit.cover,
                                                          height: 70,
                                                          width: 70,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: FutureBuilder<String>(
                                                      future: AppUtils.formatPriceRange(
                                                        priceFrom: item.priceFrom ?? '',
                                                        priceTo: item.priceTo ?? '',
                                                        currencyCode: item.currency ?? '',
                                                      ),
                                                      builder: (context, snapshot) {
                                                        return Visibility(
                                                          visible: (snapshot.data?.isNotEmpty ?? false) ||
                                                              (snapshot.data != '' && snapshot.data != null),
                                                          replacement: const SizedBox.shrink(),
                                                          child: Container(
                                                            height: 30.0,
                                                            decoration: BoxDecoration(
                                                                color: AppColors.jetBlackColor.withOpacity(0.5)),
                                                            padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 7.0),
                                                            child: Center(
                                                              child: Text(
                                                                snapshot.data ?? '',
                                                                textAlign: TextAlign.center,
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: FontTypography.defaultTextStyle.copyWith(
                                                                    color: AppColors.whiteColor, fontSize: 12.0),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 6.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.forSaleColor.withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
                                              child: Text(
                                                item.category?.toUpperCase() ?? '',
                                                style: FontTypography.itemDetailsGridViewStyle
                                                    .copyWith(color: AppColors.whiteColor, fontSize: 12.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            item.status == AppConstants.expiredStr || (item.type?.isNotEmpty ?? false),
                                        replacement: const SizedBox.shrink(),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 6.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
                                                child: Text(
                                                  item.status == AppConstants.expiredStr
                                                      ? AppConstants.expiredStr
                                                      : item.type == AppConstants.sellStr
                                                          ? AppConstants.forSellStr
                                                          : item.type == AddListingFormConstants.free
                                                              ? AddListingFormConstants.free
                                                              : item.itemType,
                                                  style: FontTypography.itemDetailsGridViewStyle
                                                      .copyWith(color: AppColors.jetBlackColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.listingName ?? '',
                                              style: FontTypography.listingStatTxtStyle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      locationRowWidget(
                                        location: item.cityCountry ?? '',
                                        time: timeDuration,
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
        }
        return const LoaderView();
      },
    );
  }

  Widget actionToBoostItem({
    required String status,
    required String statusAssetPath,
    required Color statusBackgroundColor,
    required Color statusIconColor,
    required Color activeStatusColor,
    required String activeStatusAssetPath,
    required TextStyle statusTextStyle,
    required dynamic Function()? onBoostPressed,
    required dynamic Function()? onActivePress,
    required dynamic Function() onStatisticPressed,
    required dynamic Function() onMegaPhonePressed,
  }) {
    return Row(
      children: [
        InkWell(
          onTap: onBoostPressed,
          child: boostDraftContainer(
            title: status,
            assetPath: statusAssetPath,
            backgroundColor: statusBackgroundColor,
            textStyle: statusTextStyle,
            iconColor: statusIconColor,
            assetSize: 7,
          ),
        ),
        const SizedBox(width: 5),
        boostIcons(backgroundColor: activeStatusColor, assetPath: activeStatusAssetPath, onPressed: onActivePress),
        const SizedBox(width: 5),
        boostIcons(
          assetPath: AssetPath.statisticsIcon,
          onPressed: onStatisticPressed,
        ),
        const SizedBox(width: 5),
        boostIcons(
          assetPath: AssetPath.megaphoneIcon,
          onPressed: onMegaPhonePressed,
        ),
      ],
    );
  }

  Widget editDeleteButton(
      {required String assetPath,
      required Function() onPressed,
      required double height,
      required double width,
      required Color backgroundColor}) {
    return Align(
      alignment: Alignment.topRight,
      child: AppUtils.elevatedCircleAvatar(
        height: height,
        width: width,
        backgroundColor: AppColors.deleteBgColor,
        path: assetPath,
        onPressed: onPressed,
        iconColor: AppColors.backgroundColor,
        iconSize: 12,
      ),
    );
  }

  Widget boostIcons({required String assetPath, required Function()? onPressed, Color? backgroundColor}) {
    return Expanded(
      child: AppUtils.elevatedCircleAvatar(
        height: 21,
        width: 25,
        path: assetPath,
        iconSize: 12,
        backgroundColor: backgroundColor ?? AppColors.backgroundColor,
        onPressed: onPressed,
      ),
    );
  }

  Widget boostDraftContainer({
    required Color backgroundColor,
    required TextStyle textStyle,
    required Color iconColor,
    required String assetPath,
    required double assetSize,
    required String title,
  }) {
    return Container(
      width: 64,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
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

  Widget locationRowWidget({required String location, required String time}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 1, child: ReusableWidgets.createSvg(path: AssetPath.mapIcon, size: 10)),
              sizedBox5Width(),
              Expanded(
                flex: 9,
                child: Text(
                  location,
                  style: FontTypography.itemDetailsGridViewStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        sizedBox10Width(),
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 1, child: ReusableWidgets.createSvg(path: AssetPath.timeIcon, size: 10)),
              sizedBox5Width(),
              Expanded(
                flex: 9,
                child: Text(
                  time,
                  style: FontTypography.itemDetailsGridViewStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
