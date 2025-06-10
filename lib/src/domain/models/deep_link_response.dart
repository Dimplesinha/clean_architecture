class DeepLinkResponse {
  int? statusCode;
  String? message;
  String? result;
  bool? isSuccess;
  String? utcTimeStamp;

  DeepLinkResponse({
    this.statusCode,
    this.message,
    this.result,
    this.isSuccess,
    this.utcTimeStamp,
  });

  DeepLinkResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];

    if (json['result'] != null && json['result'] is Map<String, dynamic>) {
      result = json['result'];
    } else {
      result = json['result'];
    }

    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;

   /* if (result is DeepLinkResult) {
      data['result'] = (result as DeepLinkResult).toJson();
    } else {*/
      data['result'] = result;
    //}

    data['isSuccess'] = isSuccess;
    data['utcTimeStamp'] = utcTimeStamp;
    return data;
  }
}

/*
class DeepLinkResult {
  String? url;

  DeepLinkResult({this.url});

  DeepLinkResult.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}
*/
