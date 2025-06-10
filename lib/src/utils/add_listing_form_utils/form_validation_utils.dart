import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/domain/models/add_listing_form_model.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/utils/add_listing_form_utils/listing_form_utils.dart';

class ListingFormValidationUtils {
  static final ListingFormValidationUtils _singleton = ListingFormValidationUtils._internal();

  ListingFormValidationUtils._internal();

  static ListingFormValidationUtils get instance => _singleton;

  static Future<(bool, String)> checkValidations({
    required Map<String, dynamic>? formData,
    required CategoriesListResponse category,
    required List<Sections>? section,
    required int currentFormIndex,
  }) async {
    // Get required fields for the current section only
    Map<String, String?> requiredFields = getRequiredFieldsForCurrentSection(
      currentSectionIndex: currentFormIndex,
      sections: section,
    );

    // Get fields of the current section only
    List<InputFields>? currentSectionFields = section
        ?.where((s) => s.index == currentFormIndex)
        .expand((s) => s.inputFields ?? [])
        .cast<InputFields>()
        .toList();

    for (var entry in requiredFields.entries) {
      String fieldLabel = entry.key;
      String? regex = entry.value;

      // Ensure this field belongs to the current section
      var field = currentSectionFields?.firstWhere(
            (f) => f.controlName == fieldLabel,
        orElse: () => InputFields(),
      );

      if (field == null) continue;

      // Fetch value from formData using label
      String userInput = formData?[fieldLabel]?.toString().trim() ?? '';
      // Required field check
      if (userInput.isEmpty) {
        return (false, '${field.label} is required.');
      }

      // Regex validation (if applicable)
      if (regex != null && regex.isNotEmpty) {
        String cleanedRegex = cleanRegex(regex); // Clean backend regex
        RegExp pattern = RegExp(cleanedRegex, caseSensitive: false);

        if (!pattern.hasMatch(userInput)) {
          return (false, '${field.label} format is invalid.');
        }
      }
    }
    var fieldCurrency = currentSectionFields?.firstWhere(
          (f) => f.controlName == AddListingFormConstants.currency.toLowerCase(),
      orElse: () => InputFields(),
    );

    //Ignore validation in case of classified type is free.
    if (fieldCurrency?.controlName == AddListingFormConstants.currency.toLowerCase()) {
      if (formData?[AddListingFormConstants.country.toLowerCase()] != null) {
        String? countryName = formData?[AddListingFormConstants.country.toLowerCase()];
        String? currency = formData?[AddListingFormConstants.currency.toLowerCase()];
        bool? isMatched = await AddListingFormUtils.getCountryFromCurrencyCountryName(
            currencyCode: currency, countryName: countryName);
        if (currency == null || currency.trim().isEmpty) {
          return (true, '');
        }
        if (isMatched == false) {
          return (false, AppConstants.currencyMatchCountryValidationMsg);
        }
      }
    }

    return (true, '');
  }


  static String cleanRegex(String backendRegex) {
    // Remove leading and trailing forward slashes if present
    if (backendRegex.startsWith('/') && backendRegex.endsWith('/')) {
      backendRegex = backendRegex.substring(1, backendRegex.length - 1);
    }
    return backendRegex;
  }

  ///  Get required fields and their regex for validation
  static Map<String, String?> getRequiredFieldsForCurrentSection({
    required int currentSectionIndex,
    required List<Sections>? sections,
  }) {
    //  Find the current section
    var currentSection = sections?.firstWhere(
      (sec) => sec.index == currentSectionIndex,
      orElse: () => Sections(id: 0, sectionName: '', index: 0, inputFields: []),
    );

    //  Return an empty map if section is invalid
    if (currentSection == null || currentSection.inputFields!.isEmpty) return {};

    Map<String, String?> requiredFields = {};

    //  Store required fields using `label` and regex (if present)
    for (var field in currentSection.inputFields!) {
      if (field.formValidations?.isRequired == true) {
        // Store the field label and regex if available, otherwise store null
        requiredFields[field.controlName ?? ''] =
            field.formValidations?.regex?.trim().isNotEmpty == true ? field.formValidations?.regex?.trim() : null;
      }
    }

    return requiredFields;
  }

}
