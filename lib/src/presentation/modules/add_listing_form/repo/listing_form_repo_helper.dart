import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/domain/models/add_listing_dynamic_form.dart';
import 'package:workapp/src/domain/models/add_listing_form_model.dart';
import 'package:workapp/src/domain/models/auto_type_model.dart';
import 'package:workapp/src/domain/models/business_list_model.dart';
import 'package:workapp/src/domain/models/business_profile_detail_resp.dart';
import 'package:workapp/src/domain/models/business_type_model.dart';
import 'package:workapp/src/domain/models/category_type_model.dart';
import 'package:workapp/src/domain/models/community_listing_type_model.dart';
import 'package:workapp/src/domain/models/industry_type_model.dart';
import 'package:workapp/src/domain/models/property_type_model.dart';
import 'package:workapp/src/domain/models/worker_skills_model.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_utils.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/utils/app_utils.dart';

class ListingFormRepoHelper {
  static Future<Map<String, dynamic>> getBusinessRepoRequestBody(
      {required AddListingFormLoadedState state, bool? isFromSubmitButton}) async {
    Map<String, dynamic> requestBody = {};
    double? latitude;
    double? longitude;
    bool showStreet = state.formDataMap?[AddListingFormConstants.showStreetAddress] == AddListingFormConstants.yes;

    /// Checking if there is any initial value of latitude is available or not.
    if (state.formDataMap?.containsKey(AddListingFormConstants.latitude) ??
        state.formDataMap?.containsKey(AddListingFormConstants.longitude) ??
        false) {
      var lat = state.formDataMap?[AddListingFormConstants.latitude];
      var long = state.formDataMap?[AddListingFormConstants.longitude];

      latitude = lat is String ? double.tryParse(lat) : lat;
      longitude = long is String ? double.tryParse(long) : long;
    } else {
      var latLongMap = await AppUtils.getLatLong();
      latitude = latLongMap[ModelKeys.latitude];
      longitude = latLongMap[ModelKeys.longitude];
    }
    int visibilityType = AppUtils.getIdByValue(
          map: DropDownConstants.visibilityDropDownListWithLocal,
          value: state.formDataMap?[AddListingFormConstants.businessVisibility],
        ) ??
        2;
    requestBody = {
      ModelKeys.businessTypeId: state.formDataMap?[AddListingFormConstants.businessTypeId],
      ModelKeys.businessTypeTitle: state.formDataMap?[AddListingFormConstants.otherIndustryName] ??
          state.formDataMap?[AddListingFormConstants.businessType],
      ModelKeys.businessName: state.formDataMap?[AddListingFormConstants.businessName],
      ModelKeys.description: state.formDataMap?[AddListingFormConstants.businessDescription],
      ModelKeys.registrationNumber: state.formDataMap?[AddListingFormConstants.businessRegistrationNumber],
      ModelKeys.city: state.formDataMap?[AddListingFormConstants.city],
      ModelKeys.state: state.formDataMap?[AddListingFormConstants.state],
      ModelKeys.country: state.formDataMap?[AddListingFormConstants.country],
      ModelKeys.address: state.formDataMap?[AddListingFormConstants.streetAddress] ?? '',
      ModelKeys.email: state.formDataMap?[AddListingFormConstants.businessEmail],
      ModelKeys.webSite: state.formDataMap?[AddListingFormConstants.businessWebsite] ?? '',

      /// phone
      ModelKeys.visibilityType: visibilityType,
      ModelKeys.isShowStreetAddress: showStreet,
      ModelKeys.businessLogo: getBusinessLogo(state: state),

      ModelKeys.latitude: latitude ?? 0.0,
      ModelKeys.longitude: longitude ?? 0.0,
      ModelKeys.location: state.formDataMap?[AddListingFormConstants.location] ?? '',
      ModelKeys.radiusId: state.formDataMap?[AddListingFormConstants.selectRadius] == DropDownConstants.fiftyKm ? 0 : 1,
      ModelKeys.images: getUploadFilesMap(state: state),
    };
    requestBody.addAll(ListingFormRepoHelper.getPhoneCodes(state: state));

    return requestBody;
  }

  static Future<Map<String, dynamic>> getDynamicFormData(
      {required AddListingFormLoadedState state, bool? isFromSubmitButton, required int formID,required int recordStatusID}) async {
    List<Sections> sectionResponse = [];

    for (int i = 0; i < (state.totalSectionCount ?? 0); i++) {
      List<InputFields> inputFieldsList = [];

      state.sections?[i].inputFields?.forEach((inputField) {
        int? controlID = inputField.controlId;

        String? controlValue = '';
        if (state.formDataMap?[inputField.controlName] != null) {
          if (state.formDataMap?[inputField.controlName].toString().isNotEmpty ?? false) {
            controlValue = state.formDataMap?[inputField.controlName].toString();
          }
        }

        if (controlID != 0) {
          if (state.apiResultId != null) {
            int? responseControlId;
            if (state.sections != null && i < state.sections!.length) {
              responseControlId = state.sections![i].inputFields
                  ?.firstWhere(
                    (inputField) => inputField.controlId == controlID,
                    orElse: () => InputFields(controlId: 0, controlValue: ''),
                  )
                  .responseControlId;
            }

            inputFieldsList.add(InputFields(
              responseControlId: responseControlId ?? 0,
              id: controlID,
              controlId: controlID ?? 0,
              controlValue: controlValue ?? '',
            ));
          } else {
            inputFieldsList.add(InputFields(
              id: controlID,
              controlId: controlID ?? 0,
              controlValue: controlValue ?? '',
            ));
          }
        }
      });

      sectionResponse.add(Sections(
        id: state.sections?[i].id ?? 0,
        inputFields: inputFieldsList,
      ));
    }

    /*var recordStatus = isFromSubmitButton ?? false
        ? RecordStatus.waitingForApproval.value
        : state.isDraft ?? true
            ? RecordStatus.draft.value
            : RecordStatus.waitingForApproval.value;*/

    var status = 0;

    if((state.isDraft ??  false) && isFromSubmitButton == false){
      status = RecordStatus.draft.value;
    }else if((recordStatusID ==0 && (isFromSubmitButton??false))||recordStatusID == RecordStatus.draft.value){
      status = RecordStatus.waitingForApproval.value;
    }
    else{
      status = recordStatusID;
      print('status $status');
    }

    var imageList = state.imageModelList;

    if (state.apiResultId != null) {
      return AddListingDynamicForm(
        formId: formID,
        listingId: state.apiResultId,
        recordStatusID:  status,
        sections: sectionResponse,
        images: imageList ?? [],
      ).toJson();
    } else {
      return AddListingDynamicForm(
        formId: formID,
        recordStatusID: status,
        sections: sectionResponse,
        images: [],
      ).toJson();
    }
  }

