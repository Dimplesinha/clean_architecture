import 'package:workapp/src/domain/models/login_model.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';

class AddSwitchAccountRepository {
  static final AddSwitchAccountRepository _singleton = AddSwitchAccountRepository._internal();

  AddSwitchAccountRepository._internal();

  static AddSwitchAccountRepository get instance => _singleton;

  Future<ResponseWrapper<AddSubAccountModel>> addSubAccount(
      {required String path, required Map<String, dynamic> requestBody}) async {
    try {
      var response = await ApiClient.instance.postApi(
        path: path,
        requestBody: requestBody,
      );
      if (response.status) {
        AddSubAccountModel model = AddSubAccountModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<SubAccountModel>> getSubAccount({required String path}) async {
    try {
      var response = await ApiClient.instance.getApi(path: path);
      if (response.status) {
        SubAccountModel model = SubAccountModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<AddSubAccountModel>> onVerifyAccount({
    required String path,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      var response = await ApiClient.instance.postApi(
        path: path,
        requestBody: requestBody,
      );
      if (response.status) {
        AddSubAccountModel model = AddSubAccountModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<LoginResponse>> onSwitchAccount({
    required String path,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      var response = await ApiClient.instance.postApi(path: path, requestBody: requestBody);
      if (response.status) {
        LoginResponse model = LoginResponse.fromJson(response.responseData);
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
