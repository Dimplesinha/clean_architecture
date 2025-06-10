import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/enquiry_model.dart';
import 'package:workapp/src/domain/models/statistics_insight_model.dart';
import 'package:workapp/src/domain/models/statistics_rating_model.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/listing_statistics/repo/listing_stats_repo.dart';
import 'package:workapp/src/presentation/modules/my_listing/repo/my_listing_repo.dart';

part 'listing_statistics_state.dart';

class ListingStatisticsCubit extends Cubit<ListingStatisticsLoadedState> {
  // IDs for the current listing and category
  int? listingId;
  int? categoryId;

  // Pagination tracking
  int insightRatingPage = 1;
  int insightEnquiriesPage = 1;

  // Flags for pagination availability
  bool hasInsightRatingsNextPage = false;
  bool hasInsightEnquiriesNextPage = false;

  // Boost status flag
  bool isBoosted = false;

  ListingStatisticsCubit() : super(const ListingStatisticsLoadedState());

  /// Initializes the Cubit with listing and category IDs
  /// Optionally resets and refreshes data
  void init({required int? selectedListingId, required int? selectedCategoryId, bool isRefresh = false}) async {
    listingId = selectedListingId;
    categoryId = selectedCategoryId;
    await fetchInsightStatistics();
    await fetchEnquiry(isRefresh: isRefresh);
    await fetchInsightRatingPaginated(isRefresh: isRefresh);
  }

  /// Fetches the insight statistics for a listing and category
  Future<void> fetchInsightStatistics() async {
    try {
      emit(state.copyWith(loader: true));
      if (listingId != null && categoryId != null) {
        var response = await ListingStatRepo.instance
            .fetchInsightStatistics(listingId: listingId.toString(), categoryId: categoryId.toString());

        if (response.status == true && response.responseData != null) {
          emit(state.copyWith(statisticsInsightResult: response.responseData?.result, loader: false));
        } else {
          emit(state.copyWith(loader: false));
        }
      } else {
        emit(state.copyWith(loader: false));
      }
    } catch (e) {
      emit(state.copyWith(loader: false, selectedIndex: 1));
    }
  }

  /// Fetches the enquiry list for a listing with pagination
  /// Resets the page if [isRefresh] is true
  Future<void> fetchEnquiry({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        insightEnquiriesPage = 1;
      }
      emit(state.copyWith(loader: true));

      Map<String, dynamic> requestBody = {
        ModelKeys.pageIndex: insightEnquiriesPage,
        ModelKeys.pageSize: AppConstants.pageSize,
      };

      var response = await ListingStatRepo.instance.fetchEnquiryList(
        listingId: listingId.toString(),
        requestBody: requestBody,
      );

      if (response.status == true && response.responseData != null) {
        List<StatisticsEnquiryItem> enquiriesItems = response.responseData?.result?[0].items ?? [];

        // Merge or replace list based on refresh
        List<StatisticsEnquiryItem>? updatedEnquiriesItems = isRefresh
            ? enquiriesItems
            : [...?state.statisticsEnquiryItem, ...enquiriesItems];

        // Determine if more pages are available
        if ((response.responseData?.result?[0].count ?? 0) > updatedEnquiriesItems.length) {
          hasInsightEnquiriesNextPage = true;
          insightEnquiriesPage++;
        } else {
          hasInsightEnquiriesNextPage = false;
        }

        emit(state.copyWith(statisticsEnquiryItem: updatedEnquiriesItems, loader: false));
      } else {
        emit(state.copyWith(statisticsEnquiryItem: [], loader: false));
      }
    } catch (e) {
      emit(state.copyWith(loader: false, statisticsEnquiryItem: [], selectedIndex: 1));
    }
  }

  /// Fetches paginated ratings for the selected listing
  /// Resets the page if [isRefresh] is true
  Future<void> fetchInsightRatingPaginated({bool isRefresh = false}) async {
    try {
      emit(state.copyWith(loader: true));
      if (listingId != null && categoryId != null) {
        Map<String, dynamic> requestBody = {
          ModelKeys.pageIndex: insightRatingPage,
          ModelKeys.pageSize: AppConstants.pageSize,
        };

        var response = await ListingStatRepo.instance.fetchInsightRatings(
          listingId: listingId.toString(),
          categoryId: categoryId.toString(),
          requestBody: requestBody,
        );

        List<StatisticsRatingsItems> ratingsItems = response.responseData?.result?[0].items ?? [];

        if (response.status == true && response.responseData != null) {
          List<StatisticsRatingsItems>? updatedRatingsItems = isRefresh
              ? ratingsItems
              : [...?state.statisticsRatingsItemsResult, ...ratingsItems];

          // Determine if more pages are available
          if ((response.responseData?.result?[0].count ?? 0) > updatedRatingsItems.length) {
            hasInsightRatingsNextPage = true;
            insightRatingPage++;
          } else {
            hasInsightRatingsNextPage = false;
          }

          emit(state.copyWith(statisticsRatingsItemsResult: updatedRatingsItems, loader: false));
        } else {
          emit(state.copyWith(loader: false));
        }
      } else {
        emit(state.copyWith(loader: false));
      }
    } catch (e) {
      emit(state.copyWith(loader: false, selectedIndex: 1));
    }
  }

  /// Toggles the boost state of an item
  /// Sends a boost request for the selected item
  Future<void> toggleBoost({required int? itemId, required int? categoryId}) async {
    try {
      emit(state.copyWith(loader: true));

      Map<String, dynamic> requestBody = {ModelKeys.categoryId: categoryId};

      var response = await MyListingRepo.instance.boostMyItem(
        requestBody: requestBody,
        itemId: itemId,
      );

      if (response?.status == true && response?.responseData != null) {
        emit(state.copyWith(loader: false));
        AppUtils.showSnackBar(response?.message ?? '', SnackBarType.success);

        // Refresh statistics after successful boost
        fetchInsightStatistics();
      } else {
        emit(state.copyWith(loader: false));
        AppUtils.showSnackBar(AppConstants.somethingWentWrong, SnackBarType.alert);
      }
    } catch (e) {
      if (kDebugMode) {
        print('ListingStatisticsCubit.toggleBoost------->>> ${e.toString()}');
      }
    }
  }

  /// Updates the selected tab index in the UI
  void selectButton(int index) async {
    emit(state.copyWith(selectedIndex: index));
  }
}
