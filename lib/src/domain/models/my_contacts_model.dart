class MyContactResponse {
  final int statusCode;
  final String message;
  final List<Result> result;
  final bool isSuccess;
  final DateTime utcTimeStamp;

  MyContactResponse({
    required this.statusCode,
    required this.message,
    required this.result,
    required this.isSuccess,
    required this.utcTimeStamp,
  });

  factory MyContactResponse.fromJson(Map<String, dynamic> json) {
    return MyContactResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      result: (json['result'] as List).map((e) => Result.fromJson(e)).toList(),
      isSuccess: json['isSuccess'],
      utcTimeStamp: DateTime.parse(json['utcTimeStamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'result': result.map((e) => e.toJson()).toList(),
      'isSuccess': isSuccess,
      'utcTimeStamp': utcTimeStamp.toIso8601String(),
    };
  }
}

class Result {
  final int count;
  final List<Contact> items;

  Result({
    required this.count,
    required this.items,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      count: json['count'],
      items: (json['items'] as List).map((e) => Contact.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class Contact {
  final int contactId;
  final int contactUserId;
  final int messageListId;
  final String name;
  final String? profilepic;
  final String email;
  final bool isBlockedByUser;

  Contact({
    required this.contactId,
    required this.contactUserId,
    required this.messageListId,
    required this.name,
    this.profilepic,
    required this.email,
    required this.isBlockedByUser,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      contactId: json['contactId'],
      contactUserId: json['contactUserId'],
      messageListId: json['messageListId'],
      name: json['name'],
      profilepic: json['profilepic'],
      email: json['email'],
      isBlockedByUser: json['isBlockedByUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactId': contactId,
      'contactUserId': contactUserId,
      'messageListId': messageListId,
      'name': name,
      'profilepic': profilepic,
      'email': email,
      'isBlockedByUser': isBlockedByUser,
    };
  }
}