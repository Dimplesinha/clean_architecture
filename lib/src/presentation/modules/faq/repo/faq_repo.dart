import 'package:flutter/foundation.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/faq_model.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';

class FAQRepo {
  static final FAQRepo _faqRepo = FAQRepo._internal();

  FAQRepo._internal();

  static FAQRepo get instance => _faqRepo;

  Future<ResponseWrapper<FAQModel>?> fetchFaqList() async {
    try {
      ResponseWrapper response = await ApiClient.instance.getApi(path: ApiConstant.faqAll);
      if (response.status) {
        FAQModel faqModel = FAQModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: faqModel);
      } else {
        return ResponseWrapper(message: response.message, status: false);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching listing data: $e');
      }
      // Return error in case of failure
      return ResponseWrapper(message: '', status: false);
    }
  }
}