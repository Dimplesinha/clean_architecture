import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/advance_search_item_model.dart';
import 'package:workapp/src/domain/models/add_listing_form_model.dart';
import 'package:workapp/src/domain/models/advance_search_model.dart';
import 'package:workapp/src/domain/models/advance_search_response_model.dart';
import 'package:workapp/src/domain/models/auto_type_model.dart';
import 'package:workapp/src/domain/models/category_type_model.dart';
import 'package:workapp/src/domain/models/community_listing_type_model.dart';
import 'package:workapp/src/domain/models/industry_type_model.dart';
import 'package:workapp/src/domain/models/master_data_model.dart';
import 'package:workapp/src/domain/models/property_type_model.dart';
import 'package:workapp/src/domain/models/worker_skills_model.dart';
import 'package:workapp/src/master_data/master_data_api.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart' show ReusableWidgets;
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/repo/advance_search_repo.dart';
import 'package:workapp/src/presentation/modules/search/repo/search_repo.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/utils/app_utils.dart';

part 'advance_search_state.dart';

class AdvanceSearchCubit extends Cubit<AdvanceSearchState> {
  bool saveSearch = false;
  CommonDropdownModel? commonDropdownModel;
  List<CategoriesListResponse>? categoriesList;
  bool areTabsEnabled = true;
  double? latitude = 0.0;
  double? longitude = 0.0;

  bool hasNextPage = true;
  int currentPage = 1;
  int? formID;

  List<AdvanceSearchItem>? savedSearchListing;

  List<AdvanceSearchItem>? recentSearchListing;

  //Used to identify current tab.
  bool isSaved = false;

  // It is used to manage delete all and delete button visibility.
  bool isAdvanceSearchTab = true;

  //Used to check user is login or not.
  bool? isUserLogin = false;

  AdvanceSearchCubit() : super(AdvanceSearchInitial());

  void init() async {
    emit(AdvanceSearchLoadedState());
    isUserLoggedIn().then(
      (value) {
        isUserLogin = value;
      },
    );
  }

  //Added for identify user is logged in or not.
  Future<bool> isUserLoggedIn() async {
    return await PreferenceHelper.instance.getPreference(key: PreferenceHelper.isLogin, type: bool);
  }

  void initSavedSearch(bool isSaved) async {
    this.isSaved = isSaved;
    currentPage = 1;
    if (isSaved) {
      savedSearchListing?.clear();
    } else {
      recentSearchListing?.clear();
    }

    await getAdvanceSearchData(
      isSaved: isSaved,
      categoryId: commonDropdownModel?.id == 0 ? null : commonDropdownModel?.id,
      sortOrder: 'desc',
      sortBy: 4,
    );
  }

  void selectTab(int index) {
    var oldState = state as AdvanceSearchLoadedState;
    emit(oldState.copyWith(selectedIndex: index));
  }

  void onSkillRemoved(WorkerSkillsResult skill) {
    var oldState = state as AdvanceSearchLoadedState;
    try {
      List<WorkerSkillsResult> oldSkills = oldState.selectedSkills ?? [];
      oldSkills.remove(skill);
      emit(oldState.copyWith(selectedSkills: oldSkills));
    } catch (e) {
      //
    }
  }

