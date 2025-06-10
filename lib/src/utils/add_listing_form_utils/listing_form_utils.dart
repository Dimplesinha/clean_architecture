import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';

class AddListingFormUtils {
  static final AddListingFormUtils _singleton = AddListingFormUtils._internal();

  AddListingFormUtils._internal();

  static AddListingFormUtils get instance => _singleton;

  static int getTotalSectionsCount({required String categoryName}) {
    return getSectionsList(categoryName: categoryName).length;
  }

  /// This list help in getting the the list of sections of particular category/Listing
  static List<String> getSectionsList({required String categoryName}) {
    switch (categoryName) {
      case AddListingFormConstants.business:
        return AddListingFormConstants.addBusinessList;
      case AddListingFormConstants.worker:
        return AddListingFormConstants.addWorkersList;
      case AddListingFormConstants.auto:
        return AddListingFormConstants.addAutoList;
      case AddListingFormConstants.community:
        return AddListingFormConstants.addCommunityList;
      case AddListingFormConstants.realEstate:
        return AddListingFormConstants.addRealEstateList;
      case AddListingFormConstants.job:
        return AddListingFormConstants.addJobList;
      case AddListingFormConstants.classified:
        return AddListingFormConstants.addClassifiedList;
      case AddListingFormConstants.promo:
        return AddListingFormConstants.addPromoList;
      default:
        return AddListingFormConstants.addBusinessList;
    }
  }

  /// Create a map of thr selected image with current time
  static Map<DateTime, String> setSelectedImage({required String imageUrl}) {
    return {DateTime.now(): imageUrl};
  }

  static int getBusinessImagesMaximumCount({required CategoriesListResponse? categoryName}) {
    /// Add the exceptional cases here.
    switch (categoryName?.formName) {
      case AddListingFormConstants.business:
        return 15;
      case AddListingFormConstants.promo:
        return 15;
      case AddListingFormConstants.realEstate:
        return 30;

      default:
        return 15;
    }
  }

  static Future<bool> getCountryFromCurrencyCountryName(
      {required String? currencyCode, required String? countryName}) async {
    /// getting currencyList

    if (currencyCode == null) {
      return false;
    }
    var countryData = await PreferenceHelper.instance.getCountryList();
    var currencyList;
    if (countryName!.isNotEmpty) {
      currencyList = countryData.result?.where((item) {
        if (currencyCode.isNullOrEmpty()) return false;

        return item.countryName?.toLowerCase() == countryName.toLowerCase();
      });
    } else {
      currencyList = countryData.result;
    }
    /// preparing selected item model from selected currencyCode
    if (currencyList?.first.currencyCode?.toLowerCase() == currencyCode.toLowerCase()) {
      return true;
    } else {
      return false;
    }
  }
}
