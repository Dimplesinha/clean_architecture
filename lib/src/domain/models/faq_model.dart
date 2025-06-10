class FAQModel {
  int? statusCode;
  String? message;
  List<FAQResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  FAQModel({this.statusCode, this.message, this.result, this.isSuccess, this.utcTimeStamp});

  FAQModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <FAQResult>[];
      json['result'].forEach((v) {
        result!.add(FAQResult.fromJson(v));
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
}

class FAQResult {
  int? count;
  List<FAQItems>? items;

  FAQResult({this.count, this.items});

  FAQResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <FAQItems>[];
      json['items'].forEach((v) {
        items!.add(FAQItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FAQItems {
  String? question;
  String? answer;
  bool? isVisible;

  FAQItems({
    this.question,
    this.answer,
    this.isVisible = false,
  });

  FAQItems.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }
}