  void onSkillSelected({
    required WorkerSkillsResult skill,
    required bool? isSelected,
    required String fieldLabel,
  }) {
    var oldState = state as AdvanceSearchLoadedState;

    try {
      // 1. Initialize oldSkills from selectedSkills or from formDataMap fallback
      List<WorkerSkillsResult> oldSkills = List.from(oldState.selectedSkills ?? []);

      if (oldSkills.isEmpty && (oldState.formDataMap?[fieldLabel]?.toString().isNotEmpty ?? false)) {
        final savedSkillIds = oldState.formDataMap?[fieldLabel].toString().split(',') ?? [];

        // Rebuild from masterData
        final masterSkillList = oldState.masterData
            ?.map((item) => WorkerSkillsResult(
                  skillId: item.skillId,
                  skillName: item.skillName,
                ))
            .toList();

        oldSkills =
            masterSkillList?.where((skillItem) => savedSkillIds.contains(skillItem.skillId.toString())).toList() ?? [];
      }

      // 2. Modify selection
      if (isSelected ?? false) {
        if (!oldSkills.any((item) => item.skillId == skill.skillId)) {
          oldSkills.add(skill);
        }
      } else {
        oldSkills.removeWhere((item) => item.skillId == skill.skillId);
      }

      // 3. Convert to comma-separated string
      final selectedSkillsString = oldSkills.map((e) => e.skillId).join(',');

      // 4. Update formDataMap
      final updatedFormData = Map<String, dynamic>.from(oldState.formDataMap ?? {});
      updatedFormData[fieldLabel] = selectedSkillsString;

      // 5. Emit new state
      emit(oldState.copyWith(
        selectedSkills: oldSkills,
        formDataMap: updatedFormData,
      ));
    } catch (e) {
      if (kDebugMode) print('onSkillSelected() error: $e');
    }
  }

  void onFilterSkills(String filterText) {
    var oldState = state as AdvanceSearchLoadedState;

    try {
      List<WorkerSkillsResult> oldSkills = oldState.skills?.result ?? [];
      if (filterText.isNotEmpty) {
        oldState.filteredSkills = oldSkills
            .where((skill) => skill.skillName?.toLowerCase().startsWith(filterText.toLowerCase()) ?? false)
            .toList();
        emit(oldState.copyWith(filteredSkills: oldState.filteredSkills));
      } else {
        emit(oldState.copyWith(filteredSkills: oldSkills));
      }
    } catch (e) {
      // log('e:$e');
    }
  }

  void onAllSkillSelected({required List<WorkerSkillsResult>? skills, required bool? isSelected}) {
    var oldState = state as AdvanceSearchLoadedState;

    try {
      List<WorkerSkillsResult> oldSkills = [];
      if (isSelected ?? false) {
        if (oldState.selectedSkills?.length != oldState.skills?.result?.length) {
          if (skills != null) {
            oldSkills.addAll(skills);
          }
        }
        emit(oldState.copyWith(selectedSkills: oldSkills));
      } else {
        emit(oldState.copyWith(selectedSkills: []));
      }
    } catch (e) {
      //
    }
  }

  //Used to manage button visibility.
  void manageButtonVisibility(int index) {
    if (index == 1 || index == 2) {
      isAdvanceSearchTab = false;
    } else {
      isAdvanceSearchTab = true;
    }
    var oldState = state as AdvanceSearchLoadedState;
    emit(oldState.copyWith(selectedIndex: index));
  }

  //Used fun isClickedOnDeleteIcon().
  void enableDeleteItemUI() {
    if (isSaved) {
      var oldState = state as AdvanceSearchLoadedState;
      emit(oldState.copyWith(isEnableDeleteUI: true));
    } else {
      var oldState = state as AdvanceSearchLoadedState;
      emit(oldState.copyWith(isEnableDeleteUI: true));
    }
  }

  //Used fun unselectAllItems().
  void unselectAllItems() {
    var oldState = state as AdvanceSearchLoadedState;
    if (isSaved) {
      for (var item in savedSearchListing!) {
        item.isChecked = false;
      }
      emit(oldState.copyWith(isEnableDeleteUI: false));
    } else {
      for (var item in recentSearchListing!) {
        item.isChecked = false;
      }
      emit(oldState.copyWith(isEnableDeleteUI: false));
    }
  }

  void toggleSaveSearch() {
    var oldState = state as AdvanceSearchLoadedState;
    saveSearch = !saveSearch;
    emit(oldState.copyWith(saveSearch: saveSearch));
  }

  void removeItem(int index) {
    var oldState = state as AdvanceSearchLoadedState;
    List<AdvanceSearchItem>? searchItems;
    if (isSaved) {
      searchItems = savedSearchListing;
    } else {
      searchItems = recentSearchListing;
    }
    var updatedItems =
        List<AdvanceSearchItem>.from(searchItems ?? [AppConstants.dummyText1Str, AppConstants.dummyText2Str]);
    updatedItems.removeAt(index);
    emit(oldState.copyWith(searchItems: updatedItems, isLoading: true));
  }

