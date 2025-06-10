import 'package:workapp/src/domain/models/models_export.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 12/09/24
/// @Message : [ProfileListingRepo]

class ProfileListingRepo {
  ProfileListingRepo._internal();

  static ProfileListingRepo instance = ProfileListingRepo._internal();

  Future<ResponseWrapper<List<ListingData>>> getProfileListing({required String userId}) async {
    List<ListingData> profileListings = <ListingData>[
      ListingData(
        image: 'https://picsum.photos/seed/picsum/300/300',
        listingTitle: 'Elevate Your Connect',
        location: 'Kolkata, West Bengal',
        price: '520000000',
        time: '7 Days Ago',
      ),
      ListingData(
        image:'https://picsum.photos/400/300',
        listingTitle: 'Elevate Your Connect',
        location: 'Kolkata, West Bengal',
        price: '520000000',
        time: '7 Days Ago',
      ),
      ListingData(
        image:  'https://picsum.photos/300/400',
        listingTitle: 'Elevate Your Connect',
        location: 'Kolkata, West Bengal',
        price: '520000000',
        time: '7 Days Ago',
      ),
      // Add more listings
    ];
    return ResponseWrapper(status: true, message: 'Success', responseData: profileListings);

    /// To be used when API is ready.
    // try {
    //   var resp = await ApiClient.instance.getApi(
    //     path: ApiConstant.profileBasicDetailsStr,
    //     queryParameters: {ModelKeys.id: userId},
    //   );
    //   if (resp.status) {
    //     // var response = ProfileBasicDetailsModel.fromJson(resp.responseData);
    //     ProfileBasicDetailsModel profileBasicDetailsModel = ProfileBasicDetailsModel(
    //       firstName: 'Jeneliya',
    //       lastName: 'Desoza',
    //       dobTimeStamp: 1425889100,
    //       gender: 'female',
    //     );
    //     return ResponseWrapper(status: true, message: resp.message, responseData: profileBasicDetailsModel);
    //   } else {
    //     return ResponseWrapper(status: false, message: resp.message);
    //   }
    // } catch (e) {
    //   if (kDebugMode) print(e);
    //   return ResponseWrapper(status: false, message: AppConstants.somethingWentStr);
    // }
  }
}
