class ContactModel {
  bool? success;
  String? message;
  int? code;
  List<ContactInfo>? contactInfo;

  ContactModel({this.success, this.message, this.code, this.contactInfo});

  ContactModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    code = json['code'];
    if (json['contactInfo'] != null) {
      contactInfo = <ContactInfo>[];
      json['contactInfo'].forEach((v) {
        contactInfo!.add(ContactInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['code'] = code;
    if (contactInfo != null) {
      data['contactInfo'] = contactInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContactInfo {
  int? id;
  String? name;
  String? profilePic;

  ContactInfo({this.id, this.name, this.profilePic});

  ContactInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profilePic'] = profilePic;
    return data;
  }
}
