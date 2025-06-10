import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/core/constants/assets_constants.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/models/advance_search_model.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/cubit/advance_search_cubit.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/view/meta_data_bottom_sheet.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/style/style.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/date_time_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 06/09/24
/// @Message : [SavedSearchScreenTab]
///
/// The `SavedSearchScreenTab`  class provides a user interface for performing viewing saved searches in app
///
/// Responsibilities:
/// - Display a tabbed interface one of the three sections:  Saved Search,
/// -Display saved Search Item

class SavedSearchScreenTab extends StatefulWidget {
  final AdvanceSearchLoadedState state;
  final AdvanceSearchCubit advanceSearchCubit;
  CommonDropdownModel? selectedItem;
  int pageIndex = 1;

  SavedSearchScreenTab({super.key, required this.state, required this.advanceSearchCubit});

  @override
  State<SavedSearchScreenTab> createState() => _SavedSearchScreenTabState();
}

class _SavedSearchScreenTabState extends State<SavedSearchScreenTab> {
  var scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
            widget.advanceSearchCubit.hasNextPage) {
          var categoryId = widget.advanceSearchCubit.commonDropdownModel?.id == 0
              ? null
              : widget.advanceSearchCubit.commonDropdownModel?.id;
          widget.advanceSearchCubit.getAdvanceSearchData(
            isSaved: true,
            categoryId: categoryId,
            sortOrder: 'desc',
            sortBy: 4,
          );
        }
      }
    });
    widget.advanceSearchCubit.initSavedSearch(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.state.searchItems == null || widget.state.searchItems!.isEmpty ? false : true,
      replacement: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Visibility(
          visible: widget.advanceSearchCubit.currentPage == 1 &&
                  (widget.state.searchItems == null || widget.state.searchItems!.isEmpty) &&
                  widget.state.isLoading
              ? false
              : true,
          child: Center(
            child: Text(
              AppConstants.noItemsStr,
              style: FontTypography.defaultTextStyle,
            ),
          ),
        ),
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: ListView.builder(
            itemCount: widget.state.searchItems?.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              if (widget.state.searchItems != null) {
                var item = widget.state.searchItems?[index];
                return _dismissibleCard(index, item!, widget.state);
              }
              return null;
            }),
      ),
    );
  }

  Widget _dismissibleCard(
    int index,
    AdvanceSearchItem item,
    AdvanceSearchLoadedState state,
  ) {
    DateTime date = DateTimeUtils.instance.stringToDateInLocal(string: item.dateCreated!);
    var formattedCreatedDate = DateTimeUtils.instance.dateOnlyWithSlash(date);

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Dismissible(
        key: ValueKey(item),
        background: Container(
          height: 94,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 22.0),
          decoration: BoxDecoration(
            color: AppColors.deleteColor,
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ReusableWidgets.createSvg(path: AssetPath.deleteIcon, size: 24),
        ),
        direction: !state.isEnableDeleteUI! ? DismissDirection.endToStart : DismissDirection.none,
        onDismissed: (direction) {
          if (widget.advanceSearchCubit.isSaved) {
            widget.advanceSearchCubit.savedSearchListing?.removeAt(index); // Assuming `items` is your list of data
          } else {
            widget.advanceSearchCubit.recentSearchListing?.removeAt(index); // Assuming `items` is your list of data
          }
          widget.advanceSearchCubit
              .onDeleteClick(searchId: item.searchId, index: index, isSingleDelete: true, isSavedSearch: true);
        },
        child: InkWell(
          onTap: () {
            widget.advanceSearchCubit.searchFromOldListing(advanceSearchItem: item, isItemClicked: true);
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Container(
                      padding: EdgeInsets.zero,
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.listingCardsBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ReusableWidgets.createNetworkSvg(
                        size: 25,
                        path: item.iconUrl ?? '',
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: state.isEnableDeleteUI!
                              ? Container(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0), // Increase tappable area
                                  child: Checkbox(
                                    checkColor: AppColors.whiteColor,
                                    side: BorderSide(
                                      color: item.isChecked == true ? AppColors.primaryColor : AppColors.jetBlackColor,
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                      side: BorderSide(
                                          color:
                                              item.isChecked == true ? AppColors.primaryColor : AppColors.borderColor),
                                    ),
                                    activeColor: AppColors.primaryColor,
                                    value: item.isChecked,
                                    onChanged: (value) {
                                      item.isChecked = value!;
                                      widget.advanceSearchCubit.onCheckUnCheckItem(item, true, index);
                                    },
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: item.keyword?.isNotEmpty ?? false,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 7.0),
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                      text: AppConstants.keywordHintStr,
                                      style: FontTypography.defaultTextStyle,
                                      children: [
                                        TextSpan(
                                          text: ' ${item.keyword}',
                                          style: FontTypography.appBtnStyle.copyWith(color: AppColors.jetBlackColor),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                  text: AppConstants.categoryStr,
                                  style: FontTypography.defaultTextStyle,
                                  children: [
                                    TextSpan(
                                      text: item.categoryName != null
                                          ? ': ${item.categoryName}'
                                          : ' ${AppConstants.allStr}',
                                      style: FontTypography.appBtnStyle.copyWith(color: AppColors.jetBlackColor),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                  text: AppConstants.sortBySmallStr,
                                  style: FontTypography.defaultTextStyle,
                                  children: [
                                    TextSpan(
                                      text: ' ${item.getItemSortBy}',
                                      style: FontTypography.appBtnStyle.copyWith(color: AppColors.jetBlackColor),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                  text: AppConstants.date,
                                  style: FontTypography.defaultTextStyle,
                                  children: [
                                    TextSpan(
                                      text: ': $formattedCreatedDate',
                                      style: FontTypography.appBtnStyle.copyWith(color: AppColors.jetBlackColor),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  ReusableWidgets.createSvg(path: AssetPath.locationPinIcon),
                                  sizedBox10Width(),
                                  Expanded(
                                    child: Text(
                                      item.location == null || item.location!.isEmpty
                                          ? AppConstants.n_a
                                          : '${item.location}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: FontTypography.defaultTextStyle,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      AppUtils.showBottomSheet(
                                        context,
                                        child: MetadataBottomSheet(
                                          advanceSearchCubit: widget.advanceSearchCubit,
                                          advanceSearchItem: item,
                                          isSaved: widget.advanceSearchCubit.isSaved,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(5, 5, 8, 0), // Increase tappable area
                                      child: ReusableWidgets.createSvg(
                                        size: 35,
                                        path: AssetPath.infoIcon,
                                        boxFit: BoxFit.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
