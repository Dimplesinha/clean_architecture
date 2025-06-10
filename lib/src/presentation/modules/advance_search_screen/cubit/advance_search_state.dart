part of 'advance_search_cubit.dart';

@immutable
sealed class AdvanceSearchState extends Equatable {
  const AdvanceSearchState();
}

final class AdvanceSearchInitial extends AdvanceSearchState {
  @override
  List<Object> get props => [];
}

final class AdvanceSearchLoadedState extends AdvanceSearchState {
  final int selectedIndex;
  final bool saveSearch;
  final bool isLoading;
  final List<AdvanceSearchItem>? searchItems;
  final List<AdvanceSearchItem>? recentItems;
  final bool areTabsEnabled;
  final Map<String, dynamic>? formDataMap;
  final AdvanceSearchModel? data;
  final List<SearchResult>? result;
  final PropertyTypeModel? propertyType;
  final IndustryTypeModel? industryType;
  final DynamicFormData? dynamicFormData;
  final CategoryTypeModel? categoryType;
  final List<AutoTypeList>? autoTypeList;
  final WorkerSkillsModel? skills;
  final CommunityListingTypeModel? communityListingTypeModel;
  final int? sortBy;
  final List<Sections>? sections;
  final List<MasterData>? masterData;
  List<WorkerSkillsResult>? selectedSkills;
  List<WorkerSkillsResult>? filteredSkills;
  final bool? isEnableDeleteUI;

   AdvanceSearchLoadedState({
    this.isLoading = false,
    this.selectedIndex = 0,
    this.areTabsEnabled = true,
    this.sortBy = 1,
    this.saveSearch = false,
    this.searchItems,
    this.recentItems,
    this.formDataMap,
    this.data,
    this.result,
    this.propertyType,
    this.industryType,
    this.categoryType,
    this.autoTypeList,
    this.skills,
    this.sections,
    this.masterData,
    this.dynamicFormData,
    this.selectedSkills,
    this.communityListingTypeModel,
    this.isEnableDeleteUI,
    this.filteredSkills,
  });

  @override
  List<Object?> get props => [
        selectedIndex,
        saveSearch,
        searchItems,
        recentItems,
        isLoading,
        areTabsEnabled,
        formDataMap,
        data,
        result,
        propertyType,
        industryType,
        categoryType,
        autoTypeList,
        skills,
    dynamicFormData,
    sections,
    masterData,
    selectedSkills,
        communityListingTypeModel,
        identityHashCode(this),
        isEnableDeleteUI,
    filteredSkills
      ];

  AdvanceSearchLoadedState copyWith({
    int? selectedIndex,
    bool? saveSearch,
    int? sortBy,
    bool? isLoading,
    List<MasterData>? masterData,
    List<AdvanceSearchItem>? searchItems,
    List<AdvanceSearchItem>? recentItems,
    List<WorkerSkillsResult>? selectedSkills,
    List<WorkerSkillsResult>? filteredSkills,
    bool? areTabsEnabled,
    Map<String, dynamic>? formDataMap,
    AdvanceSearchModel? data,
    List<SearchResult>? result,
    PropertyTypeModel? propertyType,
    DynamicFormData? dynamicFormData,
    IndustryTypeModel? industryType,
    CategoryTypeModel? categoryType,
    List<AutoTypeList>? autoTypeList,
    WorkerSkillsModel? skills,
    List<Sections>? sections,
    CommunityListingTypeModel? communityListingTypeModel,
    bool? isEnableDeleteUI = false,
  }) {
    return AdvanceSearchLoadedState(
      isLoading: isLoading ?? this.isLoading,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      sortBy: sortBy ?? this.sortBy,
      saveSearch: saveSearch ?? this.saveSearch,
      searchItems: searchItems ?? this.searchItems,
      recentItems: recentItems ?? this.recentItems,
      areTabsEnabled: areTabsEnabled ?? this.areTabsEnabled,
      formDataMap: formDataMap ?? this.formDataMap,
      data: data ?? this.data,
      result: result ?? this.result,
      propertyType: propertyType ?? this.propertyType,
      industryType: industryType ?? this.industryType,
      categoryType: categoryType ?? this.categoryType,
      autoTypeList: autoTypeList ?? this.autoTypeList,
      skills: skills ?? this.skills,
      masterData: masterData ?? this.masterData,
      sections: sections ?? this.sections,
      selectedSkills: selectedSkills ?? this.selectedSkills,
      filteredSkills: filteredSkills ?? this.filteredSkills,
      dynamicFormData: dynamicFormData ?? this.dynamicFormData,
      communityListingTypeModel: communityListingTypeModel ?? this.communityListingTypeModel,
      isEnableDeleteUI: isEnableDeleteUI ?? this.isEnableDeleteUI,
    );
  }
}
