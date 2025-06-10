/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 25-03-2025
/// @Message : [ContactProfileModel]

class ContactProfileModel {
  final int statusCode;
  final String message;
  final Result result;
  final bool isSuccess;
  final String utcTimeStamp;

  ContactProfileModel({
    required this.statusCode,
    required this.message,
    required this.result,
    required this.isSuccess,
    required this.utcTimeStamp,
  });

  factory ContactProfileModel.fromJson(Map<String, dynamic> json) {
    return ContactProfileModel(
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
  final String userName;
  final String location;
  final String? profilePic;

  Result({
    required this.userName,
    required this.location,
    this.profilePic,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      userName: json['userName'],
      location: json['location'],
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'location': location,
      'profilePic': profilePic,
    };
  }
}