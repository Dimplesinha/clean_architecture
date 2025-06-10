part of 'dashboard_cubit.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

final class DashboardLoadedState extends DashboardState {
  String? selectedSingleOption;
  final bool isLoading;
  final bool showUpIcon;
  final bool showSnackBar;
  final String? path;
  final int? accountType;
  final LoginModel? loginDetails;
  final List<String>? selectedOptions;
  final List<MyListingItems>? items;
  final List<MyListingModel>? listingData;
  final List<CategoriesListResponse>? listings;
  final List<CategoriesListResponse>? selectedListings;
  final List<CategoriesListResponse>? selectedTempListings;
  final CategoriesListResponse? categoriesListingsData;
  final List<Countries>? countryListing;
  String? tempSelectedSingleOption;
  String? tempPath;
  final double? appCarousalHeight;

  DashboardLoadedState({
    this.selectedSingleOption,
    this.isLoading = false,
    this.showUpIcon = false,
    this.showSnackBar = false,
    this.path,
    this.loginDetails,
    this.accountType,
    this.selectedOptions,
    this.items,
    this.listings,
    this.listingData,
    this.selectedListings = const [],
    this.selectedTempListings = const [],
    this.categoriesListingsData,
    this.countryListing,
    this.tempSelectedSingleOption,
    this.tempPath,
    this.appCarousalHeight,
  });

  @override
  List<Object?> get props => [
        selectedSingleOption,
        isLoading,
        showSnackBar,
        path,
        loginDetails,
        selectedOptions,
        items,
        accountType,
        listings,
        showUpIcon,
        listingData,
        selectedListings,
        selectedTempListings,
        categoriesListingsData,
        countryListing,
        tempSelectedSingleOption,
        tempPath,
        appCarousalHeight,
      ];

  DashboardLoadedState copyWith({
    String? selectedSingleOption,
    bool? isLoading,
    bool? showUpIcon,
    bool? showSnackBar,
    String? path,
    int? accountType,
    LoginModel? loginDetails,
    List<String>? selectedOptions,
    List<MyListingItems>? items,
    List<MyListingModel>? listingData,
    List<CategoriesListResponse>? listings,
    List<CategoriesListResponse>? selectedListings,
    List<CategoriesListResponse>? selectedTempListings,
    CategoriesListResponse? categoriesListingsData,
    List<Countries>? countryListing,
    String? tempSelectedSingleOption,
    String? tempPath,
    double? appCarousalHeight
  }) {
    return DashboardLoadedState(
      selectedSingleOption: selectedSingleOption ?? this.selectedSingleOption,
      isLoading: isLoading ?? this.isLoading,
      showUpIcon: showUpIcon ?? this.showUpIcon,
      showSnackBar: showSnackBar ?? this.showSnackBar,
      path: path ?? this.path,
      accountType: accountType ?? this.accountType,
      loginDetails: loginDetails ?? this.loginDetails,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      items: items ?? this.items,
      listingData: listingData ?? this.listingData,
      listings: listings ?? this.listings,
      selectedListings: selectedListings ?? this.selectedListings,
      selectedTempListings: selectedTempListings ?? this.selectedTempListings,
      categoriesListingsData: categoriesListingsData ?? this.categoriesListingsData,
      countryListing: countryListing ?? this.countryListing,
      tempSelectedSingleOption: tempSelectedSingleOption ?? this.tempSelectedSingleOption,
      tempPath: tempPath ?? this.tempPath,
      appCarousalHeight: appCarousalHeight ?? this.appCarousalHeight,
    );
  }
}
