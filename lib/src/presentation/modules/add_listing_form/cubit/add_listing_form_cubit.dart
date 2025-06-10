import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/add_listing_dynamic_form.dart';
import 'package:workapp/src/domain/models/add_listing_form_model.dart';
import 'package:workapp/src/domain/models/auto_type_model.dart';
import 'package:workapp/src/domain/models/business_profile_detail_resp.dart';
import 'package:workapp/src/domain/models/business_type_model.dart';
import 'package:workapp/src/domain/models/category_type_model.dart';
import 'package:workapp/src/domain/models/community_listing_type_model.dart';
import 'package:workapp/src/domain/models/dynamic_add_listing_response_model.dart';
import 'package:workapp/src/domain/models/industry_type_model.dart';
import 'package:workapp/src/domain/models/inherited_listing_model.dart';
import 'package:workapp/src/domain/models/master_data_model.dart';
import 'package:workapp/src/domain/models/property_type_model.dart';
import 'package:workapp/src/domain/models/worker_skills_model.dart';
import 'package:workapp/src/master_data/master_data_api.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/repo/add_listing_form_repo.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/repo/listing_form_repo_helper.dart';
import 'package:workapp/src/presentation/modules/dynamic_add_listing_form/repo/add_listing_form_dynamic_repo.dart';
import 'package:workapp/src/utils/add_listing_form_utils/form_validation_regex.dart';
import 'package:workapp/src/utils/add_listing_form_utils/form_validation_utils.dart';
import 'package:workapp/src/utils/add_listing_form_utils/listing_form_utils.dart';
import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/countries.dart';
import 'package:workapp/src/utils/country_list.dart';

part 'add_listing_form_state.dart';

class AddListingFormCubit extends Cubit<AddListingFormLoadedState> {
  double? latitude = 0.0;
  double? longitude = 0.0;
  int? formID = 0;
  int? itemId;
  int? recordStatusID;
  int? imageControlID;
  int? apiPath;
  String? pdfFilePath;
  String? pdfLabel;
  List<JobRequirements> deletedJobRequirementBulletPoint = [];
  BusinessProfileDetailResponse? businessDetails;
  Map<String, String?> formConstantsToModelMapBody = {};

  AddListingFormCubit() : super(AddListingFormLoadedState(category: CategoriesListResponse()));

  void init({CategoriesListResponse? category, int? itemId,int? recordStatusID, int? formId, bool? isListingEditing}) async {
    formID = formId;
    this.itemId = itemId;
    this.recordStatusID = recordStatusID;
    await fetchFormData(formId ?? 0, itemId);
    int totalCount = state.sections?.length ?? 0;
    category = await AppUtils.getCategoryModelByCategoryName(category?.formName ?? '');
    try {
      emit(state.copyWith(
        currentSectionCount: 1,
        totalSectionCount: totalCount,
        isUpdatingInitialData: false,
        category: category,
        isListingEditing: isListingEditing,
      ));
      var user = await PreferenceHelper.instance.getUserData();

      /// initializing the common static user obj if its null
      AppUtils.loginUserModel ??= user.result;
      if (itemId == null) {
        onFieldsValueChanged(keysValuesMap: {
          AddListingFormConstants.contactEmail: user.result?.email,
          AddListingFormConstants.contactName: '${user.result?.firstName} ${user.result?.lastName}',
          AddListingFormConstants.phoneNumber: user.result?.phoneNumber,
          AddListingFormConstants.phoneDialCode: user.result?.phoneDialCode,
          AddListingFormConstants.phoneCountryCode: user.result?.phoneCountryCode,
          AddListingFormConstants.countryCode: user.result?.phoneCountryCode,
        });
        log('AddListingFormCubit.init${user.result}');
      } else {
        // Populate the map with fields that have controlValue
        state.listings?.sections?.forEach((section) {
          section.inputFields?.forEach((field) {
            if (field.controlValue?.isNotEmpty == true) {
              formConstantsToModelMapBody[field.controlName ?? ''] = field.controlValue;
            }
          });
        });
        // Call the function with the updated map
        onFieldsValueChanged(keysValuesMap: formConstantsToModelMapBody);
      }
      // setDefaultCurrency();
    } catch (e) {
      if (kDebugMode) {
        print('AddListingFormCubit.init -->${e.toString()}');
      }
    }
  }

