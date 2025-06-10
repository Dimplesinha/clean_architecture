import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:workapp/src/core/constants/date_time_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/insight_count_model.dart';
import 'package:workapp/src/master_data/master_data_api.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/view/add_listing_form_view.dart';
import 'package:workapp/src/presentation/modules/my_listing/repo/my_listing_repo.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/utils/app_utils.dart';

part 'my_listing_state.dart';

class MyListingCubit extends Cubit<MyListingState> {
  final MyListingRepo myListingRepo;
  bool hasNextPage = true;
  bool hasInsightNextPage = true;
  bool hasRatingNextPage = true;
  bool hasBookmarkNextPage = true;
  int currentPage = 1;
  int ratingInsightPage = 1;
  int ratingCurrentPage = 1;
  int bookmarkCurrentPage = 1;
  int? selectedCategoryId = 0;
  String? sortBy;
  String? sortFrom;
  String? sortTo;

  //Used to effect in like count when api response success.
  bool isClickedOnLike = false;
  bool loggedIn = false;

  //Used in filter my listings bottom sheet.
  CommonDropdownModel? commonDropdownModel;

  //Used in filter insights bottom sheet.
  CommonDropdownModel? insightsCommonDropdownModel;

  List<CategoriesListResponse>? dropDownList;

  final searchTxtController = TextEditingController();
  final insightSearchTxtController = TextEditingController();
  List<CategoriesListResponse>? categoriesList;

  MyListingCubit({required this.myListingRepo}) : super(MyListingInitial());

  void init(bool isFromItemDetail) async {
    emit(MyListingLoadedState());
    loggedIn = await PreferenceHelper.instance.getPreference(
      key: PreferenceHelper.isLogin,
      type: bool,
    );
    if (loggedIn && !isFromItemDetail) {
      await fetchMyListingItems(search: '');
      await fetchBookMarkItems(search: '');
      await fetchRatings(search: '');
      await insightPaginatedData();
    }
  }

  /// fetch list of all
  Future<void> fetchMyListingItems({
    String search = '',
    bool isRefresh = false,
    bool isFromBoost = false,
  }) async {
    try {
      var oldState = state as MyListingLoadedState;
      if (isRefresh == false || isFromBoost == true) {
        emit(oldState.copyWith(loader: true));
      }

      /// Setting current page as 1 if refresh is called
      currentPage = isRefresh ? 1 : currentPage;
      Map<String, dynamic> requestBody = {
        ModelKeys.pageIndex: currentPage,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.search: search,
        ModelKeys.categoryId: commonDropdownModel?.id == 0 ? null : commonDropdownModel?.id,
      };
      var response = await myListingRepo.fetchMyListingData(requestBody: requestBody);

      if (response?.responseData?.statusCode == 200 && response?.responseData != null) {
        List<MyListingItems> myListingItem =
            (response?.responseData?.result?.expand((model) => model.items ?? []).toList() ?? [])
                .cast<MyListingItems>();

        if (myListingItem.length == AppConstants.pageSize) {
          hasNextPage = true;
          currentPage++;
        } else {
          hasNextPage = false;
        }

        if (isRefresh == true) {
          oldState.myListingItem?.clear();
        }
        List<MyListingItems> updatedMyListingItems = isRefresh
            ? myListingItem // start fresh with new items
            : [...?oldState.myListingItem, ...myListingItem];

        emit(oldState.copyWith(
          myListing: response?.responseData?.result,
          myListingItem: updatedMyListingItems,
          loader: false,
        ));
      } else {
        emit(oldState.copyWith(loader: false, myListingItem: []));
      }
    } catch (e) {
      var oldState = state as MyListingLoadedState;
      emit(oldState.copyWith(loader: false, myListingItem: []));
    }
  }

