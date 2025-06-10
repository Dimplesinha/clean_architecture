import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/data/storage/storage.dart';
import 'package:workapp/src/domain/models/business_profile_detail_resp.dart';
import 'package:workapp/src/domain/models/chat/report_type_list.dart';
import 'package:workapp/src/domain/models/dynamic_listing_detail_model.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/master_data/master_data_api.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/item_details/repo/item_details_repo.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';

part 'item_details_state.dart';

class ItemDetailsCubit extends Cubit<ItemDetailsState> {
  ItemDetailsRepo itemDetailsRepo;
  int currentPage = 1;
  bool hasNextPage = true;

  //For do some operation in like so declared.
  int? totalLikeCount = 0;

  ItemDetailsCubit({required this.itemDetailsRepo}) : super(ItemDetailsInitial());

  void currentImageIndex(int index) {
    var oldState = state as ItemDetailsLoadedState;
    try {
      emit(oldState.copyWith(currentIndex: index));
    } catch (e) {
      if (kDebugMode) {
        print(this);
      }
      emit(oldState.copyWith(isLoading: false));
    }
  }

  void shopItem({required int listingId, required String categoryName, String? search, bool isRefresh = false}) async {
    var oldState = state as ItemDetailsLoadedState;
    try {
      if (isRefresh == false) {
        emit(oldState.copyWith(isLoading: true));
      }

      int categoryId;
      var category = await PreferenceHelper.instance.getCategoryList();
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
        ModelKeys.listingId: listingId,
        ModelKeys.categoryId: categoryId,
        ModelKeys.pageIndex: currentPage,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.search: search
      };
      var response = await itemDetailsRepo.fetchRelatedListing(requestBody: requestBody);
      if (response?.responseData?.statusCode == 200 && response?.responseData != null) {
        List<MyListingItems> listingItem =
            (response?.responseData?.result?.expand((model) => model.items ?? []).toList() ?? [])
                .cast<MyListingItems>();

        if (listingItem.length == AppConstants.pageSize) {
          hasNextPage = true;
          currentPage++;
        } else {
          hasNextPage = false;
        }

        if (isRefresh == true) {
          oldState.listings?.clear();
        }
        List<MyListingItems> updatedAllItemListing =
            isRefresh ? listingItem : [...?oldState.listingItems, ...listingItem];

        emit(oldState.copyWith(
          listings: response?.responseData?.result,
          listingItems: updatedAllItemListing,
          isLoading: false,
        ));
      } else {
        emit(oldState.copyWith(
          isLoading: false,
          listings: [],
        ));
      }
    } catch (ex) {
      if (kDebugMode) {
        print(this);
      }
    }
  }

  void onLikeClick() async {
    var oldState = state as ItemDetailsLoadedState;
    try {
      emit(oldState.copyWith(isLiked: !oldState.isLiked));
    } catch (e) {
      emit(ItemDetailsLoadedState());
    }
  }

  void onBookMarkClick() async {
    var oldState = state as ItemDetailsLoadedState;
    try {
      emit(oldState.copyWith(isBookMark: !oldState.isBookMark));
    } catch (e) {
      emit(ItemDetailsLoadedState());
    }
  }

  void onFavClick() async {
    var oldState = state as ItemDetailsLoadedState;
    try {
      emit(oldState.copyWith(isFavClick: !oldState.isFavClick));
    } catch (e) {
      emit(ItemDetailsLoadedState());
    }
  }


  /// Get Item Details
  Future<void> getDynamicItemDetails({
    required int? itemId,
    required String? apiPath,
    required int? formId,
  }) async {
    emit(ItemDetailsLoadedState());
    var oldState = state as ItemDetailsLoadedState;
    try {
      emit(oldState.copyWith(isLoading: true));
      var categoryName = apiPath;

      var response = await itemDetailsRepo.getDynamicListingItemDetails(itemId: itemId, apiPath: apiPath);
      if (response.status == true && response.responseData != null) {
        totalLikeCount = response.responseData?.result.totalLikeCount;
        shopItemInit(
          listingId: itemId!,
          formId: formId ?? 0,
          categoryName: categoryName!,
          oldState: oldState,
          itemDetailResponse: response.responseData,
        );
      } else {
        emit(oldState.copyWith(isLoading: false, getDetails: response.responseData));
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        AppRouter.pop();
      }
    } catch (e) {
      emit(oldState.copyWith(isLoading: false));
      if (kDebugMode) {
        print(this);
      }
    }
  }

  Future<List<ReportTypeModelList>> getSpamList() async {
    var oldState = state as ItemDetailsLoadedState;
    try {
      emit(oldState.copyWith(isLoading: true));

      var response = await MasterDataAPI.instance.getSpamList();
      if (response.status) {
        final spamList = response.responseData?.result ?? [];

        emit(oldState.copyWith(isLoading: false, spamList: spamList));
        return spamList;
      } else {
        emit(oldState.copyWith(isLoading: false, spamList: []));
        AppUtils.showFormErrorSnackBar(msg: response.message);
        return [];
      }
    } catch (e) {
      emit(oldState.copyWith(isLoading: false));
      AppUtils.showFormErrorSnackBar(msg: AppConstants.somethingWentWrong);
      return [];
    }
  }


  /// Spam UnSpam Item
  Future<void> spamItemReport(
      {required int? recordId, required int? categoryId, required int? reportType, required String? comment}) async {
    try {
      Map<String, dynamic> requestBody = {
        ModelKeys.recordId: recordId,
        ModelKeys.recordType: categoryId,
        ModelKeys.reportType: reportType,
        ModelKeys.comment: comment,
      };
      var response = await itemDetailsRepo.spamItemReport(requestBody: requestBody);
      if (response.status == true && response.responseData != null) {
        AppRouter.pop();
        AppRouter.pop();
        AppUtils.showSnackBar(response.message, SnackBarType.success);
      } else {
        AppRouter.pop();
        AppRouter.pop();
        AppUtils.showErrorSnackBar(response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(this);
      }
    }
  }

  Future<void> spamUserReport(
      { required String? userId, required int? reportType, required String? comment}) async {
    try {
      Map<String, dynamic> requestBody = {
        ModelKeys.userId: userId,
        ModelKeys.reportTypeId: reportType,
        ModelKeys.comment: comment,
      };
      var response = await itemDetailsRepo.spamUserReport(requestBody: requestBody);
      if (response.status == true && response.responseData != null) {
        AppRouter.pop();
        AppRouter.pop();
        AppUtils.showSnackBar(response.message, SnackBarType.success);
      } else {
        AppRouter.pop();
        AppRouter.pop();
        AppUtils.showErrorSnackBar(response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(this);
      }
    }
  }

  void shopItemInit({
    required int listingId,
    required int formId,
    required String categoryName,
    required ItemDetailsLoadedState oldState,
    required DynamicListingDetailModel? itemDetailResponse,
  }) async {
    try {

      Map<String, dynamic> requestBody = {
        ModelKeys.listingId: listingId,
        ModelKeys.categoryId: formId,
        ModelKeys.pageIndex: 1,
        ModelKeys.pageSize: 10,
        ModelKeys.search: null
      };
      var response = await itemDetailsRepo.fetchRelatedListing(requestBody: requestBody);
      if (response?.responseData?.statusCode == 200 && response?.responseData != null) {
        List<MyListingItems> listingItem =
            (response?.responseData?.result?.expand((model) => model.items ?? []).toList() ?? [])
                .cast<MyListingItems>();
        print('--$this---print-----listingItem.length   ${response?.responseData?.result?.length}');
        List<MyListingItems> updatedAllItemListing = listingItem;
        emit(oldState.copyWith(
          getDetails: itemDetailResponse,
          imageItems: null,
          updatedListingItems: response?.responseData!.result?[0].count != 0 ? updatedAllItemListing : [],
          isLoading: false,
        ));
      } else {
        emit(oldState.copyWith(
          isLoading: false,
          listings: [],
        ));
      }
    } catch (ex) {
      if (kDebugMode) {
        print(this);
      }
    }
  }

  void onTabSelected(int index) {
    try {
      var oldState = state as ItemDetailsLoadedState;
      emit(oldState.copyWith(selectedTabIndex: index, listings: [], listingItems: []));
    } catch (e) {
      if (kDebugMode) {
        print(this);
      }
    }
  }

  Future<String> encodeLink(
      { required int? listingID}) async {
   try{
      var response = await itemDetailsRepo.encodeLink(listingID ?? 0);
      if (response.status == true && response.responseData != null) {
        return response.responseData?.result ?? '';
      } else {
        return '';
      }
    } catch (e) {
     return '';
    }
  }

  Future<String> decodeLink(
      { required String? listingID}) async {
    try{
      var response = await itemDetailsRepo.decodeLink(listingID ?? '');
      if (response.status == true && response.responseData != null) {
        return response.responseData?.result ?? '';
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}
