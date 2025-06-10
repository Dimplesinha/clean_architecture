
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/cubit/advance_search_cubit.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/widgets/auto_type_widget.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/widgets/category_type_widget.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/widgets/category_widget.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/widgets/industry_type_widget.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/widgets/property_type_widget.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/widgets/worker_skills_widget.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/view/google_location_view.dart';
import 'package:workapp/src/presentation/modules/search/cubit/search_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 06/09/24
/// @Message : [AdvanceSearchTab]
///
/// The `AdvanceSearchTab`  class provides a user interface for performing advanced searches in the app.
///
/// Responsibilities:
/// Responsibilities:
/// - Display a tabbed interface of one of the three sections: Advance Search
/// - Provide an advanced search form with multiple input fields for specifying search criteria.
/// - Allow users to select sorting options such as Freshest, Distance, or Price.
///
class AdvanceSearchTab extends StatefulWidget {
  final AdvanceSearchLoadedState state;
  final AdvanceSearchCubit advanceSearchCubit;
  final TextEditingController? locationController;
  final TextEditingController? keywordController;
  final Map<String, dynamic>? oldFormData;

  const AdvanceSearchTab({
    super.key,
    required this.state,
    required this.advanceSearchCubit,
    required this.locationController,
    required this.keywordController,
    required this.oldFormData,
  });

  @override
  State<AdvanceSearchTab> createState() => _AdvanceSearchTabState();
}

class _AdvanceSearchTabState extends State<AdvanceSearchTab> {
  SearchCubit searchCubit = SearchCubit();