  void removeRecentItem(int index) {
    var oldState = state as AdvanceSearchLoadedState;
    var updatedItems =
        List<AdvanceSearchItem>.from(oldState.recentItems ?? [AppConstants.dummyText1Str, AppConstants.dummyText2Str]);
    updatedItems.removeAt(index);
    emit(oldState.copyWith(recentItems: updatedItems));
  }

  void onFieldsValueChanged({String? key, dynamic value, Map<String, dynamic>? keysValuesMap}) {
    var oldState = state as AdvanceSearchLoadedState;
    try {
      Map<String, dynamic>? oldFormData = oldState.formDataMap;
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
      emit(oldState.copyWith(formDataMap: oldFormData));
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      emit(oldState.copyWith());
    }
  }

  ///getAdvanceSearchData() Used to get advance search data.
  Future<void> getAdvanceSearchData({
    required bool isSaved,
    required int? categoryId,
    required String sortOrder,
    required int sortBy,
    bool isRefresh = false,
  }) async {
    var oldState = state as AdvanceSearchLoadedState;
    try {
      if (isRefresh == false) {
        emit(oldState.copyWith(
          isLoading: true,
          isEnableDeleteUI: oldState.isEnableDeleteUI,
        ));
      }

      Map<String, dynamic> requestBody = {
        ModelKeys.isSaved: isSaved,
        ModelKeys.categoryId: categoryId,
        ModelKeys.pageIndex: currentPage,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.sortOrder: 'desc',
        ModelKeys.sortBy: 4,
      };

      if (currentPage == 1) {
        savedSearchListing?.clear();
        recentSearchListing?.clear();
      }

      var response = await AdvanceSearchRepo.instance.getAdvanceSearchData(json: requestBody);
      if (response?.responseData != null) {
        List<AdvanceSearchItem> myListingItem =
            (response?.responseData?.result?.expand((model) => model.items ?? []).toList() ?? [])
                .cast<AdvanceSearchItem>();

        if (myListingItem.length == AppConstants.pageSize) {
          hasNextPage = true;
          currentPage++;
        } else {
          hasNextPage = false;
        }

        if (isRefresh == true) {
          oldState.searchItems?.clear();
        }

        if (isSaved) {
          savedSearchListing = isRefresh
              ? myListingItem // start fresh with new items
              : [...?oldState.searchItems, ...myListingItem];
          emit(oldState.copyWith(
            result: response?.responseData?.result,
            searchItems: savedSearchListing,
            isLoading: false,
            isEnableDeleteUI: oldState.isEnableDeleteUI,
          ));
        } else {
          recentSearchListing = isRefresh
              ? myListingItem // start fresh with new items
              : [...?oldState.searchItems, ...myListingItem];
          emit(oldState.copyWith(
            result: response?.responseData?.result,
            searchItems: recentSearchListing,
            isLoading: false,
            isEnableDeleteUI: oldState.isEnableDeleteUI,
          ));
        }
      } else {
        if (isSaved) {
          emit(oldState.copyWith(
            isLoading: false,
            searchItems: savedSearchListing,
            isEnableDeleteUI: oldState.isEnableDeleteUI,
          ));
        } else {
          emit(oldState.copyWith(
            isLoading: false,
            searchItems: recentSearchListing,
            isEnableDeleteUI: oldState.isEnableDeleteUI,
          ));
        }
      }
    } catch (e) {
      if (isSaved) {
        emit(oldState.copyWith(
          isLoading: false,
          searchItems: savedSearchListing,
          isEnableDeleteUI: oldState.isEnableDeleteUI,
        ));
      } else {
        emit(oldState.copyWith(
          isLoading: false,
          searchItems: recentSearchListing,
          isEnableDeleteUI: oldState.isEnableDeleteUI,
        ));
      }
    }
  }

