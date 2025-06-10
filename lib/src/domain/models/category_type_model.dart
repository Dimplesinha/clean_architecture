class CategoryTypeModel {
  int? statusCode;
  String? message;
  List<CategoryTypeResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  CategoryTypeModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  CategoryTypeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <CategoryTypeResult>[];
      json['result'].forEach((v) {
        result!.add(CategoryTypeResult.fromJson(v));
      });
    }
    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['isSuccess'] = isSuccess;
    data['utcTimeStamp'] = utcTimeStamp;
    return data;
  }
  List<String>? get getCategoryTypeList => result?.map((item) => item.promoCategoryName as String).toList();
}

class CategoryTypeResult {
  int? promoCategoryId;
  String? promoCategoryName;
  int? diplayOrder;
  String? uuid;

  CategoryTypeResult(
      {this.promoCategoryId,
        this.promoCategoryName,
        this.diplayOrder,
        this.uuid});

  CategoryTypeResult.fromJson(Map<String, dynamic> json) {
    promoCategoryId = json['promoCategoryId'];
    promoCategoryName = json['promoCategoryName'];
    diplayOrder = json['diplayOrder'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promoCategoryId'] = promoCategoryId;
    data['promoCategoryName'] = promoCategoryName;
    data['diplayOrder'] = diplayOrder;
    data['uuid'] = uuid;
    return data;
  }
}