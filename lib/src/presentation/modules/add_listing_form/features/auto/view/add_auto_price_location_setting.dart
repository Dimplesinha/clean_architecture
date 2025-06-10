import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/features/required_fields/required_fields.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/radio_button_widget.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/view/google_location_view.dart';
import 'package:workapp/src/presentation/style/style.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/common_currency_center_dialog.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/add_listing_form_utils/decimal_input_formatter.dart';

/// Created by
/// @AUTHOR : Prakash Software Solution Pvt Ltd.
/// @DATE : 10-10-2024
/// @Message : [AddAutoPriceLocationSetting]

class AddAutoPriceLocationSetting extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const AddAutoPriceLocationSetting({super.key, required this.addListingFormCubit, required this.state});

  @override
  State<AddAutoPriceLocationSetting> createState() => _AddAutoPriceLocationSettingState();
}

class _AddAutoPriceLocationSettingState extends State<AddAutoPriceLocationSetting> {
  final searchController = TextEditingController();
  final selectCurrencyController = TextEditingController();
  List<Countries>? currencyList;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      selectCurrencyController.text = selectCurrencyController.text;
    });
    if (widget.state.formDataMap?[AddListingFormConstants.showStreetAddress] == null) {
      widget.addListingFormCubit
          .onFieldsValueChanged(keysValuesMap: {AddListingFormConstants.showStreetAddress: AddListingFormConstants.no});
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          LabelText(
            title: AddListingFormConstants.saleOrRentOrLease,
            textStyle: FontTypography.subTextStyle,
          ),
          DropDownWidget(
            items: DropDownConstants.saleOrRentOrLeaseList.values.toList(),
            dropDownOnChange: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
                AddListingFormConstants.saleOrRentOrLease: value,
              });
            },
            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.saleOrRentOrLease],
            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.saleOrRentOrLease] != '' ? (widget.state.formDataMap?[AddListingFormConstants.saleOrRentOrLease]) : null,
          ),
          LabelText(
            title: AddListingFormConstants.streetAddress,
            isRequired: false,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.enterStreetAddress,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.streetAddress],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.streetAddress, value: value);
              handleValidation();
            },
          ),
          LabelText(
            title: AddListingFormConstants.cityCountry,
            textStyle: FontTypography.subTextStyle,
          ),
          GoogleLocationView(
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
                  widget.addListingFormCubit.latitude = double.parse(json[ModelKeys.latitudeGoogleApi] ?? '0.0');
                  widget.addListingFormCubit.longitude = double.parse(json[ModelKeys.longitudeGoogleApi] ?? '0.0');

                  // Update form fields with extracted values
                } catch (e) {
                  if (kDebugMode) print('_ContactDetailsFormViewState.build-->${e.toString()}');
                }
              } else {
                widget.addListingFormCubit.latitude = 0.0;
                widget.addListingFormCubit.longitude = 0.0;
              }

              widget.addListingFormCubit.onFieldsValueChanged(
                key: AddListingFormConstants.latitude,
                value: widget.addListingFormCubit.latitude.toString(),
              );

              widget.addListingFormCubit.onFieldsValueChanged(
                key: AddListingFormConstants.longitude,
                value: widget.addListingFormCubit.longitude.toString(),
              );

              widget.addListingFormCubit.onFieldsValueChanged(
                key: AddListingFormConstants.location,
                value: location,
              );
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.city, value: city);
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.state, value: state);
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.country, value: country);
            },
          ),
          Visibility(
            visible: widget.state.formDataMap?[AddListingFormConstants.saleOrRentOrLease] == AddListingFormConstants.sale,
            child: Row(
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    LabelText(
                      title: AddListingFormConstants.price,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    AppTextField(
                      hintTxt: AddListingFormConstants.price,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        DecimalInputFormatter(
                          maxDigitsBeforeDecimal: AppConstants.maxDigitsBeforeDecimalValue,
                          maxDigitsAfterDecimal: AppConstants.maxDigitsAfterDecimalValue,
                        ),
                      ],
                      textInputAction: TextInputAction.done,
                      initialValue: widget.state.formDataMap?[AddListingFormConstants.price],
                      onChanged: (value) {
                        widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.price, value: value);
                      },
                    ),
                  ]),
                ),
                sizedBox20Width(),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    LabelText(
                      title: AddListingFormConstants.currency,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    _currencyDropdown(),
                  ]),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !(widget.state.formDataMap?[AddListingFormConstants.saleOrRentOrLease] == AddListingFormConstants.sale),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelText(
                            title: AddListingFormConstants.price,
                            isRequired: false,
                            textStyle: FontTypography.subTextStyle,
                          ),
                          AppTextField(
                            hintTxt: AddListingFormConstants.price,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              DecimalInputFormatter(
                                maxDigitsBeforeDecimal: AppConstants.maxDigitsBeforeDecimalValue,
                                maxDigitsAfterDecimal: AppConstants.maxDigitsAfterDecimalValue,
                              ),
                            ],
                            textInputAction: TextInputAction.done,
                            initialValue: widget.state.formDataMap?[AddListingFormConstants.price],
                            onChanged: (value) {
                              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.price, value: value);
                            },
                          )
                        ],
                      ),
                    ),
                    sizedBox20Width(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelText(
                            title: AddListingFormConstants.paymentInterval,
                            isRequired: false,
                            textStyle: FontTypography.subTextStyle,
                          ),
                          DropDownWidget(
                            items: DropDownConstants.estimatedSalaryPeriodDropDown.values.toList(),
                            dropDownOnChange: (value) {
                              widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
                                AddListingFormConstants.paymentInterval: value,
                              });
                            },
                            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.paymentInterval],
                            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.paymentInterval] != '' ? (widget.state.formDataMap?[AddListingFormConstants.paymentInterval]) : null,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                LabelText(
                  title: AddListingFormConstants.currency,
                  isRequired: false,
                  textStyle: FontTypography.subTextStyle,
                ),
                _currencyDropdown()
              ],
            ),
          ),
          Visibility(
            visible: widget.state.formDataMap?[AddListingFormConstants.saleOrRentOrLease] == AddListingFormConstants.sale,
            child: LabelText(
              title: AddListingFormConstants.vehicleCondition,
              textStyle: FontTypography.subTextStyle,
            ),
          ),
          Visibility(
            visible: widget.state.formDataMap?[AddListingFormConstants.saleOrRentOrLease] == AddListingFormConstants.sale,
            child: DropDownWidget(
              items: DropDownConstants.vehicleConditionDropDown.values.toList(),
              dropDownOnChange: (value) {
                widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
                  AddListingFormConstants.vehicleCondition: value,
                });
              },
              displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.vehicleCondition],
              dropDownValue: widget.state.formDataMap?[AddListingFormConstants.vehicleCondition] != '' ? (widget.state.formDataMap?[AddListingFormConstants.vehicleCondition]) : null,
            ),
          ),
          Visibility(
            visible: widget.state.formDataMap?.containsKey(AddListingFormConstants.streetAddress) ?? false,
            child: LabelText(
              title: AddListingFormConstants.showStreetAddress,
              textStyle: FontTypography.subTextStyle,
            ),
          ),
          Visibility(
            visible: widget.state.formDataMap?.containsKey(AddListingFormConstants.streetAddress) ?? false,
            child: Row(
              children: [
                RadioButtonWidget(
                  state: widget.state,
                  formConstantKey: AddListingFormConstants.showStreetAddress,
                  addListingFormCubit: widget.addListingFormCubit,
                  title: AddListingFormConstants.yes,
                ),
                sizedBox29Width(),
                RadioButtonWidget(
                  state: widget.state,
                  formConstantKey: AddListingFormConstants.showStreetAddress,
                  addListingFormCubit: widget.addListingFormCubit,
                  title: AddListingFormConstants.no,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handleValidation() {
    /// Handling case of Entering Street Address
    if (widget.state.formDataMap?[AddListingFormConstants.streetAddress] != null) {
      /// Adding Validations
      RequiredFieldsConstants.realEstateCostDetailsRequiredFields.addAll({
        AddListingFormConstants.showStreetAddress: null,
      });
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {AddListingFormConstants.showStreetAddress: AppConstants.noStr},
      );
    } else {
      /// Removing validation and there values
      RequiredFieldsConstants.removeValidations(
        requiredFieldsList: RequiredFieldsConstants.realEstateCostDetailsRequiredFields,
        deleteKeys: [AddListingFormConstants.showStreetAddress],
      );
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {AddListingFormConstants.showStreetAddress: AppConstants.noStr},
      );
    }
  }

  Widget _currencyDropdown() {
    /// getting selected  value
    String? currencyCode = widget.state.formDataMap?[AddListingFormConstants.currencyINR] ?? '';

    /// getting currencyList
    var list = widget.state.currencyList;

    /// preparing selected item model from selected currencyCode
    var currencyList = list?.where((item) {
      if (currencyCode.isNullOrEmpty()) {
        return false;
      }
      return item.currencyCode?.toLowerCase() == currencyCode?.toLowerCase();
    });

    CommonDropdownModel? selectedItem;
    if (currencyList?.isNotEmpty ?? false) {
      var item = currencyList?.first;
      selectedItem = CommonDropdownModel(
        id: int.tryParse(item?.uuid ?? ''),
        name: '${item?.currencyName} (${item?.currencySymbol})',
        code: item?.currencyCode,
      );
    }

    selectCurrencyController.text = (selectedItem?.name ?? '');
    /*return AppTextField(
      initialValue: null,
      focusNode: FocusNode()..canRequestFocus = false,
      controller: selectCurrencyController,
      hintTxt: AddListingFormConstants.selectCurrency,
      keyboardType: TextInputType.none,
      suffixIcon: SvgPicture.asset(
        AssetPath.iconDropDown,
        fit: BoxFit.none,
      ),
      onTap: () {
        // If keyboard should be hidden, unfocused the field
        FocusScope.of(context).unfocus();
        searchController.clear();
        this.currencyList = widget.state.currencyList ?? [];
        if (this.currencyList?.isNotEmpty == true) {
          print('--------------Currency');
          buildCurrencySearchDialog();
        }
      },
    );*/
    return AppTextField(
      controller: selectCurrencyController,
      isReadOnly: true,
      // 👈 prevents keyboard & focus
      focusNode: FocusNode(),
      // optional now
      hintTxt: AddListingFormConstants.selectCurrency,
      keyboardType: TextInputType.none,
      // optional with readOnly
      suffixIcon: SvgPicture.asset(
        AssetPath.iconDropDown,
        fit: BoxFit.none,
      ),
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        searchController.clear();
        currencyList = widget.state.currencyList ?? [];
        if (currencyList?.isNotEmpty == true) {
          buildCurrencySearchDialog();
        }
      },
    );
  }

  buildCurrencySearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CommonSearchCurrencyDialog(
          items: widget.state.currencyList ?? [],
          hintText: AddListingFormConstants.selectCurrency,
          searchController: searchController,
          selectController: selectCurrencyController,
          listItemBuilder: (item) {
            return ListTile(
              title: Text('${item.currencyName} (${item.currencySymbol})'),
            );
          },
          onItemSelected: (item) {
            selectCurrencyController.text = '${item.currencyName} ${item.currencyName}';
            widget.addListingFormCubit.onFieldsValueChanged(
              key: AddListingFormConstants.currencyINR,
              value: item.currencyCode,
            );
          },
          searchCriteria: (item) => item ?? '',
        );
      },
    );
  }

  void handleAutoSaleType({String? value}) {
    if (value == 'Rent' || value == 'Lease') {
      widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.vehicleCondition, value: '');
      RequiredFieldsConstants.autoPriceAndLocationRequiredFields = RequiredFieldsConstants.autoPriceAndLocationRequiredFields..remove(AddListingFormConstants.vehicleCondition,);
    } else {
      RequiredFieldsConstants.autoPriceAndLocationRequiredFields = RequiredFieldsConstants.autoPriceAndLocationRequiredFields..addAll({AddListingFormConstants.vehicleCondition: null});
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.vehicleCondition: AddListingFormConstants.newVehicle,
      });
    }
  }
}