  static Future<Map<String, dynamic>> getWorkerRepoRequestBody(
      {required AddListingFormLoadedState state,
      bool? isFromSubmitButton,
      BusinessProfileDetailResponse? businessDetails}) async {
    Map<String, dynamic> requestBody = {};
    double? latitude;
    double? longitude;
    int visibilityType = AppUtils.getIdByValue(
          map: DropDownConstants.visibilityDropDownListWithLocal,
          value: state.formDataMap?[AddListingFormConstants.businessVisibility],
        ) ??
        2;
    bool showStreet = state.formDataMap?[AddListingFormConstants.showStreetAddress] == AddListingFormConstants.yes;
    double? maxTravelDistance =
        double.tryParse(state.formDataMap?[AddListingFormConstants.maxTravelDistanceInKms] ?? '0');

    /// Checking if there is any initial value of latitude is available or not.
    if (state.formDataMap?.containsKey(AddListingFormConstants.latitude) ??
        state.formDataMap?.containsKey(AddListingFormConstants.longitude) ??
        false) {
      latitude = double.tryParse(state.formDataMap?[AddListingFormConstants.latitude]);
      longitude = double.tryParse(state.formDataMap?[AddListingFormConstants.longitude]);
    } else {
      var latLongMap = await AppUtils.getLatLong();
      latitude = latLongMap[ModelKeys.latitude];
      longitude = latLongMap[ModelKeys.longitude];
    }
    String resumeUrl = state.formDataMap?[AddListingFormConstants.uploadResume] ?? '';
    resumeUrl = resumeUrl.replaceAll(ApiConstant.imageBaseUrl, '');
    List<WorkerSkillsResult> skills = [];

    for (int i = 0; i < (state.getSkills?.length ?? 0); i++) {
      var item = state.getSkills![i];
      item.isDeleted = true;

      for (var element in state.selectedSkills ?? []) {
        if (item.skillId == element.skillId) {
          item.isDeleted = false;
        }
      }

      skills.add(item);
    }

    requestBody = {
      ModelKeys.workerName: state.formDataMap?[AddListingFormConstants.workerName],
      ModelKeys.description: state.formDataMap?[AddListingFormConstants.workerDescription],
      ModelKeys.visibilityType: visibilityType,
      ModelKeys.radiusId: state.formDataMap?[AddListingFormConstants.selectRadius] == DropDownConstants.fiftyKm ? 0 : 1,
      ModelKeys.city: state.formDataMap?[AddListingFormConstants.city],
      ModelKeys.state: state.formDataMap?[AddListingFormConstants.state],
      ModelKeys.countryPhoneCode: state.formDataMap?[AddListingFormConstants.phoneCode] ?? '',
      ModelKeys.country: state.formDataMap?[AddListingFormConstants.country],
      ModelKeys.contactName: state.formDataMap?[AddListingFormConstants.contactName] ?? '',
      ModelKeys.address: state.formDataMap?[AddListingFormConstants.streetAddress] ?? '',
      ModelKeys.email: state.formDataMap?[AddListingFormConstants.businessEmail],
      ModelKeys.isShowStreetAddress: showStreet,
      ModelKeys.distanceKm: maxTravelDistance,
      ModelKeys.cvFile: resumeUrl,
      ModelKeys.workerLogo: getBusinessLogo(state: state),
      ModelKeys.latitude: latitude ?? 0.0,
      ModelKeys.longitude: longitude ?? 0.0,
      ModelKeys.location: state.formDataMap?[AddListingFormConstants.location] ?? '',
      ModelKeys.radiusId: state.formDataMap?[AddListingFormConstants.selectRadius] == DropDownConstants.fiftyKm ? 0 : 1,
      ModelKeys.images: getUploadFilesMap(state: state),
      ModelKeys.skills: skills,
    };
    requestBody.addAll(ListingFormRepoHelper.getPhoneCodes(state: state));

    return requestBody;
  }

  static Future<Map<String, dynamic>> getCommunityRepoRequestBody(
      {required AddListingFormLoadedState state, bool? isFromSubmitButton}) async {
    Map<String, dynamic> requestBody = {};
    double? latitude;
    double? longitude;
    int visibilityType = AppUtils.getIdByValue(
          map: DropDownConstants.visibilityDropDownListWithLocal,
          value: state.formDataMap?[AddListingFormConstants.listingVisibility],
        ) ??
        2;
    bool showStreet = state.formDataMap?[AddListingFormConstants.showStreetAddress] == AddListingFormConstants.yes;

    /// Checking if there is any initial value of latitude is available or not.
    if (state.formDataMap?.containsKey(AddListingFormConstants.latitude) ??
        state.formDataMap?.containsKey(AddListingFormConstants.longitude) ??
        false) {
      latitude = double.tryParse(state.formDataMap?[AddListingFormConstants.latitude]);
      longitude = double.tryParse(state.formDataMap?[AddListingFormConstants.longitude]);
    } else {
      var latLongMap = await AppUtils.getLatLong();
      latitude = latLongMap[ModelKeys.latitude];
      longitude = latLongMap[ModelKeys.longitude];
    }

    requestBody = {
      ModelKeys.communityTypeId: state.getCommunityTypeId,
      ModelKeys.communityListingTypeId: state.formDataMap?[AddListingFormConstants.communityListingTypeId],
      ModelKeys.otherListingType: state.formDataMap?[AddListingFormConstants.describeOtherCommunityListingType] ?? '',
      ModelKeys.title: state.formDataMap?[AddListingFormConstants.listingTitle] ?? '',
      ModelKeys.description: state.formDataMap?[AddListingFormConstants.communityDescription] ?? '',
      ModelKeys.skillId: state.getSkillId,
      ModelKeys.otherSkill: state.formDataMap?[AddListingFormConstants.describeOtherSkill] ?? '',
      ModelKeys.contactName: state.formDataMap?[AddListingFormConstants.contactName] ?? '',
      ModelKeys.email: state.formDataMap?[AddListingFormConstants.businessEmail],
      ModelKeys.webSite: state.formDataMap?[AddListingFormConstants.enterYourWebsite],
      ModelKeys.city: state.formDataMap?[AddListingFormConstants.city],
      ModelKeys.state: state.formDataMap?[AddListingFormConstants.state],
      ModelKeys.country: state.formDataMap?[AddListingFormConstants.country],
      ModelKeys.address: state.formDataMap?[AddListingFormConstants.streetAddress] ?? '',
      ModelKeys.isShowStreetAddress: showStreet,
      ModelKeys.latitude: latitude ?? 0.0,
      ModelKeys.longitude: longitude ?? 0.0,
      ModelKeys.location: state.formDataMap?[AddListingFormConstants.location] ?? '',
      ModelKeys.visibilityType: visibilityType,
      ModelKeys.radiusId: state.formDataMap?[AddListingFormConstants.selectRadius] == DropDownConstants.fiftyKm ? 0 : 1,
      ModelKeys.communityLogo: getBusinessLogo(state: state),
      ModelKeys.images: getUploadFilesMap(state: state),
    };
    requestBody.addAll(ListingFormRepoHelper.getPhoneCodes(state: state));

    return requestBody;
  }

