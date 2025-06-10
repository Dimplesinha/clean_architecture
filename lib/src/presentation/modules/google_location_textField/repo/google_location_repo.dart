import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/google_location_model.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 25-09-2024
/// @Message : [FetchGoogleLocationRepo]

class FetchGoogleLocationRepo {
  static final FetchGoogleLocationRepo _singleton = FetchGoogleLocationRepo._internal();

  FetchGoogleLocationRepo._internal();

  static FetchGoogleLocationRepo get instance => _singleton;

  Future<ResponseWrapper<LocationPredictionModel>> fetchSuggestions({required String input}) async {
    var uuid = const Uuid();
    try {
      Map<String, String> queryParam = {
        ModelKeys.input: input,
        ModelKeys.key: ApiConstant.placesApiKey,
        ModelKeys.sessiontoken: uuid.v4()
      };
      var response = await ApiClient.instance.getApi(
          customBaseUrl: ApiConstant.googleApiBaseUrl, path: ApiConstant.placesApiStr, queryParameters: queryParam);
      if (response.status) {
        LocationPredictionModel data = LocationPredictionModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: data);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<Map<String, String>> getLatLongFromPlaceId({required String placeId}) async {
    Map<String, String> queryParam = {
      ModelKeys.placeId: placeId,
      ModelKeys.key: ApiConstant.placesApiKey,
    };
    Map<String, String> map = {};

    var response = await ApiClient.instance.getApi(
      customBaseUrl: ApiConstant.googleGeocodeAPIBaseURL,
      path: ApiConstant.geocodeApiStr,
      queryParameters: queryParam,
    );
    if (response.status) {
      var result = response.responseData['results'];
      List<AddressComponents> addressList = [];

      if (result[0][AppConstants.addressComponents] != null) {
        result[0][AppConstants.addressComponents].forEach((v) {
          addressList.add(AddressComponents.fromJson(v));
        });

        if (addressList.isNotEmpty) {
          for (var element in addressList) {
            List<String> types = element.types!;

            /// sub-locality  locality administrative_area_level_1 country, postal code
            if (types.isNotEmpty) {
              /// street
              if (types.contains(ModelKeys.subLocality)) {
                map.putIfAbsent(ModelKeys.subLocality, () => element.longName ?? '');
              } else if (types.contains(ModelKeys.neighborhood)) {
                map.putIfAbsent(ModelKeys.subLocality, () => element.longName ?? '');
              }

              /// City
              if (types.contains(ModelKeys.locality)) {
                map.putIfAbsent(ModelKeys.city, () => element.longName ?? '');
              } else if (types.contains(ModelKeys.administrativeAreaLevel_3)) {
                map.putIfAbsent(ModelKeys.city, () => element.longName ?? '');
              }

              /// State
              if (types.contains(ModelKeys.administrativeAreaLevel_1)) {
                map.putIfAbsent(ModelKeys.administrativeAreaLevel_1, () => element.longName ?? '');
              }
              if (types.contains(ModelKeys.postalCode)) {
                map.putIfAbsent(ModelKeys.postalCode, () => element.longName ?? '');
              }

              /// country
              if (types.contains(ModelKeys.country)) {
                map.putIfAbsent(ModelKeys.country, () => element.longName ?? '');
              }
            }
          }
        }
      }
      map.putIfAbsent('lat', () => "${result[0]['geometry']['location']['lat']}");
      map.putIfAbsent('lng', () => "${result[0]['geometry']['location']['lng']}");
    } else {
      AppUtils.showErrorSnackBar(response.message);
    }
    return map;
  }
}