  ///Used for delete search record.
  void onDeleteClick({
    required int? searchId,
    int? index,
    bool? isSingleDelete = true,
    bool? isDeleteAll = false,
    bool? isSavedSearch = false,
  }) async {
    var oldState = state as AdvanceSearchLoadedState;
    emit(oldState.copyWith(isLoading: true));
    try {
      ResponseWrapper<dynamic>? response;
      if (isSingleDelete == true) {
        Map<String, dynamic> json = {
          ModelKeys.searchId: searchId.toString(),
          ModelKeys.isClearAll: false,
          ModelKeys.isSaveSearch: isSavedSearch,
        };
        response = await AdvanceSearchRepo.instance.deleteSearchApi(
          itemId: 0,
          path: ApiConstant.deleteSearchStr,
          json: json,
        );
      } else if (isDeleteAll == true) {
        Map<String, dynamic> json = {
          ModelKeys.searchId: '',
          ModelKeys.isClearAll: true,
          ModelKeys.isSaveSearch: isSavedSearch,
        };
        response = await AdvanceSearchRepo.instance.deleteSearchApi(
          itemId: 0,
          path: ApiConstant.deleteSearchStr,
          json: json,
        );
      } else {
        String? ids = '';
        if (isSaved) {
          ids = savedSearchListing
              ?.where((item) => item.isChecked == true) // Condition: Only items with id > 2
              .map((item) => item.searchId) // Map to the IDs
              .join(',');
        } else {
          ids = recentSearchListing
              ?.where((item) => item.isChecked == true) // Condition: Only items with id > 2
              .map((item) => item.searchId) // Map to the IDs
              .join(',');
        }
        Map<String, dynamic> json = {
          ModelKeys.searchId: ids,
          ModelKeys.isClearAll: false,
          ModelKeys.isSaveSearch: isSavedSearch,
        };
        response = await AdvanceSearchRepo.instance.deleteSearchApi(
          itemId: searchId,
          path: ApiConstant.deleteSearchStr,
          json: json,
        );
      }
      if (response?.status == true) {
        currentPage = 1;
        await getAdvanceSearchData(
          isSaved: isSaved,
          categoryId: commonDropdownModel?.id == 0 ? null : commonDropdownModel?.id,
          sortOrder: 'desc',
          sortBy: 4,
          isRefresh: false,
        );
      } else {
        emit(oldState.copyWith(isLoading: false));
        AppUtils.showSnackBar(AppConstants.somethingWentWrong, SnackBarType.alert);
      }
    } catch (e) {
      emit(oldState.copyWith(isLoading: false));
      if (kDebugMode) {
        print('advance_search_cubit.onDeleteClick -------->> ${e.toString()}');
      }
    }
  }

  Future<void> getDynamicFormData({required int formId}) async {
    var oldState = state as AdvanceSearchLoadedState;

    try {
      emit(oldState.copyWith(isLoading: true));
      formId = formId;

      var response = await MasterDataAPI.instance.getDynamicFormData(formId);
      if (response.status) {
        emit(oldState.copyWith(
            isLoading: false,
            dynamicFormData: response.responseData?.result,
            sections: response.responseData?.result?.sections));
        for (var section in response.responseData?.result?.sections ?? []) {
          for (var field in section.inputFields ?? []) {
            if (field.apiUrl != null && field.apiUrl!.isNotEmpty && field.allowSearch == true) {
              await getMasterData(apiPath: field.apiUrl!);
            }
          }
        }
      } else {
        emit(oldState.copyWith(isLoading: false));
        AppUtils.showFormErrorSnackBar(msg: response.message);
      }
    } catch (e) {
      emit(oldState.copyWith(isLoading: false));
      AppUtils.showFormErrorSnackBar(msg: AppConstants.somethingWentWrong);
    }
  }

  Future<void> getMasterData({required String apiPath}) async {
    var oldState = state as AdvanceSearchLoadedState;
    try {
      emit(oldState.copyWith(isLoading: true));

      var response = await MasterDataAPI.instance.getMasterType(apiPath: apiPath);
      if (response.status) {
        emit(oldState.copyWith(isLoading: false, masterData: response.responseData?.masterData));
      } else {
        emit(oldState.copyWith(isLoading: false));
        AppUtils.showFormErrorSnackBar(msg: response.message);
      }
    } catch (e) {
      emit(oldState.copyWith(isLoading: false));
      AppUtils.showFormErrorSnackBar(msg: AppConstants.somethingWentWrong);
    }
  }

