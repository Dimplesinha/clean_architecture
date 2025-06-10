import 'package:flutter/foundation.dart';
import 'package:workapp/src/domain/models/business_list_model.dart';
import 'package:workapp/src/domain/models/business_profile_detail_resp.dart';
import 'package:workapp/src/domain/models/business_type_model.dart';
import 'package:workapp/src/domain/models/community_listing_type_model.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';

class AddListingUtils {
  static CommonDropdownModel? getBusinessDropdownItem(String? businessName, List<BusinessListResult>? list) {
    CommonDropdownModel? selectedItem;
    try {
      list = list?.where((item) => item.businessName == businessName).toList();
      if (list?.isNotEmpty ?? false) {
        var item = list?.first;
        selectedItem = CommonDropdownModel(id: item?.businessProfileId ?? 0, name: item?.businessName ?? '');
      }
    } catch (e) {
      if (kDebugMode) print('_ClassifiedBasicDetailsState._businessName $e');
    }
    return selectedItem;
  }

  static CommonDropdownModel? getBusinessTypeDropdownItem(String? businessType, List<BusinessTypeResult>? list) {
    CommonDropdownModel? selectedItem;
    try {
      list = list?.where((item) => item.businessTypeCode == businessType).toList();
      if (list?.isNotEmpty ?? false) {
        var item = list?.first;
        selectedItem = CommonDropdownModel(id: item?.businessTypeId ?? 0, name: item?.businessTypeCode ?? '');
      }
    } catch (e) {
      if (kDebugMode) print('_ClassifiedBasicDetailsState._businessName $e');
    }
    return selectedItem;
  }

  static CommonDropdownModel? getCommunityListingTypeDropdownItem(String? communityListingType, List<CommunityListingTypeResult>? list) {
    CommonDropdownModel? selectedItem;
    try {
      list = list?.where((item) => item.name == communityListingType).toList();
      if (list?.isNotEmpty ?? false) {
        var item = list?.first;
        selectedItem = CommonDropdownModel(id: item?.communityListingTypeId ?? 0, name: item?.name ?? '');
      }
    } catch (e) {
      if (kDebugMode) print('_ClassifiedBasicDetailsState._businessName $e');
    }
    return selectedItem;
  }

  static CommonDropdownModel? getCommunityDropdownItem(String? communityName, List<BusinessListResult>? list) {
    CommonDropdownModel? selectedItem;
    try {
      list = list?.where((item) => item.title == communityName).toList();
      if (list?.isNotEmpty ?? false) {
        var item = list?.first;
        selectedItem = CommonDropdownModel(id: item?.communityId ?? 0, name: item?.title ?? '');
      }
    } catch (e) {
      if (kDebugMode) print('_ClassifiedBasicDetailsState._businessName $e');
    }
    return selectedItem;
  }

  static List<Map<String, dynamic>> prepareImagesToUpload(List<BusinessImagesModel?>? imageModelList) {
    if (imageModelList != null) {
      List<Map<String, dynamic>> imageListMp = [];

      for (var item in imageModelList) {
        Map<String, dynamic> imageMap;
        String? result = item?.fileName; //.replaceFirst(ApiConstant.imageBaseUrl, '');

        imageMap = {
          ModelKeys.id: item?.id,
          ModelKeys.fileName: result,
          ModelKeys.fileType: item?.fileType,
          ModelKeys.displayOrder: ((item?.displayOrder ?? 0) + 1), // Use index for display order
          ModelKeys.isDeleted: item?.isDeleted ?? false, // Initially set to false
        };

        ///adding into image list
        imageListMp.add(imageMap);
      }
      return imageListMp;
    }
    return [];
  }

  static String handleEndDate(String endDate) {
    // Parse the date and modify it to the desired format
    DateTime date = DateTime.parse(endDate);
    DateTime lastMoment = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    // Output result
    return lastMoment.toUtc().toIso8601String();
  }

  static String handleStartDate(String startDate) {
    // Parse the date and modify it to the desired format
    DateTime date = DateTime.parse(startDate);
    DateTime lastMoment = DateTime(date.year, date.month, date.day, 00, 00, 00, 000);

    // Output result
    return lastMoment.toUtc().toIso8601String();
  }
}

enum BusinessVisibilityType {
  worldwide,
  countrywide,
}

extension VisibilityTypeExtension on BusinessVisibilityType {
  int get value {
    switch (this) {
      case BusinessVisibilityType.worldwide:
        return 1;
      case BusinessVisibilityType.countrywide:
        return 2;
    }
  }
}

enum AutoSaleType { sale, rent, lease }

extension AutoSaleTypeExtension on AutoSaleType {
  int get value {
    switch (this) {
      case AutoSaleType.sale:
        return 1;
      case AutoSaleType.rent:
        return 2;
      case AutoSaleType.lease:
        return 3;
    }
  }
}