  Future<String?> openDatePicker(BuildContext context, {String? initialDate,String? selectedStartDate,bool isEndDate = false,}) async {
    // Calculate midnight in local time zone and convert to UTC
    final DateTime now = DateTime.now();
    final DateTime midnightLocal = DateTime(now.year, now.month, now.day); // 12:00 AM local
    final DateTime midnightUtc = midnightLocal.toUtc(); // Midnight local in UTC

    DateTime? initialStartDate;
    if (initialDate != null) {
      initialStartDate = DateTime.parse(initialDate).toUtc();
    }
    DateTime? selectedStartDateTime;
    if (selectedStartDate != null) {
      selectedStartDateTime = DateTime.parse(selectedStartDate).toUtc();
    }
    String? formattedDate;
    final DateTime nowUtc = DateTime.now().toUtc();
    print('MyListingCubit.openDatePicker${selectedStartDateTime}');

    final DateTime firstDate = isEndDate && selectedStartDateTime != null
        ? selectedStartDateTime
        : DateTime.utc(2024, 01, 01);
    final DateTime lastDate = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialStartDate ?? nowUtc,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.whiteColor,
              onSurface: AppColors.blackColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      DateTime utcDate;
      if (isEndDate) {
        // End date: midnight UTC time minus 1 second
        utcDate = DateTime.utc(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          midnightUtc.hour,
          midnightUtc.minute,
          midnightUtc.second - 1, // 18:29:59Z for IST
        );
      } else {
        // Start date: midnight UTC time
        utcDate = DateTime.utc(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          0, 0, 0, // midnight UTC
        );
      }
      formattedDate = DateFormat(DateTimeConstants.dateTimeFormatWithAmPm).format(utcDate.toUtc());

    }
    return formattedDate;
  }

  bool isDateValid({required String? startDate, required String? endDate}) {
    if (startDate == null || endDate == null) {
      return false;
    }
    final DateTime start = DateTime.parse(startDate).toUtc();
    final DateTime end = DateTime.parse(endDate).toUtc();
    return !start.isAfter(end);
  }

  /// To fetch Insight Data
  Future<void> insightPaginatedData({bool isRefresh = false, bool isFiltered = false}) async {
    var oldState = state as MyListingLoadedState;
    try {
      emit(oldState.copyWith(loader: true));

      /// Setting current page as 1 if refresh is called
      int? sortById = AppUtils.getIdByValue(map: AppConstants.sortByFilterOptions, value: sortBy);
      ratingInsightPage = isRefresh ? 1 : ratingInsightPage;
      Map<String, dynamic> requestBody = {
        ModelKeys.fromDate: sortFrom,
        ModelKeys.toDate: sortTo,
        ModelKeys.search: insightSearchTxtController.text,
        ModelKeys.categoryId: insightsCommonDropdownModel?.id == 0 ? null : insightsCommonDropdownModel?.id,
        ModelKeys.pageIndex: ratingInsightPage,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.sortBy: (sortById == null || sortById == 0) ? null : sortById == 1 ? 0 : ((sortById ?? 1) - 1),
        ModelKeys.sortOrder:  (sortById == null || sortById == 0) ? '' :sortById != 1 ? AppConstants.ascending : AppConstants.descending,
      };
      var response = await myListingRepo.fetchInsightPaginated(requestBody: requestBody);

      if (response.status == true && response.responseData != null) {
        List<InsightItems> insightResult = response.responseData?.result?[0].items ?? [];

        List<InsightItems>? updatedInsightItems = isRefresh || isFiltered
            ? insightResult // start fresh with new items
            : [...?oldState.insightItems, ...insightResult];

        if ((response.responseData?.result?[0].count ?? 0) > updatedInsightItems.length) {
          hasInsightNextPage = true;
          ratingInsightPage++;
        } else {
          hasInsightNextPage = false;
        }

        if (isRefresh == true) {
          oldState.insightItems?.clear();
        }
        await insightCountData(insightItems: updatedInsightItems);
      } else {
        await insightCountData();
      }
    } catch (e) {
      emit(oldState.copyWith(loader: false));
    }
  }

  /// To fetch Insight Total Count
  Future<void> insightCountData({
    bool isRefresh = false,
    List<InsightItems>? insightItems,
  }) async {
    var oldState = state as MyListingLoadedState;
    try {
      /// Setting current page as 1 if refresh is called
      int? sortById = AppUtils.getIdByValue(map: AppConstants.sortByFilterOptions, value: sortBy);
      ratingInsightPage = isRefresh ? 1 : ratingInsightPage;
      Map<String, dynamic> requestBody = {
        ModelKeys.fromDate: sortFrom,
        ModelKeys.toDate: sortTo,
        ModelKeys.pageIndex: ratingInsightPage,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.sortBy: (sortById == null || sortById == 0) ? null : sortById == 1 ? 0 : ((sortById ?? 1) - 1),
        ModelKeys.sortOrder:  (sortById == null || sortById == 0) ? '' :sortById != 1 ? AppConstants.ascending : AppConstants.descending,
        ModelKeys.search: insightSearchTxtController.text,
        ModelKeys.categoryId: insightsCommonDropdownModel?.id == 0 ? null : insightsCommonDropdownModel?.id,
      };

      var response = await myListingRepo.fetchInsightCount(requestBody: requestBody);

      if (response.status == true && response.responseData != null) {
        InsightCountResult? insightCountResult = response.responseData?.result;

        emit(oldState.copyWith(
          loader: false,
          insightCountResult: insightCountResult,
          insightItems: insightItems,
        ));
      } else {
        emit(oldState.copyWith(loader: false));
      }
    } catch (e) {
      emit(oldState.copyWith(loader: false));
    }
  }

  ///select tab
  void selectTab(int index) {
    var oldState = state as MyListingLoadedState;
    emit(oldState.copyWith(selectedIndex: index));
  }

  /// toggle Boost button used for calling boost api call
  Future<void> toggleBoost({required int? itemId, required int? categoryId}) async {
    try {
      var oldState = state as MyListingLoadedState;
      emit(oldState.copyWith(loader: true));
      Map<String, dynamic> requestBody = {ModelKeys.categoryId: categoryId};
      var response = await myListingRepo.boostMyItem(requestBody: requestBody, itemId: itemId);

      if (response?.status == true && response?.responseData != null) {
        currentPage = 1;
        await fetchMyListingItems(search: '', isRefresh: true, isFromBoost: true);
        AppUtils.showSnackBar(response?.message ?? '', SnackBarType.success);
      } else {
        emit(oldState.copyWith(loader: false));
        AppUtils.showSnackBar(AppConstants.somethingWentWrong, SnackBarType.alert);
      }
    } catch (e) {
      if (kDebugMode) {
        print('MyListingCubit.toggleBoost------->>> ${e.toString()}');
      }
    }
  }

  ///used for pausing boost activity for inactive item n activate item
  void onPausedClick({required int? itemId, required int? categoryId, required int? status}) async {
    try {
      Map<String, dynamic> requestBody = {
        ModelKeys.categoryId: categoryId,
        ModelKeys.status: status,
      };
      var response = await myListingRepo.statusChangeOfMyItem(requestBody: requestBody, itemId: itemId);
      if (response?.status == true) {
        var isRequiredField = response?.responseData?.result?.isRequiredFieldFilled;
        if(isRequiredField == false){
          AppRouter.push(
            AppRoutes.addListingFormView,
            args:  AddListingFormView(
              isListingEditing: true, category: null,
              itemId: itemId,
              formId: categoryId,
            ),
          )?.then((result) {
            //refresh listing screen when any changes perform in edit listing
            if (result != null) {
             currentPage = 1;
             fetchMyListingItems(search: '', isRefresh: true, isFromBoost: true);
              return null;
            }
          });
        }
        AppUtils.showSnackBar(response?.message ?? '',(isRequiredField ?? false)? SnackBarType.success : SnackBarType.alert);
        currentPage = 1;
        await fetchMyListingItems(search: '', isRefresh: true, isFromBoost: true);
      } else {
        AppUtils.showSnackBar(response?.message ?? '', SnackBarType.alert);
      }
    } catch (e) {
      if (kDebugMode) {
        print('MyListingCubit.onPausedClick -------->> ${e.toString()}');
      }
    }
  }

  void onDeletingWaitingForApproval({required int? itemId, bool isFromItemEdit = false, required bool isHistory,}) async {
    try {
      var response = await myListingRepo.deleteMyWaitingItem(itemId: itemId, isHistory: isHistory);
      if (response?.status == true) {
        if (isFromItemEdit == true) {
          navigatorKey.currentState?.pop();
          AppRouter.pop(res: true);
        }
        currentPage = 1;
        await fetchMyListingItems(search: '', isRefresh: true, isFromBoost: true);
        AppUtils.showSnackBar(response?.message ?? '', SnackBarType.success);
      } else {
        AppUtils.showSnackBar(AppConstants.somethingWentWrong, SnackBarType.alert);
      }
    } catch (e) {
      if (kDebugMode) {
        print('MyListingCubit.onDeletingWaitingForApproval -------->> ${e.toString()}');
      }
    }
  }

  Future<int> fetchItemUsageCount({
    required int? itemId,
    required int? formId,
  }) async {
    var oldState = state as MyListingLoadedState;
    try {
      emit(oldState.copyWith(loader: true));

      Map<String, dynamic> requestBody = {
        ModelKeys.categoryId: formId,
        ModelKeys.listingId: itemId,
      };

      var response = await myListingRepo.usageCountMyItem(requestBody: requestBody);
      if (response?.status == true) {
        CategoryUseCountResponse? countResponse = response?.responseData;
        int itemCount = countResponse?.result?.totalCount ?? 0;
        emit(oldState.copyWith(loader: false, itemCount: itemCount));
        return itemCount;
      } else {
        emit(oldState.copyWith(loader: false));
        AppUtils.showSnackBar(AppConstants.somethingWentWrong, SnackBarType.alert);
        return 0;
      }
    } catch (e) {
      emit(oldState.copyWith(loader: false));
      if (kDebugMode) {
        print('MyListingCubit.onPausedClick -------->> ${e.toString()}');
      }
      return 0;
    }
  }

  Future<void> fetchRatings({
    String search = '',
    bool isRefresh = false,
    bool isFromRating = false,
  }) async {
    try {
      var oldState = state as MyListingLoadedState;
      if (isRefresh == false || isFromRating == true) {
        emit(oldState.copyWith(loader: true, ratingsSearchText: search));
      }
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      int? userId = user.result?.id;

      /// Setting current page as 1 if refresh is called
      ratingCurrentPage = isRefresh ? 1 : ratingCurrentPage;

      ///used for filtering item if its my review or its my item review
      bool ratingReceived = oldState.selectedRatingType == 1 ? true : false;

      Map<String, dynamic> requestBody = {
        ModelKeys.pageIndex: ratingCurrentPage,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.search: search,
        ModelKeys.userId: userId,
        ModelKeys.ratingReceived: ratingReceived,
      };

      var response = await myListingRepo.fetchRating(requestBody: requestBody, userToken: token);

      if (response.status == true && response.responseData != null) {
        var result = response.responseData?.result as List<RatingResult>;
        List<RatingItems> myRatingItems = (result.expand((model) => model.items ?? []).toList()).cast<RatingItems>();
        if (myRatingItems.length == AppConstants.pageSize) {
          hasRatingNextPage = true;
          ratingCurrentPage++;
        } else {
          hasRatingNextPage = false;
        }

        if (isRefresh == true) {
          oldState.myRatingItem?.clear();
        }

        List<RatingItems> updatedMyRatingItems = isRefresh
            ? myRatingItems // start fresh with new items
            : [...?oldState.myRatingItem, ...myRatingItems];

        emit(oldState.copyWith(
          loader: false,
          myRatingData: response.responseData?.result ?? [],
          myRatingItem: updatedMyRatingItems,
          userId: userId,
          ratingsSearchText: search,
        ));
      } else {
        emit(oldState.copyWith(
          loader: false,
          myRatingData: [],
          userId: userId,
          ratingsSearchText: search,
        ));
      }
    } catch (e) {
      var oldState = state as MyListingLoadedState;
      emit(oldState.copyWith(
        loader: false,
        myRatingData: [],
        ratingsSearchText: search,
      ));
    }
  }

  /// for fetching book mark item list
  Future<void> fetchBookMarkItems({
    String search = '',
    bool isRefresh = false,
    bool isFromUnBookmark = false,
  }) async {
    try {
      var oldState = state as MyListingLoadedState;
      if (isRefresh == false || isFromUnBookmark == true) {
        emit(oldState.copyWith(loader: true, bookmarkSearchText: search));
      }

      /// Setting current page as 1 if refresh is called
      bookmarkCurrentPage = isRefresh ? 1 : bookmarkCurrentPage;
      Map<String, dynamic> requestBody = {
        ModelKeys.pageIndex: bookmarkCurrentPage,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.search: search,
      };
      var response = await MyListingRepo.instance.fetchMyBookmarkData(requestBody: requestBody);

      if (response?.responseData?.statusCode == 200 && response?.responseData != null) {
        List<MyListingItems> myBookmarkListingItem =
            (response?.responseData?.result?.expand((model) => model.items ?? []).toList() ?? [])
                .cast<MyListingItems>();

        if (myBookmarkListingItem.length == AppConstants.pageSize) {
          hasBookmarkNextPage = true;
          bookmarkCurrentPage++;
        } else {
          hasBookmarkNextPage = false;
        }

        if (isRefresh == true) {
          oldState.myBookmarkListing?.clear();
        }
        List<MyListingItems> updatedMyBookmarkListingItems = isRefresh
            ? myBookmarkListingItem // start fresh with new items
            : [...?oldState.myBookmarkListingItem, ...myBookmarkListingItem];

        emit(oldState.copyWith(
          myBookmarkListing: response?.responseData?.result,
          myBookmarkListingItem: updatedMyBookmarkListingItems,
          loader: false,
          bookmarkSearchText: search,
        ));
      } else {
        emit(oldState.copyWith(
          loader: false,
          myBookmarkListing: [],
          bookmarkSearchText: search,
        ));
        // await insightData();
      }
    } catch (e) {
      var oldState = state as MyListingLoadedState;
      emit(oldState.copyWith(
        loader: false,
        myBookmarkListing: [],
        bookmarkSearchText: search,
      ));
    }
  }

  ///on bookmark press for adding it in bookmark list n removing it
  void onBookmarkPressed({required int? itemId, required String? categoryName, required bool isBookMarked}) async {
    var oldState = state as MyListingLoadedState;
    emit(oldState.copyWith(loader: true));
    try {
      var category = await PreferenceHelper.instance.getCategoryList();
      int categoryId;
      // Find the category ID matching the category name
      if (categoryName == AddListingFormConstants.job) {
        categoryId = category.result
                ?.firstWhere((item) => item.formName == AddListingFormConstants.job,
                    orElse: () => CategoriesListResponse(formId: 0, formName: ''))
                .formId ??
            0;
      } else if (categoryName == AddListingFormConstants.realEstate ||
          categoryName == AddListingFormConstants.realEstateWithoutSpaceStr) {
        categoryId = category.result
                ?.firstWhere((item) => item.formName == AddListingFormConstants.realEstate,
                    orElse: () => CategoriesListResponse(formId: 0, formName: ''))
                .formId ??
            0;
      } else {
        categoryId = category.result
                ?.firstWhere((item) => item.formName == categoryName,
                    orElse: () => CategoriesListResponse(formId: 0, formName: ''))
                .formId ??
            0;
      }
      Map<String, dynamic> requestBody = {
        ModelKeys.listingId: itemId,
        ModelKeys.categoryId: categoryId,
      };
      var response = await myListingRepo.bookmarkUnBookmarkItem(requestBody: requestBody);

      if (response?.status == true && response?.responseData != null) {
        bookmarkCurrentPage = 1;
        await fetchBookMarkItems(search: '', isRefresh: true, isFromUnBookmark: true);

        var updatedList = oldState.myBookmarkListingItem;
        updatedList?.removeWhere((item) => item.id == itemId);

        // Prepare updated state
        var newState = oldState.copyWith(
          loader: false,
          isBookMarked: !isBookMarked,
          isBookMarkClicked: true,
          myBookmarkListingItem: [],
        );
        emit(newState);
        if (!isBookMarked) {
          bookmarkCurrentPage = 1;
          await fetchBookMarkItems(search: '', isRefresh: true, isFromUnBookmark: true);
        }
        AppUtils.showSnackBar(response?.message ?? '', SnackBarType.success);
      } else {
        AppUtils.showSnackBar(AppConstants.somethingWentWrong, SnackBarType.alert);
        emit(oldState.copyWith(loader: false));
      }
    } catch (e) {
      if (kDebugMode) {
        print('MyListingCubit.toggleBoost------->>> ${e.toString()}');
      }
    }
  }

  void ratingVisibility(int value) async {
    var oldState = state as MyListingLoadedState;
    try {
      emit(oldState.copyWith(selectedRatingType: value));
      ratingCurrentPage = 1;
      await fetchRatings(search: '', isRefresh: true, isFromRating: true);
    } catch (e) {
      emit(oldState.copyWith());
    }
  }

  void onLikePress(
      {required int? itemId, required String? categoryName, bool? isFromItemDetail, required bool isSelfLike}) async {
    var oldState = state as MyListingLoadedState;

    try {
      emit(oldState.copyWith(loader: true));
      var category = await PreferenceHelper.instance.getCategoryList();
      int categoryId;
      // Find the category ID matching the category name
      if (categoryName == AddListingFormConstants.job) {
        categoryId = category.result?.firstWhere((item) => item.formName == AddListingFormConstants.job).formId ?? 0;
      } else {
        categoryId = category.result?.firstWhere((item) => item.formName == categoryName).formId ?? 0;
      }
      Map<String, dynamic> requestBody = {
        ModelKeys.listingId: itemId,
        ModelKeys.categoryId: categoryId,
      };
      var response = await myListingRepo.likeUnlikeItem(requestBody: requestBody);

      if (response?.status == true && response?.responseData != null) {
        isClickedOnLike = true;
        emit(oldState.copyWith(loader: false, isSelfLike: !isSelfLike, isSelfLikeClicked: true));
        AppUtils.showSnackBar(response?.message ?? '', SnackBarType.success);
      } else {
        AppUtils.showSnackBar(AppConstants.somethingWentWrong, SnackBarType.alert);
        emit(oldState.copyWith(loader: false));
      }
    } catch (e) {
      if (kDebugMode) {
        emit(oldState.copyWith(loader: false));
        print('MyListingCubit.toggleBoost------->>> ${e.toString()}');
      }
    }
  }

  /// Used to set category which is used in filter my listings bottom sheet.
  void setCategoryList() {
    dropDownList?.clear();
    MasterDataAPI.getCategoriesList().then(
      (value) {
        dropDownList = value.responseData?.result;
      },
    );
  }

  /// Used for apply filter when clicks on apply button.
  void applyCategoryFilter(CommonDropdownModel? selectedCategory) {
    commonDropdownModel = selectedCategory;
    currentPage = 1;
    fetchMyListingItems(search: searchTxtController.text.trim(), isRefresh: true, isFromBoost: true);
  }

  /// Used for apply insight filter when clicks on apply button.
  void applyInsightFilter(CommonDropdownModel? selectedCategory) {
    insightsCommonDropdownModel = selectedCategory;
    currentPage = 1;
    insightPaginatedData(isFiltered: true);
  }

  void isRated() async {
    var oldState = state as MyListingLoadedState;
    try {
      emit(oldState.copyWith(isRated: true));
    } catch (e) {
      emit(oldState.copyWith());
    }
  }

  void manageActivityTracking({
    required int? listingId,
    required int? categoryId,
    required int? activityTypeId,
    required int? deviceTypeId,
  }) async {
    try {
      Map<String, dynamic> requestBody = {
        ModelKeys.listingId: listingId,
        ModelKeys.categoryId: categoryId,
        ModelKeys.activityTypeId: activityTypeId,
        ModelKeys.deviceTypeId: deviceTypeId,
      };
      await myListingRepo.activityTracking(requestBody: requestBody);
    } catch (e) {
      if (kDebugMode) {
        print(this);
      }
    }
  }
}
