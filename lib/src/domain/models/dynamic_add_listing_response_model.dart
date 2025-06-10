import 'package:workapp/src/domain/models/add_listing_dynamic_form.dart';
import 'package:workapp/src/domain/models/add_listing_form_model.dart';
import 'package:workapp/src/domain/models/business_profile_detail_resp.dart';

class DynamicAddListingResponseModel {
  final int statusCode;
  final String message;
  final Result result;
  final bool isSuccess;
  final String utcTimeStamp;

  DynamicAddListingResponseModel({
    required this.statusCode,
    required this.message,
    required this.result,
    required this.isSuccess,
    required this.utcTimeStamp,
  });

  factory DynamicAddListingResponseModel.fromJson(Map<String, dynamic> json) {
    return DynamicAddListingResponseModel(
      statusCode: json['statusCode'],
      message: json['message'],
      result: Result.fromJson(json['result']),
      isSuccess: json['isSuccess'],
      utcTimeStamp: json['utcTimeStamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'result': result.toJson(),
      'isSuccess': isSuccess,
      'utcTimeStamp': utcTimeStamp,
    };
  }
}

class Result {
  final int listingId;
  final int formId;
  final int recordStatusID;
  final List<Sections> sections;
  final List<BusinessImagesModel?>? images;

  Result({
    required this.listingId,
    required this.formId,
    required this.recordStatusID,
    required this.sections,
    required this.images,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      listingId: json['listingId'],
      formId: json['formId'],
      recordStatusID: json['recordStatusID'],
      sections: (json['sections'] as List)
          .map((section) => Sections.fromJson(section))
          .toList(),
      images: json['images'] != null
          ? (json['images'] as List)
          .map((image) => BusinessImagesModel.fromJson(image))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listingId': listingId,
      'formId': formId,
      'recordStatusID': recordStatusID,
      'sections': sections.map((section) => section.toJson()).toList(),
      'images': images,
    };
  }
}
