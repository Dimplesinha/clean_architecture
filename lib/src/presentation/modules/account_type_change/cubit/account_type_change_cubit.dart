import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/modules/account_type_change/account_type_repo/account_type_repo.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';

part 'account_type_change_state.dart';

class AccountTypeChangeCubit extends Cubit<AccountTypeChangeLoadedState> {
  final AccountTypeRepo accountTypeRepo;
  bool hasNextPage = true;
  int currentPage = 1;

  AccountTypeChangeCubit({required this.accountTypeRepo}) : super(const AccountTypeChangeLoadedState());

  /// Api Call to change Account type on dashboard when logged in or sign up from social media and haven't updated account type
  Future<void> onSelectAccountType(
    BuildContext context, {
    required int accountType,
  }) async {
    var oldState = state;
    try {
      emit(oldState.copyWith(isLoading: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.accountType: accountType,
      };

      var response = await accountTypeRepo.selectAccountType(requestBody);

      if (response.status) {
        emit(oldState.copyWith(isLoading: false));
        await PreferenceHelper.instance.updateAccountType(AppUtils.getAccountTypeString(accountType));
        AppRouter.pop();
        AppUtils.showSnackBar(response.message, SnackBarType.success);
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(oldState.copyWith(
          isLoading: false,
        ));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(oldState.copyWith(
        isLoading: false,
      ));
    }
  }

  /// Change dropdown value
  void accountTypeChange(int value) async {
    var oldState = state;
    try {
      emit(oldState.copyWith(accountType: value));
    } catch (e) {
      emit(const AccountTypeChangeLoadedState());
    }
  }

  /// Api Call to fetch active listing count while changing account type
  Future<void> activeListingCount(BuildContext context,
      {required int accountType, required AccountTypeChangeCubit accountTypeChangeCubit}) async {
    try {
      emit(state.copyWith(isLoading: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.accountType: accountType,
      };

      var response = await accountTypeRepo.activeListingCount(requestBody);

      if (response.status) {
        emit(state.copyWith(
          isLoading: false,
          businessDeleteCount: response.responseData?.result?.businessDeleteCount ?? 0,
          activeListingCount: response.responseData?.result?.activeListingCount ?? 0,
        ));

        /// Check if the account type is being changed from Business to Personal and has business listing
        if (state.accountType == EnumType.personalAccountType && ((state.businessDeleteCount ?? 0) > 0)) {
          await ReusableWidgets.showConfirmationDialog(
            AppConstants.pleasConfirm,
            AppConstants.accountTypeChangeBusinessMessage,
            () async {
              AppRouter.pop();

              if ((state.activeListingCount ?? 0) > 0) {
                // Navigate to choose active listing if there are active listings
                AppRouter.push(
                  AppRoutes.chooseActiveListing,
                  args: {
                    ModelKeys.accountTypeChangeCubit: accountTypeChangeCubit,
                    ModelKeys.accountType: state.accountType,
                  },
                );
              } else {
                // Change account type if there are no active listings
                await changeAccountType(
                  accountType: state.accountType ?? 0,
                );
              }
            },
          );
        }
        else if (state.accountType == EnumType.businessAccountType) {
          await ReusableWidgets.showConfirmationDialog(
            AppConstants.accountType,
            AppConstants.accountTypeChangePersonalMessage,
            () async {
              AppRouter.pop();

              if ((state.activeListingCount ?? 0) > 0) {
                AppRouter.push(
                  AppRoutes.chooseActiveListing,
                  args: {
                    ModelKeys.accountTypeChangeCubit: accountTypeChangeCubit,
                    ModelKeys.accountType: state.accountType,
                  },
                );
              }
            },
          );
        } else {
          // If no business listings need deletion, check active listings

          if ((state.activeListingCount ?? 0) > 0) {
            AppRouter.push(
              AppRoutes.chooseActiveListing,
              args: {
                ModelKeys.accountTypeChangeCubit: accountTypeChangeCubit,
                ModelKeys.accountType: state.accountType,
              },
            );
          }
        }

        /// User haven't created any items then change account
        if (response.responseData?.result?.businessDeleteCount == 0 &&
            response.responseData?.result?.activeListingCount == 0) {
          changeAccountType(accountType: accountType);
        }
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(state.copyWith(isLoading: false, businessDeleteCount: 0, activeListingCount: 0));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Api Call to change account type
  Future<void> changeAccountType({
    required int accountType,
  }) async {
    var oldState = state;
    try {
      emit(oldState.copyWith(isLoading: true));
      bool? selectAll;
      if (state.activeListingList != null && state.activeListingList!.isNotEmpty) {
        selectAll = state.selectedListing.first.selectAll ?? false;
      } else {
        selectAll = false;
      }
      var activeListings = state.selectedListing
          .where((item) => item.isSelected == true)
          .map((item) => {
                ModelKeys.categoryId: item.categoryId,
                ModelKeys.listingId: item.id,
              })
          .toList();
      Map<String, dynamic> requestBody = {
        ModelKeys.isSelectAll: selectAll,
        ModelKeys.activeListing: selectAll == true ? [] : (activeListings.isEmpty ? [] : activeListings),
      };

      var response = await accountTypeRepo.changeAccountType(requestBody, accountType);

      if (response.status) {
        emit(oldState.copyWith(
          isLoading: false,
        ));

        AppUtils.loginUserModel?.accountTypeValue = AppConstants.accountTypeOptions[accountType];
        await PreferenceHelper.instance.updateAccountType(AppConstants.accountTypeOptions[accountType]!);
        AppRouter.pushRemoveUntil(AppRoutes.homeScreenRoute);
        AppUtils.showSnackBar(response.message, SnackBarType.success);
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(oldState.copyWith(
          isLoading: false,
        ));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(oldState.copyWith(
        isLoading: false,
      ));
    }
  }

  /// Api call to fetch all active listing
  Future<void> activeListingList({
    required int accountType,
    bool isRefresh = false,
  }) async {
    var oldState = state;

    try {
      emit(oldState.copyWith(isLoading: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.accountType: accountType,
        ModelKeys.search: '',
        ModelKeys.pageIndex: currentPage,
        ModelKeys.pageSize: AppConstants.pageSize,
      };

      var response = await accountTypeRepo.activeListingList(requestBody);
      if (response.responseData?.statusCode == 200 && response.responseData != null) {
        List<MyListingItems> activeListingList =
            (response.responseData?.result?.expand((model) => model.items ?? []).toList() ?? []).cast<MyListingItems>();
        List<MyListingItems> updatedActiveListingList =
            isRefresh ? activeListingList : [...?oldState.activeListingList, ...activeListingList];
        if ((response.responseData?.result?[0].count ?? 0) > updatedActiveListingList.length) {
          hasNextPage = true;
          currentPage++;
        } else {
          hasNextPage = false;
        }
        int count =
            (response.responseData?.result?.map((model) => model.count ?? 0).reduce((sum, current) => sum + current)) ??
                0;
        if (isRefresh == true) {
          oldState.activeListingList?.isNotEmpty ?? false ? oldState.activeListingList?.clear() : null;
          oldState.selectedListing.isNotEmpty ? oldState.selectedListing.clear() : null;
        }
        emit(oldState.copyWith(
            isLoading: false,
            activeListingList: updatedActiveListingList,
            selectedListing: updatedActiveListingList,
            totalCount: count));
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(oldState.copyWith(isLoading: false, activeListingList: [], selectedListing: []));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(oldState.copyWith(isLoading: false));
    }
  }

  void updateActiveListing(List<MyListingItems> updatedList) {
    var oldState = state;
    emit(oldState.copyWith(selectedListing: updatedList));
  }

  void clearSelectedListings(List<MyListingItems> updatedList) {
    var oldState = state;
    emit(oldState.copyWith(selectedListing: updatedList));
  }
}

class ActiveListing {
  final int? categoryId;
  final int? listingID;
  bool isSelected;

  ActiveListing({required this.categoryId, required this.listingID, this.isSelected = false});
}
