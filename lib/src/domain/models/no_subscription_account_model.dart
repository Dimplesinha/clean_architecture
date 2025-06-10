class NoSubscriptionAccount {
  int? statusCode;
  String? message;
  List<NoSubscriptionAccountData>? noSubscriptionAccountData;
  bool? isSuccess;

  NoSubscriptionAccount(
      {this.statusCode, this.message, this.noSubscriptionAccountData, this.isSuccess});

  NoSubscriptionAccount.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      noSubscriptionAccountData = <NoSubscriptionAccountData>[];
      json['result'].forEach((v) {
        noSubscriptionAccountData!.add(NoSubscriptionAccountData.fromJson(v));
      });
    }
    isSuccess = json['isSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (noSubscriptionAccountData != null) {
      data['result'] = noSubscriptionAccountData!.map((v) => v.toJson()).toList();
    }
    data['isSuccess'] = isSuccess;
    return data;
  }
}

class NoSubscriptionAccountData {
  int? userId;
  String? userName;
  String? email;
  String? status;
  int? accountType;
  String? accountTypeValue;

  NoSubscriptionAccountData(
      {this.userId, this.userName, this.email, this.status, this.accountType,this.accountTypeValue});

  NoSubscriptionAccountData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    email = json['email'];
    status = json['status'];
    accountType = json['accountType'];
    accountTypeValue = json['accountTypeValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['email'] = email;
    data['status'] = status;
    data['accountType'] = accountType;
    data['accountTypeValue'] = accountTypeValue;
    return data;
  }
}
