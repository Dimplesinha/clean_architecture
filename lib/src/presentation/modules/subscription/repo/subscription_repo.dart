import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/my_subscription_data_model.dart';
import 'package:workapp/src/domain/models/no_subscription_account_model.dart';
import 'package:workapp/src/domain/models/promo_code_details.dart';
import 'package:workapp/src/domain/models/promo_code_list_model.dart';
import 'package:workapp/src/domain/models/promo_validate_model.dart';
import 'package:workapp/src/domain/models/sign_up_model.dart';
import 'package:workapp/src/domain/models/subscription_purchase_model.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 12/09/24
/// @Message : [SubscriptionRepo]

///Subscription Repo for api call with response wrapper.
class SubscriptionRepo {
  static final SubscriptionRepo _subscriptionRepo = SubscriptionRepo._internal();

  SubscriptionRepo._internal();

  static SubscriptionRepo get instance => _subscriptionRepo;

  Future<ResponseWrapper<SubscriptionHistoryResponse>> fetchHistoryDetails(Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance.putApi(
          path: ApiConstant.subscriberHistory.replaceAll('{userID}', AppUtils.loginUserModel?.id.toString() ?? ''),
          requestBody: json);
      if (response.status) {
        SubscriptionHistoryResponse model = SubscriptionHistoryResponse.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<SubscriptionHistoryResponse>> fetchSubscriptionPlan(Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.subscriberPlan, requestBody: json);
      if (response.status) {
        SubscriptionHistoryResponse model = SubscriptionHistoryResponse.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<SubscriptionPurchaseResponse>> buySubscriptionPlan(Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.buySubscriptionPlan, requestBody: json);
      if (response.status) {
        SubscriptionPurchaseResponse model = SubscriptionPurchaseResponse.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<SubscriptionDataModel>> fetchTransferSubscriptionAvailable() async {
    try {
      var response = await ApiClient.instance.getApi(
        path: ApiConstant.mySubscription.replaceAll('{account1}', AppUtils.loginUserModel?.id.toString() ?? ''),
      );
      if (response.status) {
        SubscriptionDataModel model = SubscriptionDataModel.fromJson(response.responseData);

        return ResponseWrapper(status: true, message: response.message, responseData: model);

      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<NoSubscriptionAccount>> getNoSubscriptionAccount() async {
    try {
      var response = await ApiClient.instance.getApi(
        path: ApiConstant.noSubscriptionAccounts,
      );
      if (response.status) {
        NoSubscriptionAccount model = NoSubscriptionAccount.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<SubscriptionDataModel>> activeListingCount(int selectedUserId, int subscriptionID) async {
    try {
      var response = await ApiClient.instance.getApi(
        path: ApiConstant.activeListingCountOfSubscriber
            .replaceAll('{account1}', subscriptionID.toString())
            .replaceAll('{account2}', selectedUserId.toString()),
      );
      if (response.status) {
        SubscriptionDataModel model = SubscriptionDataModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<MyListingResponse>> activeListingList(Map<String, dynamic> json, int selectedUserId) async {
    try {
      var response = await ApiClient.instance.postApi(
          path: ApiConstant.subscriptionActiveListingList.replaceAll('{switchAccount}', selectedUserId.toString()),
          requestBody: json);
      if (response.status) {
        MyListingResponse model = MyListingResponse.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<PromoCodeList>> promoCodeList(Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.promoCodeList, requestBody: json);
      if (response.status) {
        PromoCodeList model = PromoCodeList.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<PromoCodeAppliedDetails>> promoCodeDetails(int subscriberId, String promoCode) async {
    try {
      var response = await ApiClient.instance.getApi(
        path: '${ApiConstant.promoCodeData}$subscriberId',
        queryParameters: {
          ModelKeys.promoCode: promoCode,
        },
      );
      if (response.status) {
        PromoCodeAppliedDetails model = PromoCodeAppliedDetails.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<PromoCodeValidate>> promoCodeValidate(Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.promoCodeValidate, requestBody: json);
      if (response.status) {
        PromoCodeValidate model = PromoCodeValidate.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<VerifyModel>> transferSubscriptionPlan(
      Map<String, dynamic> json, int subscriptionId, int selectedUserId) async {
    try {
      var response = await ApiClient.instance.postApi(
          path: ApiConstant.transferSubscriptionPlan
              .replaceAll('{subscriptionId}', subscriptionId.toString())
              .replaceAll('{switchUserId}', selectedUserId.toString()),
          requestBody: json);
      if (response.status) {
        VerifyModel model = VerifyModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }
  Future<ResponseWrapper<VerifyModel>> isUpgradable(Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance.postApi(
        path: ApiConstant.isUpgradable,
        requestBody: json
      );
      if (response.status) {
        VerifyModel model = VerifyModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<CancelModel>> cancelSubscription(Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance.postApi(
          path: ApiConstant.cancelSubscription,
          requestBody: json);
      if (response.status) {
        CancelModel model = CancelModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }
}
