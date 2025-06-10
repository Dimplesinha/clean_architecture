import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/presentation/modules/search/repo/search_repo.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  bool hasNextPage = true;
  int currentPage = 1;
  double? latitude = 0.0;
  double? longitude = 0.0;

  SearchCubit() : super(SearchInitial());

  void init() async {
    emit(const SearchLoadedState());
  }

  void initialSearch({required String location}) {
    searchListing(keyword: '', location: location, recentSearch: false);
  }

  void locationUpdated(String? location) {
    var oldState = state as SearchLoadedState;
    try {
      emit(oldState.copyWith(address: location));
    } catch (e) {
      emit(oldState.copyWith());
    }
  }

  /// Search Keyword Api
  Future<void> searchListing({
    required String keyword,
    required String location,
    bool isRefresh = false,
    bool isPaginated = false,
    bool? recentSearch,
  }) async {
    try {
      if (isPaginated && currentPage == 1) {
        currentPage++;
      }
      var oldState = state as SearchLoadedState;
      emit(oldState.copyWith(loader: true));
      location = location;
      double? currentLatitude;
      double? currentLongitude;
      String latLong = AppUtils.loginUserModel?.location??'';

      if (latitude != 0.0 && longitude != 0.0) {
        currentLatitude = latitude;
        currentLongitude = longitude;
      } else if (location.isNotEmpty) {
        try {
          var placemarks = await locationFromAddress(location);
          if (placemarks.isNotEmpty) {
            currentLatitude = placemarks.first.latitude;
            currentLongitude = placemarks.first.longitude;
          }
        } catch (geocodeError) {
          emit(oldState.copyWith(loader: false));
          return;
        }
      }
      else if (latLong.isNotEmpty ) {
        try {
          var placemarks = await locationFromAddress(latLong);
          if (placemarks.isNotEmpty) {
            currentLatitude = placemarks.first.latitude;
            currentLongitude = placemarks.first.longitude;
          }
        } catch (geocodeError) {
          emit(oldState.copyWith(loader: false));
          return;
        }
      }

      Map<String, dynamic> requestBody = {
        ModelKeys.pageIndex: currentPage,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.latitude:currentLatitude,
        ModelKeys.longitude: currentLongitude ,
        ModelKeys.keyword: oldState.advanceSearchFormData?[AppConstants.keywordHintStr] ?? keyword,
        ModelKeys.location: location,
        ModelKeys.advanceSearch: oldState.advanceSearchFormData?[AppConstants.advanceSearchMap] != null &&
                oldState.advanceSearchFormData?[AppConstants.advanceSearchMap] != '{}'
            ? oldState.advanceSearchFormData![AppConstants.advanceSearchMap] //No need to encode JSON
            : null,
        ModelKeys.sortOrder: oldState.advanceSearchFormData?[AppConstants.priceStr] == null
            ? null
            : oldState.advanceSearchFormData?[AppConstants.priceStr] == 1
                ? 'ASC'
                : 'DESC',
        ModelKeys.sortBy:
            oldState.advanceSearchFormData?[AppConstants.priceStr] != null ? AddListingFormConstants.priceFrom : null,
        ModelKeys.categoryId: oldState.advanceSearchFormData?[AppConstants.selectCategoryIdStr] == 0
            ? null
            : oldState.advanceSearchFormData?[AppConstants.selectCategoryIdStr],
        ModelKeys.visibilityType: oldState.advanceSearchFormData?[AppConstants.sortBySmallStr] ?? 2,
        ModelKeys.saveSearch: false,
        ModelKeys.recentSearch: recentSearch ?? currentPage == 1 ? true : false,
      };
      var response = await SearchListingRepo.instance.searchListing(requestBody);

      if (response.responseData?.statusCode == 200 && response.responseData != null) {
        List<MyListingItems> myListingItem = getMyListingItems(result: response.responseData?.result ?? []);
        List<MyListingItems> nonBillboardOldItems =
            (oldState.items ?? []).where((e) => e.isBillBoard == false).toList();
        List<MyListingItems> nonBillboardNewItems = myListingItem.where((e) => e.isBillBoard == false).toList();
        int totalCount = nonBillboardOldItems.length + nonBillboardNewItems.length;
        if (response.responseData?.result?[0].count != totalCount && response.responseData?.result?[0].count != 0) {
          hasNextPage = true;
          currentPage++;
        } else {
          hasNextPage = false;
        }

        if (isRefresh == true) {
          oldState.items?.clear();
        }
        List<MyListingItems> updatedMyListingItems = isRefresh ? myListingItem : [...?oldState.items, ...myListingItem];

        emit(oldState.copyWith(
          searchResult: response.responseData,
          items: updatedMyListingItems,
          loader: false,
        ));
      } else {
        emit(oldState.copyWith(loader: false, items: []));
      }
    } catch (e) {
      var oldState = state as SearchLoadedState;
      emit(oldState.copyWith(loader: false, items: []));
    }
  }

  void updateListing({required List<MyListingModel>? myListingModel, Map<String, dynamic>? formData}) {
    var oldState = state as SearchLoadedState;
    List<MyListingItems> myListingItem = getMyListingItems(result: myListingModel ?? []);
    emit(oldState.copyWith(items: myListingItem, advanceSearchFormData: formData));
  }

  List<MyListingItems> getMyListingItems({required List<MyListingModel> result}) {
    return result.expand((model) => model.items ?? []).toList().cast<MyListingItems>();
  }

  void onFieldsValueChanged({String? key, dynamic value, Map<String, dynamic>? keysValuesMap}) {
    var oldState = state as SearchLoadedState;
    try {
      Map<String, dynamic>? oldFormData = oldState.advanceSearchFormData;
      oldFormData ??= {};
      if (keysValuesMap?.isEmpty ?? true) {
        /// Update the map of form Data for one value

        if ((value is String? && (value?.isEmpty ?? true)) || value == null) {
          /// if keysValuesMap is empty then changed are made to single field only which is the only case a filed can be cleared
          /// So removing the key for formData map if the value is empty
          oldFormData.remove(key);
        } else {
          /// If value is not empty then updating the value.
          oldFormData.update(key!, (_) => value, ifAbsent: () => value);
        }
      } else {
        /// Update the map of form Data for multiple value
        keysValuesMap?.forEach((key, value) {
          if ((value is String? && (value?.isEmpty ?? true)) || value == null) {
            /// if keysValuesMap is empty then changed are made to single field only which is the only case a filed can be cleared
            /// So removing the key for formData map if the value is empty
            oldFormData?.remove(key);
          } else {
            /// If value is not empty then updating the value.
            oldFormData?.update(key, (_) => value, ifAbsent: () => value);
          }
        });
      }
      emit(oldState.copyWith(advanceSearchFormData: oldFormData));
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      emit(oldState.copyWith());
    }
  }

  void updateKeyValueMap(String key, dynamic value) {
    onFieldsValueChanged(
      keysValuesMap: {key: value},
    );
  }
}
