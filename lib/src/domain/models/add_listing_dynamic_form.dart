import 'package:workapp/src/domain/models/add_listing_form_model.dart';
import 'package:workapp/src/domain/models/business_profile_detail_resp.dart';

class AddListingDynamicForm {
  final int formId;
  final int? listingId;
  final int recordStatusID;
  final List<Sections> sections;
  List<BusinessImagesModel?>? images = [];

  AddListingDynamicForm({
    required this.formId,
    this.listingId,
    required this.recordStatusID,
    required this.sections,
    required this.images,
  });

  factory AddListingDynamicForm.fromJson(Map<String, dynamic> json) {
    return AddListingDynamicForm(
      formId: json['formId'],
      listingId: json['listingId'],
      recordStatusID: json['recordStatusID'],
      images: json['images'],
      sections: (json['sections'] as List).map((section) => Sections.fromJson(section)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'formId': formId,
      'recordStatusID': recordStatusID,
      'images': images,
      'sections': sections.map((section) => section.toJson()).toList(),
    };
    if (listingId != null) {
      data['listingId'] = listingId;
    }
    return data;
    /*return {
      'formId': formId,
      'listingId': listingId,
      'recordStatusID': recordStatusID,
      'images': images,
      'sections': sections.map((section) => section.toJson()).toList(),
    };*/
  }
}

class Section {
  final int id;
  final List<InputField> inputFields;

  Section({
    required this.id,
    required this.inputFields,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      inputFields: (json['inputFields'] as List).map((field) => InputField.fromJson(field)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inputFields': inputFields.map((field) => field.toJson()).toList(),
    };
  }
}

class InputField {
  final int? controlId;
  final int? responseControlId;
  final String? controlValue;

  InputField({
    required this.controlId,
    this.responseControlId,
    required this.controlValue,
  });

  factory InputField.fromJson(Map<String, dynamic> json) {
    return InputField(
      controlId: json['controlId'],
      responseControlId: json['responseControlId'],
      controlValue: json['controlValue'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'controlId': controlId,
      'controlValue': controlValue,
    };
    if (responseControlId != null) {
      data['responseControlId'] = responseControlId;
    }
    return data;
    /*return {
      'controlId': controlId,
      'responseControlId': responseControlId,
      'controlValue': controlValue,
    };*/
  }
}

class ImageData {
  final int id;
  final String fileName;
  final int fileType;
  final int displayOrder;
  final bool isDeleted;

  ImageData({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.displayOrder,
    required this.isDeleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileType': fileType,
      'displayOrder': displayOrder,
      'isDeleted': isDeleted,
    };
  }
}