  @override
  void initState() {
    /// If old form Data is available then updating the formData of state with old form data
    /// OldFormData is basically the form data of previous search of advance search screen
    if (widget.oldFormData != null) {
      widget.advanceSearchCubit.updateFormData(oldFormData: widget.oldFormData);
      widget.keywordController?.text = widget.oldFormData?[AppConstants.keywordHintStr] ?? '';
    }
    if (widget.state.formDataMap?[AppConstants.sortBySmallStr] == null &&
        widget.oldFormData?[AppConstants.sortBySmallStr] == null) {
      widget.advanceSearchCubit.onFieldsValueChanged(key: AppConstants.sortBySmallStr, value: 3);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        CategoryWidget(state: widget.state, advanceSearchCubit: widget.advanceSearchCubit),
        const SizedBox(height: 20),
        AppTextField(
          hintTxt: AppConstants.keywordHintStr,
          height: 40,
          controller: widget.keywordController,
          textCapitalization: TextCapitalization.none,
          onChanged: (value) {
            widget.advanceSearchCubit.onFieldsValueChanged(key: AppConstants.keywordHintStr, value: value);
          },
        ),
        const SizedBox(height: 20),
        GoogleLocationView(
          hintText: AppConstants.locationStr,
          locationController: widget.locationController,
          selectedLocation: widget.state.formDataMap?[AddListingFormConstants.location],
          onLocationChanged: (Map<String, String?>? json) {
            // Extract city, state, and country based on the number of parts available
            String? city;
            String? state;
            String? country;
            String? location;
            if (json != null) {
              try {
                city = json[ModelKeys.city];
                state = json[ModelKeys.administrativeAreaLevel_1];
                country = json[ModelKeys.country];
                location = json[ModelKeys.description];
                widget.advanceSearchCubit.latitude = double.parse(json[ModelKeys.latitudeGoogleApi] ?? '0.0');
                widget.advanceSearchCubit.longitude = double.parse(json[ModelKeys.longitudeGoogleApi] ?? '0.0');
                // Update form fields with extracted values
              } catch (e) {
                if (kDebugMode) print('_ContactDetailsFormViewState.build-->${e.toString()}');
              }
            } else {
              widget.advanceSearchCubit.latitude = 0.0;
              widget.advanceSearchCubit.longitude = 0.0;
            }
            widget.advanceSearchCubit.onFieldsValueChanged(keysValuesMap: {
              AddListingFormConstants.city: city,
              AddListingFormConstants.state: state,
              AddListingFormConstants.country: country,
              AddListingFormConstants.location: location,
              AddListingFormConstants.latitude: widget.advanceSearchCubit.latitude.toString(),
              AddListingFormConstants.longitude: widget.advanceSearchCubit.longitude.toString(),
            });
          },
        ),
        ...createSearchFields(categoryName: widget.state.formDataMap?[AppConstants.selectCategoryStr]),
        sortByRadioWidget(),
        Visibility(
          visible: widget.advanceSearchCubit.isUserLogin!,
          child: GestureDetector(
            onTap: () {
              widget.advanceSearchCubit.onFieldsValueChanged(
                key: AppConstants.saveSearchStr,
                value: !(widget.state.formDataMap?[AppConstants.saveSearchStr] ?? false),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Checkbox(
                      checkColor: AppColors.whiteColor,
                      side: BorderSide(color: AppColors.primaryColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                        side: BorderSide(color: AppColors.primaryColor),
                      ),
                      activeColor: AppColors.primaryColor,
                      visualDensity: VisualDensity.standard,
                      value: widget.state.formDataMap?[AppConstants.saveSearchStr] ?? false,
                      onChanged: (value) {
                        widget.advanceSearchCubit.onFieldsValueChanged(key: AppConstants.saveSearchStr, value: value);
                      },
                    ),
                  ),
                  sizedBox5Width(),
                  Text(
                    AppConstants.saveSearchStr,
                    style: FontTypography.listingStatTxtStyle,
                  )
                ],
              ),
            ),
          ),
        ),
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CancelButton(
                  bgColor: Colors.white,
                  onPressed: () {
                    widget.keywordController?.clear();
                    widget.locationController?.clear();
                    widget.advanceSearchCubit.resetFormData();
                  },
                  title: AppConstants.reset.toUpperCase(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: AppButton(
                  function: () {
                    widget.advanceSearchCubit.searchListingForAdvanceSearch(
                      keyword: widget.keywordController?.text,
                      location: widget.locationController?.text,
                    );
                  },
                  title: AppConstants.searchStr.toUpperCase(),
                  textStyle: FontTypography.planTxtStyle.copyWith(color: AppColors.whiteColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Sort By Radio Button
  Widget sortByRadioWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AppConstants.sortBySmallStr,
          textStyle: FontTypography.subTextStyle,
          isRequired: false,
        ),
        Visibility(
          visible: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildRadioOption(2, widget.state, AddListingFormConstants.countrywide, AppConstants.sortBySmallStr),
              // Freshest option
              _buildRadioOption(1, widget.state, AddListingFormConstants.worldwide, AppConstants.sortBySmallStr),
              // Distance option
              _buildRadioOption(3, widget.state, AppConstants.nearMeStr, AppConstants.sortBySmallStr),
              // Price option
            ],
          ),
        ),
      ],
    );
  }

  /// Pets Allowed Radio Button
  Widget petsAllowedRadioWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AddListingFormConstants.petsAllowed,
          textStyle: FontTypography.subTextStyle,
          isRequired: false,
        ),
        Visibility(
          visible: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildRadioOption(1, widget.state, AppConstants.yesStr, AddListingFormConstants.petsAllowed),
              _buildRadioOption(2, widget.state, AppConstants.noStr, AddListingFormConstants.petsAllowed),
            ],
          ),
        ),
      ],
    );
  }

  /// Price Range Radio Button
  Widget priceRangeWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AddListingFormConstants.priceRange,
          textStyle: FontTypography.subTextStyle,
          isRequired: false,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AppTextField(
                hintTxt: AppConstants.minStr,
                initialValue: widget.state.formDataMap?[AppConstants.minStr],
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  widget.advanceSearchCubit.onFieldsValueChanged(key: AppConstants.minStr, value: value);
                },
              ),
            ),
            sizedBox5Width(),
            Expanded(
              child: AppTextField(
                hintTxt: AppConstants.maxStr,
                initialValue: widget.state.formDataMap?[AppConstants.maxStr],
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  widget.advanceSearchCubit.onFieldsValueChanged(key: AppConstants.maxStr, value: value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Price Sorting Radio Button
  Widget priceSortingRadioWidget() {
    return Column(
      children: [
        LabelText(
          title: AppConstants.priceStr,
          textStyle: FontTypography.subTextStyle,
          isRequired: false,
        ),
        Visibility(
          visible: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildRadioOption(1, widget.state, AppConstants.priceLowToHigh, AppConstants.priceStr),
              _buildRadioOption(2, widget.state, AppConstants.priceHighToLow, AppConstants.priceStr),
            ],
          ),
        ),
      ],
    );
  }

  /// Price Sorting Radio Button
  Widget ownerShipTypeRadioWidget({bool isLeaseRequired = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AppConstants.ownerShipType,
          textStyle: FontTypography.subTextStyle,
          isRequired: false,
        ),
        Visibility(
          visible: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildRadioOption(1, widget.state, AddListingFormConstants.sale, AppConstants.ownerShipType),
              _buildRadioOption(2, widget.state, AddListingFormConstants.rent, AppConstants.ownerShipType),
              Visibility(
                visible: isLeaseRequired,
                child: _buildRadioOption(3, widget.state, AddListingFormConstants.lease, AppConstants.ownerShipType),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(int value, AdvanceSearchLoadedState state, String label, String title) {
    return Expanded(
      child: SizedBox(
        height: 20,
        width: 100,
        child: GestureDetector(
          onTap: () {
            widget.advanceSearchCubit.onFieldsValueChanged(key: title, value: value);
          },
          child: Row(
            children: [
              Radio(
                value: value,
                groupValue: state.formDataMap?[title],
                visualDensity: VisualDensity.compact,
                onChanged: (value) {
                  widget.advanceSearchCubit.onFieldsValueChanged(key: title, value: value);
                },
                activeColor: AppColors.primaryColor,
              ),
              Text(label, style: FontTypography.defaultTextStyle),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createSearchFields({required String? categoryName}) {
    final formData = widget.state.dynamicFormData;
    switch (categoryName) {
    /// Community
      case AddListingFormConstants.community:
        return [
          LabelText(
            title: AddListingFormConstants.communityType,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          DropDownWidget(
            items: DropDownConstants.advanceSearchCommunityTypeDropDownList.values.toList(),
            dropDownOnChange: (value) {
              widget.advanceSearchCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.communityType, value: value ?? '');
            },
            hintText: AddListingFormConstants.communityTypeHint,
            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.communityType] ?? '',
            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.communityType],
          ),
        ];

    /// Worker
      case AddListingFormConstants.worker:
        return [
          WorkerSkillsWidget(
            state: widget.state,
            advanceSearchCubit: widget.advanceSearchCubit,
          )
        ];

    /// Classified
      case AddListingFormConstants.classified:
        return [
          LabelText(
            title: AddListingFormConstants.classifiedType,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          DropDownWidget(
            items: DropDownConstants.classifiedListDropDownList.values.toList(),
            dropDownOnChange: (value) {
              widget.advanceSearchCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.classifiedType, value: value ?? '');
            },
            hintText: AddListingFormConstants.classifiedType,
            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.classifiedType] ??
                AddListingFormConstants.classifiedType,
            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.classifiedType],
          ),
          priceRangeWidget(),
          priceSortingRadioWidget(),
        ];

    /// Real Estate
      case AddListingFormConstants.realEstate:
        return [
          ownerShipTypeRadioWidget(),
          PropertyTypeWidget(
            state: widget.state,
            advanceSearchCubit: widget.advanceSearchCubit,
          ),
          Visibility(
            visible: widget.state.formDataMap?[AppConstants.ownerShipType] == 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LabelText(
                  title: AddListingFormConstants.duration,
                  textStyle: FontTypography.subTextStyle,
                  isRequired: false,
                ),
                DropDownWidget(
                  items: DropDownConstants.estimatedSalaryPeriodDropDown.values.toList(),
                  hintText: AddListingFormConstants.duration,
                  dropDownOnChange: (value) {
                    widget.advanceSearchCubit.onFieldsValueChanged(key: AddListingFormConstants.duration, value: value);
                  },
                  displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.duration],
                  dropDownValue: widget.state.formDataMap?[AddListingFormConstants.duration] != ''
                      ? (widget.state.formDataMap?[AddListingFormConstants.duration])
                      : null,
                ),
              ],
            ),
          ),
          priceRangeWidget(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.beds,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    DropDownWidget(
                      items: DropDownConstants.countsList,
                      dropDownOnChange: (value) {
                        widget.advanceSearchCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.beds, value: value ?? '');
                      },
                      hintText: AddListingFormConstants.bedHint,
                      displaySelectedItem:
                      widget.state.formDataMap?[AddListingFormConstants.beds] ?? AddListingFormConstants.bedHint,
                      dropDownValue: widget.state.formDataMap?[AddListingFormConstants.beds],
                    ),
                  ],
                ),
              ),
              sizedBox10Width(),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.baths,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    DropDownWidget(
                      items: DropDownConstants.countsList,
                      dropDownOnChange: (value) {
                        widget.advanceSearchCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.baths, value: value ?? '');
                      },
                      hintText: AddListingFormConstants.bathHint,
                      displaySelectedItem:
                      widget.state.formDataMap?[AddListingFormConstants.baths] ?? AddListingFormConstants.bathHint,
                      dropDownValue: widget.state.formDataMap?[AddListingFormConstants.baths],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.garages,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    DropDownWidget(
                      items: DropDownConstants.countsList,
                      dropDownOnChange: (value) {
                        widget.advanceSearchCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.garages, value: value ?? '');
                      },
                      hintText: AddListingFormConstants.garageHint,
                      displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.garages] ??
                          AddListingFormConstants.garageHint,
                      dropDownValue: widget.state.formDataMap?[AddListingFormConstants.garages],
                    ),
                  ],
                ),
              ),
              sizedBox10Width(),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.pools,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    DropDownWidget(
                      items: DropDownConstants.countsList,
                      dropDownOnChange: (value) {
                        widget.advanceSearchCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.pools, value: value ?? '');
                      },
                      hintText: AddListingFormConstants.poolHint,
                      displaySelectedItem:
                      widget.state.formDataMap?[AddListingFormConstants.pools] ?? AddListingFormConstants.poolHint,
                      dropDownValue: widget.state.formDataMap?[AddListingFormConstants.pools],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.landSize,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    AppTextField(
                      hintTxt: AddListingFormConstants.landSize,
                      initialValue: widget.state.formDataMap?[AddListingFormConstants.landSize],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        widget.advanceSearchCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.landSize, value: value);
                      },
                    ),
                  ],
                ),
              ),
              sizedBox10Width(),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.landSizeUnit,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    DropDownWidget(
                      items: DropDownConstants.unitOfMeasureDropDownList.values.toList(),
                      dropDownOnChange: (value) {
                        widget.advanceSearchCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.landSizeUnit, value: value ?? '');
                      },
                      hintText: AddListingFormConstants.unitOfMeasure,
                      displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.landSizeUnit] ??
                          AddListingFormConstants.unitOfMeasure,
                      dropDownValue: widget.state.formDataMap?[AddListingFormConstants.landSizeUnit],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.buildingSize,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    AppTextField(
                      hintTxt: AddListingFormConstants.buildingSize,
                      initialValue: widget.state.formDataMap?[AddListingFormConstants.buildingSize],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        widget.advanceSearchCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.buildingSize, value: value);
                      },
                    ),
                  ],
                ),
              ),
              sizedBox10Width(),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.buildingSizeUnit,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    DropDownWidget(
                      items: DropDownConstants.unitOfMeasureDropDownList.values.toList(),
                      dropDownOnChange: (value) {
                        widget.advanceSearchCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.buildingSizeUnit, value: value ?? '');
                      },
                      hintText: AddListingFormConstants.unitOfMeasure,
                      displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.buildingSizeUnit] ??
                          AddListingFormConstants.unitOfMeasure,
                      dropDownValue: widget.state.formDataMap?[AddListingFormConstants.buildingSizeUnit],
                    ),
                  ],
                ),
              ),
            ],
          ),
          priceSortingRadioWidget(),
          petsAllowedRadioWidget()
        ];

    /// Job Or Jobs
      case AddListingFormConstants.job:
        return [
          IndustryTypeWidget(
            state: widget.state,
            advanceSearchCubit: widget.advanceSearchCubit,
          ),
        ];

    /// Promo
      case AddListingFormConstants.promo:
        return [
          CategoryTypeWidget(
            state: widget.state,
            advanceSearchCubit: widget.advanceSearchCubit,
          ),
        ];

    /// Auto
      case AddListingFormConstants.auto:
        return [
          AutoTypeWidget(
            state: widget.state,
            advanceSearchCubit: widget.advanceSearchCubit,
          ),
          priceRangeWidget(),
          priceSortingRadioWidget(),
          ownerShipTypeRadioWidget(isLeaseRequired: true),
        ];
      default:
        return [];
    }
  }
}