  static Future<Map<String, dynamic>> getAutoRepoRequestBody(
      {required AddListingFormLoadedState state, bool? isFromSubmitButton}) async {
    Map<String, dynamic> requestBody = {};
    double? latitude;
    double? longitude;
    String? currency = state.formDataMap?[AddListingFormConstants.currencyINR];
    int visibilityType = AppUtils.getIdByValue(
          map: DropDownConstants.visibilityDropDownListWithLocal,
          value: state.formDataMap?[AddListingFormConstants.businessVisibility],
        ) ??
        2;
    bool showStreet = state.formDataMap?[AddListingFormConstants.showStreetAddress] == AddListingFormConstants.yes;
    var priceValue = state.formDataMap?[AddListingFormConstants.price];
    double? price = priceValue != null ? double.tryParse(priceValue) : null;

    /// Checking if there is any initial value of latitude is available or not.
    if (state.formDataMap?.containsKey(AddListingFormConstants.latitude) ??
        state.formDataMap?.containsKey(AddListingFormConstants.longitude) ??
        false) {
      latitude = double.tryParse(state.formDataMap?[AddListingFormConstants.latitude]);
      longitude = double.tryParse(state.formDataMap?[AddListingFormConstants.longitude]);
    } else {
      var latLongMap = await AppUtils.getLatLong();
      latitude = latLongMap[ModelKeys.latitude];
      longitude = latLongMap[ModelKeys.longitude];
    }
    bool autoRegistered = state.formDataMap?[AddListingFormConstants.autoRegistered] == 'Yes' ? true : false;
    int? autoSaleType = AppUtils.getIdByValue(
      map: DropDownConstants.saleOrRentOrLeaseList,
      value: state.formDataMap?[AddListingFormConstants.saleOrRentOrLease],
    );

    int? vehicleCondition = AppUtils.getIdByValue(
      map: DropDownConstants.vehicleConditionDropDown,
      value: state.formDataMap?[AddListingFormConstants.vehicleCondition],
    );
    int? paymentInterval = AppUtils.getIdByValue(
      map: DropDownConstants.estimatedSalaryPeriodDropDown,
      value: state.formDataMap?[AddListingFormConstants.paymentInterval],
    );

    /// If Brand New is selected then replacing it from current year
    String? autoYear = (state.formDataMap?[AddListingFormConstants.autoYear] ?? '')
        .toString()
        .replaceAll(DropDownConstants.brandYear, DateTime.now().year.toString());

    requestBody = {
      ModelKeys.latitude: latitude ?? 0.0,
      ModelKeys.longitude: longitude ?? 0.0,
      ModelKeys.businessProfileId: (state.formDataMap?[AddListingFormConstants.businessProfileId] != null)
          ? int.tryParse(state.formDataMap?[AddListingFormConstants.businessProfileId])
          : null,
      ModelKeys.location: state.formDataMap?[AddListingFormConstants.location] ?? '',
      ModelKeys.autoTitle: state.formDataMap?[AddListingFormConstants.autoTitle] ?? '',
      ModelKeys.autoType: (state.formDataMap?[AddListingFormConstants.autoTypeId] != null)
          ? int.tryParse(state.formDataMap?[AddListingFormConstants.autoTypeId])
          : null,
      ModelKeys.autoRegistered: autoRegistered,
      ModelKeys.autoRegistrationNumber: state.formDataMap?[AddListingFormConstants.autoRegistrationNumber] ?? '',
      ModelKeys.autoDescription: state.formDataMap?[AddListingFormConstants.autoDescription] ?? '',
      ModelKeys.autoYear: autoYear,
      ModelKeys.autoSaleType: autoSaleType ?? 1,
      ModelKeys.price: price,
      ModelKeys.currency: currency,
      ModelKeys.vehicleCondition: vehicleCondition ?? 1,
      ModelKeys.paymentInterval: paymentInterval ?? 2,
      ModelKeys.city: state.formDataMap?[AddListingFormConstants.city],
      ModelKeys.state: state.formDataMap?[AddListingFormConstants.state],
      ModelKeys.country: state.formDataMap?[AddListingFormConstants.country],
      ModelKeys.countryCode: state.formDataMap?[AddListingFormConstants.countryCode] ?? '',
      ModelKeys.phoneDialCode: state.formDataMap?[AddListingFormConstants.phoneCode] ?? '',
      ModelKeys.phoneCountryCode: state.formDataMap?[AddListingFormConstants.phoneCode] ?? '',
      ModelKeys.address: state.formDataMap?[AddListingFormConstants.streetAddress] ?? '',
      ModelKeys.isShowStreetAddress: showStreet,
      ModelKeys.contactName: state.formDataMap?[AddListingFormConstants.contactName] ?? '',
      ModelKeys.contactEmail: state.formDataMap?[AddListingFormConstants.contactEmail],
      ModelKeys.contactPhone: state.formDataMap?[AddListingFormConstants.businessPhone],
      ModelKeys.webSite: state.formDataMap?[AddListingFormConstants.enterYourWebsite],
      ModelKeys.visibilityType: visibilityType,
      ModelKeys.autoLogo: getBusinessLogo(state: state),
      ModelKeys.images: getUploadFilesMap(state: state),
    };
    requestBody.addAll(ListingFormRepoHelper.getPhoneCodes(state: state));
    return requestBody;
  }

  static Future<Map<String, dynamic>> getClassifiedRepoRequestBody(
      {required AddListingFormLoadedState state, bool? isFromSubmitButton}) async {
    Map<String, dynamic> requestBody = {};
    double? latitude;
    double? longitude;
    int visibilityType = AppUtils.getIdByValue(
          map: DropDownConstants.visibilityDropDownListWithLocal,
          value: state.formDataMap?[AddListingFormConstants.businessVisibility],
        ) ??
        2;
    bool showStreet = state.formDataMap?[AddListingFormConstants.showStreetAddress] == AddListingFormConstants.yes;

    /// Checking if there is any initial value of latitude is available or not.
    if (state.formDataMap?.containsKey(AddListingFormConstants.latitude) ?? false) {
      latitude = double.tryParse(state.formDataMap?[AddListingFormConstants.latitude]);
      longitude = double.tryParse(state.formDataMap?[AddListingFormConstants.longitude]);
    } else {
      var latLongMap = await AppUtils.getLatLong();
      latitude = latLongMap[ModelKeys.latitude] ?? 0.0;
      longitude = latLongMap[ModelKeys.longitude] ?? 0.0;
    }

    var priceValue = state.formDataMap?[AddListingFormConstants.price];
    double? price = priceValue != null ? double.tryParse(priceValue) : null;

    requestBody = {
      ModelKeys.classifiedType: AppUtils.getIdByValue(
        map: DropDownConstants.classifiedListDropDownList,
        value: state.formDataMap?[AddListingFormConstants.classifiedType],
      ),
      ModelKeys.itemName: state.formDataMap?[AddListingFormConstants.itemName],
      ModelKeys.itemDescription: state.formDataMap?[AddListingFormConstants.itemDescription],
      ModelKeys.price: price,
      ModelKeys.currency: state.formDataMap?[AddListingFormConstants.currencyINR],
      ModelKeys.communityId: (state.formDataMap?[AddListingFormConstants.communityId] != null)
          ? int.tryParse(state.formDataMap?[AddListingFormConstants.communityId])
          : null,
      ModelKeys.businessProfileId: (state.formDataMap?[AddListingFormConstants.businessProfileId] != null)
          ? int.tryParse(state.formDataMap?[AddListingFormConstants.businessProfileId])
          : null,

      ModelKeys.sellURL: state.formDataMap?[AddListingFormConstants.productSellURL],
      ModelKeys.visibilityType: visibilityType,
      ModelKeys.city: state.formDataMap?[AddListingFormConstants.city],
      ModelKeys.state: state.formDataMap?[AddListingFormConstants.state],
      ModelKeys.country: state.formDataMap?[AddListingFormConstants.country],
      ModelKeys.address: state.formDataMap?[AddListingFormConstants.streetAddress] ?? '',
      ModelKeys.contactEmail: state.formDataMap?[AddListingFormConstants.businessEmail],
      ModelKeys.contactName: state.formDataMap?[AddListingFormConstants.contactName],
      ModelKeys.webSite: state.formDataMap?[AddListingFormConstants.businessWebsite] ?? '',
      ModelKeys.contactPhone: state.formDataMap?[AddListingFormConstants.businessPhone],
      ModelKeys.isShowStreetAddress: showStreet,

      /// here just changing API key not changing map's key as its using in whole flow for all categories
      ModelKeys.classifiedLogo: getBusinessLogo(state: state),

      ModelKeys.latitude: latitude,
      ModelKeys.longitude: longitude,
      ModelKeys.location: state.formDataMap?[AddListingFormConstants.location] ?? '',
      ModelKeys.images: getUploadFilesMap(state: state),
    };
    requestBody.addAll(ListingFormRepoHelper.getPhoneCodes(state: state));
    return requestBody;
  }

