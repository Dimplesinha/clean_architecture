import 'package:workapp/src/domain/models/my_listing_model.dart';

class AdvanceSearchResponseResultModel {
  List<MyListingModel>? result;
  Map<String, dynamic>? oldFormData;

  AdvanceSearchResponseResultModel({
    this.result,
    this.oldFormData,
  });

  factory AdvanceSearchResponseResultModel.fromJson(Map<String, dynamic> json) {
    return AdvanceSearchResponseResultModel(
      result: (json['result'] as List?)
          ?.map((item) => MyListingModel.fromJson(item))
          .toList(),
      oldFormData: json['oldFormData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result?.map((item) => item.toJson()).toList(),
      'oldFormData': oldFormData,
    };
  }
}
