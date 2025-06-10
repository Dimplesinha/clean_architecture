import 'package:workapp/src/domain/models/business_profile_detail_resp.dart';

class DynamicFormDataModel {
  int? statusCode;
  String? message;
  DynamicFormData? result;
  bool? isSuccess;
  String? utcTimeStamp;

  DynamicFormDataModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  DynamicFormDataModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result =
    json['result'] != null ? new DynamicFormData.fromJson(json['result']) : null;
    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['isSuccess'] = isSuccess;
    data['utcTimeStamp'] = utcTimeStamp;
    return data;
  }
}

class DynamicFormData {
  String? formName;
  int? formId;
  String? formDescription;
  String? accountType;
  String? iconUrl;
  int? listingId;
  int? recordStatusId;
  bool? isSpam;
  bool? isTrustedUser;
  bool? isAvailableHistory;
  int? userAccountType;
  String? uuid;
  List<Sections>? sections;
  List<BusinessImagesModel>? images;

  DynamicFormData({
    this.formName,
    this.formId,
    this.formDescription,
    this.accountType,
    this.iconUrl,
    this.listingId,
    this.recordStatusId,
    this.isSpam,
    this.isTrustedUser,
    this.isAvailableHistory,
    this.userAccountType,
    this.uuid,
    this.sections,
    this.images,
  });