  static Future<Map<String, dynamic>> getPromoRepoRequestBody(
      {required AddListingFormLoadedState state, bool? isFromSubmitButton}) async {
    Map<String, dynamic> requestBody = {};
    double? latitude;
    double? longitude;
    int visibilityType = AppUtils.getIdByValue(
          map: DropDownConstants.visibilityDropDownListWithLocal,
          value: state.formDataMap?[AddListingFormConstants.businessVisibility],
        ) ??
        2;
    bool showStreet = state.formDataMap?[AddListingFormConstants.showStreetAddress] == AddListingFormConstants.yes;

    int? categoryType = (state.formDataMap?[AddListingFormConstants.promoCategoryId] != null)
        ? int.tryParse(state.formDataMap?[AddListingFormConstants.promoCategoryId])
        : null;

    /// Checking if there is any initial value of latitude is available or not.
    if (state.formDataMap?.containsKey(AddListingFormConstants.latitude) ?? false) {
      latitude = double.tryParse(state.formDataMap?[AddListingFormConstants.latitude]);
      longitude = double.tryParse(state.formDataMap?[AddListingFormConstants.longitude]);
    } else {
      var latLongMap = await AppUtils.getLatLong();
      latitude = latLongMap[ModelKeys.latitude] ?? 0.0;
      longitude = latLongMap[ModelKeys.longitude] ?? 0.0;
    }

    String selectedDate = state.formDataMap?[AddListingFormConstants.endDate];

    String? endDate;
    if (selectedDate.isNotEmpty) {
      endDate = AddListingUtils.handleEndDate(selectedDate);
    }

    String selectedStartDate = state.formDataMap?[AddListingFormConstants.startDate];

    String? startDate;
    if (selectedDate.isNotEmpty) {
      startDate = AddListingUtils.handleEndDate(selectedStartDate);
    }

    requestBody = {
      ModelKeys.businessProfileId: (state.formDataMap?[AddListingFormConstants.businessProfileId] != null)
          ? int.tryParse(state.formDataMap?[AddListingFormConstants.businessProfileId])
          : null,
      ModelKeys.communityId: (state.formDataMap?[AddListingFormConstants.communityId] != null)
          ? int.tryParse(state.formDataMap?[AddListingFormConstants.communityId])
          : null,
      ModelKeys.promoName: state.formDataMap?[AddListingFormConstants.promotionName],
      ModelKeys.promoCategoryId: categoryType,
      ModelKeys.description: state.formDataMap?[AddListingFormConstants.promotionDescription],
      ModelKeys.promoStartDate: startDate,
      ModelKeys.promoEndDate: endDate,
      ModelKeys.promoURL: state.formDataMap?[AddListingFormConstants.promoUrl],
      ModelKeys.promoLogo: getBusinessLogo(state: state),
      ModelKeys.city: state.formDataMap?[AddListingFormConstants.city],
      ModelKeys.state: state.formDataMap?[AddListingFormConstants.state],
      ModelKeys.countryPhoneCode: state.formDataMap?[AddListingFormConstants.phoneCode] ?? '',
      ModelKeys.country: state.formDataMap?[AddListingFormConstants.country],
      ModelKeys.address: state.formDataMap?[AddListingFormConstants.streetAddress] ?? '',
      ModelKeys.contactName: state.formDataMap?[AddListingFormConstants.contactName] ?? '',
      ModelKeys.contactEmail: state.formDataMap?[AddListingFormConstants.contactEmail] ?? '',
      // ModelKeys.contactPhone: state.formDataMap?[AddListingFormConstants.contactPhone] ?? '',
      ModelKeys.contactPhone: state.formDataMap?[AddListingFormConstants.businessPhone] ?? '',
      ModelKeys.webSite: state.formDataMap?[AddListingFormConstants.businessWebsite] ?? '',
      ModelKeys.visibilityType: visibilityType,
      ModelKeys.isShowStreetAddress: showStreet,
      ModelKeys.latitude: latitude,
      ModelKeys.longitude: longitude,
      ModelKeys.location: state.formDataMap?[AddListingFormConstants.location] ?? '',
      ModelKeys.images: getUploadFilesMap(state: state),
    };
    requestBody.addAll(ListingFormRepoHelper.getPhoneCodes(state: state));
    return requestBody;
  }

  static Future<Map<String, dynamic>> getJobRepoRequestBody(
      {required AddListingFormLoadedState state, bool? isFromSubmitButton}) async {
    List<JobRequirements> deletedJobRequirementBulletPoint = [];
    Map<String, dynamic> requestBody = {};
    double? latitude;
    double? longitude;

    /// Checking if there is any initial value of latitude is available or not.
    if (state.formDataMap?.containsKey(AddListingFormConstants.latitude) ??
        state.formDataMap?.containsKey(AddListingFormConstants.longitude) ??
        false) {
      latitude = double.tryParse(state.formDataMap?[AddListingFormConstants.latitude]);
      longitude = double.tryParse(state.formDataMap?[AddListingFormConstants.longitude]);
    } else {
      var latLongMap = await AppUtils.getLatLong();
      latitude = latLongMap[ModelKeys.latitude];
      longitude = latLongMap[ModelKeys.longitude];
    }
    int visibilityType = AppUtils.getIdByValue(
          map: DropDownConstants.visibilityDropDownListWithLocal,
          value: state.formDataMap?[AddListingFormConstants.businessVisibility],
        ) ??
        2;
    bool showStreet = state.formDataMap?[AddListingFormConstants.showStreetAddress] == AddListingFormConstants.yes;
    // String docFile = (state.formDataMap?[AddListingFormConstants.uploadResume]?.isNotEmpty ?? false)
    //     ? (state.formDataMap?[AddListingFormConstants.uploadResume])?.split('.')?.first ?? ''
    //     : '';
    // docFile = docFile.replaceAll(ApiConstant.imageBaseUrl, '');
    String resumeUrl = state.formDataMap?[AddListingFormConstants.uploadResume] ?? '';
    resumeUrl = resumeUrl.replaceAll(ApiConstant.imageBaseUrl, '');

    // Used for adding item which were made as isDeleted = true
    var requirementList = state.formDataMap?[AddListingFormConstants.jobRequirementsBulletPoint] ?? [];
    if (deletedJobRequirementBulletPoint.isNotEmpty) {
      requirementList.addAll(deletedJobRequirementBulletPoint);
    }

    String selectedDate = state.formDataMap?[AddListingFormConstants.selectYourDate] ?? '';
    String? endDate;
    if (selectedDate.isNotEmpty) {
      endDate = AddListingUtils.handleEndDate(selectedDate);
    }
    requestBody = {
      ModelKeys.address: state.formDataMap?[AddListingFormConstants.streetAddress] ?? '',
      ModelKeys.businessProfileId: (state.formDataMap?[AddListingFormConstants.businessProfileId] != null)
          ? int.tryParse(state.formDataMap?[AddListingFormConstants.businessProfileId])
          : null,
      ModelKeys.industryTypeId: (state.formDataMap?[AddListingFormConstants.industryTypeId] != null)
          ? int.tryParse(state.formDataMap?[AddListingFormConstants.industryTypeId])
          : null,
      ModelKeys.city: state.formDataMap?[AddListingFormConstants.city] ?? '',
      ModelKeys.communityId: (state.formDataMap?[AddListingFormConstants.communityId] != null)
          ? int.tryParse(state.formDataMap?[AddListingFormConstants.communityId])
          : null,
      ModelKeys.contactEmail: state.formDataMap?[AddListingFormConstants.businessEmail],
      ModelKeys.contactName: state.formDataMap?[AddListingFormConstants.name],
      ModelKeys.contactPhone: state.formDataMap?[AddListingFormConstants.businessPhone],
      ModelKeys.country: state.formDataMap?[AddListingFormConstants.country] ?? '',
      ModelKeys.currency: state.formDataMap?[AddListingFormConstants.currencyINR],
      ModelKeys.description: state.formDataMap?[AddListingFormConstants.description],
      ModelKeys.docFile: resumeUrl,
      ModelKeys.duration: (state.formDataMap?[AddListingFormConstants.duration] != null)
          ? int.tryParse(state.formDataMap?[AddListingFormConstants.duration])
          : 1,
      ModelKeys.endDate: endDate,
      ModelKeys.images: getUploadFilesMap(state: state),
      ModelKeys.isShowStreetAddress: showStreet,
      ModelKeys.jobLogo: getBusinessLogo(state: state),
      ModelKeys.priceFrom: state.formDataMap?[AddListingFormConstants.minSalary],
      ModelKeys.priceTo: state.formDataMap?[AddListingFormConstants.maxSalary],
      ModelKeys.jobRequirements: requirementList ?? [],
      ModelKeys.jobTitle: state.formDataMap?[AddListingFormConstants.jobTitle],
      ModelKeys.latitude: latitude,
      ModelKeys.location: state.formDataMap?[AddListingFormConstants.location] ?? '',
      ModelKeys.longitude: longitude,
      ModelKeys.visibilityType: visibilityType,
      ModelKeys.state: state.formDataMap?[AddListingFormConstants.state] ?? '',
      ModelKeys.webSite: state.formDataMap?[AddListingFormConstants.businessWebsite],
    };

    requestBody.addAll(ListingFormRepoHelper.getPhoneCodes(state: state));
    return requestBody;
  }

