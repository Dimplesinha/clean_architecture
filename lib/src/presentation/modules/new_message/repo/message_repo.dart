import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/constants/api_constants.dart';
import 'package:workapp/src/domain/api/api_exports.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/domain/models/my_contacts_model.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 19/09/24
/// @Message : [ContactRepository]

class ContactRepository {
  static final ContactRepository _chatRepository = ContactRepository._internal();

  ContactRepository._internal();

  static ContactRepository get instance => _chatRepository;

  Future<ResponseWrapper<ContactModel>> fetchContact() async {
    try {
      const jsonString = '''
      {
    "success": true,
    "message": "Contacts fetched successfully",
    "code": 200,
    "contactInfo": [
    {
        "id": 1,
        "name": "John Doe",
        "profilePic": "https://example.com/johndoe.jpg"
    },
    {
        "id": 2,
        "name": "Jane Smith",
        "profilePic": "https://example.com/janesmith.jpg"
    },
    {
        "id": 3,
        "name": "Alice Johnson",
        "profilePic": "https://example.com/alicejohnson.jpg"
    },
    {
        "id": 4,
        "name": "Bob Brown",
        "profilePic": "https://example.com/bobbrown.jpg"
    },
    {
        "id": 5,
        "name": "Charlie Davis",
        "profilePic": "https://example.com/charliedavis.jpg"
    },
    {
        "id": 6,
        "name": "Emily White",
        "profilePic": "https://example.com/emilywhite.jpg"
    },
    {
        "id": 7,
        "name": "David Clark",
        "profilePic": "https://example.com/davidclark.jpg"
    },
    {
        "id": 8,
        "name": "Grace Lewis",
        "profilePic": "https://example.com/gracelewis.jpg"
    },
    {
        "id": 9,
        "name": "Henry Wilson",
        "profilePic": "https://example.com/henrywilson.jpg"
    },
    {
        "id": 10,
        "name": "Sophia Martinez",
        "profilePic": "https://example.com/sophiamartinez.jpg"
    }
]

}
      ''';

      final Map<String, dynamic> jsonData = json.decode(jsonString);
      ContactModel model = ContactModel.fromJson(jsonData);

      return ResponseWrapper(status: true, message: 'Data fetched successfully', responseData: model);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: '');
    }
  }

  /// Fetch contact Listing Data
  /* Future<ResponseWrapper<MyContactResponse>?> fetchContactList() async {
    try {
      //var user = await PreferenceHelper.instance.getUserData();
      //String token = user.result?.token ?? '';
      ResponseWrapper response = await ApiClient.instance.mockPostApiWithToken(path: ApiConstant.mockContactList);
      if (response.status) {
        MyContactResponse listingResponse = MyContactResponse.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: listingResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching listing data: $e');
      }
      // Return error in case of failure
      return ResponseWrapper(message: '', status: false);
    }
  }*/

  /// Fetch contact Listing Data
  Future<ResponseWrapper<MyContactResponse>?> fetchContactList({Map<String, dynamic>? requestBody}) async {
    try {
      ResponseWrapper response =
          await ApiClient.instance.postApi(path: ApiConstant.contactList, requestBody: requestBody);
      if (response.status) {
        MyContactResponse listingResponse = MyContactResponse.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: listingResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching listing data: $e');
      }
      // Return error in case of failure
      return ResponseWrapper(message: '', status: false);
    }
  }
}
