import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/models/advance_search_response_model.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/view/advance_search_screen_view.dart';
import 'package:workapp/src/presentation/modules/app_carousel/app_carousel_exports.dart';
import 'package:workapp/src/presentation/modules/app_carousel/view/app_carousel.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/view/google_location_view.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/modules/profile_listings/widgets/listing_grid.dart';
import 'package:workapp/src/presentation/modules/search/cubit/search_cubit.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 04/12/24
/// @Message : [SearchScreen]
///
/// The `SearchScreen`  class provides a user interface for performing advanced searches,
///
/// Responsibilities:
/// - Display a tabbed interface with three sections: Horizontal List Items, Search Bar, and Vertical List Items.
///

class SearchScreen extends StatefulWidget {
  final List<CategoriesListResponse> categoriesList;

  const SearchScreen({super.key, required this.categoriesList});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  SearchCubit searchCubit = SearchCubit();
  final scrollController = ScrollController();
  final TextEditingController searchTxtController = TextEditingController();
  final TextEditingController locationTxtController = TextEditingController();
  bool isLocationInitialized = false;
  double? latitude;
  double? longitude;

  void initialApiCall() async {
    await _initializeLocation();
    searchCubit.initialSearch(location: locationTxtController.text);
  }

  @override
  void initState() {
    searchCubit.init();
    initialApiCall();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent && searchCubit.hasNextPage) {
          searchCubit.searchListing(
              keyword: searchTxtController.text, location: locationTxtController.text, isPaginated: true);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder<SearchCubit, SearchState>(
        bloc: searchCubit,
        builder: (context, state) {
          if (state is SearchLoadedState) {
            return Scaffold(
              appBar: MyAppBar(
                title: AppConstants.searchStr,
                backBtn: true,
                shadowColor: AppColors.borderColor.withOpacity(0.5),
                actionList: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: InkWell(
                      onTap: () {
                        AppRouter.push(
                          AppRoutes.advanceSearchScreenRoute,
                          args: AdvanceSearchScreen(
                            categoriesList: widget.categoriesList,
                            locationController: locationTxtController,
                            keywordController: searchTxtController,
                            oldFormData: state.advanceSearchFormData,
                          ),
                        )?.then((data) {
                          if (data != null && data is AdvanceSearchResponseResultModel) {
                            AdvanceSearchResponseResultModel advanceSearchResponse = data;
                            int givenCount = data.result?.first.count ?? 0;
                            int? totalItemCount = data.result?.first.items?.length??0;
                            int countBillboardItems = (data.result?.first.items ?? []).where((e) => e.isBillBoard == true).toList().length;
                            int actualCountWithBillboard =  countBillboardItems + givenCount;
                            searchCubit.updateListing(
                              myListingModel: advanceSearchResponse.result,
                              formData: advanceSearchResponse.oldFormData,
                            );
                            //given count + billboard count = total count
                            if(totalItemCount != givenCount && givenCount !=0 && actualCountWithBillboard != totalItemCount) {
                              searchCubit.hasNextPage = true;
                            }
                            else{
                              searchCubit.hasNextPage = false;
                            }
                           searchTxtController.text =
                                advanceSearchResponse.oldFormData?[AppConstants.keywordHintStr] ?? '';
                            locationTxtController.text =
                                advanceSearchResponse.oldFormData?[AddListingFormConstants.location] ?? '';
                          }
                        });
                      },

                      child: Center(
                        child: ReusableWidgets.createSvg(
                          path: AssetPath.filterIcon,
                          size: 20,
                          color: AppColors.primaryColor
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () async {
                  searchCubit.currentPage = 1;
                 state.advanceSearchFormData?.clear();
                  await searchCubit.searchListing(
                    keyword: searchTxtController.text,
                    location: locationTxtController.text,
                    isRefresh: true,
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: CustomScrollView(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child:
                                Container(padding: const EdgeInsets.only(bottom: 20), child: const AppCarouselView()),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _SearchBarDelegate(
                              searchCubit: searchCubit,
                              searchLoadedState: state,
                              categoriesList: widget.categoriesList,
                              locationTxtController: locationTxtController,
                              searchTxtController: searchTxtController,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: state.items == null || state.items!.isEmpty
                                ? Center(child: Text(AppConstants.noItemsStr, style: FontTypography.defaultTextStyle))
                                : Column(
                                    children: [
                                      Visibility(
                                        visible: state.items?.length == 1 &&
                                            state.items?[0].listingName == AppConstants.specialRecord,
                                        child: Center(
                                          child: Text(
                                            AppConstants.noItemsStr,
                                            style: FontTypography.defaultTextStyle,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ListingsGrid(
                                        myListingItems: state.items ?? [],
                                        hasDummyItem: true,
                                        needScrolling: false,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        onItemClick: () => AppRouter.push(AppRoutes.itemDetailsViewRoute),
                                        isFromMyListing: false,
                                      ),

                                    ],
                                  ),
                          )
                        ],
                      ),
                    ),
                    state.loader ? const LoaderView() : const SizedBox.shrink()
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

  Future<void> _initializeLocation() async {
    try {
      final String? profileLocation = AppUtils.loginUserModel?.location;
      final latLong = await AppUtils.getLatLong();

      if (latLong[ModelKeys.latitude] != 0.0 && latLong[ModelKeys.longitude] != 0.0) {
        latitude = latLong[ModelKeys.latitude];
        longitude = latLong[ModelKeys.longitude];

        final placemarks = await placemarkFromCoordinates(latitude!, longitude!);
        final placemark = placemarks.first;

        final currentLocation = '${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
        locationTxtController.text = currentLocation;
        // Notify the cubit of the location change
        searchCubit.locationUpdated(currentLocation);
      } else if (profileLocation?.trim().isNotEmpty ?? false) {
        locationTxtController.text = profileLocation ?? '';
        searchCubit.locationUpdated(profileLocation);
      } else {
        locationTxtController.text = 'United States';
        searchCubit.locationUpdated('United States');
      }
      searchCubit.onFieldsValueChanged(key: AddListingFormConstants.location, value: locationTxtController.text);
      setState(() => isLocationInitialized = true);
    } catch (e) {
      locationTxtController.text = '';
      if (kDebugMode) {
        print('Error in _initializeLocation: $e');
      }
    }
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final SearchCubit searchCubit;
  final SearchLoadedState searchLoadedState;
  final List<CategoriesListResponse> categoriesList;
  final TextEditingController searchTxtController;
  final TextEditingController locationTxtController;

  _SearchBarDelegate({
    required this.searchCubit,
    required this.searchLoadedState,
    required this.categoriesList,
    required this.searchTxtController,
    required this.locationTxtController,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: maxExtent,
      child: _SearchBarContent(
        searchCubit: searchCubit,
        searchLoadedState: searchLoadedState,
        categoriesList: categoriesList,
        locationTxtController: locationTxtController,
        searchTxtController: searchTxtController,
        maxExtent: maxExtent,
      ),
    );
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class _SearchBarContent extends StatefulWidget {
  final SearchCubit searchCubit;
  final SearchLoadedState searchLoadedState;
  final List<CategoriesListResponse> categoriesList;
  final double maxExtent;
  final TextEditingController searchTxtController;
  final TextEditingController locationTxtController;

  const _SearchBarContent({
    Key? key,
    required this.searchCubit,
    required this.searchLoadedState,
    required this.categoriesList,
    required this.maxExtent,
    required this.locationTxtController,
    required this.searchTxtController,
  }) : super(key: key);

  @override
  State<_SearchBarContent> createState() => _SearchBarContentState();
}

class _SearchBarContentState extends State<_SearchBarContent> {
  final StreamController<bool> _streamControllerClearBtn = StreamController<bool>.broadcast();

  int count = 0;

  bool isLocationInitialized = false;
  double? latitude;
  double? longitude;
  String? lastSearchedKeyword;
  String? lastSearchedLocation;

  @override
  void dispose() {
    _streamControllerClearBtn.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (count < 2) {
      count++;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        color: AppColors.whiteColor,
        child: Column(
          children: [
           Expanded(child: _categoryFilters(context)),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _searchWidget()),
                  sizedBox10Width(),
                  Expanded(child: _locationWidget()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationWidget() {
    return GoogleLocationView(
      hintText: AppConstants.locationStr,
      locationController: widget.locationTxtController,
      onLocationChanged: (Map<String, String?>? json) {
        isLocationInitialized = true;

        if (json != null) {
          widget.locationTxtController.clear();

          final city = json[ModelKeys.city];
          final state = json[ModelKeys.administrativeAreaLevel_1];
          final country = json[ModelKeys.country];
          final locationComponents =
              [city, state, country].where((component) => component != null && component.isNotEmpty).toList();
          final updatedLocation = locationComponents.join(', ');
          widget.searchCubit.latitude = double.parse(json[ModelKeys.latitudeGoogleApi] ?? '0.0');
          widget.searchCubit.longitude = double.parse(json[ModelKeys.longitudeGoogleApi] ?? '0.0');
          lastSearchedLocation = null; // Reset to allow a new search
          widget.locationTxtController.text = updatedLocation;
          widget.searchCubit.locationUpdated(updatedLocation);
          widget.searchCubit.currentPage = 1;
          widget.searchCubit.searchListing(
            keyword: widget.searchTxtController.text.trim(),
            location: widget.locationTxtController.text,
            isRefresh: true,
          );
          return;
        }

        //  This part runs when location is cleared
        widget.locationTxtController.clear();
        widget.searchCubit.latitude = 0.0;
        widget.searchCubit.longitude = 0.0;
        widget.searchCubit.locationUpdated('');
        lastSearchedLocation = null;
        widget.searchCubit.currentPage = 1;
        widget.searchCubit.searchListing(
          keyword: widget.searchTxtController.text.trim(),
          location: '',
          isRefresh: true,
        );
      },
    );
  }


  Widget _searchWidget() {
    return ReusableWidgets.searchWidget(
      maxLines: 1,
      hintTxt: AppConstants.keywordHintStr,
      onSubmit: (value) {
        if (widget.searchTxtController.text.trim().isNotEmpty) {
          _onSearchClick();
        } else {
          AppUtils.showSnackBar(AppConstants.searchHintStr, SnackBarType.alert);
        }
      },
      onChanged: (value) {
        widget.searchCubit.onFieldsValueChanged(key: AppConstants.keywordHintStr, value: value);
        _streamControllerClearBtn.add(value.isNotEmpty);
        lastSearchedKeyword = null; // Reset to allow a new search
        widget.searchCubit.currentPage = 1;
      },
      stream: _streamControllerClearBtn.stream,
      onCancelClick: () {
        _streamControllerClearBtn.add(false);
        widget.searchTxtController.clear();
        // Reset keyword in state while clear searchbox
        widget.searchLoadedState.advanceSearchFormData?[AppConstants.keywordHintStr] = '';
        _onSearchClick();
      },
      onSearchIconClick: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
        _onSearchClick();
      },
      txtController: widget.searchTxtController,
    );
  }

  void _onSearchClick() {

    // Perform the search
    widget.searchCubit.currentPage = 1;
    widget.searchCubit.searchListing(
      keyword: widget.searchTxtController.text.trim(),
      location: widget.locationTxtController.text,
      isRefresh: true,
    );
  }


  Widget _categoryFilters(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip(context, 'All',AssetPath.allCategoryIcon),
          ...widget.categoriesList.map((e) => _filterChip(context, e.formName ?? '',e.iconUrl??'')),
        ],
      ),
    );
  }

  Widget _filterChip(BuildContext context, String label, String iconUrl) {
    final selectedCategoryId =
    widget.searchLoadedState.advanceSearchFormData?[AppConstants.selectCategoryIdStr];

    final isAllCategory = label.toLowerCase() == 'all';
    final isSelected = isAllCategory
        ? selectedCategoryId == null || selectedCategoryId.toString().isEmpty
        : widget.categoriesList.any(
          (element) =>
      element.formName == label &&
          element.formId.toString() == selectedCategoryId?.toString(),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          if (isAllCategory) {
            widget.searchLoadedState.advanceSearchFormData
                ?.remove(AppConstants.selectCategoryIdStr);
          } else {
            final matchedCategory = widget.categoriesList.firstWhere(
                  (element) => element.formName == label,
              orElse: () => CategoriesListResponse(),
            );
            if (matchedCategory.formId != null) {
              widget.searchCubit.updateKeyValueMap(AppConstants.selectCategoryIdStr, matchedCategory.formId);
              widget.searchCubit.updateKeyValueMap(AppConstants.selectCategoryStr, matchedCategory.formName);
            }
          }

          widget.searchCubit.currentPage = 1;
          widget.searchCubit.searchListing(
            keyword: widget.searchTxtController.text.trim(),
            location: widget.locationTxtController.text,
            isRefresh: true,
          );
        },
        child: Container(
          width: 75,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : AppColors.listingCardsBgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.listingCardsBgColor),
          ),
          child: Column(
            children: [
              ReusableWidgets.createNetworkSvg(
                path: iconUrl,
                size: 18,
                color:isSelected ? Colors.white : AppColors.darkBlackColor,
              ),
              sizedBox3Height(),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FontTypography.categoryCardTextStyle.copyWith(
                  color: isSelected ? Colors.white : AppColors.darkBlackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
