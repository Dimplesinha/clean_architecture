import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/modules/my_contact_user_listing/repo/my_contact_user_listing_repo.dart';

part 'my_contact_user_listing_state.dart';

class MyContactUserListingCubit extends Cubit<MyContactUserListingState> {

  final MyContactUserListingRepo myContactUserListingRepo;
  bool hasNextPage = true;
  bool hasPastListingsPage = true;
  int currentPage = 1;
  int pastListingsPage = 1;
  bool loggedIn = false;
  int? userId = 0;

  MyContactUserListingCubit({required this.myContactUserListingRepo}) : super(MyContactUserListingInitial());

  void init(bool isFromItemDetail) async {
    emit(MyContactUserListingLoadedState());
    loggedIn = await PreferenceHelper.instance.getPreference(
      key: PreferenceHelper.isLogin,
      type: bool,
    );
    if (loggedIn && !isFromItemDetail) {
      await fetchMyListingItems(search: '');
      await fetchContactUserPastListing(search: '');
    }
  }

  /// fetch list of all
  Future<void> fetchMyListingItems({String search = '', bool isRefresh = false}) async {
    try {
      var oldState = state as MyContactUserListingLoadedState;
      if (isRefresh == false) {
        emit(oldState.copyWith(loader: true));
      }

      /// Setting current page as 1 if refresh is called
      currentPage = isRefresh ? 1 : currentPage;
      Map<String, dynamic> requestBody = {
        ModelKeys.userId: userId,
        ModelKeys.pageIndex: currentPage,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.search: search,
        ModelKeys.categoryId: null,
      };
      var response = await myContactUserListingRepo.fetchMyListingData(requestBody: requestBody);

      if (response?.responseData?.statusCode == 200 && response?.responseData != null) {
        List<MyListingItems> myListingItem =
            (response?.responseData?.result?.expand((model) => model.items ?? []).toList() ?? [])
                .cast<MyListingItems>();

        if (myListingItem.length == AppConstants.pageSize) {
          hasNextPage = true;
          currentPage++;
        } else {
          hasNextPage = false;
        }

        if (isRefresh == true) {
          oldState.contactUserListingItem?.clear();
        }
        List<MyListingItems> updatedMyListingItems = isRefresh
            ? myListingItem // start fresh with new items
            : [...?oldState.contactUserListingItem, ...myListingItem];

        emit(oldState.copyWith(
          contactUserListing: response?.responseData?.result,
          contactUserListingItem: updatedMyListingItems,
          loader: false,
        ));
      } else {
        emit(oldState.copyWith(loader: false, contactUserListingItem: []));
      }
    } catch (e) {
      var oldState = state as MyContactUserListingLoadedState;
      emit(oldState.copyWith(loader: false, contactUserListingItem: []));
    }
  }

  ///select tab
  void selectTab(int index) {
    var oldState = state as MyContactUserListingLoadedState;
    emit(oldState.copyWith(selectedIndex: index));
  }

  /// fetch list of all
  Future<void> fetchContactUserPastListing({
    String search = '',
    bool isRefresh = false,
  }) async {
    try {
      var oldState = state as MyContactUserListingLoadedState;
      if (isRefresh == false) {
        emit(oldState.copyWith(loader: true));
      }

      /// Setting current page as 1 if refresh is called
      pastListingsPage = isRefresh ? 1 : pastListingsPage;
      Map<String, dynamic> requestBody = {
        ModelKeys.userId: userId,
        ModelKeys.pageIndex: pastListingsPage,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.search: search,
        ModelKeys.categoryId: null,
      };

      var response = await myContactUserListingRepo.fetchMyPastListingData(requestBody: requestBody);

      if (response?.responseData?.statusCode == 200 && response?.responseData != null) {
        List<MyListingItems> myListingItem =
            (response?.responseData?.result?.expand((model) => model.items ?? []).toList() ?? [])
                .cast<MyListingItems>();

        if (myListingItem.length == AppConstants.pageSize) {
          hasPastListingsPage = true;
          pastListingsPage++;
        } else {
          hasPastListingsPage = false;
        }

        if (isRefresh == true) {
          oldState.contactUserPastListingItem?.clear();
        }
        List<MyListingItems> updatedMyListingItems = isRefresh
            ? myListingItem // start fresh with new items
            : [...?oldState.contactUserPastListingItem, ...myListingItem];

        emit(oldState.copyWith(
          contactUserPastListing: response?.responseData?.result,
          contactUserPastListingItem: updatedMyListingItems,
          loader: false,
        ));
      } else {
        emit(oldState.copyWith(loader: false, contactUserPastListingItem: []));
      }
    } catch (e) {
      var oldState = state as MyContactUserListingLoadedState;
      emit(oldState.copyWith(loader: false, contactUserPastListingItem: []));
    }
  }
}
