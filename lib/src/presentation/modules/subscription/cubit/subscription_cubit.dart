import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/my_subscription_data_model.dart';
import 'package:workapp/src/domain/models/no_subscription_account_model.dart';
import 'package:workapp/src/domain/models/promo_code_details.dart';
import 'package:workapp/src/domain/models/promo_code_list_model.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/subscription/repo/subscription_repo.dart';

import 'package:workapp/src/utils/in_app_purchase_utils.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  bool hasNextPage = true;
  int currentPage = 1;
  bool isPromoApplied = false;

  SubscriptionCubit() : super(SubscriptionInitial());

  ///init method for emitting loaded state
  void init() async {
    emit(SubscriptionLoadedState());
    await fetchTransferSubscriptionAvailable();
    await getNoSubscriptionAccount();
    await fetchSubscriptionPlan();
  }

  ///On Plan click is for selecting subscription plan
  void onPlanClick(int planID) {
    try {
      if (planID == 1) {
        emit(SubscriptionLoadedState(isPersonalPlanChecked: true, isWorkAppPlanChecked: false));
      } else {
        emit(SubscriptionLoadedState(isPersonalPlanChecked: false, isWorkAppPlanChecked: true));
      }
    } catch (e) {
      emit(SubscriptionLoadedState());
    }
  }

  void initialise() {
    emit(SubscriptionLoadedState());
  }

  ///Fetch History Items list using subscription repo and adding response data getting from response wrapper
  Future<void> fetchHistoryItems({bool isRefresh = false}) async {
    var oldState = state as SubscriptionLoadedState;

    try {
      emit(oldState.copyWith(loader: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.pageIndex: currentPage,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.sortOrder: EnumType.descOrder,
        ModelKeys.sortBy: 1,
        ModelKeys.search: '',
      };
      var response = await SubscriptionRepo.instance.fetchHistoryDetails(requestBody);

      if (response.status == true && response.responseData != null) {
        List<SubscriptionList> subscriptionData =
            (response.responseData?.result?.expand((model) => model.items ?? []).toList() ?? [])
                .cast<SubscriptionList>();
        List<SubscriptionList> subscriptionList =
            isRefresh ? subscriptionData : [...?oldState.mySubscriptionHistoryData, ...subscriptionData];
        if ((response.responseData?.result?[0].count ?? 0) > subscriptionList.length) {
          hasNextPage = true;
          currentPage++;
        } else {
          hasNextPage = false;
        }
        emit(
          oldState.copyWith(
            loader: false,
            mySubscriptionHistoryData: subscriptionList,
          ),
        );
      } else {
        emit(oldState.copyWith(loader: false, mySubscriptionHistoryData: []));
      }
    } catch (e) {
      emit(oldState.copyWith(loader: false, mySubscriptionHistoryData: []));
    }
  }

  ///Fetch subscription plan
  Future<void> fetchSubscriptionPlan({bool isRefresh = false}) async {
    var oldState = state as SubscriptionLoadedState;

    try {
      emit(oldState.copyWith(loader: true));

      if (isRefresh) {
        currentPage = 1;
      }

      Map<String, dynamic> requestBody = {
        ModelKeys.fromDate: null,
        ModelKeys.toDate: null,
        ModelKeys.status: 0,
        ModelKeys.pageIndex: currentPage,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.sortOrder: EnumType.descOrder,
        ModelKeys.sortBy: 1,
        ModelKeys.search: '',
      };
      var response = await SubscriptionRepo.instance.fetchSubscriptionPlan(requestBody);

      // Ensure result and items exist
      final resultList = response.responseData?.result;
      if (resultList == null || resultList.isEmpty) {
        emit(oldState.copyWith(loader: false, subscriptionData: []));
        return;
      }

      List<SubscriptionList> subscriptionList =
          resultList.expand((model) => model.items ?? []).toList().cast<SubscriptionList>();

      List<SubscriptionList> subscriptionData =
          isRefresh ? subscriptionList : [...?oldState.subscriptionData, ...subscriptionList];

      if ((resultList[0].count ?? 0) > subscriptionData.length) {
        hasNextPage = true;
        currentPage++;
      } else {
        hasNextPage = false;
      }

      emit(
        oldState.copyWith(
          loader: false,
          subscriptionData: subscriptionData,
        ),
      );
    } catch (e) {
      emit(oldState.copyWith(loader: false, subscriptionData: []));
    }
  }

  Future<void> buySubscriptionPlan(
    BuildContext context, {
    PurchaseDetails? purchaseDetail,
    required int countryId,
    required int subscriptionPlanId,
  }) async {
    var oldState = state as SubscriptionLoadedState;

    try {
      emit(oldState.copyWith(loader: true));
      double price = 0.0;
      String deviceId;
      try {
        price = InAppPurchaseUtils.instance.pricePremium;
        final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

        if (Platform.isIOS) {
          var iosInfo = await deviceInfoPlugin.iosInfo;
          deviceId = iosInfo.identifierForVendor ?? '';
        } else {
          var androidInfo = await deviceInfoPlugin.androidInfo;
          deviceId = androidInfo.id;
        }
      } catch (e) {
        if (kDebugMode) print('catch price format----->$this ${e.toString()}');
      }
      final String purchaseToken = purchaseDetail?.verificationData.serverVerificationData ?? '';

      Map<String, dynamic> requestBody = {
        ModelKeys.subscriptionId: subscriptionPlanId,
        ModelKeys.userId: AppUtils.loginUserModel?.id,
        ModelKeys.countryId: countryId,
        ModelKeys.price: oldState.promoDetails?.promoCode != null ? 0.0 : price,
        ModelKeys.transactionId: purchaseDetail?.purchaseID,
        ModelKeys.deviceType: Platform.isIOS ? 2 : 3,
        ModelKeys.deviceID: AppUtils.deviceUDID,
        ModelKeys.purchaseToken: purchaseToken,
        ModelKeys.promoCode: oldState.promoDetails?.promoCode,
      };
      if (oldState.subscriptionData?.first.transactionId.toString() != purchaseToken && oldState.isUpgradable == true) {
        var response = await SubscriptionRepo.instance.buySubscriptionPlan(requestBody);

        if (response.status == true && response.responseData != null) {
          AppRouter.pop();
          await fetchTransferSubscriptionAvailable();
          await fetchSubscriptionPlan(isRefresh: true);
          AppUtils.loginUserModel?.planPurchased = true;
          emit(
            oldState.copyWith(
              loader: false,
            ),
          );
          AppUtils.showSnackBar(response.message, SnackBarType.success);
        } else {
          await fetchTransferSubscriptionAvailable();
          await fetchSubscriptionPlan(isRefresh: true);

          emit(oldState.copyWith(
            loader: false,
          ));
          AppUtils.showSnackBar(response.message, SnackBarType.fail);
        }
      } else {
        emit(oldState.copyWith(
          loader: false,
        ));
      }
    } catch (e) {
      emit(oldState.copyWith(
        loader: false,
      ));
    }
  }

  Future<void> fetchTransferSubscriptionAvailable() async {
    var oldState = state as SubscriptionLoadedState;

    try {
      emit(oldState.copyWith(loader: true));
      var response = await SubscriptionRepo.instance.fetchTransferSubscriptionAvailable();

      if (response.status == true && response.responseData != null) {
        AppUtils.loginUserModel?.planPurchased = true;
        emit(
          oldState.copyWith(
            loader: false,
            mySubscriptionData: response.responseData?.mySubscriptionData,
          ),
        );
      } else {
        AppUtils.loginUserModel?.planPurchased = false;
        AppUtils.loginUserModel?.subscriberPlan = null;
        emit(oldState.copyWith(
          loader: false,
        ));
      }
    } catch (e) {
      emit(oldState.copyWith(
        loader: false,
      ));
    }
  }

  Future<bool> cancelSubscription(BuildContext context, int subscriptionPlanId) async {
    var oldState = state as SubscriptionLoadedState;

    try {
      emit(oldState.copyWith(loader: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.subscriptionId: subscriptionPlanId,
        ModelKeys.userId: AppUtils.loginUserModel?.id,
      };
      var response = await SubscriptionRepo.instance.cancelSubscription(requestBody);
      if (response.status == true && response.responseData != null) {
        emit(
          oldState.copyWith(
            loader: false,
            isCancelled: true,
          ),
        );
        AppUtils.showSnackBar(response.message, SnackBarType.success);
        await fetchTransferSubscriptionAvailable();
        await getNoSubscriptionAccount();
        await fetchSubscriptionPlan();
        return true;
      } else {
        AppUtils.showAlertDialog(
          context,
          title: AppConstants.cancelSubscription,
          description: response.message,
          confirmationText: AppConstants.okStr,
          onOkPressed: () {
            navigatorKey.currentState?.pop();
          },
        );
        emit(oldState.copyWith(loader: false, isCancelled: false));

        return false;
      }
    } catch (e) {
      emit(oldState.copyWith(
        loader: false,
      ));
      return false;
    }
  }

  Future<bool> isUpgradable(BuildContext context, double price) async {
    var oldState = state as SubscriptionLoadedState;

    try {
      emit(oldState.copyWith(loader: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.userId: AppUtils.loginUserModel?.id,
        ModelKeys.price: price,
        ModelKeys.deviceType: Platform.isIOS ? 2 : 3,
      };
      var response = await SubscriptionRepo.instance.isUpgradable(requestBody);

      if (response.status == true && response.responseData != null) {
        emit(
          oldState.copyWith(
            loader: false,
            isUpgradable: true,
          ),
        );
        return true;
      } else {
        emit(oldState.copyWith(
          loader: false,
        ));
        AppUtils.showAlertDialog(
          context,
          title: AppConstants.cancelSubscription,
          description: response.message,
          confirmationText: AppConstants.okStr,
          onOkPressed: () {
            navigatorKey.currentState?.pop();
          },
        );

        return false;
      }
    } catch (e) {
      emit(oldState.copyWith(
        loader: false,
      ));
      return false;
    }
  }

  Future<void> getNoSubscriptionAccount() async {
    var oldState = state as SubscriptionLoadedState;

    try {
      var response = await SubscriptionRepo.instance.getNoSubscriptionAccount();

      if (response.status == true && response.responseData != null) {
        List<NoSubscriptionAccountData> data = response.responseData?.noSubscriptionAccountData ?? [];
        emit(oldState.copyWith(loader: false, noSubscriptionAccountData: data));
      } else {
        emit(oldState.copyWith(loader: false));
      }
    } catch (e) {
      emit(oldState.copyWith(loader: false));
    }
  }

  void updateActiveListing(List<MyListingItems> updatedList) {
    var oldState = state as SubscriptionLoadedState;
    emit(oldState.copyWith(selectedListing: updatedList));
  }

  void changeSubscriptionAccount(String value, int selectedUserId) async {
    var oldState = state as SubscriptionLoadedState;
    try {
      emit(oldState.copyWith(selectedAccount: value, selectedUserId: selectedUserId));
    } catch (e) {
      emit(SubscriptionLoadedState());
    }
  }

  /// Api Call to fetch active listing count while changing account type
  Future<void> activeListingCount(BuildContext context,
      {required int selectedUserId, required SubscriptionCubit subscriptionCubit, required int subscriptionID}) async {
    var oldState = state as SubscriptionLoadedState;
    try {
      var response = await SubscriptionRepo.instance.activeListingCount(selectedUserId, subscriptionID);

      if (response.status) {
        emit(oldState.copyWith(loader: false, listingCount: response.responseData?.mySubscriptionData?.totalCount));
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(oldState.copyWith(
          loader: false,
        ));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(oldState.copyWith(loader: false));
    }
  }

  Future<void> activeListingList({
    required int selectedUserId,
    bool isRefresh = false,
  }) async {
    var oldState = state as SubscriptionLoadedState;

    try {
      emit(oldState.copyWith(loader: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.search: '',
        ModelKeys.pageIndex: currentPage,
        ModelKeys.pageSize: AppConstants.pageSize,
      };

      var response = await SubscriptionRepo.instance.activeListingList(requestBody, selectedUserId);
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
            loader: false,
            activeListingList: updatedActiveListingList,
            selectedListing: updatedActiveListingList,
            totalCount: count));
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(oldState.copyWith(loader: false, activeListingList: [], selectedListing: []));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(oldState.copyWith(loader: false));
    }
  }

  Future<void> transferSubscriptionPlan({
    required bool isFromActiveListing,
  }) async {
    var oldState = state as SubscriptionLoadedState;
    try {
      emit(oldState.copyWith(loader: true));
      int? subscriptionId = oldState.mySubscriptionData?.subscriptionId;
      int? selectedUserId = oldState.selectedUserId;
      bool? selectAll;
      if (oldState.activeListingList != null && oldState.activeListingList!.isNotEmpty) {
        selectAll = oldState.selectedListing.first.selectAll ?? false;
      } else {
        selectAll = false;
      }
      var activeListings = oldState.selectedListing
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

      var response =
          await SubscriptionRepo.instance.transferSubscriptionPlan(requestBody, subscriptionId ?? 0, selectedUserId!);

      if (response.status) {
        AppRouter.pop();
        AppUtils.loginUserModel?.subscriberPlan = null;
        if (isFromActiveListing == true) {
          AppRouter.pop();
          AppRouter.pop();
        }
        emit(oldState.copyWith(
          loader: false,
        ));

        AppUtils.showSnackBar(response.message, SnackBarType.success);
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(oldState.copyWith(
          loader: false,
        ));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(oldState.copyWith(
        loader: false,
      ));
    }
  }

  void clearSelectedListings(List<MyListingItems> updatedList) {
    var oldState = state as SubscriptionLoadedState;
    emit(oldState.copyWith(selectedListing: updatedList));
  }

  void selectedPromoCode(String promoCode) {
    var oldState = state as SubscriptionLoadedState;
    emit(oldState.copyWith(promoCode: promoCode));
  }

  Future<void> promoCodeList({
    required int subscriberId,
    bool isRefresh = false,
  }) async {
    emit(SubscriptionLoadedState());
    var oldState = state as SubscriptionLoadedState;

    try {
      emit(oldState.copyWith(loader: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.search: '',
        ModelKeys.pageIndex: 1,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.sortOrder: EnumType.descOrder,
        ModelKeys.sortBy: 1,
        ModelKeys.subscriptionId: subscriberId,
      };

      var response = await SubscriptionRepo.instance.promoCodeList(requestBody);
      oldState.promoCodeItems?.isNotEmpty ?? false ? oldState.promoCodeItems?.clear() : null;

      if (response.responseData?.statusCode == 200 && response.responseData != null) {
        List<PromoCodeItems> promoCodeItems =
            (response.responseData?.result?.expand((model) => model.items ?? []).toList() ?? []).cast<PromoCodeItems>();
        List<PromoCodeItems> updatedPromoCodeItems =
            isRefresh ? promoCodeItems : [...?oldState.promoCodeItems, ...promoCodeItems];
        if ((response.responseData?.result?[0].count ?? 0) > updatedPromoCodeItems.length) {
          hasNextPage = true;
          currentPage++;
        } else {
          hasNextPage = false;
        }
        int count =
            (response.responseData?.result?.map((model) => model.count ?? 0).reduce((sum, current) => sum + current)) ??
                0;

        emit(oldState.copyWith(
          loader: false,
          promoCodeItems: updatedPromoCodeItems,
        ));
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(oldState.copyWith(loader: false));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(oldState.copyWith(loader: false));
    }
  }

  Future<void> promoCodeDetail({
    required int subscriberId,
    required String promoCode,
    bool isRefresh = false,
  }) async {
    var oldState = state as SubscriptionLoadedState;

    try {
      emit(oldState.copyWith(loader: true));
      var response = await SubscriptionRepo.instance.promoCodeDetails(
        subscriberId,
        promoCode,
      );
      if (response.status) {
        emit(oldState.copyWith(loader: false, promoDetails: response.responseData?.result));
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(oldState.copyWith(loader: false));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(oldState.copyWith(loader: false));
    }
  }

  Future<bool> promoCodeValidate(
    BuildContext context, {
    required int subscriberId,
    required String promoCode,
    bool isRefresh = false,
    required SubscriptionCubit subscriptionCubit,
  }) async {
    var oldState = state as SubscriptionLoadedState;

    try {
      emit(oldState.copyWith(loader: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.promoCode: promoCode,
        ModelKeys.subscriptionId: subscriberId,
      };
      var response = await SubscriptionRepo.instance.promoCodeValidate(requestBody);
      if (response.responseData?.statusCode == 200 && response.responseData != null) {
        promoCodeDetail(subscriberId: subscriberId, promoCode: promoCode);
        emit(oldState.copyWith(loader: false));
        AppUtils.showSnackBar(response.message, SnackBarType.success);
        return true;
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(oldState.copyWith(loader: false));
        return false;
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(oldState.copyWith(loader: false));
      return false;
    }
  }

  void removePromoCode() {
    var oldState = state as SubscriptionLoadedState;
    emit(oldState.copyWith(promoCode: ''));
  }
}
