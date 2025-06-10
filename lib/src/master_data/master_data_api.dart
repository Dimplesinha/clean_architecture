import 'package:flutter/foundation.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/add_listing_form_model.dart';
import 'package:workapp/src/domain/models/auto_type_model.dart';
import 'package:workapp/src/domain/models/business_type_model.dart';
import 'package:workapp/src/domain/models/category_type_model.dart';
import 'package:workapp/src/domain/models/chat/report_type_list.dart';
import 'package:workapp/src/domain/models/community_listing_type_model.dart';
import 'package:workapp/src/domain/models/inherited_listing_model.dart';
import 'package:workapp/src/domain/models/master_data_model.dart';
import 'package:workapp/src/domain/models/property_type_model.dart';
import 'package:workapp/src/domain/models/worker_skills_model.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 01-10-2024
/// @Message : [MasterDataAPI]

class MasterDataAPI {
  static final MasterDataAPI _masterDataAPI = MasterDataAPI._internal();

  MasterDataAPI._internal();

  static MasterDataAPI get instance => _masterDataAPI;

  /// Fetch user API call using ApiClient with getAPI call using ResponseWrapper and adding response to All Listing model.
  static Future<ResponseWrapper<CategoriesList>> getCategoriesList() async {
    try {
      var response = await ApiClient.instance.getApi(path: ApiConstant.dynamicAddListingCategoryList);
      if (response.status) {
        CategoriesList model = CategoriesList.fromJson(response.responseData);
        PreferenceHelper.instance.setCategoryData(model);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: '');
    }
  }

  /// Fetch country API call using ApiClient with getAPI call using ResponseWrapper and adding response to Country All
  /// Listing model.
  static Future<ResponseWrapper<CountryAllListing>> getCountries() async {
    try {
      var response = await ApiClient.instance.getApi(path: ApiConstant.countryAllListingStr);
      if (response.status) {
        CountryAllListing model = CountryAllListing.fromJson(response.responseData);
        PreferenceHelper.instance.setCountryList(model);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: '');
    }
  }

  Future<ResponseWrapper<WorkerSkillsModel?>> getWorkerSkills() async {
    try {
      var response = await ApiClient.instance.getApi(path: ApiConstant.getWorkerSkills);
      if (response.status) {
        WorkerSkillsModel model = WorkerSkillsModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<BusinessTypeModel?>> getAllBusinessType() async {
    try {
      var response = await ApiClient.instance.getApi(path: ApiConstant.getBusinessType);
      if (response.status) {
        BusinessTypeModel model = BusinessTypeModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<CommunityListingTypeModel?>> getAllCommunityListingType() async {
    try {
      var response = await ApiClient.instance.getApi(path: ApiConstant.communityListingType);
      if (response.status) {
        CommunityListingTypeModel model = CommunityListingTypeModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<PropertyTypeModel?>> getAllPropertyType() async {
    try {
      var response = await ApiClient.instance.getApi(path: ApiConstant.getAllPropertyType);
      if (response.status) {
        PropertyTypeModel model = PropertyTypeModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }
  Future<ResponseWrapper<DynamicFormDataModel>> getDynamicFormData(int formId, {int? listingId}) async {
    try {
      var apiPath = ApiConstant.dynamicFormData.replaceAll('{formId}', formId.toString());
      Map<String, String>? queryParameters ={};
      if(listingId != null ) {
        queryParameters ={ModelKeys.listingId:listingId.toString() };
      }
      var response = await ApiClient.instance.getApi(
          path:  apiPath,
          queryParameters: queryParameters
      );
      if (response.status) {
        DynamicFormDataModel model = DynamicFormDataModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<AutoTypeResponse?>> getAutoType() async {
    try {
      var response = await ApiClient.instance.getApi(path: ApiConstant.getAutoTypeStr);
      if (response.status) {
        AutoTypeResponse model = AutoTypeResponse.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<CategoryTypeModel?>> getCategoryType() async {
    try {
      var response = await ApiClient.instance.getApi(path: ApiConstant.promoCategoryType);
      if (response.status) {
        CategoryTypeModel model = CategoryTypeModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<MasterDataModel?>> getMasterType({required String apiPath}) async {
    try {
      var response = await ApiClient.instance.getApi(path: apiPath);
      if (response.status) {
        MasterDataModel model = MasterDataModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }
  Future<ResponseWrapper<InheritedListingModel?>> getInheritListing({required Map<String,dynamic> requestBody}) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.getInheritedListing,requestBody: requestBody);
      if (response.status) {
        InheritedListingModel model = InheritedListingModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }
  Future<ResponseWrapper<ReportTypeModel?>> getSpamList() async {
    try {
      var response = await ApiClient.instance.getApi(path: ApiConstant.reportSpamList,);
      if (response.status) {
        ReportTypeModel model = ReportTypeModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }
}



