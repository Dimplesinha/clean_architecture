part of 'add_listing_form_cubit.dart';

final class AddListingFormLoadedState extends Equatable {
  final CategoriesListResponse category;
  final int? currentSectionCount;
  final int? totalSectionCount;
  final List<MasterData>? masterData;
  final List<InheritList>? inheritList;
  final List<Countries>? countries;
  final List<CommunityListingTypeResult>? communityListingTypeResult;
  final List<BusinessTypeResult>? businessTypeResult;
  final List<BusinessListResult>? businessListResult;
  final List<BusinessListResult>? communityListResult;
  final Map<String, dynamic>? formDataMap;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final String? selectedDate;
  final String? startTime;
  final String? startDate;
  final String? endTime;
  final String? endDate;
  final List<JobRequirements>? jobRequirementList;
  final bool isLoading;
  final List<XFile?>? imageList;
  String? businessLogo;
  final String? resumeUploadURL;
  final bool isBusinessLogoUploading;
  final bool isUpdatingInitialData;
  List<BusinessImagesModel?>? imageModelList;
  final BusinessProfileDetailResponse? fetchBusinessDetails;
  final WorkerSkillsModel? skills;
  IndustryTypeModel? industryType;
  CategoryTypeModel? categoryType;
  PropertyTypeModel? propertyType;
  final int? apiResultId;
  final DateTime? selectedInspectionDate;
  List<WorkerSkillsResult>? selectedSkills;
  List<WorkerSkillsResult>? filteredSkills;
  final List<Countries>? currencyList;
  final List<AutoTypeList>? autoTypeList;
  final bool isListingEditing;
  final List<Sections>? sections;
  final List<Section>? dynamicResponseSections;
  final int? currentSectionIndex;
  final bool? isDraft;
  final bool? isDisable;
  final DynamicFormData? listings;
  final Map<String, dynamic>? formValues;

  AddListingFormLoadedState({
    required this.category,
    this.businessLogo,
    this.resumeUploadURL,
    this.masterData,
    this.isBusinessLogoUploading = false,
    this.currentSectionCount = 1,
    this.totalSectionCount,
    this.communityListingTypeResult,
    this.businessTypeResult,
    this.businessListResult,
    this.selectedInspectionDate,
    this.formDataMap,
    this.selectedStartDate,
    this.selectedEndDate,
    this.selectedDate,
    this.startTime,
    this.endTime,
    this.jobRequirementList = const [],
    this.countries,
    this.startDate,
    this.endDate,
    this.isLoading = false,
    this.imageList,
    this.apiResultId,
    this.imageModelList,
    this.fetchBusinessDetails,
    this.communityListResult,
    this.isUpdatingInitialData = true,
    this.skills,
    this.industryType,
    this.categoryType,
    this.propertyType,
    this.selectedSkills,
    this.filteredSkills,
    this.autoTypeList,
    this.sections,
    this.dynamicResponseSections,
    this.currentSectionIndex,
    this.listings,
    this.inheritList,
    this.formValues,
    this.isListingEditing = false,
    this.isDraft = true,
    this.isDisable = false,
    List<Countries>? currencyList,
  }) : currencyList = _getUniqueCurrenciesByName(currencyList);

  static List<Countries>? _getUniqueCurrenciesByName(List<Countries>? currencyList) {
    if (currencyList == null) return null;
    final uniqueMap = {for (var country in currencyList) country.currencyName!: country};
    final uniqueList = uniqueMap.values.toList();
    uniqueList.sort((a, b) => a.currencyName!.compareTo(b.currencyName!));
    return uniqueList;
  }

  @override
  List<Object?> get props => [
        businessLogo,
        currentSectionCount,
        totalSectionCount,
        formDataMap,
        masterData,
        countries,
        selectedStartDate,
        selectedEndDate,
        startDate,
        endDate,
        selectedInspectionDate,
        selectedDate,
        startTime,
        endTime,
        jobRequirementList,
        isLoading,
        imageList,
        apiResultId,
        imageModelList,
        isBusinessLogoUploading,
        fetchBusinessDetails,
        communityListingTypeResult,
        businessTypeResult,
        businessListResult,
        isUpdatingInitialData,
        communityListResult,
        resumeUploadURL,
        category,
        businessLogo,
        currentSectionCount,
        totalSectionCount,
        formDataMap,
        countries,
        selectedStartDate,
        selectedEndDate,
        startDate,
        endDate,
        selectedDate,
        startTime,
        endTime,
        jobRequirementList,
        isLoading,
        imageList,
        imageModelList,
        isBusinessLogoUploading,
        fetchBusinessDetails,
        communityListResult,
        isUpdatingInitialData,
        skills,
        selectedSkills,
        filteredSkills,
        currencyList,
        industryType,
        categoryType,
        propertyType,
        autoTypeList,
        isListingEditing,
        sections,
        currentSectionIndex,
        listings,
        dynamicResponseSections,
        formValues,
        inheritList,
        isDraft,
        isDisable,
        identityHashCode(this),
      ];

