import 'dart:developer';

import 'package:workapp/src/core/constants/api_constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 26/03/25
/// @Message : [InviteContactFormRepository]

class InviteContactFormRepository {
  static final InviteContactFormRepository _chatRepository = InviteContactFormRepository._internal();

  InviteContactFormRepository._internal();

  static InviteContactFormRepository get instance => _chatRepository;

  Future<ResponseWrapper<void>> inviteContacts({required List<Map<String, dynamic>> requestBody}) async {
    try {
      ResponseWrapper response = await ApiClient.instance.postApiWithArray(path: ApiConstant.inviteContact, requestBody: requestBody);
      log('response:${response.status}');
      if (response.status) {
        return ResponseWrapper(message: response.message, status: true);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      return ResponseWrapper(status: false, message: 'Failed to fetch');
    }
  }

  Future<ResponseWrapper<void>> checkEmailValidation({required Map<String, dynamic> requestBody}) async {
    try {
      ResponseWrapper response = await ApiClient.instance.postApi(path: ApiConstant.inviteValidate, requestBody: requestBody);
      log('response:${response.status}');
      if (response.status) {
        return ResponseWrapper(message: response.message, status: true);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      return ResponseWrapper(status: false, message: 'Failed to fetch');
    }
  }
}