  static Future<Map<String, dynamic>> getRealEstateRequestBody(
      {required AddListingFormLoadedState state, bool? isFromSubmitButton}) async {
    Map<String, dynamic> requestBody = {};
    double? latitude;
    double? longitude;
    int visibilityType = AppUtils.getIdByValue(
          map: DropDownConstants.visibilityDropDownListWithLocal,
          value: state.formDataMap?[AddListingFormConstants.listingVisibility],
        ) ??
        2;
    bool showStreet = state.formDataMap?[AddListingFormConstants.showStreetAddress] == AddListingFormConstants.yes;

    /// Checking if there is any initial value of latitude is available or not.
    if (state.formDataMap?.containsKey(AddListingFormConstants.latitude) ??
        state.formDataMap?.containsKey(AddListingFormConstants.longitude) ??
        false) {
      latitude = double.tryParse(state.formDataMap?[AddListingFormConstants.latitude]);
      longitude = double.tryParse(state.formDataMap?[AddListingFormConstants.longitude]);
    } else {
      var latLongMap = await AppUtils.getLatLong();
      latitude = latLongMap[ModelKeys.latitude];
      longitude = latLongMap[ModelKeys.longitude];
    }

    requestBody = {
      ModelKeys.priceFrom: (state.formDataMap?[AddListingFormConstants.priceFrom] != null)
          ? double.tryParse(state.formDataMap?[AddListingFormConstants.priceFrom])
          : null,
      ModelKeys.priceTo: (state.formDataMap?[AddListingFormConstants.priceTo] != null)
          ? double.tryParse(state.formDataMap?[AddListingFormConstants.priceTo])
          : null,
      ModelKeys.businessProfileId: (state.formDataMap?[AddListingFormConstants.businessProfileId] != null)
          ? int.tryParse(state.formDataMap?[AddListingFormConstants.businessProfileId])
          : null,
      ModelKeys.title: state.formDataMap?[AddListingFormConstants.propertyTitle] ?? '',
      ModelKeys.description: state.formDataMap?[AddListingFormConstants.propertyDescription] ?? '',
      ModelKeys.contactName: state.formDataMap?[AddListingFormConstants.contactName] ?? '',
      ModelKeys.contactEmail: state.formDataMap?[AddListingFormConstants.contactEmail],
      ModelKeys.contactPhone: state.formDataMap?[AddListingFormConstants.businessPhone],
      ModelKeys.webSite: state.formDataMap?[AddListingFormConstants.website],
      ModelKeys.saleTypeId: AppUtils.getIdByValue(
          map: DropDownConstants.typeOfSaleList, value: state.formDataMap?[AddListingFormConstants.typeOfSale]),
      ModelKeys.costTypeId:
          state.formDataMap?[AddListingFormConstants.propertyOnSaleRent] == AddListingFormConstants.sale ? 1 : 2,
      ModelKeys.inSpectionTypeId: AppUtils.getIdByValue(
          map: DropDownConstants.inspectionTypeList,
          value: state.formDataMap?[AddListingFormConstants.typeOfInspection]),
      ModelKeys.inSpectionDate: state.formDataMap?[AddListingFormConstants.inspectionDate],
      ModelKeys.inSpectionStartTime: state.formDataMap?[AddListingFormConstants.startTime],
      ModelKeys.inSpectionEndTime: state.formDataMap?[AddListingFormConstants.endTime],
      ModelKeys.auctionDate: state.formDataMap?[AddListingFormConstants.auctionDate],
      ModelKeys.auctionTime: state.formDataMap?[AddListingFormConstants.auctionTime],
      ModelKeys.currency: state.formDataMap?[AddListingFormConstants.currencyINR],
      ModelKeys.bondDeposit: state.formDataMap?[AddListingFormConstants.bondDeposit],
      ModelKeys.duration: AppUtils.getIdByValue(
          map: DropDownConstants.estimatedSalaryPeriodDropDown,
          value: state.formDataMap?[AddListingFormConstants.duration]),
      ModelKeys.address: state.formDataMap?[AddListingFormConstants.streetAddress] ?? '',
      ModelKeys.city: state.formDataMap?[AddListingFormConstants.city],
      ModelKeys.state: state.formDataMap?[AddListingFormConstants.state],
      ModelKeys.countryCode: state.formDataMap?[AddListingFormConstants.countryCode] ?? '',
      ModelKeys.phoneDialCode: state.formDataMap?[AddListingFormConstants.phoneDialCode] ?? '',
      ModelKeys.phoneCountryCode: state.formDataMap?[AddListingFormConstants.countryCode] ?? '',
      ModelKeys.country: state.formDataMap?[AddListingFormConstants.country],
      ModelKeys.isShowStreetAddress: showStreet,
      ModelKeys.propertyTypeId: state.formDataMap?[AddListingFormConstants.propertyTypeId],
      ModelKeys.visibilityType: visibilityType,
      ModelKeys.bed: state.formDataMap?[AddListingFormConstants.beds],
      ModelKeys.bath: state.formDataMap?[AddListingFormConstants.baths],
      ModelKeys.garage: state.formDataMap?[AddListingFormConstants.garages],
      ModelKeys.pool: state.formDataMap?[AddListingFormConstants.pools],
      ModelKeys.petsAllowed:
          state.formDataMap?[AddListingFormConstants.petsAllowed] == AddListingFormConstants.yes ? true : false,
      ModelKeys.landSize: state.formDataMap?[AddListingFormConstants.landSize],
      ModelKeys.landUnitsofMeasure: AppUtils.getIdByValue(
          map: DropDownConstants.unitOfMeasureDropDownList,
          value: state.formDataMap?[AddListingFormConstants.landSizeUnit]),
      ModelKeys.buildingSize: state.formDataMap?[AddListingFormConstants.buildingSize],
      ModelKeys.buildingUnitsofMeasure: AppUtils.getIdByValue(
          map: DropDownConstants.unitOfMeasureDropDownList,
          value: state.formDataMap?[AddListingFormConstants.buildingSizeUnit]),
      ModelKeys.realEstateLogo: getBusinessLogo(state: state),
      ModelKeys.images: getUploadFilesMap(state: state),
      ModelKeys.latitude: latitude ?? 0.0,
      ModelKeys.longitude: longitude ?? 0.0,
      ModelKeys.location: state.formDataMap?[AddListingFormConstants.location] ?? '',
      ModelKeys.businessWebsite: state.formDataMap?[AddListingFormConstants.businessWebsite],
    };

    return requestBody;
  }

