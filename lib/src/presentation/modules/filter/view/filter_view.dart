import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/app_bar.dart';
import 'package:workapp/src/presentation/modules/filter/cubit/filter_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 09-09-2024
/// @Message : [FilterViewScreen]

///This `FilterViewScreen` view contains 2 panel for filter where left panel is main option which contains categories, freshest, closet and rating
///the categories has options of all the categories in list with check box.
///This also contains list of ratings from 1 star to 5 star.
///This screen is called from filter screen from search screen
class FilterViewScreen extends StatefulWidget {
  const FilterViewScreen({super.key});

  @override
  State<FilterViewScreen> createState() => _FilterViewScreenState();
}

class _FilterViewScreenState extends State<FilterViewScreen> {
  ///Cubit adding for statemanagment
  FilterCubit filterCubit = FilterCubit();

  @override
  void initState() {
    filterCubit.init();
    super.initState();
  }

  ///Build method with app bar and body where app bar has clear all option and body is divided into 2 panels left and right
  ///left panel contains types of filter and right contains types of sub filter for specific.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder<FilterCubit, FilterState>(
        bloc: filterCubit,
        builder: (context, state) {
          if (state is FilterLoadedState) {
            return SafeArea(
              bottom: false,
              child: Scaffold(
                appBar: MyAppBar(
                  elevation: 0.3,
                  title: '',
                  centerTitle: false,
                  backBtn: false,
                  automaticallyImplyLeading: false,
                  isProfilePicVisible: true,
                  widget: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      AppConstants.filterStr,
                      style: FontTypography.appBarWithoutBack,
                    ),
                  ),
                  actionList: [
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          AppConstants.clearAllStr,
                          style: FontTypography.forgetPassStyle,
                        ),
                      ),
                    )
                  ],
                ),
                body: Row(
                  children: [
                    Expanded(
                      flex: 15,
                      child: _leftPanelView(state),
                    ),
                    Expanded(
                      flex: 20,
                      child: _rightPanelView(state),
                    ),
                  ],
                ),
                bottomNavigationBar: _bottomNavBar(),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  ///left panel has 4 options for now 1 has categories, freshest, closest, and ratings there sub filters are displayed on right panel
  ///also has custom container
  Widget _leftPanelView(FilterLoadedState state) {
    return Container(
      color: AppColors.locationButtonBackgroundColor,
      child: Column(
        children: [
          _leftPanelNameWidget(
            containerBGColor:
                state.isCategorySelected == true ? AppColors.whiteColor : AppColors.locationButtonBackgroundColor,
            onTap: () => filterCubit.onCategorySelect(),
            labelName: AppConstants.categoriesStr,
            textColor: state.isCategorySelected == true ? AppColors.primaryColor : AppColors.jetBlackColor,
          ),
          _leftPanelNameWidget(
            containerBGColor:
                state.isFreshestSelected == true ? AppColors.whiteColor : AppColors.locationButtonBackgroundColor,
            onTap: () => filterCubit.onFreshestSelect(),
            labelName: AppConstants.freshestStr,
            textColor: state.isFreshestSelected == true ? AppColors.primaryColor : AppColors.jetBlackColor,
          ),
          _leftPanelNameWidget(
            containerBGColor:
                state.isClosetSelected == true ? AppColors.whiteColor : AppColors.locationButtonBackgroundColor,
            onTap: () => filterCubit.onClosestSelect(),
            labelName: AppConstants.closestStr,
            textColor: state.isClosetSelected == true ? AppColors.primaryColor : AppColors.jetBlackColor,
          ),
          _leftPanelNameWidget(
            containerBGColor:
                state.isRatingSelected == true ? AppColors.whiteColor : AppColors.locationButtonBackgroundColor,
            onTap: () => filterCubit.onRatingSelect(),
            labelName: AppConstants.ratingStr,
            textColor: state.isRatingSelected == true ? AppColors.primaryColor : AppColors.jetBlackColor,
          ),
        ],
      ),
    );
  }

  ///Right panel is based on visibility where it displays sub filter based on main filter option.
  Widget _rightPanelView(FilterLoadedState state) {
    return Container(
      color: AppColors.whiteColor,
      child: Column(
        children: [
          Visibility(visible: state.isCategorySelected == true, child: _categoriesList()),
          Visibility(visible: state.isRatingSelected == true, child: _ratingList()),
        ],
      ),
    );
  }

  ///Bottom Nav bar for close and apply option for filter
  Widget _bottomNavBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        color: AppColors.whiteColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                onPressed: () => AppRouter.pop(),
                child: Text(
                  AppConstants.closeStr,
                  style: FontTypography.textFieldBlackStyle,
                ),
              ),
            ),
            VerticalDivider(color: AppColors.verticalDividerColor),
            InkWell(
              onTap: () {
                AppRouter.pop(res: true);
              },
              child: Row(
                children: [
                  Center(
                    child: Text(
                      AppConstants.applyStr,
                      style: FontTypography.textFieldBlackStyle.copyWith(color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///Left panel name widget is custom container with label name and background color change on selection
  Widget _leftPanelNameWidget({
    required Function()? onTap,
    required String labelName,
    required Color? containerBGColor,
    required Color? textColor,
  }) {
    return Flexible(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
          color: containerBGColor,
          child: Text(
            labelName,
            style: FontTypography.textFieldBlackStyle.copyWith(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  ///Category list screen where list of categories are added with view all option
  Widget _categoriesList() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Row(
              children: [
                SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: Checkbox(
                    side: BorderSide(color: AppColors.borderColor, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: BorderSide(color: AppColors.primaryColor),
                    ),
                    activeColor: AppColors.primaryColor,
                    value: filterCubit.selectAllCategories,
                    onChanged: (value) {
                      filterCubit.toggleSelectAllCategories();
                      setState(() {});
                    },
                  ),
                ),
                sizedBox5Width(),
                const Text('All Categories'),
              ],
            ),
          ),
          sizedBox5Height(),
          Expanded(
            child: ListView.builder(
              itemCount: filterCubit.categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          filterCubit.toggleCategorySelection(index);
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: Checkbox(
                                side: BorderSide(color: AppColors.borderColor, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  side: BorderSide(color: AppColors.primaryColor),
                                ),
                                activeColor: AppColors.primaryColor,
                                value: filterCubit.categories[index].isSelected,
                                onChanged: (value) {
                                  filterCubit.toggleCategorySelection(index);
                                  // Update the selected categories list in your filterCubit
                                  filterCubit.selectedCategories =
                                      filterCubit.categories.where((category) => category.isSelected).toList();
                                  setState(() {});
                                },
                              ),
                            ),
                            sizedBox5Width(),
                            Text(
                              filterCubit.categories[index].title,
                              style: FontTypography.defaultTextStyle,
                            )
                          ],
                        ),
                      ),
                      sizedBox10Height(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ///Ratings list screen where list of ratings are added with view all option
  Widget _ratingList() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Row(
              children: [
                SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: Checkbox(
                    side: BorderSide(color: AppColors.borderColor, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: BorderSide(color: AppColors.primaryColor),
                    ),
                    activeColor: AppColors.primaryColor,
                    value: filterCubit.selectAllRating,
                    onChanged: (value) {
                      filterCubit.toggleSelectAllRating();
                      setState(() {});
                    },
                  ),
                ),
                sizedBox5Width(),
                const Text('All Ratings'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filterCubit.ratings.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          filterCubit.toggleRatingSelection(index);
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                side: BorderSide(color: AppColors.borderColor, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  side: BorderSide(color: AppColors.primaryColor),
                                ),
                                activeColor: AppColors.primaryColor,
                                value: filterCubit.ratings[index].isSelected,
                                onChanged: (value) {
                                  filterCubit.toggleRatingSelection(index);
                                  // Optionally, trigger a rebuild of the widget to ensure UI updates:
                                  setState(() {});
                                },
                              ),
                            ),
                            sizedBox5Width(),
                            Text(
                              filterCubit.ratings[index].value,
                              style: FontTypography.defaultTextStyle,
                            )
                          ],
                        ),
                      ),
                      sizedBox10Height(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
