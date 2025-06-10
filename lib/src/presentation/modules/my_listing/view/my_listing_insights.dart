import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/models/insight_model.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/my_listing/view/insight_view_filter.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 09/09/24
/// @Message : [MyListingInsights]
///
/// The `MyListingInsights`  class provides a user interface for performing my listing consist of tab bar view and all item view
///with tab bar of listing insights, bookmark,
class MyListingInsights extends StatelessWidget {
  final MyListingCubit myListingCubit;
  final MyListingLoadedState myListingLoadedState;

  MyListingInsights({super.key, required this.myListingCubit, required this.myListingLoadedState});

  final StreamController<bool> _streamControllerClearBtn = StreamController<bool>.broadcast();

  Stream<bool> get _streamClearBtn => _streamControllerClearBtn.stream;

  Future<void> _onSearchClick() async {
    await myListingCubit.insightPaginatedData(isFiltered: true, isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: ReusableWidgets.searchWidget(
                    hintTxt: AppConstants.findMyInsights,
                    onSubmit: (value) {
                      _onSearchClick();
                    },
                    onChanged: (value) => _streamControllerClearBtn.add(value.isNotEmpty),
                    stream: _streamClearBtn,
                    onCancelClick: () {
                      _streamControllerClearBtn.add(false);
                      myListingCubit.insightSearchTxtController.clear();
                      _onSearchClick();
                    },
                    onSearchIconClick: () {
                      _onSearchClick();
                    },
                    txtController: myListingCubit.insightSearchTxtController,
                  ),
                ),
                sizedBox15Width(),
                InkWell(
                  onTap: () async {
                    var categoryData = await PreferenceHelper.instance.getCategoryList();
                    myListingCubit.categoriesList = categoryData.result;
                    AppUtils.showBottomSheetWithData(
                      context,
                      child: InsightViewFilter(
                        myListingCubit: myListingCubit,
                        myListingLoadedState: myListingLoadedState,
                      ),
                      onCancelWithData: (action) {},
                    );
                  },
                  child: ReusableWidgets.createSvg(
                    path: AssetPath.insightFilterIcon,
                    color: AppColors.blackColor,
                  ),
                ),
                sizedBox5Width(),
              ],
            ),
          ),
          myListingLoadedState.insightItems == null || myListingLoadedState.insightItems?.isEmpty == true
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Center(
                    child: Text(AppConstants.noItemsStr, style: FontTypography.defaultTextStyle),
                  ))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: myListingLoadedState.insightItems?.isNotEmpty ?? false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(
                          AppConstants.totalStr,
                          style: FontTypography.profileTitleHeading.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.whiteColor),
                      child: Visibility(
                        visible: myListingLoadedState.insightItems?.isNotEmpty ?? false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildInfoItem(AssetPath.callIcon,
                                        myListingLoadedState.insightCountResult?.totalListingCalls ?? '0',
                                        title: AppConstants.callsStr),
                                    buildDivider(),
                                    buildInfoItem(AssetPath.mailIcon,
                                        myListingLoadedState.insightCountResult?.totalListingEmails ?? '0',
                                        title: AppConstants.emailStr),
                                    buildDivider(),
                                    buildInfoItem(AssetPath.messageInsightIcon,
                                        myListingLoadedState.insightCountResult?.totalListingMessages ?? '0',
                                        title: AppConstants.messageStr),
                                    buildDivider(),
                                    buildInfoItem(AssetPath.linkIcon,
                                        myListingLoadedState.insightCountResult?.totalListingWebsites ?? '0',
                                        title: AppConstants.websiteStr),
                                    buildDivider(),
                                    InkWell(
                                      child: buildInfoItem(
                                        AssetPath.eyeIcon,
                                        myListingLoadedState.insightCountResult?.totalListingViews ?? '0',
                                        title: AppConstants.viewsStr,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      itemCount: myListingLoadedState.insightItems?.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 20),
                      itemBuilder: (context, index) {
                        final InsightItems? insightResult = myListingLoadedState.insightItems?[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.locationButtonBackgroundColor),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  insightResult?.listingName ?? '',
                                  style: FontTypography.defaultTextStyle,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(12.0, 12.5, 12.0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildInfoItem(AssetPath.callIcon, insightResult?.callsCount ?? ''),
                                      buildDivider(height: 52),
                                      buildInfoItem(AssetPath.mailIcon, insightResult?.emailsCount ?? ''),
                                      buildDivider(height: 52),
                                      buildInfoItem(AssetPath.messageInsightIcon, insightResult?.messagesCount ?? ''),
                                      buildDivider(height: 52),
                                      buildInfoItem(AssetPath.linkIcon, insightResult?.websitesCount ?? ''),
                                      buildDivider(height: 52),
                                      InkWell(
                                        onTap: () => AppRouter.push(AppRoutes.listingStatisticsInsightRoute, args: {
                                          ModelKeys.listingId: insightResult?.listingId,
                                          ModelKeys.categoryId: insightResult?.categoryId,
                                          ModelKeys.isActiveListing: insightResult?.status == AppConstants.activeStr
                                        })?.then((onValue) {
                                          if (onValue == true) {
                                            myListingCubit.fetchMyListingItems(
                                              search: myListingCubit.insightSearchTxtController.text.trim(),
                                              isRefresh: true,
                                              isFromBoost: true,
                                            );
                                          }
                                        }),
                                        child: buildInfoItem(AssetPath.eyeIcon, insightResult?.viewsCount ?? ''),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )
        ],
      ),
    );
  }

  Widget buildInfoItem(String path, String value, {String? title}) {
    return Column(
      children: [
        ReusableWidgets.createSvg(path: path, size: 18),
        const SizedBox(height: 10),
        Text(value, style: FontTypography.insightTextBoldStyle),
        const SizedBox(height: 3),
        Text(title ?? '', style: FontTypography.tabBarStyle.copyWith(color: AppColors.subTextColor)),
      ],
    );
  }

  Widget buildDivider({double? height}) {
    return SizedBox(
      height: height ?? 71,
      child: VerticalDivider(
        thickness: 0.5,
        color: AppColors.borderColor,
      ),
    );
  }
}