  static Future<Map<String, String?>> getFormConstantsToModelMap({
    required AddListingFormLoadedState state,
    required BusinessProfileDetailResponse? businessDetailsResponse,
  }) async {
    final businessDetails = businessDetailsResponse?.businessProfileModel;

    String businessVisibility =
        DropDownConstants.visibilityDropDownListWithLocal[businessDetails?.visibilityType] ?? '2';
    String isShowStreetAddress =
        businessDetails?.isShowStreetAddress == false ? AddListingFormConstants.no : AddListingFormConstants.yes;
    int? businessTypeId = businessDetails?.businessTypeId;
    String? promoId = businessDetails?.promoId.toString() ?? '1';
    int? businessProfileId = businessDetails?.businessProfileId;
    int? communityId = businessDetails?.communityId;
    int? promoCategoryId = businessDetails?.promoCategoryId;
    int? industryTypeId = businessDetails?.industryTypeId;
    int? propertyTypeId = businessDetails?.propertyTypeId;
    int? autoTypeId = businessDetails?.autoType;
    int? communityListingTypeId = businessDetails?.communityListingTypeId;
    bool isBusiness = businessProfileId != null && businessProfileId != 0;
    bool isCommunity = communityId != null && communityId != 0;
    String autoRegistered =
        businessDetails?.autoRegistered == false ? AddListingFormConstants.no : AddListingFormConstants.yes;

    /// Fetch Community id And business
    CommonDropdownModel? communityName;
    CommonDropdownModel? businessName;
    CommonDropdownModel? autoTypeName;
    CommonDropdownModel? businessTypeName;
    CommonDropdownModel? categoryTypeName;
    CommonDropdownModel? industryTypeName;
    CommonDropdownModel? propertyTypeName;
    CommonDropdownModel? communityListingTypeName;

    try {
      var businessList = state.businessListResult;
      var businessListId = businessList?.firstWhere((item) => item.businessProfileId == businessProfileId,
          orElse: () => BusinessListResult(businessProfileId: 0, businessName: ''));

      if (businessListId != null) {
        businessName =
            CommonDropdownModel(id: businessListId.businessProfileId, name: businessListId.businessName ?? '');
      }

      var businessTypeList = state.businessTypeResult;
      var businessType = businessTypeList?.firstWhere((item) => item.businessTypeId == businessTypeId,
          orElse: () => BusinessTypeResult(businessTypeId: 0, businessTypeCode: ''));

      if (businessType != null) {
        businessTypeName =
            CommonDropdownModel(id: businessType.businessTypeId, name: businessType.businessTypeCode ?? '');
      }

      var communityList = state.communityListResult;
      var community = communityList?.firstWhere((item) => item.communityId == communityId,
          orElse: () => BusinessListResult(communityId: 0, title: ''));

      if (community != null) {
        communityName = CommonDropdownModel(id: community.communityId, name: community.title ?? '');
      }
      var autoTypeList = state.autoTypeList;
      var autoType = autoTypeList?.firstWhere((item) => item.autoTypeId == autoTypeId,
          orElse: () => AutoTypeList(autoTypeId: 0, autoTypeName: ''));

      if (autoType != null) {
        autoTypeName = CommonDropdownModel(id: autoType.autoTypeId, name: autoType.autoTypeName ?? '');
      }
      var promoCategoryList = state.categoryType?.result;
      var promoCategory = promoCategoryList?.firstWhere((item) => item.promoCategoryId == promoCategoryId,
          orElse: () => CategoryTypeResult(promoCategoryId: 0, promoCategoryName: ''));

      if (promoCategory != null) {
        categoryTypeName =
            CommonDropdownModel(id: promoCategory.promoCategoryId, name: promoCategory.promoCategoryName ?? '');
      }
      var industryTypeList = state.industryType?.result;
      var industryType = industryTypeList?.firstWhere((item) => item.industryTypeId == industryTypeId,
          orElse: () => IndustryTypeResult(industryTypeId: 0, industryTypeName: ''));

      if (industryType != null) {
        industryTypeName =
            CommonDropdownModel(id: industryType.industryTypeId, name: industryType.industryTypeName ?? '');
      }

      var propertyTypeList = state.propertyType?.result;
      var propertyType = propertyTypeList?.firstWhere((item) => item.propertyTypeId == propertyTypeId,
          orElse: () => PropertyTypeResult(propertyTypeId: 0, propertyTypeName: ''));

      if (propertyType != null) {
        propertyTypeName =
            CommonDropdownModel(id: propertyType.propertyTypeId, name: propertyType.propertyTypeName ?? '');
      }

      var communityListingTypeList = state.communityListingTypeResult;
      var communityListingType = communityListingTypeList?.firstWhere(
          (item) => item.communityListingTypeId == communityListingTypeId,
          orElse: () => CommunityListingTypeResult(communityListingTypeId: 0, name: ''));

      if (communityListingType != null) {
        communityListingTypeName =
            CommonDropdownModel(id: communityListingType.communityListingTypeId, name: communityListingType.name ?? '');
      }
    } catch (e) {
      if (kDebugMode) print('Error: $e');
    }
    Map<String, String?> formConstantsToModelMapBody = {
      AddListingFormConstants.businessType: businessTypeName?.name,
      AddListingFormConstants.businessTypeId: businessTypeName?.id.toString(),
      AddListingFormConstants.businessName: businessName?.name ?? businessDetails?.businessName,
      AddListingFormConstants.businessDescription: businessDetails?.description,
      AddListingFormConstants.streetAddress: businessDetails?.address,
      AddListingFormConstants.otherIndustryName: businessDetails?.businessTypeTitle,
      AddListingFormConstants.location: businessDetails?.location,
      AddListingFormConstants.latitude: businessDetails?.latitude.toString(),
      AddListingFormConstants.longitude: businessDetails?.longitude.toString(),
      AddListingFormConstants.city: businessDetails?.city,
      AddListingFormConstants.state: businessDetails?.state,
      AddListingFormConstants.country: businessDetails?.country,
      AddListingFormConstants.businessEmail: businessDetails?.email,
      AddListingFormConstants.contactEmail: businessDetails?.contactEmail ?? businessDetails?.email,
      AddListingFormConstants.businessWebsite: businessDetails?.webSite,
      AddListingFormConstants.website: businessDetails?.webSite,
      AddListingFormConstants.businessPhone: businessDetails?.phone ?? businessDetails?.contactPhone,
      AddListingFormConstants.businessVisibility: businessVisibility,
      AddListingFormConstants.listingVisibility: businessVisibility,
      AddListingFormConstants.showStreetAddress: isShowStreetAddress,
      AddListingFormConstants.businessRegistrationNumber: businessDetails?.registrationNumber,
      if (isBusiness) AddListingFormConstants.businessCommunityTypeKey: AppConstants.businessStr,
      if (isCommunity) AddListingFormConstants.businessCommunityTypeKey: AppConstants.communityOrganization,
      AddListingFormConstants.businessCommunityTypeKey:
          isBusiness ? AppConstants.businessStr : AppConstants.communityOrganization,
      AddListingFormConstants.businessProfileId: businessProfileId.toString(),
      AddListingFormConstants.uploadHomePageLogo:
          businessDetails?.getListingIdOrLogo(categoryName: state.category.formName).itemLogo,
      AddListingFormConstants.communityType:
          DropDownConstants.communityTypeDropDownList[businessDetails?.communityTypeId],
      AddListingFormConstants.listingTitle: businessDetails?.title,
      AddListingFormConstants.communityListingType: communityListingTypeName?.name,
      AddListingFormConstants.describeOtherCommunityListingType: businessDetails?.otherListingType,
      AddListingFormConstants.communityDescription: businessDetails?.description,
      AddListingFormConstants.skill: DropDownConstants.skillDropDownList[businessDetails?.skillId],
      AddListingFormConstants.communityId: communityId.toString(),
      AddListingFormConstants.community: communityName?.name,
      AddListingFormConstants.promoCategory: categoryTypeName?.name,
      AddListingFormConstants.promoCategoryId: categoryTypeName?.id.toString(),
      AddListingFormConstants.promoId: promoId,
      AddListingFormConstants.promotionName: businessDetails?.promoName,
      AddListingFormConstants.promotionDescription: businessDetails?.description,
      AddListingFormConstants.startDate: businessDetails?.promoStartDate != null
          ? DateTime.parse(businessDetails?.promoStartDate ?? '').toLocal().toString().split(' ')[0]
          : null,
      AddListingFormConstants.endDate: businessDetails?.promoEndDate != null
          ? DateTime.parse(businessDetails?.promoEndDate ?? '').toLocal().toString().split(' ')[0]
          : null,
      AddListingFormConstants.promoUrl: businessDetails?.promoURL,
      AddListingFormConstants.contactName: businessDetails?.userName,
      AddListingFormConstants.name: businessDetails?.userName,
      AddListingFormConstants.contactPhone: businessDetails?.contactPhone,
      AddListingFormConstants.accountType: AppUtils.getAccountTypeString(businessDetails?.accountType ?? 0),

      /// Worker Specific fields
      AddListingFormConstants.workerName: businessDetails?.workerName,
      AddListingFormConstants.workerDescription: businessDetails?.description,
      AddListingFormConstants.selectVisibility: businessVisibility,
      AddListingFormConstants.uploadResume: businessDetails?.cvFile,
      AddListingFormConstants.maxTravelDistanceInKms: businessDetails?.distanceKm.toString(),
      if (businessDetails?.radiusId != null)
        AddListingFormConstants.selectRadius:
            businessDetails?.radiusId == 0 ? DropDownConstants.fiftyKm : DropDownConstants.hundredKm,

      /// Real Estate fields
      AddListingFormConstants.propertyTitle: businessDetails?.title,
      AddListingFormConstants.propertyDescription: businessDetails?.description,
      AddListingFormConstants.propertyOnSaleRent:
          businessDetails?.costTypeId == 1 ? AddListingFormConstants.sale : AddListingFormConstants.rent,
      AddListingFormConstants.typeOfSale: DropDownConstants.typeOfSaleList[businessDetails?.saleTypeId],
      AddListingFormConstants.typeOfInspection: DropDownConstants.inspectionTypeList[businessDetails?.inSpectionTypeId],
      AddListingFormConstants.inspectionDate: AppUtils.formatDateInServerFormat(businessDetails?.inSpectionDate),
      AddListingFormConstants.auctionDate: AppUtils.formatDateInServerFormat(businessDetails?.auctionDate),
      AddListingFormConstants.startTime: AppUtils.formatTimeToHHMM(businessDetails?.inSpectionStartTime),
      AddListingFormConstants.endTime: AppUtils.formatTimeToHHMM(businessDetails?.inSpectionEndTime),
      AddListingFormConstants.auctionTime: AppUtils.formatTimeToHHMM(businessDetails?.auctionTime),
      AddListingFormConstants.bondDeposit: businessDetails?.bondDeposit,
      AddListingFormConstants.duration: DropDownConstants.estimatedSalaryPeriodDropDown[businessDetails?.duration],
      AddListingFormConstants.beds: DropDownConstants.countsList[businessDetails?.bed ?? 0],
      AddListingFormConstants.baths: DropDownConstants.countsList[businessDetails?.bath ?? 0],
      AddListingFormConstants.garages: DropDownConstants.countsList[businessDetails?.garage ?? 0],
      AddListingFormConstants.pools: DropDownConstants.countsList[businessDetails?.pool ?? 0],
      AddListingFormConstants.petsAllowed:
          businessDetails?.petsAllowed == true ? AddListingFormConstants.yes : AddListingFormConstants.no,
      AddListingFormConstants.landSize: businessDetails?.landSize != null ? businessDetails?.landSize.toString() : '',
      AddListingFormConstants.landSizeUnit:
          DropDownConstants.unitOfMeasureDropDownList[businessDetails?.landUnitsofMeasure],
      AddListingFormConstants.buildingSize:
          businessDetails?.buildingSize != null ? businessDetails?.buildingSize.toString() : '',

      AddListingFormConstants.buildingSizeUnit:
          DropDownConstants.unitOfMeasureDropDownList[businessDetails?.buildingUnitsofMeasure],
    };

    /// Handling business Logo
    switch (state.category.formName) {
      case AddListingFormConstants.businessStr:
        formConstantsToModelMapBody.addAll({
          AddListingFormConstants.businessName: businessDetails?.businessName,
        });
        break;
      case AddListingFormConstants.worker:
        state.selectedSkills = businessDetails?.skills;
        break;
      case AddListingFormConstants.classified:
        formConstantsToModelMapBody.addAll({
          /// classified
          AddListingFormConstants.uploadHomePageLogo: businessDetails?.classifiedLogo,
          AddListingFormConstants.itemName: businessDetails?.itemName,
          AddListingFormConstants.itemDescription: businessDetails?.itemDescription,
          AddListingFormConstants.classifiedType:
              DropDownConstants.classifiedListDropDownList[businessDetails?.classifiedType],

          if (businessDetails?.price != null) AddListingFormConstants.price: businessDetails?.price.toString(),
          AddListingFormConstants.currencyINR: businessDetails?.currency,
          if (isBusiness) AddListingFormConstants.businessCommunityTypeKey: AppConstants.businessStr,
          if (isCommunity) AddListingFormConstants.businessCommunityTypeKey: AppConstants.communityOrganization,
          AddListingFormConstants.businessCommunityTypeKey: isBusiness
              ? AppConstants.businessStr
              : isCommunity
                  ? AppConstants.communityOrganization
                  : null,
          AddListingFormConstants.productSellURL: businessDetails?.productSellURL,
          //
          AddListingFormConstants.contactName: businessDetails?.contactName,
          if (!(businessDetails?.contactEmail.isNullOrEmpty() ?? true))
            AddListingFormConstants.businessEmail: businessDetails?.contactEmail,

          if (!(businessDetails?.contactPhone.isNullOrEmpty() ?? true))
            AddListingFormConstants.businessPhone: businessDetails?.contactPhone,
        });
        break;
      case AddListingFormConstants.job:
        String resumeValue = extractFileName(businessDetails?.docFile ?? '');
        formConstantsToModelMapBody.addAll({
          /// job
          if (isBusiness) AddListingFormConstants.businessCommunityTypeKey: AppConstants.businessStr,
          if (isCommunity) AddListingFormConstants.businessCommunityTypeKey: AppConstants.communityOrganization,
          AddListingFormConstants.businessCommunityTypeKey: isBusiness
              ? AppConstants.businessStr
              : isCommunity
                  ? AppConstants.communityOrganization
                  : null,
          AddListingFormConstants.currencyINR: businessDetails?.currency,
          AddListingFormConstants.businessProfileId: businessProfileId.toString(),
          AddListingFormConstants.businessName: businessName?.name,
          AddListingFormConstants.industryType: industryTypeName?.name,
          AddListingFormConstants.industryTypeId: industryTypeName?.id.toString(),
          AddListingFormConstants.communityId: communityId.toString(),
          AddListingFormConstants.community: communityName?.name,
          AddListingFormConstants.description: businessDetails?.description,
          AddListingFormConstants.uploadResume: businessDetails?.docFile,
          AddListingFormConstants.displayFilePath: resumeValue,
          AddListingFormConstants.duration: businessDetails?.duration.toString(),
          AddListingFormConstants.selectYourDate: businessDetails?.endDate != null
              ? DateTime.parse(businessDetails?.endDate ?? '').toLocal().toString().split(' ')[0]
              : null,
          AddListingFormConstants.uploadHomePageLogo: businessDetails?.jobLogo,
          if (businessDetails?.priceFrom != null)
            AddListingFormConstants.minSalary: businessDetails?.priceFrom.toString(),
          if (businessDetails?.priceTo != null) AddListingFormConstants.maxSalary: businessDetails?.priceTo.toString(),
          AddListingFormConstants.jobTitle: businessDetails?.jobTitle,
          AddListingFormConstants.contactName: businessDetails?.contactName,
          if (!(businessDetails?.contactEmail.isNullOrEmpty() ?? true))
            AddListingFormConstants.businessEmail: businessDetails?.contactEmail,

          if (!(businessDetails?.contactPhone.isNullOrEmpty() ?? true))
            AddListingFormConstants.businessPhone: businessDetails?.contactPhone,
          AddListingFormConstants.accountType: AppUtils.getAccountTypeString(businessDetails?.accountType ?? 0),
        });
        break;
      case AddListingFormConstants.auto:

        /// If Current year is selected then replacing it Brand New
        String? autoYear =
            businessDetails?.autoYear?.replaceAll(DateTime.now().year.toString(), DropDownConstants.brandYear);
        formConstantsToModelMapBody.addAll({
          /// auto
          if (businessDetails?.price != null) AddListingFormConstants.price: businessDetails?.price.toString(),
          AddListingFormConstants.currencyINR: businessDetails?.currency,
          AddListingFormConstants.businessName: businessName?.name,
          AddListingFormConstants.businessProfileId: businessProfileId.toString(),
          AddListingFormConstants.autoType: autoTypeName?.name,
          AddListingFormConstants.autoTypeId: autoTypeId.toString(),
          AddListingFormConstants.autoTitle: businessDetails?.autoTitle,
          AddListingFormConstants.paymentInterval:
              DropDownConstants.estimatedSalaryPeriodDropDown[businessDetails?.paymentInterval],
          AddListingFormConstants.autoRegistered: autoRegistered,
          AddListingFormConstants.autoRegistrationNumber: businessDetails?.autoRegistrationNumber,
          AddListingFormConstants.autoDescription: businessDetails?.autoDescription,
          AddListingFormConstants.autoYear: autoYear,
          AddListingFormConstants.saleOrRentOrLease:
              DropDownConstants.saleOrRentOrLeaseList[businessDetails?.autoSaleType],
          AddListingFormConstants.uploadHomePageLogo: businessDetails?.autoLogo,
          AddListingFormConstants.contactName: businessDetails?.userName,
          AddListingFormConstants.contactPhone: businessDetails?.contactPhone,
          AddListingFormConstants.enterYourWebsite: businessDetails?.webSite,
          AddListingFormConstants.vehicleCondition:
              DropDownConstants.vehicleConditionDropDown[businessDetails?.vehicleCondition],
        });
        break;
      case AddListingFormConstants.realEstate:
        formConstantsToModelMapBody.addAll({
          AddListingFormConstants.currencyINR: businessDetails?.currency,
          AddListingFormConstants.contactName: businessDetails?.contactName,
          AddListingFormConstants.contactEmail: businessDetails?.contactEmail,
          AddListingFormConstants.contactPhone: businessDetails?.contactPhone,
          AddListingFormConstants.propertyType: propertyTypeName?.name,
          AddListingFormConstants.propertyTypeId: propertyTypeName?.id.toString(),
          AddListingFormConstants.businessWebsite: businessDetails?.businessWebsite,
          AddListingFormConstants.priceFrom:
              businessDetails?.priceFrom != null ? businessDetails?.priceFrom.toString() : '',
          AddListingFormConstants.priceTo: businessDetails?.priceTo != null ? businessDetails?.priceTo.toString() : '',
        });
      case AddListingFormConstants.promo:
        formConstantsToModelMapBody.addAll({
          AddListingFormConstants.businessPhone: businessDetails?.contactPhone,
          AddListingFormConstants.contactEmail: businessDetails?.contactEmail,
        });
    }

    /// setting some common fields regarding phone, country code, dial code etc.
    formConstantsToModelMapBody.addAll(setPhoneCodes(businessProfileModel: businessDetails));

    return formConstantsToModelMapBody;
  }