  AddListingFormLoadedState copyWith({
    CategoriesListResponse? category,
    int? currentSectionCount,
    int? totalSectionCount,
    List<Countries>? countries,
    List<MasterData>? masterData,
    List<InheritList>? inheritList,
    Map<String, dynamic>? formDataMap,
    DateTime? selectedInspectionDate,
    DateTime? selectedStartDate,
    DateTime? selectedEndDate,
    String? selectedDate,
    String? startTime,
    String? endTime,
    List<CommunityListingTypeResult>? communityListingTypeResult,
    List<BusinessTypeResult>? businessTypeResult,
    List<BusinessListResult>? businessListResult,
    List<BusinessListResult>? communityListResult,
    List<JobRequirements>? jobRequirementList,
    bool? isBusinessLogoUploading,
    String? endDate,
    String? startDate,
    String? businessLogo,
    String? resumeUploadURL,
    String? jobLogo,
    bool? isLoading,
    bool? isDraft,
    int? apiResultId,
    List<XFile?>? imageList,
    // bool? isBusinessLogoUploading,
    bool? isUpdatingInitialData,
    bool? isDisable,
    List<BusinessImagesModel?>? imageModelList,
    BusinessProfileDetailResponse? fetchBusinessDetails,
    WorkerSkillsModel? skills,
    IndustryTypeModel? industryType,
    CategoryTypeModel? categoryType,
    PropertyTypeModel? propertyType,
    List<WorkerSkillsResult>? selectedSkills,
    List<WorkerSkillsResult>? filteredSkills,
    final List<Countries>? currencyList,
    List<AutoTypeList>? autoTypeList,
    bool? isListingEditing,
    List<Sections>? sections,
    List<Section>? dynamicResponseSections,
    DynamicFormData? listings,
    Map<String, dynamic>? formValues,
    int? currentSectionIndex,
  }) {
    return AddListingFormLoadedState(
        category: category ?? this.category,
        currentSectionCount: currentSectionCount ?? this.currentSectionCount,
        totalSectionCount: totalSectionCount ?? this.totalSectionCount,
        formDataMap: formDataMap ?? this.formDataMap,
        masterData: masterData ?? this.masterData,
        countries: countries ?? this.countries,
        selectedStartDate: selectedStartDate ?? this.selectedStartDate,
        selectedEndDate: selectedEndDate ?? this.selectedEndDate,
        selectedInspectionDate: selectedInspectionDate ?? this.selectedInspectionDate,
        selectedDate: selectedDate ?? this.selectedDate,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        jobRequirementList: jobRequirementList ?? this.jobRequirementList,
        isLoading: isLoading ?? this.isLoading,
        isDraft: isDraft ?? this.isDraft,
        imageList: imageList ?? this.imageList,
        apiResultId: apiResultId ?? this.apiResultId,
        businessLogo: businessLogo ?? this.businessLogo,
        imageModelList: imageModelList ?? this.imageModelList,
        isBusinessLogoUploading: isBusinessLogoUploading ?? this.isBusinessLogoUploading,
        fetchBusinessDetails: fetchBusinessDetails ?? this.fetchBusinessDetails,
        isUpdatingInitialData: isUpdatingInitialData ?? this.isUpdatingInitialData,
        communityListingTypeResult: communityListingTypeResult ?? this.communityListingTypeResult,
        businessTypeResult: businessTypeResult ?? this.businessTypeResult,
        businessListResult: businessListResult ?? this.businessListResult,
        communityListResult: communityListResult ?? this.communityListResult,
        currencyList: currencyList ?? this.currencyList,
        skills: skills ?? this.skills,
        industryType: industryType ?? this.industryType,
        categoryType: categoryType ?? this.categoryType,
        propertyType: propertyType ?? this.propertyType,
        selectedSkills: selectedSkills ?? this.selectedSkills,
        filteredSkills: filteredSkills ?? this.filteredSkills,
        resumeUploadURL: resumeUploadURL ?? this.resumeUploadURL,
        autoTypeList: autoTypeList ?? this.autoTypeList,
        isListingEditing: isListingEditing ?? this.isListingEditing,
        currentSectionIndex: currentSectionIndex ?? this.currentSectionIndex,
        sections: sections ?? this.sections,
        dynamicResponseSections: dynamicResponseSections ?? this.dynamicResponseSections,
        listings: listings ?? this.listings,
        inheritList: inheritList ?? this.inheritList,
        formValues: formValues ?? this.formValues,
        isDisable: isDisable ?? this.isDisable);
  }

  List<WorkerSkillsResult>? get getSkills => filteredSkills ?? skills?.result;

  int get getCommunityTypeId {
    if (formDataMap?[AddListingFormConstants.communityType] == DropDownConstants.individual) {
      return 1;
    } else {
      return 2;
    }
  }

  int get getCommunityListingTypeId {
    if (formDataMap?[AddListingFormConstants.communityListingType] == DropDownConstants.volunteer) {
      return 1;
    } else {
      return 2;
    }
  }

  int get getSkillId {
    if (formDataMap?[AddListingFormConstants.skill] == DropDownConstants.cooking) {
      return 1;
    } else if (formDataMap?[AddListingFormConstants.skill] == DropDownConstants.librarying) {
      return 2;
    } else if (formDataMap?[AddListingFormConstants.skill] == DropDownConstants.other) {
      return 3;
    } else {
      return 4;
    }
  }

  int getTimeInHH(String? time) {
    if (time != null) {
      return int.parse(time.split(':')[0]);
    } else {
      return DateTime.now().hour;
    }
  }

  int getTimeInMM(String? time) {
    if (time != null) {
      try {
        // Removing any AM/PM and trimming spaces
        final cleanedTime = time.replaceAll(RegExp(r'[^\d:]'), '').trim();
        return int.parse(cleanedTime.split(':')[1]);
      } catch (e) {
        return DateTime.now().minute;
      }
    } else {
      return DateTime.now().minute;
    }
  }

  DateTime getFormattedDateTime(String key) {
    String? date = formDataMap?[key];
    if (date != null) {
      DateTime parsedDate = DateTime.parse(date);
      return parsedDate;
    }
    return DateTime.now();
  }
}