  Future<void> getCategoryType() async {
    var oldState = state as AdvanceSearchLoadedState;
    ResponseWrapper? response;
    try {
      response = await MasterDataAPI.instance.getCategoryType();
      if (response.status) {
        emit(oldState.copyWith(isLoading: false, categoryType: response.responseData));
      } else {
        emit(oldState.copyWith(isLoading: false));
        AppUtils.showFormErrorSnackBar(msg: response.message);
      }
    } catch (e) {
      emit(oldState.copyWith(isLoading: false));
      AppUtils.showFormErrorSnackBar(msg: AppConstants.somethingWentWrong);
    }
  }

  void getWorkerSkills() async {
    var oldState = state as AdvanceSearchLoadedState;
    ResponseWrapper? response;
    try {
      response = await MasterDataAPI.instance.getWorkerSkills();
      if (response.status) {
        emit(oldState.copyWith(isLoading: false, skills: response.responseData));
      } else {
        emit(oldState.copyWith(isLoading: false));
        AppUtils.showFormErrorSnackBar(msg: response.message);
      }
    } catch (e) {
      emit(oldState.copyWith(isLoading: false));
      AppUtils.showFormErrorSnackBar(msg: AppConstants.somethingWentWrong);
    }
  }

  void searchFromOldListing({required AdvanceSearchItem? advanceSearchItem, bool isItemClicked = false}) {
    if (advanceSearchItem != null) {
      onFieldsValueChanged(
        keysValuesMap: {
          AppConstants.keywordHintStr: advanceSearchItem.keyword,
          AddListingFormConstants.latitude: advanceSearchItem.latitude,
          AddListingFormConstants.longitude: advanceSearchItem.longitude,
          AddListingFormConstants.location: advanceSearchItem.location,
          AppConstants.selectCategoryIdStr: advanceSearchItem.categoryId,
          AppConstants.selectCategoryStr: advanceSearchItem.categoryName,
          AppConstants.sortBySmallStr: advanceSearchItem.visibilityType,
          AppConstants.saveSearchStr: advanceSearchItem.saveSearch,
          AppConstants.advanceSearchMap: advanceSearchItem.advanceSearch,
          AppConstants.priceStr: advanceSearchItem.sortOrder != null
              ? advanceSearchItem.sortOrder?.toUpperCase() == 'ASC'
                  ? 1
                  : 2
              : null
        },
      );
      setSearchMap(encodedAdvanceSearchData: advanceSearchItem.advanceSearch ?? '');

      /// [isItemClicked] is used to find if we are in bottom sheet or user clicked on item directly
      if (!isItemClicked) {
        /// Closing the Meta Data bottomSheet
        navigatorKey.currentState?.pop();
      }
      searchListingForAdvanceSearch(isRecentSearch: false, location: advanceSearchItem.location);
    }
  }

  void resetFormDataOnCategoryChange({int? formId, String? categoryName}) {
    var oldState = state as AdvanceSearchLoadedState;
    String keyWord = oldState.formDataMap?[AppConstants.keywordHintStr] ?? '';
    String location = oldState.formDataMap?[AddListingFormConstants.location] ?? '';
    int visibilityType = oldState.formDataMap?[AppConstants.sortBySmallStr] ?? 3;
    bool saveSearch = oldState.formDataMap?[AppConstants.saveSearchStr] ?? false;
    if (categoryName == 'All') {
      emit(oldState.copyWith(sections: []));
    } else {
      getDynamicFormData(formId: formId ?? 0);
    }

    oldState.formDataMap?.clear();

    onFieldsValueChanged(
      keysValuesMap: {
        AppConstants.keywordHintStr: keyWord,
        AddListingFormConstants.location: location,
        AppConstants.sortBySmallStr: visibilityType,
        AppConstants.saveSearchStr: saveSearch
      },
    );
  }