  static String extractFileName(String filePath) {
    // Extract the file name without the extension
    String fileNameWithExtension = filePath.split('/').last;
    return fileNameWithExtension;
  }

  static Map<String, String?> getPhoneCodes({required AddListingFormLoadedState state}) {
    return {
      ModelKeys.phone: state.formDataMap?[AddListingFormConstants.businessPhone],
      ModelKeys.countryCode: state.formDataMap?[AddListingFormConstants.countryCode] ?? '',
      ModelKeys.phoneCountryCode: state.formDataMap?[AddListingFormConstants.phoneCountryCode] ?? '',
      ModelKeys.phoneDialCode: state.formDataMap?[AddListingFormConstants.phoneDialCode] ?? '',
    };
  }

  static Map<String, String?> setPhoneCodes({required BusinessProfileModel? businessProfileModel}) {
    return {
      ModelKeys.phone: businessProfileModel?.phone,
      ModelKeys.countryCode: businessProfileModel?.countryCode,
      ModelKeys.phoneCountryCode: businessProfileModel?.phoneCountryCode,
      ModelKeys.phoneDialCode: businessProfileModel?.phoneDialCode,
    };
  }

  static Map<String, dynamic> getCommonMap({
    required AddListingFormLoadedState state,
    required bool isFromSubmitButton,
  }) {
    return {ModelKeys.isDraft: state.isListingEditing || isFromSubmitButton ? false : true};
  }

