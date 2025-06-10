import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/utils/add_listing_form_utils/form_validation_regex.dart';

class RequiredFieldsConstants {
  /// Basic Details Required Fields
  static Map<String, dynamic> basicDetailsRequiredFields = {
    AddListingFormConstants.businessType: null,
    AddListingFormConstants.businessName: FormValidationRegex.nameRegex,
    AddListingFormConstants.businessDescription: null,
  };

  /// Contact Details Required Fields
  static Map<String, dynamic> contactDetailsRequiredFields = {
    AddListingFormConstants.location: null,
    AddListingFormConstants.businessEmail: FormValidationRegex.businessEmailRegex,
  };

  /// Privacy Policy Required Fields
  static Map<String, dynamic> privacyPolicyRequiredFields = {
    AddListingFormConstants.businessVisibility: null,
  };

  /// Business Images Required Fields
  static Map<String, dynamic> businessImagesRequiredFields = {};

  /// Worker Basic Details Required Fields
  static Map<String, dynamic> workerBasicDetailsRequiredFields = {
    AddListingFormConstants.workerName: null,
    AddListingFormConstants.workerDescription: null,
    AddListingFormConstants.selectVisibility: null,
  };

  /// Worker Contact Details Required Fields
  static Map<String, dynamic> workerContactDetailsRequiredFields = {
    AddListingFormConstants.location: null,
    AddListingFormConstants.contactName: null,
    AddListingFormConstants.businessEmail: FormValidationRegex.businessEmailRegex,
  };

  /// Worker Skills Required Fields
  static Map<String, dynamic> skillsRequiredFields = {
    AddListingFormConstants.selectVisibility: null,
  };

  /// Auto Basic Details Required Fields
  static Map<String, dynamic> autoBasicDetailsRequiredFields = {
    AddListingFormConstants.autoType: null,
    AddListingFormConstants.autoTitle: null,
    AddListingFormConstants.autoRegistered: null,
    AddListingFormConstants.autoDescription: null,
    AddListingFormConstants.autoYear: null,
  };

  /// Auto Price and Location Required Fields
  static Map<String, dynamic> autoPriceAndLocationRequiredFields = {
    AddListingFormConstants.saleOrRentOrLease: null,
    AddListingFormConstants.location: null,
    AddListingFormConstants.vehicleCondition: null,
  };

  /// Auto Price and Location Required Fields
  static Map<String, dynamic> autoContactDetailsRequiredFields = {
    AddListingFormConstants.contactName: null,
    AddListingFormConstants.contactEmail: FormValidationRegex.businessEmailRegex,
    AddListingFormConstants.showStreetAddress: null,
    AddListingFormConstants.listingVisibility: null,
  };

  // static Map<String,dynamic> for promo basic details
  static Map<String, dynamic> promoBasicDetailsRequiredFields = {
    AddListingFormConstants.businessCommunityTypeKey: null,
    AddListingFormConstants.businessName: null,
    AddListingFormConstants.community: null,
    AddListingFormConstants.promoCategory: null,
    AddListingFormConstants.promotionName: null,
    AddListingFormConstants.promotionDescription: null,
    AddListingFormConstants.startDate: null,
    AddListingFormConstants.endDate: null,
  };

  // static Map<String,dynamic> for promo contact details
  static Map<String, dynamic> promoContactDetailsRequiredFields = {
    AddListingFormConstants.contactName: null,
    AddListingFormConstants.contactEmail: FormValidationRegex.emailRegex,
    AddListingFormConstants.location: null,
  };

  /// Promo Images Required Fields
  static Map<String, dynamic> promoImagesRequiredFields = {};

  /// Job Images Required Fields
  static Map<String, dynamic> jobImagesRequiredFields = {};

  /// Classified Images Required Field
  static Map<String, dynamic> classifiedImagesRequiredFields = {};

  /// Job Basic Details Required Fields
  static Map<String, dynamic> jobBasicDetailsRequiredFields = {
    AddListingFormConstants.jobTitle: null,
    AddListingFormConstants.industryType: null,
    AddListingFormConstants.description: null,
  };

  /// Job Contact Details Required Fields
  static Map<String, dynamic> jobSalaryDetailsRequiredFields = {
    AddListingFormConstants.estimatedSalary: null,
    AddListingFormConstants.currencyINR: null,
    // AddListingFormConstants.selectYourDate: FormValidationRegex.dateRegex,
    AddListingFormConstants.selectYourDate: null,
    AddListingFormConstants.selectVisibility: null,
    AddListingFormConstants.location: null,
  };

  static Map<String, dynamic> jobContactDetailsRequiredFields = {
    AddListingFormConstants.name: null,
    AddListingFormConstants.businessEmail: FormValidationRegex.businessEmailRegex,
  };

  static Map<String, dynamic> classifiedBasicDetailsRequiredFields = {
    AddListingFormConstants.classifiedType: null,
    AddListingFormConstants.itemName: null,
    AddListingFormConstants.itemDescription: null,
  };

  static Map<String, dynamic> classifiedDeliveryDetailsRequiredFields = {
    AddListingFormConstants.listingVisibility: null,
    AddListingFormConstants.location: null,
    AddListingFormConstants.currencyINR: null,
  };

  static Map<String, dynamic> classifiedContactDetailsRequiredFields = {
    AddListingFormConstants.contactName: null,
    AddListingFormConstants.businessEmail: null,
    AddListingFormConstants.businessVisibility: null,
  };

  /// Add Community Required Fields
  static Map<String, dynamic> communityBasicDetailsRequiredFields = {
    AddListingFormConstants.communityType: null,
    AddListingFormConstants.listingTitle: null,
    AddListingFormConstants.communityDescription: null,
  };

  static Map<String, dynamic> communityContactDetailsRequiredFields = {
    AddListingFormConstants.contactName: null,
    AddListingFormConstants.contactEmail: null,
    AddListingFormConstants.location: null,
    AddListingFormConstants.showStreetAddress: null,
    AddListingFormConstants.listingVisibility: null,
  };

  /// Add Real Estate Required Fields
  static Map<String, dynamic> realEstateBasicDetailsRequiredFields = {
    AddListingFormConstants.propertyTitle: null,
    AddListingFormConstants.propertyDescription: null,
    AddListingFormConstants.propertyType: null,
  };
  static Map<String, dynamic> realEstateCostDetailsRequiredFields = {
    AddListingFormConstants.location: null,
    AddListingFormConstants.propertyOnSaleRent: null,
    AddListingFormConstants.currencyINR: null,
  };
  static Map<String, dynamic> realEstateContactDetailsRequiredFields = {
    AddListingFormConstants.contactName: null,
    AddListingFormConstants.contactEmail: null,
    AddListingFormConstants.listingVisibility: null,
  };

  /// Removing validation method
  /// Should be used if deleting multiple validations
  static void removeValidations({required Map<String, dynamic> requiredFieldsList, required List<String> deleteKeys}) {
    for (var element in deleteKeys) {
      requiredFieldsList.remove(element);
    }
  }
}
