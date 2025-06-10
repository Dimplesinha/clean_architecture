part of 'listing_statistics_cubit.dart';

/// State class for [ListingStatisticsCubit].
/// Holds all the necessary data related to statistics,
/// such as insight statistics, enquiries, ratings, and UI state.
final class ListingStatisticsLoadedState extends Equatable {
  /// Indicates whether a loader/spinner should be displayed in the UI.
  final bool loader;

  /// Represents the selected tab index (e.g., Insights, Ratings, Enquiries).
  final int? selectedIndex;

  /// List of enquiry items related to the listing statistics.
  final List<StatisticsEnquiryItem>? statisticsEnquiryItem;

  /// Data model representing overall insight statistics.
  final StatisticsInsightResult? statisticsInsightResult;

  /// List of rating items fetched for the selected listing.
  final List<StatisticsRatingsItems>? statisticsRatingsItemsResult;

  /// Constructor with default and optional values.
  const ListingStatisticsLoadedState({
    this.selectedIndex = 1,
    this.statisticsEnquiryItem,
    this.statisticsInsightResult,
    this.statisticsRatingsItemsResult,
    this.loader = false,
  });

  /// Props used by [Equatable] to compare state instances.
  @override
  List<Object?> get props => [
    selectedIndex,
    statisticsEnquiryItem,
    statisticsInsightResult,
    statisticsRatingsItemsResult,
    loader,
  ];

  /// Returns a copy of the current state with optional overrides.
  /// Useful for state updates with minimal changes.
  ListingStatisticsLoadedState copyWith({
    int? selectedIndex,
    List<StatisticsEnquiryItem>? statisticsEnquiryItem,
    StatisticsInsightResult? statisticsInsightResult,
    List<StatisticsRatingsItems>? statisticsRatingsItemsResult,
    bool? loader,
  }) {
    return ListingStatisticsLoadedState(
      loader: loader ?? this.loader,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      statisticsEnquiryItem: statisticsEnquiryItem ?? this.statisticsEnquiryItem,
      statisticsInsightResult: statisticsInsightResult ?? this.statisticsInsightResult,
      statisticsRatingsItemsResult: statisticsRatingsItemsResult ?? this.statisticsRatingsItemsResult,
    );
  }
}
