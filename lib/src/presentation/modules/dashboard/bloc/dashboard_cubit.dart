import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/master_data/master_data_api.dart';
import 'package:workapp/src/presentation/modules/dashboard/repo/dashboard_repo.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/date_time_utils.dart';
import 'package:workapp/src/utils/my_location_type_stream.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository dashboardRepository;
  bool hasNextPage = true;
  bool isAllCategorySelected = true;
  int currentPage = 1;
  double carousalHeight = 0;

  //Used to diable-enable drawer icon.
  int totalApiCount = 0;

  DashboardCubit({required this.dashboardRepository}) : super(DashboardLoadedState());

  bool check = false;

  void init() async {
    emit(DashboardLoadedState());
    await countryAPICall();
    await fetchAllCategories();
    await fetchItems(isFromInitialCall: true, visibilityTypeName: AppConstants.myCountryStr);
    check = await PreferenceHelper.instance.getPreference(key: PreferenceHelper.isLogin, type: bool);
    if (check) {
      await fetchUserData();
    }
  }

  /// select location option
  void selectSingleOption(String? option, String? path) {
    var oldState = state as DashboardLoadedState;
    emit(oldState.copyWith(
        tempSelectedSingleOption: option ?? AppConstants.myCountryStr, tempPath: path ?? AssetPath.myCountryIcon));
  }

  /// Stores currently selected options

  final List<CategoriesListResponse> _selectedCategoryOptions = [];

  /// Handle multi-select case for categories
  void selectCategory(CategoriesListResponse option) async {
    var oldState = state as DashboardLoadedState;

    // Use current state for consistency
    List<CategoriesListResponse> updatedSelectedCategories = List.from(oldState.selectedTempListings ?? []);
    // Toggle the selected category
    if (updatedSelectedCategories.contains(option)) {
      //It will return if only last item selected.
      if (updatedSelectedCategories.length == 1) {
        return;
      }
      updatedSelectedCategories.remove(option);
    } else {
      updatedSelectedCategories.add(option);
    }
    // Emit the updated state
    emit(oldState.copyWith(selectedTempListings: updatedSelectedCategories));
  }

  /// Selects or deselects all options, including "Select All"
  Future<void> selectAllCategories() async {
    var oldState = state as DashboardLoadedState;
    // Use current state for consistency
    List<CategoriesListResponse> listings = oldState.listings ?? [];
    emit(oldState.copyWith(selectedTempListings: listings));
  }

  /// Set initial category if dialog canceled.
  Future<void> setInitialCategory() async {
    var oldState = state as DashboardLoadedState;
    // Emit the updated state
    emit(oldState.copyWith(
      selectedListings: oldState.selectedListings,
      selectedTempListings: oldState.selectedListings == oldState.selectedTempListings
          ? oldState.selectedTempListings
          : oldState.selectedListings,
    ));
  }

  /// Set initial selected option if dialog canceled.
  Future<void> setInitialSelectedOption(String? option, String? path) async {
    var oldState = state as DashboardLoadedState;
    // Emit the updated state
    emit(oldState.copyWith(
      selectedSingleOption: option ?? AppConstants.myCountryStr,
      path: path ?? AssetPath.myCountryIcon,
      tempSelectedSingleOption: option ?? AppConstants.myCountryStr,
      tempPath: path ?? AssetPath.myCountryIcon,
    ));
  }

  /// Set actual category if press on ok.
  Future<void> setActualCategory() async {
    var oldState = state as DashboardLoadedState;
    // Emit the updated state
    emit(oldState.copyWith(
      selectedListings: oldState.selectedTempListings,
      selectedTempListings: oldState.selectedTempListings,
    ));
  }

  /// Set actual selected option if dialog canceled.
  Future<void> setActualSelectedOption(String? option, String? path) async {
    var oldState = state as DashboardLoadedState;
    // Emit the updated state
    emit(oldState.copyWith(
      selectedSingleOption: option ?? AppConstants.myCountryStr,
      path: path ?? AssetPath.myCountryIcon,
      tempSelectedSingleOption: option ?? AppConstants.myCountryStr,
      tempPath: path ?? AssetPath.myCountryIcon,
    ));
  }

  /// Fetch all Categories
  Future<void> fetchAllCategories({bool isRefresh = false}) async {
    var oldState = state as DashboardLoadedState;
    try {
      if (!isRefresh) emit(oldState.copyWith(isLoading: true));
      await MasterDataAPI.getCategoriesList();
      var response = await PreferenceHelper.instance.getCategoryList();
      if (response.statusCode == 200 && response.result != null) {
        _selectedCategoryOptions
          ..clear()
          ..addAll(response.result ?? []); // Synchronize selected options
        totalApiCount = 1;
        emit(oldState.copyWith(
          listings: response.result,
          selectedListings: _selectedCategoryOptions.toList(),
          selectedTempListings: _selectedCategoryOptions.toList(),
          isLoading: false,
        ));
      } else {
        _selectedCategoryOptions.clear();
        totalApiCount = 1;
        emit(oldState.copyWith(
          listings: response.result ?? [],
          selectedListings: [],
          selectedTempListings: [],
          isLoading: false,
        ));
      }
    } catch (e) {
      _selectedCategoryOptions.clear();
      totalApiCount = 1;
      emit(oldState.copyWith(
        listings: [],
        selectedListings: [],
        selectedTempListings: [],
        isLoading: false,
      ));
    }
  }

  Future<void> fetchUserData() async {
    var oldState = state as DashboardLoadedState;
    try {
      emit(oldState.copyWith(isLoading: true));
      var response = await PreferenceHelper.instance.getUserData();
      if (response.statusCode == 200 && response.result != null) {
        AppUtils.loginUserModel ??= response.result;
        emit(oldState.copyWith(isLoading: false, loginDetails: response.result));
      } else {
        emit(oldState.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(oldState.copyWith(
        isLoading: false,
      ));
    }
  }

  Future<void> fetchItems({
    bool isFromChangedCategory = false,
    bool isRefresh = false,
    bool isFromInitialCall = false,
    String? visibilityTypeName,
  }) async {
    try {
      var oldState = state as DashboardLoadedState;
      if (isRefresh == false || isFromChangedCategory == true) {
        emit(oldState.copyWith(isLoading: true));
      }
      var latLong = await AppUtils.getLatLong();
      FirebaseRepository.instance.initAllServices();

      oldState.selectedSingleOption = visibilityTypeName ?? oldState.selectedSingleOption ?? AppConstants.myCountryStr;

      /// [locationTypeStream] Will be used to update the location at dashboard
      LocationTypeStream.instance.addLocationType(oldState.selectedSingleOption ?? AppConstants.myCountryStr);
      int visibilityType = selectVisibilityType(oldState.selectedSingleOption ?? '');
      String visibilityTypePath = iconPathForVisibility(oldState.selectedSingleOption ?? '');
      String? categoryListingIds;
      categoryListingIds = oldState.selectedTempListings
              ?.map((category) => category.formId.toString())
              .where((id) => id != null)
              .join(',') ??
          '';

      Map<String, dynamic> requestBody = {
        ModelKeys.pageIndex: currentPage,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.latitude: latLong[ModelKeys.latitude],
        ModelKeys.longitude: latLong[ModelKeys.longitude],
        ModelKeys.visibilityType: visibilityType,
        ModelKeys.categoryId: categoryListingIds,
      };
      var response = await DashboardRepository.instance.fetchListingData(requestBody: requestBody);

      if (response.responseData?.statusCode == 200 && response.responseData != null) {
        List<MyListingItems> listingItems =
            (response.responseData?.result?.expand((model) => model.items ?? []).toList() ?? []).cast<MyListingItems>();

        bool showUpIconValue = false;

        if (isRefresh == true || isFromChangedCategory == true) {
          oldState.items?.clear();
        }

        List<MyListingItems> updatedListingItems = isRefresh ? listingItems : [...?oldState.items, ...listingItems];

        // If visiblity type is 'NearMe', no need to check with total count. As backend is not providing exact count.
        // In this case, keep continue for infinity loop.
        if (visibilityType == selectVisibilityType(AppConstants.nearMeStr)) {
          hasNextPage = true;
          currentPage++;
          if (currentPage >= 3) {
            showUpIconValue = true;
          } else {
            showUpIconValue = false;
          }
        } else {
          if (response.responseData?.result?[0].count != updatedListingItems.length) {
            hasNextPage = true;
            currentPage++;
            if (currentPage >= 3) {
              showUpIconValue = true;
            } else {
              showUpIconValue = false;
            }
          } else {
            hasNextPage = false;
          }
        }
        totalApiCount = 2;
        emit(oldState.copyWith(
          listingData: response.responseData?.result,
          items: updatedListingItems,
          isLoading: false,
          showUpIcon: showUpIconValue,
          path: visibilityTypePath,
          selectedSingleOption: oldState.selectedSingleOption,
          tempSelectedSingleOption: oldState.selectedSingleOption,
          selectedListings: oldState.selectedTempListings,
          tempPath: visibilityTypePath,
          appCarousalHeight: carousalHeight
        ));

        // If records count is less then 100 in country wide, nees to call API for worldWide
        // If we call this function before emit, it will creating an issues on page number
        // Because of this, added at last.
        if ((response.responseData?.result?[0].count ?? 0) < 100 &&
            oldState.selectedSingleOption == AppConstants.myCountryStr &&
            isFromInitialCall == true) {
          oldState.selectedSingleOption = AppConstants.worldwideStr;
          currentPage = 1;
          fetchItems(isRefresh: true, isFromInitialCall: false, visibilityTypeName: AppConstants.worldwideStr);
        }
      } else {
        totalApiCount = 2;
        emit(oldState.copyWith(
          items: [],
          isLoading: false,
          showUpIcon: false,
          path: visibilityTypePath,
          selectedSingleOption: oldState.selectedSingleOption,
          tempSelectedSingleOption: oldState.selectedSingleOption,
          tempPath: visibilityTypePath,
          appCarousalHeight: carousalHeight
        ));
      }
    } catch (e) {
      var oldState = state as DashboardLoadedState;
      totalApiCount = 2;
      emit(oldState.copyWith(items: [], isLoading: false, showUpIcon: false));
    }
  }

  int selectVisibilityType(String visibilityOption) {
    switch (visibilityOption) {
      case AppConstants.worldwideStr:
        return 1;
      case AppConstants.myCountryStr:
        return 2;
      case AppConstants.nearMeStr:
        return 3;
      default:
        return 2;
    }
  }

  String iconPathForVisibility(String visibilityOption) {
    switch (visibilityOption) {
      case AppConstants.nearMeStr:
        return AssetPath.nearMeIcon;
      case AppConstants.myCountryStr:
        return AssetPath.myCountryIcon;
      case AppConstants.worldwideStr:
        return AssetPath.worldWideIcon;
      default:
        return AssetPath.myCountryIcon;
    }
  }

  Future<void> countryAPICall() async {
    try {
      var countryData = await PreferenceHelper.instance.getCountryList();
      if (countryData.result != null) {
        DateTime currentDate = DateTime.now();
        String currentFormattedDate = DateTimeUtils.instance.timeStampToDateOnly(currentDate);
        if (countryData.getCountryLoadedDate() != currentFormattedDate) {
          await MasterDataAPI.getCountries();
        } else {
          await PreferenceHelper.instance.getCountryList();
        }
      } else {
        await MasterDataAPI.getCountries();
      }
    } catch (e) {
      if (kDebugMode) {
        print('--$this---print-----   ${e.toString()}');
      }
    }
  }

  void showCustomSnackBar() {
    var oldState = state as DashboardLoadedState;
    emit(oldState.copyWith(
      showSnackBar: true,
    ));
    Future.delayed(const Duration(seconds: 3)).then((value) {
      var oldState = state as DashboardLoadedState;
      emit(oldState.copyWith(
        showSnackBar: false,
      ));
    });
  }

  void updateScrollPosition(double scrollOffset) {
    bool shouldShow = scrollOffset > 700; // Show the icon if scrolled more than 500px.
    var oldState = state as DashboardLoadedState;
    if (oldState.showUpIcon != shouldShow) {
      emit(oldState.copyWith(showUpIcon: shouldShow));
    }
  }

  /// Updates the height of the app carousel based on the presence of listing results.
  ///
  /// If [response] contains results (i.e., `response.responseData?.result` is not empty),
  /// the carousel height is calculated dynamically based on the screen width.
  /// The calculation is `((MediaQuery.of(context).size.width - 30) / 2) + 140`.
  /// This typically aims to set a height proportional to half the screen width (minus some padding)
  /// plus a fixed offset.
  ///
  /// If there are no results, the carousel height is set to `0`.
  ///
  /// Parameters:
  ///   [response]: The [ResponseWrapper] containing the [MyListingResponse]. This is checked
  ///               to see if there are any listing items.
  ///   [context]: The [BuildContext] used to access `
  Future<void> updateCarousalHeight(MyListingResponse? response, BuildContext context) async {
    final oldState = state as DashboardLoadedState;

    final hasResponseResults = response?.result?.isNotEmpty == true;
    final premiumListingData = await PreferenceHelper.instance.getPremiumListingData();
    final hasPremiumListings = premiumListingData.result?.isNotEmpty == true;
    final shouldShowCarousal = hasResponseResults || hasPremiumListings;

    carousalHeight = shouldShowCarousal ? ((MediaQuery.of(context).size.width - 30) / 2) + 140 : 0 ;

    emit(oldState.copyWith(
      appCarousalHeight: carousalHeight,
    ));
  }
}
