import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/view/add_listing_form_view.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/my_listing/view/my_listing_category_filter.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 09/09/24
/// @Message : [MyListingFilter]
///
/// The `MyListingFilter`  class provides a user interface for performing my listing filter
class MyListingFilter extends StatefulWidget {
  final MyListingCubit myListingCubit;
  final ScrollController scrollController;

  const MyListingFilter({super.key, required this.myListingCubit, required this.scrollController});

  @override
  State<MyListingFilter> createState() => _MyListingFilterState();
}

class _MyListingFilterState extends State<MyListingFilter> with SingleTickerProviderStateMixin {
  final StreamController<bool> _streamControllerClearBtn = StreamController<bool>.broadcast();

  Stream<bool> get _streamClearBtn => _streamControllerClearBtn.stream;

  @override
  void initState() {
    super.initState();
    widget.myListingCubit.setCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = (MediaQuery.of(context).size.width - 30) / 2;
    return BlocBuilder<MyListingCubit, MyListingState>(
      bloc: widget.myListingCubit,
      builder: (context, state) {
        if (state is MyListingLoadedState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ReusableWidgets.searchWidget(
                          hintTxt: AppConstants.findMyListings,
                          onSubmit: (value) {
                            _onSearchClick();
                          },
                          onChanged: (value) => _streamControllerClearBtn.add(value.isNotEmpty),
                          stream: _streamClearBtn,
                          onCancelClick: () {
                            _streamControllerClearBtn.add(false);
                            widget.myListingCubit.searchTxtController.clear();
                            _onSearchClick();
                          },
                          onSearchIconClick: () {
                            _onSearchClick();
                          },
                          txtController: widget.myListingCubit.searchTxtController,
                        ),
                      ),
                      const SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          AppUtils.showBottomSheetWithData(
                            context,
                            child: MyListingCategoryFilter(
                              myListingCubit: widget.myListingCubit,
                              myListingLoadedState: state,
                            ),
                            onCancelWithData: (action) {},
                          );
                        },
                        child: ReusableWidgets.createSvg(
                          path: AssetPath.insightFilterIcon,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (state.myListingItem == null || state.myListingItem!.isEmpty) Center(
                          child: Text(AppConstants.noItemsStr, style: FontTypography.defaultTextStyle),
                        ) else GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 20),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.70,
                          ),
                          itemCount: state.myListingItem?.length ?? 0,
                          itemBuilder: (context, index) {

                            MyListingItems item = state.myListingItem?[index] ?? MyListingItems();
                            final randomColor = Colors.primaries[item.hashCode % Colors.primaries.length].shade400;
                            var isPriceFromEmpty = false;
                            var isPriceToEmpty = false;

                            if (item.priceFrom == null || item.priceFrom == '0.00' || item.priceFrom?.isEmpty == true) {
                              isPriceFromEmpty = true;
                            }
                            if (item.priceTo == null || item.priceTo == '0.00' || item.priceTo?.isEmpty == true) {
                              isPriceToEmpty = true;
                            }

                            String timeDuration = AppUtils.timeAgo(item.boostDate ??item.dateModified?? '');

                            return InkWell(
                              onTap: () {
                                AppRouter.push(
                                  AppRoutes.itemDetailsViewRoute,
                                  args: {
                                    ModelKeys.itemId: item.id,
                                    ModelKeys.category: item.category,
                                    ModelKeys.formId: item.formId,
                                    ModelKeys.communityId: item.category,
                                    ModelKeys.myListingCubit: widget.myListingCubit,
                                    ModelKeys.isDraft: item.status == AppConstants.draftStr,
                                    ModelKeys.isAvailableHistory: item.isAvailableHistory
                                  },
                                )?.then((result) {
                                  if (result == true) {
                                    widget.myListingCubit.currentPage = 1;
                                    widget.myListingCubit
                                        .fetchMyListingItems(search: '', isRefresh: true, isFromBoost: true);
                                    return null;
                                  }
                                  //refresh listing screen when any changes perform in detail screen.
                                  if (result != null) {
                                    widget.myListingCubit.currentPage = 1;
                                    widget.myListingCubit
                                        .fetchMyListingItems(search: '', isRefresh: true, isFromBoost: true);
                                    return null;
                                  }
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
                                                          child: Container(
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
                                            visible: item.status == AppConstants.expiredStr ||
                                                (item.type?.isNotEmpty ?? false),
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
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10.0, right: 10.0, left: 6.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                editDeleteButton(
                                                  height: 25,
                                                  width: 25,
                                                  backgroundColor: AppColors.deleteBgColor,
                                                  assetPath: AssetPath.deleteIcon,
                                                  onPressed: () => onDeletedPress(item: item, state: state),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                                          Visibility(
                                            visible: (item.cityCountry ?? '').isNotEmpty,
                                            child: locationRowWidget(
                                              location: item.cityCountry ?? '',
                                              time: timeDuration,
                                                status:item.status
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Visibility(
                                            visible: item.status == AppConstants.draftStr,
                                            replacement: const SizedBox.shrink(),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: InkWell(
                                                onTap: () {
                                                  ///Add draft logic
                                                },
                                                child: boostDraftContainer(
                                                  backgroundColor: AppColors.whiteColor,
                                                  title: AppConstants.draftStr,
                                                  border: Border.all(color: AppColors.blackColor),
                                                  assetPath: AssetPath.draftIcon,
                                                  iconColor: AppColors.blackColor,
                                                  textStyle: FontTypography.snackBarButtonStyle
                                                      .copyWith(color: AppColors.jetBlackColor),
                                                  assetSize: 12, containerSize: 64,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: item.status == AppConstants.activeStr,
                                            replacement: const SizedBox.shrink(),
                                            child: actionToBoostItem(
                                              status: AppConstants.boostStr,
                                              statusAssetPath: AssetPath.boostIcon,
                                              statusBackgroundColor: AppColors.primaryColor,
                                              activeStatusColor: Colors.green,
                                              activeStatusAssetPath: AssetPath.activeIcon,
                                              onBoostPressed: () async {
                                                ///add condition of empty check
                                                if (item.id != 0 && item.category != null) {
                                                  widget.myListingCubit
                                                      .toggleBoost(categoryId: item.formId, itemId: item.id);
                                                  await widget.scrollController.animateTo(0.0,
                                                      duration: const Duration(milliseconds: 100),
                                                      curve: Curves.easeIn);
                                                }
                                              },
                                              onActivePress: () async{
                                                int itemCount = await widget.myListingCubit.fetchItemUsageCount(
                                                  itemId: item.id,
                                                  formId: item.formId,
                                                );
                                                ReusableWidgets.showConfirmationWithTwoFuncDialog(
                                                    AppConstants.pleasConfirm,
                                                    itemCount>0?AppConstants.areYouSurePauseStr.replaceFirst(
                                                        '{categoryName}', item.category?.toLowerCase() ?? ''):AppConstants.categoryInUse,
                                                    funcYes: () async {
                                                      navigatorKey.currentState?.pop();
                                                      if (item.id != 0 &&
                                                          item.category != null &&
                                                          item.status != null) {
                                                        int status = item.statusId(
                                                            status: item.status == AppConstants.activeStr
                                                                ? AppConstants.inActiveStr
                                                                : AppConstants.activeStr);
                                                        widget.myListingCubit.onPausedClick(
                                                          itemId: item.id,
                                                          categoryId: item.formId,
                                                          status: status,
                                                        );
                                                        await widget.scrollController.animateTo(0.0,
                                                            duration: const Duration(milliseconds: 100),
                                                            curve: Curves.easeIn);
                                                      }
                                                    },
                                                    funcNo: () => navigatorKey.currentState?.pop());
                                              },
                                              onMegaPhonePressed: () {},
                                              onStatisticPressed: () => onStatisticsIconPressed(item: item),
                                              statusTextStyle: FontTypography.snackBarButtonStyle
                                                  .copyWith(fontSize: 12),
                                              statusIconColor: AppColors.whiteColor,
                                            ),
                                          ),
                                          Visibility(
                                            visible: item.status == AppConstants.inActiveStr,
                                            child: actionToBoostItem(
                                              statusTextStyle: FontTypography.snackBarButtonStyle
                                                  .copyWith(color: AppColors.primaryColor,fontSize: 12),
                                              statusIconColor: AppColors.primaryColor,
                                              statusBackgroundColor: AppColors.whiteColor,
                                              activeStatusColor: AppColors.deleteColor,
                                              activeStatusAssetPath: AssetPath.inactiveIcon,
                                              status: AppConstants.boostStr,
                                              statusAssetPath: AssetPath.boostIcon,
                                              onBoostPressed: null,
                                              onActivePress: () {
                                                ReusableWidgets.showConfirmationWithTwoFuncDialog(
                                                    AppConstants.pleasConfirm,
                                                    AppConstants.areYouSureActiveStr.replaceFirst(
                                                        '{categoryName}', item.category?.toLowerCase() ?? ''),
                                                    funcYes: () async {
                                                      navigatorKey.currentState?.pop();
                                                      if (item.id != 0 &&
                                                          item.category != null &&
                                                          item.status != null) {
                                                        int status = item.statusId(
                                                            status: item.status == AppConstants.activeStr
                                                                ? AppConstants.inActiveStr
                                                                : AppConstants.activeStr);
                                                        widget.myListingCubit.onPausedClick(
                                                          itemId: item.id,
                                                          categoryId: item.formId,
                                                          status: status,
                                                        );
                                                        await widget.scrollController.animateTo(0.0,
                                                            duration: const Duration(milliseconds: 100),
                                                            curve: Curves.easeIn);
                                                      }
                                                    },
                                                    funcNo: () => navigatorKey.currentState?.pop());
                                              },
                                              onStatisticPressed: () => onStatisticsIconPressed(item: item),
                                              onMegaPhonePressed: () {},
                                            ),
                                          ),
                                          Visibility(
                                            visible: item.status == AppConstants.expiredStr,
                                            child: actionToBoostItem(
                                              statusTextStyle: FontTypography.snackBarButtonStyle
                                                  .copyWith(color: AppColors.primaryColor,fontSize: 12),
                                              statusIconColor: AppColors.primaryColor,
                                              statusBackgroundColor: AppColors.whiteColor,
                                              activeStatusColor: AppColors.greenColor,
                                              activeStatusAssetPath: AssetPath.activeIcon,
                                              status: AppConstants.boostStr,
                                              statusAssetPath: AssetPath.boostIcon,
                                              onBoostPressed: null,
                                              onActivePress: item.category == AppConstants.promoStr ||
                                                      item.category == AppConstants.jobStr
                                                  ? () {
                                                      CategoriesListResponse category =
                                                          CategoriesListResponse(formName: item.category);
                                                      AppRouter.push(
                                                        AppRoutes.addListingFormView,
                                                        args: AddListingFormView(
                                                          itemId: item.id,
                                                          category: category,
                                                          formId: item.formId,
                                                          myListingCubit: widget.myListingCubit,
                                                          isListingEditing: true,
                                                        ),
                                                      )?.then((result) {
                                                        //refresh listing screen when any changes perform in edit listing
                                                        if (result != null) {
                                                          widget.myListingCubit.currentPage = 1;
                                                          widget.myListingCubit.fetchMyListingItems(search: '', isRefresh: true, isFromBoost: true);
                                                          return null;
                                                        }
                                                      });;
                                                    }
                                                  : null,
                                              onStatisticPressed: () => onStatisticsIconPressed(item: item),
                                              onMegaPhonePressed: () {},
                                            ),
                                          ),
                                          Visibility(
                                            visible: item.status == AppConstants.pausedStr,
                                            child: actionToBoostItem(
                                              statusTextStyle: FontTypography.snackBarButtonStyle
                                                  .copyWith(color: AppColors.primaryColor,fontSize: 12),
                                              statusIconColor: AppColors.primaryColor,
                                              statusBackgroundColor: AppColors.whiteColor,
                                              activeStatusColor: AppColors.deleteColor,
                                              activeStatusAssetPath: AssetPath.inactiveIcon,
                                              status: AppConstants.boostStr,
                                              statusAssetPath: AssetPath.boostIcon,
                                              onBoostPressed: null,
                                              onActivePress: item.category == AppConstants.jobStr ||
                                                      item.category == AppConstants.promoStr
                                                  ? () {}
                                                  : null,
                                              onStatisticPressed: () => onStatisticsIconPressed(item: item),
                                              onMegaPhonePressed: () {},
                                            ),
                                          ),
                                          Visibility(
                                            visible: (item.status == AppConstants.waitingForApprovalStr)&&(item.isAvailableHistory==false),
                                            replacement: const SizedBox.shrink(),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: InkWell(
                                                  onTap: () {
                                                    ///Add draft logic
                                                  },
                                                  child: Container(
                                                    width: 90,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.approvalWaitingColor,
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    padding: const EdgeInsets.all(4),
                                                    child: Center(
                                                      child: Text(
                                                        item.status ?? '',
                                                        style: FontTypography.locationTextStyle
                                                            .copyWith(color: AppColors.lightBlackColor),
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                          Visibility(
                                            visible: (item.status == AppConstants.waitingForApprovalStr)&&(item.isAvailableHistory==true),
                                            replacement: const SizedBox.shrink(),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: InkWell(
                                                  onTap: () {
                                                    ///Add draft logic
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 90,
                                                        decoration: BoxDecoration(
                                                          color: AppColors.approvalWaitingColor,
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        padding: const EdgeInsets.all(4),
                                                        child: Center(
                                                          child: Text(
                                                            item.status??'',
                                                            style: FontTypography.locationTextStyle
                                                                .copyWith(color: AppColors.lightBlackColor),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      boostIcons(
                                                        assetPath: AssetPath.statisticsIcon,
                                                        onPressed:(){ onStatisticsIconPressed(item: item);},
                                                      ),
                                                      const SizedBox(width: 5),
                                                      // boostIcons(
                                                      //   assetPath: AssetPath.megaphoneIcon,
                                                      //   onPressed:(){},
                                                      // ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                          Visibility(
                                            visible: item.status == AppConstants.disapprovedStr,
                                            replacement: const SizedBox.shrink(),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: InkWell(
                                                onTap: () {
                                                  ///Add draft logic
                                                },
                                                child: boostDraftContainer(
                                                  backgroundColor: AppColors.whiteColor,
                                                  title: AppConstants.disapprovedStr,
                                                  containerSize:110,
                                                  assetPath: AssetPath.draftIcon,
                                                  iconColor: AppColors.deleteColor,
                                                  textStyle: FontTypography.snackBarButtonStyle
                                                      .copyWith(color: AppColors.deleteColor),
                                                  assetSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(width: 5),
        InkWell(
          onTap: onBoostPressed,
          child: boostDraftContainer(
            title: status,
            assetPath: statusAssetPath,
            backgroundColor: statusBackgroundColor,
            textStyle: statusTextStyle,
            iconColor: statusIconColor,
            assetSize: 7, containerSize: 64,
          ),
        ),
        const SizedBox(width: 16),
        boostIcons(backgroundColor: activeStatusColor, assetPath: activeStatusAssetPath, onPressed: onActivePress),
        const SizedBox(width: 16),
        boostIcons(
          assetPath: AssetPath.statisticsIcon,
          onPressed: onStatisticPressed,
        ),
        const SizedBox(width: 5),
        // const SizedBox(width: 5),
        // boostIcons(
        //   assetPath: AssetPath.megaphoneIcon,
        //   onPressed: onMegaPhonePressed,
        // ),
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
    Border? border,
    required double containerSize,
    required String title,
  }) {
    return Container(
      width: containerSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
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

  Widget locationRowWidget({required String location, required String time, String? status}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Changed this
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
        Visibility(
          visible: status != AppConstants.waitingForApprovalStr &&  status != AppConstants.disapprovedStr,
          child: Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end, // Add this to the inner Row
              children: [
                ReusableWidgets.createSvg(path: AssetPath.timeIcon, size: 10),
                sizedBox5Width(),
                Text(
                  time,
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

  void _onSearchClick() {
    widget.myListingCubit.currentPage = 1;
    widget.myListingCubit.fetchMyListingItems(
      search: widget.myListingCubit.searchTxtController.text.trim(),
      isRefresh: true,
    );
  }

  void onDeletedPress({required MyListingItems item, required MyListingLoadedState state}) async {
    if (item.status != AppConstants.activeStr && item.isAvailableHistory ==true) {
      // If status is "waiting for approval", ask user what they want to delete
      await ReusableWidgets.showConfirmationDialog2(
        AppConstants.pleasConfirm,
        AppConstants.areYouSureDeleteWaitingStr,
            () async {
          // Delete Listing
          widget.myListingCubit.onDeletingWaitingForApproval(itemId: item.id, isHistory: false);
        },
        positiveBtnTitle:AppConstants.deleteListing,
        // negativeBtnTitle: AppConstants.deleteAwaitingApproval,
        negativeBtnTitle: '${AppConstants.deleteStr} ${item.status}',
      ).then((result) async {
        if (result == false) {
          // Delete Awaiting Approval
          widget.myListingCubit.onDeletingWaitingForApproval(itemId: item.id, isHistory: true,);
        }
      });
    } else {
      int itemCount = await widget.myListingCubit.fetchItemUsageCount(
        itemId: item.id,
        formId: item.formId,
      );
      if (itemCount != 0) {
        ReusableWidgets.showConfirmationDialog(
          AppConstants.pleasConfirm,
          AppConstants.categoryInUse,
              () async {
            navigatorKey.currentState?.pop();
            widget.myListingCubit.onDeletingWaitingForApproval(itemId: item.id, isHistory: true,);
            await widget.scrollController.animateTo(0.0, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
          },
        );
      } else {
        // Default delete flow
        ReusableWidgets.showConfirmationDialog(
          AppConstants.pleasConfirm,
          item.category != AppConstants.businessStr
              ? AppConstants.areYouSureDeleteStr.replaceFirst('{categoryName}', item.category?.toLowerCase() ?? '')
              : AppConstants.areYouSureDeleteBusinessProfStr,
              () async {
            navigatorKey.currentState?.pop();
            widget.myListingCubit.onDeletingWaitingForApproval(itemId: item.id, isHistory: false,);
            await widget.scrollController.animateTo(0.0, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
          },
        );
      }
    }
  }



  void onStatisticsIconPressed({required MyListingItems item}) {
    AppRouter.push(AppRoutes.listingStatisticsInsightRoute, args: {
      ModelKeys.listingId: item.id,
      ModelKeys.categoryId: item.categoryId,
      ModelKeys.isActiveListing: item.status == AppConstants.activeStr
    })?.then((onValue) {
      if (onValue == true) {
        widget.myListingCubit.fetchMyListingItems(
          search: widget.myListingCubit.searchTxtController.text.trim(),
          isRefresh: true,
          isFromBoost: true,
        );
      }
    });
  }
}