  static List getUploadFilesMap({required AddListingFormLoadedState state}) {
    return AddListingUtils.prepareImagesToUpload(state.imageModelList);
  }

  static Future<Map<String, dynamic>> getListingRequestBody(
      {required AddListingFormLoadedState state,
      bool isFromSubmit = false,
      BusinessProfileDetailResponse? businessDetails}) async {
    switch (state.category.formName) {
      case AddListingFormConstants.business:
        return getBusinessRepoRequestBody(state: state, isFromSubmitButton: isFromSubmit);
      case AddListingFormConstants.worker:
        return getWorkerRepoRequestBody(
          state: state,
          isFromSubmitButton: isFromSubmit,
          businessDetails: businessDetails,
        );
      case AddListingFormConstants.auto:
        return getAutoRepoRequestBody(state: state, isFromSubmitButton: isFromSubmit);
      case AddListingFormConstants.promo:
        return getPromoRepoRequestBody(state: state, isFromSubmitButton: isFromSubmit);
      case AddListingFormConstants.classified:
        return getClassifiedRepoRequestBody(state: state, isFromSubmitButton: isFromSubmit);
      case AddListingFormConstants.job:
        return getJobRepoRequestBody(state: state, isFromSubmitButton: isFromSubmit);
      case AddListingFormConstants.community:
        return getCommunityRepoRequestBody(state: state, isFromSubmitButton: isFromSubmit);
      case AddListingFormConstants.realEstate:
        return getRealEstateRequestBody(state: state, isFromSubmitButton: isFromSubmit);
      default:
        return {};
    }
  }

  static String getBusinessLogo({required AddListingFormLoadedState state}) {
    String businessLogo = state.formDataMap?[AddListingFormConstants.uploadHomePageLogo] ?? '';
    businessLogo = businessLogo.replaceAll(ApiConstant.imageBaseUrl, '');
    return businessLogo;
  }
}