  void resetFormData() {
    var oldState = state as AdvanceSearchLoadedState;
    int visibilityType = 2;
    oldState.formDataMap?.clear();
    onFieldsValueChanged(
      keysValuesMap: {AppConstants.sortBySmallStr: visibilityType},
    );
    emit(oldState.copyWith(sections: [], selectedSkills: []));
  }

  /// Search Keyword Api
  Future<void> searchListingForAdvanceSearch({String? keyword, String? location, bool? isRecentSearch}) async {
    var oldState = state as AdvanceSearchLoadedState;
    emit(oldState.copyWith(isLoading: true));
    String latLong = AppUtils.loginUserModel?.location ?? '';
    try {
      double? currentLatitude;
      double? currentLongitude;
      if (location?.isEmpty ?? false) {
        oldState.formDataMap?[AddListingFormConstants.location] = '';
      }
      if (latitude != 0.0 && longitude != 0.0) {
        currentLatitude = latitude;
        currentLongitude = longitude;
      } else if (location?.isNotEmpty ?? false) {
        try {
          var placemarks = await locationFromAddress(location!);
          if (placemarks.isNotEmpty) {
            currentLatitude = placemarks.first.latitude;
            currentLongitude = placemarks.first.longitude;
          }
        } catch (geocodeError) {
          emit(oldState.copyWith(isLoading: false));
          return;
        }
      } else if (latLong.isNotEmpty) {
        try {
          var placemarks = await locationFromAddress(latLong);
          if (placemarks.isNotEmpty) {
            currentLatitude = placemarks.first.latitude;
            currentLongitude = placemarks.first.longitude;
          }
        } catch (geocodeError) {
          currentLatitude = null;
          currentLongitude = null;
          emit(oldState.copyWith(isLoading: false));

          print('AdvanceSearchCubit.searchListingForAdvanceSearch');
          return;
        }
      }
      Map<String, dynamic> requestBody = {
        ModelKeys.pageIndex: 1,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.latitude: currentLatitude,
        ModelKeys.longitude: currentLongitude,
        ModelKeys.keyword: keyword ?? oldState.formDataMap?[AppConstants.keywordHintStr],
        ModelKeys.location: location,
        ModelKeys.categoryId: oldState.formDataMap?[AppConstants.selectCategoryIdStr] == 0
            ? null
            : oldState.formDataMap?[AppConstants.selectCategoryIdStr],
        ModelKeys.advanceSearch: getSearchMap().isEmpty ? null : getSearchMap(),
        ModelKeys.sortOrder: (oldState.formDataMap?['Sort'] == null || oldState.formDataMap?['Sort'] == '')
            ? null
            : oldState.formDataMap?['Sort'] == '2'
                ? 'ASC'
                : 'DESC',
        ModelKeys.sortBy: oldState.formDataMap?[AppConstants.sortByStr] != null
            ? (oldState.formDataMap?[AppConstants.sortByStr].toString())
            : null,
        ModelKeys.saveSearch: oldState.formDataMap?[AppConstants.saveSearchStr] ?? false,
        ModelKeys.visibilityType: oldState.formDataMap?[AppConstants.sortBySmallStr],
        ModelKeys.recentSearch: isRecentSearch ?? currentPage == 1 ? true : false,
      };
      var response = await SearchListingRepo.instance.searchListing(requestBody);

      if (response.responseData?.statusCode == 200 && response.responseData != null) {
        emit(oldState.copyWith(isLoading: false));
        MyListingResponse? data = response.responseData;
        AdvanceSearchResponseResultModel searchResponse = AdvanceSearchResponseResultModel(
          result: data?.result,
          oldFormData: oldState.formDataMap,
        );
        AppRouter.pop(res: searchResponse);
      } else {
        emit(oldState.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(oldState.copyWith(isLoading: false));
    }
  }

  String getSearchMap() {
    var oldState = state as AdvanceSearchLoadedState;
    List<Map<String, dynamic>> searchDataList = [];

    oldState.sections?.forEach((section) {
      section.inputFields?.forEach((inputField) {
        int? controlID = inputField.controlId;
        String? controlValue;

        // Get value from formData if available
        if (oldState.formDataMap?[inputField.controlName] != null &&
            oldState.formDataMap![inputField.controlName].toString().isNotEmpty) {
          controlValue = oldState.formDataMap?[inputField.controlName].toString();
        }
        // Else, fallback to inputField value if available
        else if (inputField.controlValue != null && inputField.controlValue.toString().isNotEmpty) {
          controlValue = inputField.controlValue.toString();
        }

        // Skip adding if controlValue is null or empty
        if (controlID != null && controlValue != null && controlValue.isNotEmpty) {
          searchDataList.add({
            'controlId': controlID,
            'value': controlValue,
          });
        }
      });
    });

    // Convert to JSON string format
    String searchJson = jsonEncode(searchDataList);

    // Print for debugging
    print('dgffhgfjghjghghkjhjk$searchJson');

    return searchJson;
  }

  void setSearchMap({required String encodedAdvanceSearchData}) {
    if (encodedAdvanceSearchData.isNotEmpty) {
      LinkedHashMap<String, String>? hashMap = LinkedHashMap();
      List<dynamic> jsonList = jsonDecode(encodedAdvanceSearchData);

      List<AdvanceSearchItemMetaData> dataList =
          jsonList.map((item) => AdvanceSearchItemMetaData.fromJson(item)).toList();
      for (var element in dataList) {
        hashMap[element.controlLabel ?? ''] = element.displayValue ?? '';
      }

      onFieldsValueChanged(keysValuesMap: hashMap);
    }
  }

  ///On Plan click is for selecting subscription plan.
  void onCheckUnCheckItem(AdvanceSearchItem item, bool isSaved, int index) {
    var oldState = state as AdvanceSearchLoadedState;
    if (this.isSaved) {
      savedSearchListing?[index] = item;
      emit(oldState.copyWith(
        isLoading: false,
        isEnableDeleteUI: true,
        searchItems: savedSearchListing,
      ));
    } else {
      recentSearchListing?[index] = item;
      emit(oldState.copyWith(
        isLoading: false,
        isEnableDeleteUI: true,
        searchItems: recentSearchListing,
      ));
    }
  }

  //Delete all search items.
  void deleteAll() {
    var oldState = state as AdvanceSearchLoadedState;

    ReusableWidgets.showConfirmationWithTwoFuncDialog(AppConstants.appTitleStr,
        isSaved ? AppConstants.areYouSureWantToDeleteSavedItems : AppConstants.areYouSureWantToDeleteRecentItems,
        option1: AppConstants.yesStr, option2: AppConstants.noStr, funcYes: () {
      navigatorKey.currentState?.pop();
      if (isSaved) {
        onDeleteClick(isSingleDelete: false, isDeleteAll: true, searchId: null, isSavedSearch: isSaved);
      } else {
        onDeleteClick(isSingleDelete: false, isDeleteAll: true, searchId: null, isSavedSearch: isSaved);
      }
    }, funcNo: () {
      navigatorKey.currentState?.pop();
    });
  }

  //Delete specific items.
  void delete() {
    var oldState = state as AdvanceSearchLoadedState;
    final searchId =
        oldState.searchItems?.firstWhere((item) => item.isChecked ?? false, orElse: () => AdvanceSearchItem()).searchId;
    ReusableWidgets.showConfirmationWithTwoFuncDialog(AppConstants.appTitleStr,
        isSaved ? AppConstants.areYouSureWantToDeleteItems : AppConstants.areYouSureWantToDeleteRecentItems,
        option1: AppConstants.yesStr, option2: AppConstants.noStr, funcYes: () {
      navigatorKey.currentState?.pop();
      if (isSaved) {
        onDeleteClick(isSingleDelete: true, searchId: searchId, isSavedSearch: isSaved);
      } else {
        onDeleteClick(isSingleDelete: false, searchId: null, isSavedSearch: isSaved);
      }
    }, funcNo: () {
      navigatorKey.currentState?.pop();
    });
  }

  void updateFormData({Map<String, dynamic>? oldFormData}) {
    var oldState = state as AdvanceSearchLoadedState;
    emit(oldState.copyWith(formDataMap: oldFormData));
  }
}
