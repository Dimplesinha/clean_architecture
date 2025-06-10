import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/presentation/modules/account_type_change/cubit/account_type_change_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/modules/subscription/cubit/subscription_cubit.dart';
import 'package:workapp/src/utils/app_utils.dart';

class ListingCard extends StatelessWidget {
  final MyListingItems? myListingItem;
  final bool showDeleteIcon;
  final bool showBookmarkIcon;
  final bool showCheckBox;
  final bool chooseListing;
  final bool isFromMyListing;
  final int? index;
  final Function()? onItemClick;
  final Function()? onDeleteItemClick;
  final Function()? onBookmarkItemClick;
  final MyListingCubit? myListingCubit;
  final AccountTypeChangeCubit? accountTypeChangeCubit;
  final AccountTypeChangeLoadedState? accountTypeChangeLoadedState;
  final SubscriptionCubit? subscriptionCubit;
  final SubscriptionLoadedState? subscriptionLoadedState;
  final Function()? callback;

  const ListingCard({
    super.key,
    this.myListingItem,
    this.isFromMyListing = false,
    this.onItemClick,
    this.onDeleteItemClick,
    this.onBookmarkItemClick,
    this.showDeleteIcon = false,
    this.showBookmarkIcon = false,
    this.chooseListing = false,
    this.showCheckBox = false,
    this.myListingCubit,
    this.index,
    this.accountTypeChangeLoadedState,
    this.accountTypeChangeCubit,
    this.subscriptionLoadedState,
    this.subscriptionCubit,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    var isPriceFromEmpty = false;
    var isPriceToEmpty = false;

    if (myListingItem?.priceFrom == null ||
        myListingItem?.priceFrom == '0.00' ||
        myListingItem?.priceFrom?.isEmpty == true) {
      isPriceFromEmpty = true;
    }
    if (myListingItem?.priceTo == null || myListingItem?.priceTo == '0.00' || myListingItem?.priceTo?.isEmpty == true) {
      isPriceToEmpty = true;
    }

    ///ToDo: Remove static value its is only for displaying due to removing model
    double imageSize = (MediaQuery.of(context).size.width - 30) / 2;
    final randomColor = Colors.primaries[myListingItem.hashCode % Colors.primaries.length].shade400;
    return InkWell(
      onTap: () {
        AppRouter.push(
          AppRoutes.itemDetailsViewRoute,
          args: {
            ModelKeys.itemId: myListingItem?.id,
            ModelKeys.category: myListingItem?.category,
            ModelKeys.formId: myListingItem?.formId,
            ModelKeys.communityId: myListingItem?.formId,
            ModelKeys.isDraft: myListingItem?.status == AppConstants.draftStr,
          },
        )?.then((data) {
          callback?.call();
        });
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
                        width: imageSize,
                        height: imageSize,
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: myListingItem?.logo ?? '',
                              height: imageSize,
                              width: imageSize,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.low,
                              cacheManager: CacheManager(
                                Config(
                                  'customCacheKey', // Custom cache key
                                  stalePeriod: const Duration(days: 7), // Cached images remain valid for 7 days
                                  maxNrOfCacheObjects: 20, // Limit the number of cached objects
                                ),
                              ),
                              fadeInDuration: const Duration(milliseconds: 300),
                              errorWidget: (context, error, stackTrace) {
                                return Container(
                                  height: imageSize,
                                  width: imageSize,
                                  color: randomColor,
                                  child: Center(
                                    child: ReusableWidgets.createSvg(
                                      path: AssetPath.defaultImageIcon,
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
                                  priceFrom: myListingItem?.priceFrom ?? '',
                                  priceTo: myListingItem?.priceTo ?? '',
                                  currencyCode: myListingItem?.currency ?? '',
                                ),
                                builder: (context, snapshot) {
                                  return Visibility(
                                    visible: (snapshot.data?.isNotEmpty ?? false) || snapshot.data != '',
                                    replacement: const SizedBox.shrink(),
                                    child: Container(
                                      height: 30.0,
                                      decoration: BoxDecoration(color: AppColors.jetBlackColor.withValues(alpha: 0.5)),
                                      padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 7.0),
                                      child: Center(
                                        child: Text(
                                          snapshot.data ?? '',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: FontTypography.defaultTextStyle
                                              .copyWith(color: AppColors.whiteColor, fontSize: 12.0),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: myListingItem?.category?.toUpperCase().isNotEmpty ?? false,
                    replacement: const SizedBox.shrink(),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.forSaleColor.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
                            child: Text(
                              myListingItem?.category?.toUpperCase() ?? '',
                              style: FontTypography.itemDetailsGridViewStyle.copyWith(color: AppColors.whiteColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: myListingItem?.type?.isNotEmpty ?? false,
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
                              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1),
                              child: Text(
                                myListingItem?.type == AppConstants.sellStr
                                    ? AppConstants.forSellStr
                                    : myListingItem?.itemType ?? '',
                                style: FontTypography.itemDetailsGridViewStyle.copyWith(color: AppColors.jetBlackColor),
                              )),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 10.0, left: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: myListingItem?.status == AppConstants.expiredStr,
                          replacement: const SizedBox.shrink(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
                              child: Text(
                                myListingItem?.category == AppConstants.realEstateStr ||
                                        myListingItem?.category == AppConstants.classFieldsStr
                                    ? myListingItem?.itemType ?? ''
                                    : AppConstants.expiredStr,
                                style: FontTypography.itemDetailsGridViewStyle.copyWith(color: AppColors.jetBlackColor),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showDeleteIcon,
                          replacement: const SizedBox.shrink(),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: AppUtils.elevatedCircleAvatar(
                              height: 25,
                              width: 25,
                              backgroundColor: AppColors.deleteBgColor,
                              path: AssetPath.deleteIcon,
                              onPressed: onDeleteItemClick,
                              iconSize: 12,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showBookmarkIcon,
                          replacement: const SizedBox.shrink(),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: AppUtils.elevatedCircleAvatar(
                              height: 25,
                              width: 25,
                              backgroundColor: AppColors.whiteColor,
                              path: AssetPath.bookmarkFilledIcon,
                              onPressed: () {
                                if (myListingItem?.id != null && myListingItem?.category != null) {
                                  myListingCubit?.onBookmarkPressed(
                                      itemId: myListingItem?.id,
                                      categoryName: myListingItem?.category,
                                      isBookMarked: false);
                                }
                              },
                              iconSize: 13,
                            ),
                          ),
                        ),
                        if (showCheckBox) _buildCheckbox(accountTypeChangeLoadedState, accountTypeChangeCubit),
                        if (chooseListing) _buildCheckbox(subscriptionLoadedState, subscriptionCubit),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.0, bottom: 10, right: 11),
                          child: Text(
                            myListingItem?.listingName ?? 'Business Item',
                            style: FontTypography.listingStatTxtStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  locationRowWidget(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isSelected(int? index) {
    if (index != null && accountTypeChangeLoadedState?.selectedListing != null) {
      return accountTypeChangeLoadedState!.selectedListing.any((listing) => listing.id == myListingItem?.id);
    } else if (index != null && subscriptionLoadedState?.selectedListing != null) {
      return subscriptionLoadedState!.selectedListing.any((listing) => listing.id == myListingItem?.id);
    }
    return false;
  }

  Widget locationRowWidget() {
    String timeDuration = AppUtils.timeAgo(myListingItem?.boostDate ?? '2024-12-16T04:32:00.213');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Changed this
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              Expanded(flex: 1, child: ReusableWidgets.createSvg(path: AssetPath.mapIcon, size: 10)),
              sizedBox5Width(),
              Expanded(
                flex: 10,
                child: Text(
                  myListingItem?.cityCountry ?? 'US',
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
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end, // Add this to the inner Row
              children: [
                ReusableWidgets.createSvg(path: AssetPath.timeIcon, size: 10),
                sizedBox5Width(),
                Text(
                  timeDuration,
                  textAlign: TextAlign.end, // Align text to the right
                  style: FontTypography.itemDetailsGridViewStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// CheckBox to select Listing
  Widget _buildCheckbox(dynamic state, dynamic cubit) {
    return Align(
      alignment: Alignment.topRight,
      child: Checkbox(
        checkColor: AppColors.whiteColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(color: AppColors.checkboxColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: AppColors.primaryColor),
        ),
        activeColor: AppColors.primaryColor,
        value: state?.selectedListing[index ?? 0].isSelected ?? false,
        onChanged: (value) async {
          if (value != null && state?.selectedListing != null) {
            state.selectedListing[index ?? 0].isSelected = value;
            state.selectedListing.first.selectAll = false;
            cubit?.updateActiveListing(state.selectedListing ?? []);
          }
        },
      ),
    );
  }
}