  Future<void> fetchFormData(int formId, int? listingId) async {
    try {
      emit(state.copyWith(isLoading: true));

      final response = await AddListingDynamicFormRepository.instance.getDynamicFormData(formId, listingId: listingId);

      if (response.status) {
        List<Future> futureCalls = [];

        List<InheritList> collectedInheritList = [];
        List<MasterData> collectedMasterData = [];

        for (var section in response.responseData?.result?.sections ?? []) {
          for (var field in section.inputFields ?? []) {
            // Inherit Listing API call
            if (field.bindDropdown == 3 && field.inheritControlId != null) {
              futureCalls.add(Future(() async {
                Map<String, dynamic> requestBody = {
                  ModelKeys.controlIdStr: field.inheritControlId,
                  ModelKeys.uuid: AppUtils.loginUserModel?.uuid,
                  ModelKeys.formId: field.inheritListingId ?? 0,
                  ModelKeys.types: field.inheritListingType,
                };
                var response = await MasterDataAPI.instance.getInheritListing(requestBody: requestBody);
                if (response.status) {
                  final list = response.responseData?.inheritList ?? [];

                  for (var item in list) {
                    item.comparedValue = field.comparedValue;
                  }
                  collectedInheritList.addAll(list);
                } else {
                  AppUtils.showFormErrorSnackBar(msg: response.message);
                }
              }));
            }

            // Master Data API call
            if (field.apiUrl != null && field.apiUrl!.isNotEmpty) {
              futureCalls.add(Future(() async {
                var response = await MasterDataAPI.instance.getMasterType(apiPath: field.apiUrl!);
                if (response.status) {
                collectedMasterData.addAll(response.responseData?.masterData ?? []);
                } else {
                  AppUtils.showFormErrorSnackBar(msg: response.message);
                }
              }));
            }
          }
        }

        // Wait for all API calls in parallel
        await Future.wait(futureCalls);

        final result = response.responseData?.result;
        final isDraft = result?.recordStatusId != RecordStatus.active.value;

        // Emit final state once
        emit(state.copyWith(
          isLoading: false,
          apiResultId: listingId,
          isDraft: isDraft,
          listings: result,
          imageModelList: result?.images ?? [],
          sections: result?.sections,
          inheritList: collectedInheritList,
          masterData: collectedMasterData,
        ));
      } else {
        emit(state.copyWith(
          isDraft: true,
          isLoading: false,
          apiResultId: listingId,
          listings: response.responseData?.result,
          sections: response.responseData?.result?.sections ?? [],
        ));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }


  Future<void> getMasterData({required String apiPath}) async {
    try {
      emit(state.copyWith(isLoading: true));

      var response = await MasterDataAPI.instance.getMasterType(apiPath: apiPath);
      if (response.status) {

        emit(state.copyWith(isLoading: false, masterData: response.responseData?.masterData));
      } else {
        emit(state.copyWith(isLoading: false));
        AppUtils.showFormErrorSnackBar(msg: response.message);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      AppUtils.showFormErrorSnackBar(msg: AppConstants.somethingWentWrong);
    }
  }

  Future<void> getInheritListing({required int controlId, required int formId, required String types,required String comparedValue}) async {
    try {
      emit(state.copyWith(isLoading: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.controlIdStr: controlId,
        ModelKeys.uuid: AppUtils.loginUserModel?.uuid,
        ModelKeys.formId: formId,
        ModelKeys.types: types,
      };
      var response = await MasterDataAPI.instance.getInheritListing(requestBody: requestBody);
      if (response.status) {
        final list = response.responseData?.inheritList ?? [];
        for (var item in list) {
          item.comparedValue = comparedValue;
        }
        emit(state.copyWith(inheritList: []));
        emit(state.copyWith(isLoading: false, inheritList: response.responseData?.inheritList ?? []));
      } else {
        emit(state.copyWith(
          isLoading: false,
        ));
        AppUtils.showFormErrorSnackBar(msg: response.message);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      AppUtils.showFormErrorSnackBar(msg: AppConstants.somethingWentWrong);
    }
  }

  void onBackButtonClick() {
    try {
      emit(state.copyWith(
        currentSectionCount: (state.currentSectionCount ?? 0) - 1,
        totalSectionCount: state.totalSectionCount,
      ));
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  void onGalleryReordered({required Map<DateTime, String>? filesMap, required int oldIndex, required int newIndex}) {
    try {
      var element = state.imageModelList?.removeAt(oldIndex);
      state.imageModelList?.insert(newIndex, element);

      // Update displayOrder for each item
      for (int i = 0; i < (state.imageModelList?.length ?? 0); i++) {
        (state.imageModelList ?? [])[i]?.displayOrder = i;
      }

      emit(state.copyWith(imageModelList: state.imageModelList));
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  Future<DynamicAddListingResponseModel?> onNextButtonClick({
    int? imageControlID,
    bool isFromSubmitButton = false,
    bool isUpdatingFile = false,
    bool isFromResumeUpload = false,
    bool? isListingEditing = false,
  }) async {
    // Perform validation for only the current section
    (bool, String) isValid = await ListingFormValidationUtils.checkValidations(
      formData: state.formDataMap,
      category: state.category,
      currentFormIndex: state.currentSectionCount ?? 0,
      section: state.sections,
    );

    if (!isValid.$1) {
      // Show error and stop execution if validation fails
      AppUtils.showFormErrorSnackBar(msg: isValid.$2);
      return null;
    }

    DynamicAddListingResponseModel? response;

    // Clear active snackBars
    snackBarKey.currentState?.clearSnackBars();

    // Ensure business logo is uploaded (if required)
    bool result = isUpdatingFile ? true : await checkBusinessLogoUploaded();

    if (!result) return null;

    // Get fields only from the current section
    List<InputFields>? currentSectionFields = state.sections
        ?.where((s) => s.index == state.currentSectionCount)
        .expand((s) => s.inputFields ?? [])
        .cast<InputFields>()
        .toList();

    if (currentSectionFields == null) return null;

    // Fetch values from formData
    String? businessPhone = state.formDataMap?[AddListingFormConstants.phoneNumber]?.trim();
    String? countryCode = state.formDataMap?[FormFieldType.phoneCountryCode.value] ?? '';
    String? websiteUrl = state.formDataMap?[AddListingFormConstants.businessWebsite] ?? '';
    String? listingTitle = state.formDataMap?[AddListingFormConstants.listingTitle] ?? '';
    String? email = state.formDataMap?[AddListingFormConstants.contactEmail] ?? '';
    String? listingDateRange =
        '${state.formDataMap?[AddListingFormConstants.endDate] ?? ''},${state.formDataMap?[AddListingFormConstants.listingDateRange] ?? ''}';
    String? timeRange = state.formDataMap?[AddListingFormConstants.inspectionTime] ?? '';
    String? estimatedSalary = state.formDataMap?[AddListingFormConstants.estimatedSalary] ??
        state.formDataMap?[AddListingFormConstants.priceRange] ??
        '';

    //  Section-wise Phone Number Validation
    for (var field in currentSectionFields) {
      if (field.type == FormFieldType.phoneNumber.value) {
        if (businessPhone != null && businessPhone.isNotEmpty) {
          bool isValidPhone = checkPhoneNo(businessPhone, countryCode ?? '');
          if (!isValidPhone) {
            AppUtils.showSnackBar(AppConstants.validMobileStr, SnackBarType.fail);
            return null;
          }
        }
      }

      //  Section-wise Website Validation
      if (field.controlName == AddListingFormConstants.businessWebsite) {
        if (websiteUrl != null && websiteUrl.isNotEmpty) {
          final RegExp urlPattern = RegExp(
              r'^(https?:\/\/)?(www\.)?([a-zA-Z0-9-]+)(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})(\/[a-zA-Z0-9\-._~:/?#[\]@!$&\()*+,;=]*)?$',
          caseSensitive: false,);
          if (!urlPattern.hasMatch(websiteUrl)) {
            AppUtils.showSnackBar(AppConstants.invalidWebsite, SnackBarType.fail);
            return null;
          }
        }
      }

      final titleField = currentSectionFields.firstWhere(
          (field) => field.controlName == AddListingFormConstants.listingTitle,
          orElse: () => InputFields());
      if (listingTitle?.isNotEmpty??false) {
        if (!FormValidationRegex.businessRegex.hasMatch(listingTitle??'')) {
          final label = titleField.label ?? '';
          AppUtils.showSnackBar('${AppConstants.validStr} $label', SnackBarType.fail);
          return null;
        }
      }

      //  Section-wise Email Validation
      if (field.controlName == AddListingFormConstants.contactEmail) {
        if (email != null && email.isNotEmpty) {
          final RegExp emailPattern = RegExp(
            r'^(?![-_.])([a-zA-Z0-9]+[._%+-]?)+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,}(?:\.[a-zA-Z]{2,})?$',
            caseSensitive: false,
          );

          if (!emailPattern.hasMatch(email)) {
            AppUtils.showSnackBar(AppConstants.emailValidationStr, SnackBarType.fail);
            return null;
          }
        }
      }
      // Section-wise Email Validation
      if (field.controlName == AddListingFormConstants.estimatedSalary ||
          field.controlName == AddListingFormConstants.priceRange) {
        if (estimatedSalary != null &&
            estimatedSalary.isNotEmpty &&
            estimatedSalary.contains(',')) {
          final parts = estimatedSalary.split(',');
          if (parts.length == 2) {
            final minValue = parts[0].trim();
            final maxValue = parts[1].trim();

            final min = double.tryParse(minValue);
            final max = double.tryParse(maxValue);

            if (min != null && max != null && min > max) {
              AppUtils.showSnackBar(
                AppConstants.minMaxPriceValidation.replaceAll('{salary}', field.label??''),
                SnackBarType.fail,
              );
              return null;
            }
          }
        }
      }

      if (field.type == FormFieldType.timeRange.value) {
        if (timeRange != null && timeRange.isNotEmpty && timeRange.contains(',')) {
          final parts = timeRange.split(',');
          if (parts.length == 2) {
            final startStr = parts[0].trim();
            final endStr = parts[1].trim();

            final format = DateFormat('HH:mm'); // For example: 11:14 AM
            try {
              final start = format.parse(startStr);
              final end = format.parse(endStr);

              if (start.isAfter(end)) {
                AppUtils.showSnackBar(
                  '${AppConstants.validStr} ${field.label}',
                  SnackBarType.fail,
                );
                return null;
              }
            } catch (e) {
              if (kDebugMode) print('Time parse error: ${e.toString()}');
              AppUtils.showSnackBar(
                'Invalid time format for ${field.label}',
                SnackBarType.fail,
              );
              return null;
            }
          }
        }
      }

      if (field.controlName == AddListingFormConstants.listingDateRange) {
        if (!_validateDateRange(listingDateRange, field.label ?? '')) return null;
      }
    }

    //  API Call if all validations pass
    response = await handleAPICall(
      formID: formID ?? 0,
      isFromSubmitButton: isFromSubmitButton,
      isUpdatingFile: isUpdatingFile,
      categoryName: state.category.formName ?? '',
    );

    return response;
  }

  bool _validateDateRange(String combinedValue, String label) {
    if (combinedValue.isNotEmpty && combinedValue.contains(',')) {
      final parts = combinedValue.split(',');
      if (parts.length == 2) {
        final start = DateTime.tryParse(parts[0].trim());
        final end = DateTime.tryParse(parts[1].trim());

        if (start != null && end != null && start.isAfter(end)) {
          AppUtils.showSnackBar('${AppConstants.validStr} $label', SnackBarType.fail);
          return false;
        }
      }
    }
    return true;
  }

  //Used to check phone number.
  bool checkPhoneNo(String businessPhone, String countryCode) {
    var country = myCountryList.where((element) => element.code.toUpperCase() == countryCode.toUpperCase()).toList();

    if (country.isEmpty) {
      return false;
    }

    var minLength = country.first.minLength;
    var maxLength = country.first.maxLength;

    final RegExp mobilePattern = RegExp(r'^\d+$'); // Only digits
    if (!mobilePattern.hasMatch(businessPhone)) {
      return false;
    } else if (businessPhone.length < minLength || businessPhone.length > maxLength) {
      return false;
    } else {
      return true;
    }
  }

  //Used to check phone number.
  bool checkPhoneNoWhenEdit(String businessPhone, countryCode) {
    var country =
        myCountryList.where((element) => '+${element.dialCode.toUpperCase()}' == countryCode.toUpperCase()).toList();
    if (country.isEmpty) {
      // Check for empty list instead of null
      return false;
    }
    var minLength = country.first.minLength;
    var maxLength = country.first.maxLength;

    final RegExp mobilePattern = RegExp(r'^\d+$'); // Only digits
    if (!mobilePattern.hasMatch(businessPhone)) {
      return false;
    } else if (businessPhone.length < minLength || businessPhone.length > maxLength) {
      return false;
    } else {
      return true;
    }
  }

  void showLoading() {
    emit(state.copyWith(isBusinessLogoUploading: true));
  }

  void onFieldsValueChanged({String? key, dynamic value, Map<String, String?>? keysValuesMap}) {
    try {
      Map<String, dynamic>? oldFormData = state.formDataMap;
      oldFormData ??= {};

      /// Update the map of form Data for one value
      if (keysValuesMap?.isEmpty ?? true) {
        if ((value is String? && (value?.trim().isEmpty ?? true)) || value == null) {
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
          if(value == null){
            /// if keysValuesMap is null then changed are made to single field only which is the only case a filed can be cleared
            /// So removing the key for formData map if the value is null
            oldFormData?.remove(key);
          } else {
            /// If value is not empty then updating the value.
            oldFormData?.update(key, (_) => value, ifAbsent: () => value);
          }
        });
      }
      emit(state.copyWith(formDataMap: oldFormData));
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      emit(state.copyWith());
    }
  }

  Future<void> onUploadResume({
    required String imageControlLabel,
    required int imageControlID,
    required String key,
    required String filePath,
  }) async {
    try {
      //  if (key == AddListingFormConstants.uploadResume) {
      Map<String, dynamic>? oldFormData = state.formDataMap ?? {};
      emit(state.copyWith(isBusinessLogoUploading: true));

      oldFormData.update(key, (_) {
        return filePath;
      }, ifAbsent: () => filePath);
      this.imageControlID = imageControlID;
      (String?, File?, String?)? imageData;
      if (state.apiResultId != null) {
        emit(state.copyWith(apiResultId: state.apiResultId, isLoading: true));
        imageData = await uploadImage(state.category, filePath, false);
      } else {
        var response =
            await onNextButtonClick(isFromSubmitButton: false, isUpdatingFile: true, isFromResumeUpload: true);
        emit(state.copyWith(apiResultId: response?.result.listingId));
        imageData = await uploadImage(state.category, filePath, false);
      }
      if (imageData == null) {
        emit(state.copyWith(formDataMap: oldFormData, isBusinessLogoUploading: false, resumeUploadURL: pdfFilePath));
        return;
      }
      onFieldsValueChanged(key: key, value: imageData.$1);

      await onNextButtonClick(isFromSubmitButton: false, isUpdatingFile: true, isFromResumeUpload: true);
      state.formDataMap?[AddListingFormConstants.uploadResume] = imageData.$1;

      String? path = imageData.$1;
      String businessLogo = '${ApiConstant.imageBaseUrl}$path';

      emit(state.copyWith(formDataMap: oldFormData, isBusinessLogoUploading: false, resumeUploadURL: businessLogo));
      //  }
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  Future<void> onResumeDeleted({required String key, required String imagePath}) async {
    try {
      ReusableWidgets.showConfirmationDialog(
        AppConstants.appTitleStr, // Dialog title
        AppConstants.confirmDeleteMessageFilePDF,
        () async {
          navigatorKey.currentState?.pop();
          state.formDataMap?[key] = '';
          await onNextButtonClick(isFromSubmitButton: false, isUpdatingFile: true);
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));

      if (kDebugMode) {
        print('AddListingFormCubit.onFieldsImageDeleted--->${e.toString()}');
        AppUtils.showSnackBar(AppConstants.somethingWentWrong, SnackBarType.fail);
      }
    }
  }

  void onJobRequirementSet(BusinessProfileModel? model) {
    try {
      List<JobRequirements> jobRequirement = [];
      model?.jobRequirements?.forEach((item) {
        JobRequirements jobRequirementModel = JobRequirements(
            jobRequirementId: item.jobRequirementId,
            jobRequirement: item.jobRequirement,
            displayOrder: item.displayOrder ?? 0,
            isDeleted: item.isDeleted);
        jobRequirement.add(jobRequirementModel);
      });
      state.formDataMap?[AddListingFormConstants.jobRequirementsBulletPoint] = jobRequirement;
      emit(state.copyWith(jobRequirementList: jobRequirement));
    } catch (e) {
      if (kDebugMode) {
        print('AddListingFormCubit.onJobRequirementSet ----- >> ${e.toString()}');
      }
    }
  }

  Future<void> onFieldsImagesChanged({
    required int? imageControlID,
    required String? imageControlLabel,
    required String key,
    required String imagePath,
    bool? multiImageSupported,
  }) async {
    try {
      if (imageControlID != null) {
        this.imageControlID = imageControlID;
      }
      if (key == AppConstants.profile) {
        Map<String, dynamic>? oldFormData = state.formDataMap ?? {};
        if (multiImageSupported ?? false) {
          oldFormData.update(key, (_) {
            /// allImagesData = {photos:{12-10-2024:Some string,12-20-2022:Some String}}
            Map<DateTime, String> allImagesData = oldFormData[key];
            allImagesData.addAll(AddListingFormUtils.setSelectedImage(imageUrl: imagePath));
            return allImagesData;
          }, ifAbsent: () {
            return AddListingFormUtils.setSelectedImage(imageUrl: imagePath);
          });
        } else {
          oldFormData.update(key, (_) {
            return imagePath;
          }, ifAbsent: () => imagePath);
        }
        emit(state.copyWith(isLoading: true));

        (String?, File?, String?)? imageData = await uploadImage(state.category, imagePath, true);

        if (imageData == null) {
          return;
        }
        state.formDataMap?[AddListingFormConstants.uploadHomePageLogo] = imageData.$1;
        String? path = imageData.$1;
        // String businessLogo = '${ApiConstant.homeLogoimageBaseUrl}$path';
        String businessLogo = '$path';

        state.formDataMap?[imageControlLabel ?? AddListingFormConstants.uploadHomePageLogo] = imageData.$1;

        /// After uploading image to blob updating the image in our database
        /// by calling update API.
        DynamicAddListingResponseModel? updateApiResData;
        updateApiResData = await onNextButtonClick(isFromSubmitButton: false, isUpdatingFile: true);

        if (updateApiResData != null) {
          emit(state.copyWith(formDataMap: oldFormData, businessLogo: businessLogo, isLoading: false));
        }
      } else {
        Map<String, dynamic>? oldFormData = state.formDataMap;
        oldFormData ??= {};
        state.imageModelList ??= [];
        state.imageModelList?.add(BusinessImagesModel(fileLocalPath: imagePath, displayOrder: 0));
        await handleImageUpload(state.category, imagePath, state.imageModelList?.length ?? 0);
        emit(state.copyWith(formDataMap: oldFormData));
      }
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  List<Sections> updateInputTypeValueById(List<Sections> sections, int inputTypeId, String newValue) {
    for (var section in sections) {
      for (var inputType in section.inputFields ?? []) {
        if (inputType?.id == inputTypeId) {
          inputType.value = newValue;
          return sections; // Exit once updated
        }
      }
    }
    return sections;
  }

  Future<void> onFieldsImageDeleted({
    int? imageControlID,
    String? imageControlLabel,
    required String key,
    required String imagePath,
    bool? multiImageSupported,
  }) async {
    try {
      ReusableWidgets.showConfirmationDialog(
        AppConstants.appTitleStr, // Dialog title
        AppConstants.confirmDeleteMessage,
        () async {
          navigatorKey.currentState?.pop();
          emit(state.copyWith(isLoading: true));

          /// user is deleting logo so removing also from state variable
          String? businessLogo = state.businessLogo;
          if (key == AddListingFormConstants.uploadHomePageLogo) {
            businessLogo = '';
            state.formDataMap?.remove(key);
            state.formDataMap?[imageControlLabel ?? ''] = '';
            state.businessLogo = '';
            updateInputTypeValueById(sections, imageControlID ?? 0, '');
          }

          List<Map<String, dynamic>> imageListMp = [];

          // Create the image map with the current index as display order

          state.imageModelList?.forEach((item) {
            if (item?.fileName == imagePath) {
              // Update the specific item's properties as required
              item?.displayOrder = (item.displayOrder ?? 0) + 1;
              item?.isDeleted = true; // Assuming you want to set isDeleted to true
            }

            Map<String, dynamic> imageMap;
            String? result = item?.fileName; //.replaceFirst(ApiConstant.imageBaseUrl, '');
            print('ImagePath$result');
            imageMap = {
              ModelKeys.id: item?.id,
              ModelKeys.fileName: result,
              ModelKeys.fileType: item?.fileType,
              ModelKeys.displayOrder: (item?.displayOrder ?? 0) + 1,
              // Use index for display order
              ModelKeys.isDeleted: item?.fileName == imagePath,
            };

            ///adding into image list
            imageListMp.add(imageMap);
          });

          if (multiImageSupported == false) {
            state.formDataMap?.remove(key);
          }

          DynamicAddListingResponseModel? updateApiResData;
          updateApiResData = await onNextButtonClick(isFromSubmitButton: false, isUpdatingFile: true);
          if (updateApiResData != null) {
            /// remove image locally from list
            state.imageModelList?.removeWhere((test) => test?.fileName == imagePath);
            emit(state.copyWith(isLoading: false, businessLogo: businessLogo));
          }
          /*} else {
            AppUtils.showSnackBar(AppConstants.somethingWentWrong, SnackBarType.fail);
            emit(state.copyWith(isLoading: false));
          }*/
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));

      if (kDebugMode) {
        print('AddListingFormCubit.onFieldsImageDeleted--->${e.toString()}');
        AppUtils.showSnackBar(
          AppConstants.somethingWentWrong,
          SnackBarType.fail,
        );
      }
    }
  }

  Future<void> fetchCountry() async {
    try {
      var response = await PreferenceHelper.instance.getCountryList();
      if (response.statusCode == 200 && response.result != null) {
        emit(state.copyWith(countries: response.result));
      } else {
        emit(state.copyWith(countries: response.result ?? []));
      }
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      emit(state.copyWith(countries: []));
    }
  }

  Future<void> openDynamicDatePicker(BuildContext context, String label) async {
    DateTime now = DateTime.now();
    DateTime firstDate = now;
    DateTime lastDate = DateTime(2101);

    // Use selected date if available, else fallback to now
    String? selectedDateString = state.selectedDate;
    DateTime initialDate = now;

    if (selectedDateString != null && selectedDateString.isNotEmpty) {
      try {
        initialDate = DateTime.parse(selectedDateString);
      } catch (_) {
        // fallback to now if parsing fails
        initialDate = now;
      }
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
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
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      emit(state.copyWith(selectedDate: formattedDate));

      onFieldsValueChanged(
        key: label,
        value: formattedDate,
      );
    }
  }

  Future<void> openDatePicker(
    BuildContext context, {
    required bool hasStartEndDate,
    bool isFromStartDate = false,
    String? key,
    bool isTodayRequired = false,
    DateTime? initialDate,
  }) async {
    final DateTime now = DateTime.now();

    if (!hasStartEndDate) {
      // Single date selection
      String? formattedDate;

      final DateTime firstDate = DateTime(now.year, now.month, now.day).add(Duration(days: isTodayRequired ? 0 : 1));
      final DateTime lastDate = firstDate.add(const Duration(days: 29));

      final DateTime pickedInitialDate = state.selectedInspectionDate ?? initialDate ?? firstDate;

      DateTime adjustedInitialDate = pickedInitialDate;
      if (pickedInitialDate.isBefore(firstDate)) {
        adjustedInitialDate = firstDate;
      } else if (pickedInitialDate.isAfter(lastDate)) {
        adjustedInitialDate = lastDate;
      }

      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: adjustedInitialDate,
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
        formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        emit(state.copyWith(
          selectedInspectionDate: pickedDate,
          selectedDate: formattedDate,
        ));
        onFieldsValueChanged(
          key: AddListingFormConstants.selectYourDate,
          value: formattedDate,
        );
      }
    } else {
      // Start and end date selection
      String? formattedStartDate;
      String? formattedEndDate;

      final DateTime? selectedStartDate = state.startDate != null
          ? DateTime.tryParse(state.startDate!)
          : (state.formDataMap?[AddListingFormConstants.startDate] != null
              ? DateTime.tryParse(state.formDataMap![AddListingFormConstants.startDate]!)
              : null);

      final DateTime? selectedEndDate = state.endDate != null
          ? DateTime.tryParse(state.endDate!)
          : (state.formDataMap?[AddListingFormConstants.endDate] != null
              ? DateTime.tryParse(state.formDataMap![AddListingFormConstants.endDate]!)
              : null);

      final DateTime pickedInitialDate = isFromStartDate
          ? (selectedStartDate ?? now)
          : (selectedEndDate ?? selectedStartDate?.add(const Duration(days: 1)) ?? now.add(const Duration(days: 1)));

      DateTime firstDate = isFromStartDate ? now : (selectedStartDate?.add(const Duration(days: 1)) ?? now);

      DateTime lastDate;

      if (isFromStartDate) {
        if (selectedEndDate != null) {
          lastDate = selectedEndDate.subtract(const Duration(days: 1));
        } else {
          lastDate = now.add(const Duration(days: 7));
        }
      } else {
        lastDate = DateTime(2101);
      }

      DateTime adjustedInitialDate = pickedInitialDate;
      if (pickedInitialDate.isBefore(firstDate)) {
        adjustedInitialDate = firstDate;
      } else if (pickedInitialDate.isAfter(lastDate)) {
        adjustedInitialDate = lastDate;
      }

      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: adjustedInitialDate,
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
        if (isFromStartDate) {
          formattedStartDate = DateFormat('yyyy-MM-dd').format(pickedDate);

          // Auto assign endDate only if it's not set
          if (selectedEndDate == null) {
            final DateTime newEndDate = pickedDate.add(const Duration(days: 7));
            formattedEndDate = DateFormat('yyyy-MM-dd').format(newEndDate);

            emit(state.copyWith(
              startDate: formattedStartDate,
              endDate: formattedEndDate,
            ));

            onFieldsValueChanged(key: AddListingFormConstants.startDate, value: formattedStartDate);
            onFieldsValueChanged(key: AddListingFormConstants.endDate, value: formattedEndDate);
          } else {
            emit(state.copyWith(startDate: formattedStartDate));
            onFieldsValueChanged(key: AddListingFormConstants.startDate, value: formattedStartDate);
          }
        } else {
          formattedEndDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          emit(state.copyWith(endDate: formattedEndDate));
          onFieldsValueChanged(key: AddListingFormConstants.endDate, value: formattedEndDate);
        }
      }
    }
  }

  Future<void> selectTime({
    required BuildContext context,
    TimeOfDay? timeOfDay,
    required bool isStartTime,
    String? formKey,
  }) async {
    TimeOfDay? startTime = TimeOfDay.now();
    TimeOfDay? endTime = timeOfDay;
    String? formattedStartTime;
    String? formattedEndTime;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? startTime : (endTime ?? TimeOfDay.now()),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.whiteColor,
              onSurface: AppColors.blackColor,
              secondary: AppColors.primaryColor,
              onSecondary: AppColors.whiteColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      if (isStartTime) {
        startTime = pickedTime;
        formattedStartTime = AppUtils.formatTime24HrHHMM(startTime);
        // endTime = _addOneHour(pickedTime);
        // formattedEndTime = AppUtils.formatTime(endTime);
        emit(state.copyWith(startTime: formattedStartTime));
        onFieldsValueChanged(key: formKey, value: formattedStartTime);
      } else {
        // Ensure end time is greater than start time
        if (pickedTime.hour < startTime.hour ||
            (pickedTime.hour == startTime.hour && pickedTime.minute <= startTime.minute)) {
          // Show a message or handle it however you need
          return AppUtils.showSnackBar('End time must be greater than the start time.', SnackBarType.fail);
        }

        formattedEndTime = AppUtils.formatTime24HrHHMM(pickedTime);
        emit(state.copyWith(endTime: formattedEndTime));
        onFieldsValueChanged(key: formKey, value: formattedEndTime);
      }
    }
  }

  Future<void> openDateFromPicker(
    BuildContext context, {
    String? key,
    DateTime? initialDate,
  }) async {
    String? formattedDate;
    final DateTime now = DateTime.now();
    DateTime firstDate = DateTime(1970, 1, 1);
    DateTime lastDate = DateTime(2100);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
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
      formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      onFieldsValueChanged(key: key, value: formattedDate);
    }
  }

  Future<void> selectTimeFromPicker({required BuildContext context, TimeOfDay? timeOfDay, String? formKey}) async {
    TimeOfDay? startTime = timeOfDay ?? TimeOfDay.now();
    String? formattedStartTime;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.whiteColor,
              onSurface: AppColors.blackColor,
              secondary: AppColors.primaryColor,
              onSecondary: AppColors.whiteColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      formattedStartTime = AppUtils.formatTime24HrHHMM(pickedTime);
      onFieldsValueChanged(key: formKey, value: formattedStartTime);
    }
  }

  // Add 1 hour to the selected start time
  TimeOfDay _addOneHour(TimeOfDay time) {
    int hour = time.hour + 1;
    if (hour >= 24) {
      hour -= 24; // Handle overflow to the next day
    }
    return TimeOfDay(hour: hour, minute: time.minute);
  }

  Future<void> addJobRequirement({
    required String jobRequirementBulletPoint,
    required int jobRequirementId,
  }) async {
    if (jobRequirementBulletPoint.trim().isEmpty) {
      return;
    }

    try {
      // Get the existing job requirements as a list of strings
      String existingRequirements = state.formDataMap?[AddListingFormConstants.jobRequirementsBulletPoint] ?? '';

      List<String> jobRequirementList =
          existingRequirements.isNotEmpty ? existingRequirements.split(',').map((e) => e.trim()).toList() : [];

      // Check for duplicates
      String newRequirement = jobRequirementBulletPoint.trim();
      if (jobRequirementList.contains(newRequirement)) {
        AppUtils.showSnackBar(AppConstants.jobRequirementExists, SnackBarType.alert);
        return;
      }

      // Add the new requirement
      jobRequirementList.add(newRequirement);

      // Convert list to comma-separated string
      String jobRequirementsString = jobRequirementList.join(', ');

      // Update the form data map
      onFieldsValueChanged(
        key: AddListingFormConstants.jobRequirementsBulletPoint,
        value: jobRequirementsString,
      );

      // Emit the updated state
      emit(state.copyWith(
        formDataMap: {
          ...state.formDataMap ?? {},
          AddListingFormConstants.jobRequirementsBulletPoint: jobRequirementsString
        },
      ));
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  Future<void> removeJobRequirement({
    required String jobRequirementBulletPoint,
    required String controlName,
  }) async {
    try {
      // Get the existing job requirements as a comma-separated string
      String existingRequirements = state.formDataMap?[AddListingFormConstants.jobRequirementsBulletPoint] ?? '';

      // Convert the string into a list
      List<String> jobRequirementList =
          existingRequirements.isNotEmpty ? existingRequirements.split(',').map((e) => e.trim()).toList() : [];

      // Remove only the first occurrence
      jobRequirementList.remove(jobRequirementBulletPoint.trim());

      // Convert list back to a comma-separated string
      String jobRequirementsString = jobRequirementList.join(', ');

      // Update the form data map
      onFieldsValueChanged(
        key: AddListingFormConstants.jobRequirementsBulletPoint,
        value: jobRequirementsString,
      );
      // Update the form data map
      onFieldsValueChanged(
        key: controlName,
        value: jobRequirementsString,
      );

      // Emit the updated state
      emit(state.copyWith(
        formDataMap: {
          ...state.formDataMap ?? {},
          AddListingFormConstants.jobRequirementsBulletPoint: jobRequirementsString
        },
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  void setStartAndEndDateFromString(String dateRangeString) {
    if (dateRangeString.contains(',')) {
      final parts = dateRangeString.split(',');

      if (parts.length == 2) {
        final start = DateTime.tryParse(parts[0].trim());
        final end = DateTime.tryParse(parts[1].trim());

        if (start != null && end != null) {
          final formattedStart = start.toIso8601String();
          final formattedEnd = end.toIso8601String();

          emit(state.copyWith(
            startDate: formattedStart,
            endDate: formattedEnd,
          ));

          onFieldsValueChanged(
            key: AddListingFormConstants.startDate,
            value: formattedStart,
          );
          onFieldsValueChanged(
            key: AddListingFormConstants.endDate,
            value: formattedEnd,
          );
        }
      }
    }
  }


  Future<void> selectedDateTime() async {
    // Current date and time
    DateTime now = DateTime.now();

    // Calculate end date (30 days from now)
    // DateTime endDate = now.add(const Duration(days: 30));

    // Calculate time 24 hours from now
    DateTime timePlus24Hours = now.add(const Duration(hours: 24));
    TimeOfDay timeAfter24Hours = TimeOfDay(hour: timePlus24Hours.hour, minute: timePlus24Hours.minute);

    // Format end date and time
    String formattedDate = DateFormat('yyyy-MM-dd').format(timePlus24Hours); // e.g., "2024-12-19"
    String formattedEndTime = AppUtils.formatTime24Hr(timeAfter24Hours); // Ensure AppUtils supports TimeOfDay

    // Update fields and state
    onFieldsValueChanged(
      keysValuesMap: {
        AddListingFormConstants.selectYourDate: formattedDate,
        AddListingFormConstants.selectTime: formattedEndTime,
      },
    );
    emit(state.copyWith(endTime: formattedEndTime, selectedDate: formattedDate));
  }

  Future<List<Map<String, dynamic>>> handleImageUpload(
    CategoriesListResponse? currentCategory,
    String fileLocalPath,
    int listSize,
  ) async {
    List<Map<String, dynamic>> imageListMp = [];

    try {
      emit(state.copyWith(isLoading: true));

      /// Iterate through each entry in the imageFile map

      if (fileLocalPath.isNotEmpty) {
        (String?, File?, String?)? azureData = await uploadImage(currentCategory, fileLocalPath, false);
        // File? renamedFile = azureData?.$2;
        String? blobPath = azureData?.$1;

        int fileType = 0;
        // Determine the file type
        if (AppUtils.isImageFile(fileLocalPath)) {
          fileType = 1;
        } else if (AppUtils.isVideoFile(fileLocalPath)) {
          fileType = 2;
        }

        // Create the image map with the current index as display order
        state.imageModelList?.last = BusinessImagesModel(
          id: 0,
          fileName: blobPath,
          fileType: fileType,
          displayOrder: (state.imageModelList?.length ?? 0),
          isDeleted: false,
        );

        if (listSize == state.imageModelList?.length) {
          print('Upload complete for file: $fileLocalPath');
          await onNextButtonClick(isFromSubmitButton: false, isUpdatingFile: true);
        }
        if (kDebugMode) print('Upload complete for file: $fileLocalPath');
      } else {
        emit(state.copyWith(isLoading: false));
        if (kDebugMode) print('File path is null or not found');
      }
    } catch (err) {
      emit(state.copyWith(isLoading: false));
      if (kDebugMode) {
        print('_BusinessImagesFormViewState.uploadImageToAzure-print-----   $err');
      }
    }
    List<Map<String, dynamic>> nonDeletedImages = imageListMp.where((image) => !image[ModelKeys.isDeleted]).toList();

    return nonDeletedImages;
  }

  Future<(String?, File?, String?)?> uploadImage(
      CategoriesListResponse? currentCategory, String fileLocalPath, bool isHomeLogo) async {
    try {
      ///Renaming file to timestamp with extension
      File? renamedFile = await AppUtils.renameFileWithTimestamp(File(fileLocalPath));

      /// Determine the content type of the file

      Map<String, dynamic> requestBody = {
        ModelKeys.listingId: state.apiResultId,
        ModelKeys.formId: formID ?? '',
        ModelKeys.controlId: imageControlID,
      };

      var response = await AddListingFormRepository.instance.uploadImageVideo(requestBody, renamedFile);

      var blobPath = response.responseData?.result?.fileName ?? '';

      return (blobPath, renamedFile, blobPath);
    } catch (e) {
      if (kDebugMode) print('AddListingFormCubit.uploadToAzure--$e');

      return null;
    }
  }

  /// used in extracting file name to display in resume text field
  String extractFileName(String filePath) {
    // Extract the file name without the extension
    String fileNameWithExtension = filePath.split('/').last;
    return fileNameWithExtension;
  }

  Future<void> businessDataDisplay({required BusinessProfileDetailResponse? businessDetailsResponse}) async {
    try {
      final businessDetails = businessDetailsResponse?.businessProfileModel;

      List<BusinessImagesModel?>? imageModelList = [];
      businessDetails?.images?.forEach((item) {
        BusinessImagesModel imageModel = BusinessImagesModel(
          id: item.id,
          fileName: item.fileName,
          displayOrder: item.displayOrder ?? 0,
          fileType: item.fileType,
        );

        ///adding into image list
        imageModelList.add(imageModel);
      });

      latitude = businessDetails?.latitude;
      longitude = businessDetails?.longitude;
      // Set each field's value
      Map<String, String?> initialValuesMap = await ListingFormRepoHelper.getFormConstantsToModelMap(
        state: state,
        businessDetailsResponse: businessDetailsResponse,
      );
      onFieldsValueChanged(keysValuesMap: initialValuesMap);
      if (state.category.formName == AddListingFormConstants.job) {
        onJobRequirementSet(businessDetails);
      }
      if (state.category.formName == AddListingFormConstants.auto) {
        await getAutoType();
      }
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(
        imageModelList: imageModelList,
        businessLogo: businessDetails?.getListingIdOrLogo(categoryName: state.category.formName).itemLogo,
        selectedSkills: state.selectedSkills,
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Error in businessDataDisplay: $e');
      }
    }
  }

  Future<void> businessListDisplay() async {
    try {
      String? categoryName = state.category.formName ?? '';
      var categoryData = await PreferenceHelper.instance.getCategoryList();
      var matchedCategory = categoryData.result?.firstWhere(
        (category) => category.formName == categoryName,
      );

      int? businessCategoryId = matchedCategory?.formId ?? 0;

      var response = await AddListingFormRepository.instance.getBusinessOfCategory(
        path: '${ApiConstant.allCategoryBusinessList}$businessCategoryId',
      );

      List<BusinessListResult> businessList = [];
      if (response.responseData != null) {
        businessList = response.responseData?.result ?? [];
      }
      emit(state.copyWith(businessListResult: businessList));
    } catch (e) {
      if (kDebugMode) {
        print('Error in businessDataDisplay: $e');
      }
    }
  }

  Future<void> communityListDisplay({
    bool? isListingEditing = false,
    int totalCount = 0,
    int itemId = 0,
  }) async {
    try {
      // Fetch the list of businesses for the given category
      var response = await AddListingFormRepository.instance.getBusinessOfCategory(
        path: ApiConstant.allCategoryCommunityList,
      );
      List<BusinessListResult> communityListResult = [];
      if (response.responseData != null) {
        communityListResult = response.responseData?.result ?? [];
      }
      if (isListingEditing == true) {
        emit(state.copyWith(
          isLoading: false,
          isUpdatingInitialData: false,
          fetchBusinessDetails: businessDetails,
          currentSectionCount: 1,
          totalSectionCount: totalCount,
          apiResultId: itemId,
          communityListResult: communityListResult,
        ));
      } else {
        emit(state.copyWith(communityListResult: communityListResult));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in businessDataDisplay: $e');
      }
    }
  }

  Future<void> businessTypeDisplay() async {
    try {
      // Fetch the list of businesses for the given category
      var response = await MasterDataAPI.instance.getAllBusinessType();
      List<BusinessTypeResult> businessTypeResult = [];
      if (response.responseData != null) {
        businessTypeResult = response.responseData?.result ?? [];
      }
      emit(state.copyWith(businessTypeResult: businessTypeResult));
    } catch (e) {
      if (kDebugMode) {
        print('Error in businessDataDisplay: $e');
      }
    }
  }

  Future<void> communityTypeDisplay() async {
    try {
      // Fetch the list of businesses for the given category
      var response = await MasterDataAPI.instance.getAllCommunityListingType();
      List<CommunityListingTypeResult> communityTypeResult = [];
      if (response.responseData != null) {
        communityTypeResult = response.responseData?.result ?? [];
      }
      emit(state.copyWith(communityListingTypeResult: communityTypeResult));
    } catch (e) {
      if (kDebugMode) {
        print('Error in businessDataDisplay: $e');
      }
    }
  }

  /// Handle API Calls
  Future<DynamicAddListingResponseModel?> handleAPICall({
    int? imageControlID,
    int formID = 0,
    bool isFromSubmitButton = false,
    bool isUpdatingFile = false,
    String categoryName = '',
  }) async {
    // Enabling the loader


    // Getting the respective request body
    Map<String, dynamic> requestBody = await ListingFormRepoHelper.getDynamicFormData(
        state: state, isFromSubmitButton: isFromSubmitButton, formID: formID, recordStatusID:  recordStatusID ?? 0);

    // if item already created then data will submit at last submit button click.
    // Also checking file is updating or not
    if(state.apiResultId != null && state.apiResultId != 0 && !isFromSubmitButton && recordStatusID != RecordStatus.draft.value ){
      if(!isUpdatingFile) {
        emit(state.copyWith(currentSectionCount: (state.currentSectionCount ?? 0) + 1,isLoading: false));
      }else{
        emit(state.copyWith(isLoading: false));
      }
      return null;
    }
    emit(state.copyWith(isLoading: true));
    /// Adding keys which are common to every category
    // requestBody.addAll(ListingFormRepoHelper.getCommonMap(state: state, isFromSubmitButton: isFromSubmitButton));
    ResponseWrapper<DynamicAddListingResponseModel?> response;

    //  if (state.apiResultId == null) {
    response = await AddListingFormRepository.instance.postAddListingData(
      path: ApiConstant.addListingApi,
      requestBody: requestBody,
    );
    if (response.status) {
      var sections = state.sections ?? [];
      var responseSections = response.responseData?.result.sections ?? [];

      ///Here assign controlValue to existing sections inputType filed.
      sections = updateInputTypeFieldsFromResponse(sections, responseSections);

      /// Closing the loader after success
      if (isFromSubmitButton) {
        /// Trigger navigation pop if from submit button
        AppUtils.showSnackBar('$categoryName ${response.message}', SnackBarType.success);

        /// If user come from detail screen for edit that time only pop screen, not open details screen again.
        if (state.isListingEditing) {
          navigatorKey.currentState?.pop(AppConstants.needToRefresh);
        }else {
          moveToItemDetailsScreen(response);
        }

      } else {
        if (!isUpdatingFile) {
          emit(state.copyWith(
              currentSectionCount: (state.currentSectionCount ?? 0) + 1,
              totalSectionCount: state.totalSectionCount,
              apiResultId: response.responseData?.result.listingId,
              sections: sections,
              isLoading: false));
        } else {
          emit(state.copyWith(
              sections: sections, isLoading: false, imageModelList: response.responseData?.result.images ?? []));
        }
      }

    } else {
      // Handle API failure case (optional)
      emit(state.copyWith(
        isLoading: false,
      ));

      await AppUtils.showAlertDialog(
        navigatorKey.currentContext!,
        title: AppConstants.appTitleStr,
        description: response.message,
        confirmationText: AppConstants.okStr,
        onOkPressed: () {
          navigatorKey.currentState?.pop();
        },
      );
    }
    return response.responseData;
  }

  void getWorkerSkills() async {
    ResponseWrapper? response;
    try {
      response = await MasterDataAPI.instance.getWorkerSkills();
      if (response.status) {
        emit(state.copyWith(isLoading: false, skills: response.responseData));
      } else {
        emit(state.copyWith(isLoading: false));
        AppUtils.showFormErrorSnackBar(msg: response.message);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      AppUtils.showFormErrorSnackBar(msg: AppConstants.somethingWentWrong);
    }
  }

  Future<void> getCategoryType() async {
    ResponseWrapper? response;
    try {
      response = await MasterDataAPI.instance.getCategoryType();
      if (response.status) {
        emit(state.copyWith(isLoading: false, categoryType: response.responseData));
      } else {
        emit(state.copyWith(isLoading: false));
        AppUtils.showFormErrorSnackBar(msg: response.message);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      AppUtils.showFormErrorSnackBar(msg: AppConstants.somethingWentWrong);
    }
  }

  Future<void> getAllPropertyType() async {
    ResponseWrapper? response;
    try {
      response = await MasterDataAPI.instance.getAllPropertyType();
      if (response.status) {
        emit(state.copyWith(isLoading: false, propertyType: response.responseData));
      } else {
        emit(state.copyWith(isLoading: false));
        AppUtils.showFormErrorSnackBar(msg: response.message);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      AppUtils.showFormErrorSnackBar(msg: AppConstants.somethingWentWrong);
    }
  }

  Future<void> fetchCurrency() async {
    var countryData = await PreferenceHelper.instance.getCountryList();
    emit(state.copyWith(currencyList: countryData.result));
  }

  Future<void> getAutoType() async {
    try {
      var response = await MasterDataAPI.instance.getAutoType();
      List<AutoTypeList> autoTypeList = [];
      if (response.responseData != null) {
        autoTypeList = response.responseData?.autoTypeList ?? [];
      }
      emit(state.copyWith(autoTypeList: autoTypeList));
    } catch (e) {
      if (kDebugMode) {
        print('Error in businessDataDisplay: $e');
      }
    }
  }

  void onSkillSelected({
    required WorkerSkillsResult skill,
    required bool? isSelected,
    required String fieldLabel,
  }) {
    try {
      // 1. Initialize oldSkills from selectedSkills or from formDataMap fallback
      List<WorkerSkillsResult> oldSkills = List.from(state.selectedSkills ?? []);

      if (oldSkills.isEmpty && (state.formDataMap?[fieldLabel]?.toString().isNotEmpty ?? false)) {
        final savedSkillIds = state.formDataMap?[fieldLabel].toString().split(',') ?? [];

        // Rebuild from masterData
        final masterSkillList = state.masterData
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
      final updatedFormData = Map<String, dynamic>.from(state.formDataMap ?? {});
      updatedFormData[fieldLabel] = selectedSkillsString;

      // 5. Emit new state
      emit(state.copyWith(
        selectedSkills: oldSkills,
        formDataMap: updatedFormData,
      ));
    } catch (e) {
      if (kDebugMode) print('onSkillSelected() error: $e');
    }
  }

  void onFilterSkills(String filterText) {
    try {
      List<WorkerSkillsResult> oldSkills = state.skills?.result ?? [];
      if (filterText.isNotEmpty) {
        state.filteredSkills = oldSkills
            .where((skill) => skill.skillName?.toLowerCase().startsWith(filterText.toLowerCase()) ?? false)
            .toList();
        emit(state.copyWith(filteredSkills: state.filteredSkills));
      } else {
        emit(state.copyWith(filteredSkills: oldSkills));
      }
    } catch (e) {
      // log('e:$e');
    }
  }

  void onAllSkillSelected({required List<WorkerSkillsResult>? skills, required bool? isSelected}) {
    try {
      List<WorkerSkillsResult> oldSkills = [];
      if (isSelected ?? false) {
        if (state.selectedSkills?.length != state.skills?.result?.length) {
          if (skills != null) {
            oldSkills.addAll(skills);
          }
        }
        emit(state.copyWith(selectedSkills: oldSkills));
      } else {
        emit(state.copyWith(selectedSkills: []));
      }
    } catch (e) {
      //
    }
  }

  void onSkillRemoved(WorkerSkillsResult skill) {
    try {
      List<WorkerSkillsResult> oldSkills = state.selectedSkills ?? [];
      oldSkills.remove(skill);
      emit(state.copyWith(selectedSkills: oldSkills));
    } catch (e) {
      //
    }
  }

  Future<void> setDefaultCurrency() async {
    try {
      String countryCode = await AppUtils.getCountry();
      var currentLocationCountry =
          countryList.firstWhere((element) => element.isoCode == countryCode, orElse: () => countryList.first);

      List<Countries>? item = state.currencyList
          ?.where((currencyItem) => currencyItem.countryPhoneCode == currentLocationCountry.phoneCode)
          .toList();
      if (item?.isNotEmpty == true) {
        onFieldsValueChanged(key: AddListingFormConstants.currencyINR, value: item?.first.currencyCode);
      }
    } catch (e) {
      if (kDebugMode) {
        print('AddListingFormCubit.setDefaultCurrency--${e.toString()}');
      }
    }
  }

  Future<bool> checkBusinessLogoUploaded() async {
    bool? isContinued = true;

    /// Checking the current page is photos/videos or not.
    if (state.currentSectionCount != null) {
      final fields = state.sections?[state.currentSectionCount! - 1].inputFields
          ?.where((field) => field.type == FormFieldType.homePageLogo.value)
          .toList();
      if (fields?.isNotEmpty ?? false) {
        /// If logo is not uploaded then showing a dialog box
       // if (!state.formDataMap!.containsKey(AddListingFormConstants.uploadHomePageLogo)) {
        if (state.formDataMap![AddListingFormConstants.uploadHomePageLogo].toString().isEmpty) {
          isContinued = await ReusableWidgets.showConfirmationDialog(
              AppConstants.appTitleStr, AppConstants.logoUploadDescValidationMsg, () async {
            navigatorKey.currentState?.pop();
          });
          return isContinued ?? true;
        }
      }
    }
    return isContinued;
  }
  void disableField(bool isDisable) {
      emit(state.copyWith(isDisable:isDisable));


  }

  List<Sections> sections = [];
  int currentSectionIndex = 0;

  void loadFormData(List<Sections> newSections) {
    sections = newSections;
    currentSectionIndex = 0;
    emit(state.copyWith(currentSectionCount: currentSectionIndex, sections: sections));
  }

  void nextSection() {
    if (currentSectionIndex < sections.length - 1) {
      currentSectionIndex++;
      emit(state.copyWith(currentSectionCount: currentSectionIndex, sections: sections));
    } else {
      submitForm();
    }
  }

  void previousSection() {
    if (currentSectionIndex > 0) {
      currentSectionIndex--;
      emit(state.copyWith(currentSectionCount: currentSectionIndex, sections: sections));
    }
  }

  void submitForm() {
    // Handle final submission
  }

  List<Sections> updateInputTypeFieldsFromResponse(List<Sections> sections, List<Sections> responseSections) {
    for (var newSection in responseSections) {
      // Find the existing section in sections list
      var existingSectionIndex = sections.indexWhere((section) => section.id == newSection.id);

      if (existingSectionIndex != -1) {
        var existingSection = sections[existingSectionIndex];

        // Iterate through input fields of the new section
        for (var newInputField in newSection.inputFields ?? []) {
          // Find matching input field in existing section
          var existingInputIndex =
              existingSection.inputFields?.indexWhere((input) => input.id == newInputField.controlId) ?? -1;

          if (existingInputIndex != -1) {
            // Update only controlValue and responseControlId
            existingSection.inputFields![existingInputIndex].id = newInputField.controlId;
            existingSection.inputFields![existingInputIndex].controlId = newInputField.controlId;
            existingSection.inputFields![existingInputIndex].controlValue = newInputField.controlValue;
            existingSection.inputFields![existingInputIndex].responseControlId = newInputField.responseControlId;
          }
        }
      }
    }
    return sections;
  }

  void updateListingID(int listingId) {
    emit(state.copyWith(apiResultId: listingId));
  }

  Future<void> moveToItemDetailsScreen(ResponseWrapper<DynamicAddListingResponseModel?> response) async {

    var categoryList = await PreferenceHelper.instance.getCategoryList();
    var categoryName = categoryList.result
        ?.firstWhere((item) => item.formId == response.responseData?.result.formId,
        orElse: () => CategoriesListResponse(formId: 0, formName: '')).formName ?? '' ;
    navigatorKey.currentState?.pop(AppConstants.needToRefresh);
    AppRouter.push(
        AppRoutes.itemDetailsViewRoute,
        args: {
        ModelKeys.itemId: response.responseData?.result.listingId,
        ModelKeys.category: categoryName,
        ModelKeys.formId: response.responseData?.result.formId,
        ModelKeys.isDraft: false
        }
    );
  }
}