  DynamicFormData.fromJson(Map<String, dynamic> json) {
    formName = json['formName'];
    formId = json['formId'];
    formDescription = json['formDescription'];
    accountType = json['accountType'];
    iconUrl = json['iconUrl'];
    listingId = json['listingId'];
    recordStatusId = json['recordStatusId'];
    isSpam = json['isSpam'];
    isTrustedUser = json['isTrustedUser'];
    isAvailableHistory = json['isAvailableHistory'];
    userAccountType = json['userAccountType'];
    uuid = json['uuid'];

    if (json['sections'] != null) {
      sections = <Sections>[];
      json['sections'].forEach((v) {
        sections!.add(Sections.fromJson(v));
      });
    }

    // ✅ Fix: Ensure images are correctly deserialized
    if (json['images'] != null) {
      images = <BusinessImagesModel>[];
      json['images'].forEach((v) {
        images!.add(BusinessImagesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['formName'] = formName;
    data['formId'] = formId;
    data['formDescription'] = formDescription;
    data['accountType'] = accountType;
    data['iconUrl'] = iconUrl;
    data['listingId'] = listingId;
    data['recordStatusId'] = recordStatusId;
    data['isSpam'] = isSpam;
    data['isTrustedUser'] = isTrustedUser;
    data['isAvailableHistory'] = isAvailableHistory;
    data['userAccountType'] = userAccountType;
    data['uuid'] = uuid;

    if (sections != null) {
      data['sections'] = sections!.map((v) => v.toJson()).toList();
    }

    // ✅ Fix: Convert images to JSON properly
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}


class ImageData {
  int? id;
  String? fileName;
  int? fileType;
  int? displayOrder;

  ImageData({this.id, this.fileName, this.fileType, this.displayOrder});

  ImageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['fileName'];
    fileType = json['fileType'];
    displayOrder = json['displayOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fileName'] = fileName;
    data['fileType'] = fileType;
    data['displayOrder'] = displayOrder;
    return data;
  }
}

class Sections {
  int? id;
  String? sectionName;
  String? sectionControlName;
  int? index;
  List<InputFields>? inputFields;

  Sections(
      {this.id,
        this.sectionName,
        this.sectionControlName,
        this.index,
        this.inputFields});

  Sections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sectionName = json['sectionName'];
    sectionControlName = json['sectionControlName'];
    index = json['index'];
    if (json['inputFields'] != null) {
      inputFields = <InputFields>[];
      json['inputFields'].forEach((v) {
        inputFields!.add(new InputFields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(id != null) data['id'] = id;
    if(sectionName != null) data['sectionName'] = sectionName;
    if(sectionControlName != null) data['sectionControlName'] = sectionControlName;
    if(index != null) data['index'] = index;
    if (inputFields != null) data['inputFields'] = inputFields!.map((v) => v.toJson()).toList();
    return data;
  }
}

class InputFields {
  int? _id;
  int? _controlId;
  int? responseControlId;
  String? uniqueInputId;
  String? label;
  String? inputIconUrl;
  bool? allowSearch;
  bool? allowView;
  String? apiUrl;
  int? bindDropdown;
  String? keyLabel;
  String? valueLabel;
  int? inheritListingId;
  int? inheritControlId;
  String? inheritListingType;
  bool? isFieldPreDefined;
  String? connectedTo;
  String? comparedValue;
  String? controlName;
  String? placeholder;
  int? attributeId;
  String? type;
  bool? hasRange;
  bool? allowSorting;
  bool? isMultiSelect;
  int? maxFileAllow;
  String? allowFiles;
  String? controlAccountType;
  String? listingWidth;
  int? fieldOrder;
  List<Options>? options;
  FormValidations? formValidations;
  String? controlValue;

  int? get id => _id;
  set id(int? value) {
    _id = value;
    _controlId = value; // If controlId is null, assign id to controlId
  }

  int? get controlId => _controlId;
  set controlId(int? value) {
    if(value!=null) {
      _controlId = value;
    }
  }

  InputFields({
    int? id,
    int? controlId,
    this.responseControlId,
    this.uniqueInputId,
    this.label,
    this.inputIconUrl,
    this.allowSearch,
    this.allowView,
    this.apiUrl,
    this.bindDropdown,
    this.keyLabel,
    this.valueLabel,
    this.inheritListingId,
    this.inheritControlId,
    this.inheritListingType,
    this.isFieldPreDefined,
    this.connectedTo,
    this.comparedValue,
    this.controlName,
    this.placeholder,
    this.attributeId,
    this.type,
    this.hasRange,
    this.isMultiSelect,
    this.maxFileAllow,
    this.allowFiles,
    this.controlAccountType,
    this.listingWidth,
    this.fieldOrder,
    this.allowSorting,
    this.options,
    this.formValidations,
    this.controlValue,
  }) {
    this.id = id;
    this.controlId = controlId;
  }

  InputFields.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    controlId = json['controlId'];
    responseControlId = json['responseControlId'];
    uniqueInputId = json['uniqueInputId'];
    label = json['label'];
    inputIconUrl = json['inputIconUrl'];
    allowSearch = json['allowSearch'];
    allowView = json['allowView'];
    apiUrl = json['apiUrl'];
    bindDropdown = json['bindDropdown'];
    keyLabel = json['keyLabel'];
    valueLabel = json['valueLabel'];
    inheritListingId = json['inheritListingId'];
    inheritControlId = json['inheritControlId'];
    inheritListingType = json['inheritListingType'];
    isFieldPreDefined = json['isFieldPreDefined'];
    connectedTo = json['connectedTo'];
    comparedValue = json['comparedValue'];
    controlName = json['controlName'];
    placeholder = json['placeholder'];
    attributeId = json['attributeId'];
    type = json['type'];
    hasRange = json['hasRange'];
    isMultiSelect = json['isMultiSelect'];
    maxFileAllow = json['maxFileAllow'];
    allowFiles = json['allowFiles'];
    controlAccountType = json['controlAccountType'];
    listingWidth = json['listingWidth'];
    fieldOrder = json['fieldOrder'];
    allowSorting = json['allowSorting'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    formValidations = json['formValidations'] != null
        ? FormValidations.fromJson(json['formValidations'])
        : null;
    controlValue = json['controlValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_id != null) data['id'] = _id;
    if (_controlId != null) data['controlId'] = _controlId;
    if (responseControlId != null) data['responseControlId'] = responseControlId;
    if (uniqueInputId != null) data['uniqueInputId'] = uniqueInputId;
    if (label != null) data['label'] = label;
    if (inputIconUrl != null) data['inputIconUrl'] = inputIconUrl;
    if (allowSearch != null) data['allowSearch'] = allowSearch;
    if (allowView != null) data['allowView'] = allowView;
    if (apiUrl != null) data['apiUrl'] = apiUrl;
    if (bindDropdown != null) data['bindDropdown'] = bindDropdown;
    if (keyLabel != null) data['keyLabel'] = keyLabel;
    if (valueLabel != null) data['valueLabel'] = valueLabel;
    if (inheritListingId != null) data['inheritListingId'] = inheritListingId;
    if (inheritControlId != null) data['inheritControlId'] = inheritControlId;
    if (inheritListingType != null) data['inheritListingType'] = inheritListingType;
    if (isFieldPreDefined != null) data['isFieldPreDefined'] = isFieldPreDefined;
    if (connectedTo != null) data['connectedTo'] = connectedTo;
    if (comparedValue != null) data['comparedValue'] = comparedValue;
    if (controlName != null) data['controlName'] = controlName;
    if (placeholder != null) data['placeholder'] = placeholder;
    if (attributeId != null) data['attributeId'] = attributeId;
    if (type != null) data['type'] = type;
    if (hasRange != null) data['hasRange'] = hasRange;
    if (allowFiles != null) data['allowFiles'] = allowFiles;
    if (controlAccountType != null) data['controlAccountType'] = controlAccountType;
    if (isMultiSelect != null) data['isMultiSelect'] = isMultiSelect;
    if (maxFileAllow != null) data['maxFileAllow'] = maxFileAllow;
    if (listingWidth != null) data['listingWidth'] = listingWidth;
    if (fieldOrder != null) data['fieldOrder'] = fieldOrder;
    if (options != null) data['options'] = options!.map((v) => v.toJson()).toList();
    if (formValidations != null) data['formValidations'] = formValidations!.toJson();
    if (controlValue != null) data['controlValue'] = controlValue;
    data['allowSorting'] = allowSorting;
    return data;
  }
}


class Options {
  int? id;
  String? label;
  String? value;

  Options({this.id, this.label, this.value});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}

class FormValidations {
  bool? isRequired;
  int? id;
  String? minimum;
  String? maximum;
  String? regex;
  String? regexErrorMessage;

  FormValidations(
      {this.isRequired,
        this.id,
        this.minimum,
        this.maximum,
        this.regex,
        this.regexErrorMessage});

  FormValidations.fromJson(Map<String, dynamic> json) {
    isRequired = json['isRequired'];
    id = json['id'];
    minimum = json['minimum'];
    maximum = json['maximum'];
    regex = json['regex'];
    regexErrorMessage = json['regexErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isRequired'] = isRequired;
    data['id'] = id;
    data['minimum'] = minimum;
    data['maximum'] = maximum;
    data['regex'] = regex;
    data['regexErrorMessage'] = regexErrorMessage;
    return data;
  }
}
