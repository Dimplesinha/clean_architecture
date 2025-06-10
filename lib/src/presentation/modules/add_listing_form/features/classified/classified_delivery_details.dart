import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/features/required_fields/required_fields.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/radio_button_widget.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/view/google_location_view.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/common_currency_center_dialog.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/add_listing_form_utils/decimal_input_formatter.dart';
import 'package:workapp/src/utils/app_utils.dart';

class ClassifiedDeliveryDetailsView extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const ClassifiedDeliveryDetailsView({super.key, required this.addListingFormCubit, required this.state});

  @override
  State<ClassifiedDeliveryDetailsView> createState() => _ClassifiedDeliveryDetailsViewState();
}

class _ClassifiedDeliveryDetailsViewState extends State<ClassifiedDeliveryDetailsView> {
  final searchController = TextEditingController();
  final selectCurrencyController = TextEditingController();
  List<Countries>? currencyList;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      selectCurrencyController.text = selectCurrencyController.text;
    });
    widget.addListingFormCubit
        .onFieldsValueChanged(key: AddListingFormConstants.listingVisibility, value: DropDownConstants.countrywide);
    // widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.showStreetAddress, value: DropDownConstants.yes);
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
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelText(
            visible: AppUtils.loginUserModel?.accountTypeValue == AppConstants.businessStr,
            title: AddListingFormConstants.productSellURL,
            isRequired: false,
            textStyle: FontTypography.subTextStyle,
          ),
          Visibility(
            visible: AppUtils.loginUserModel?.accountTypeValue == AppConstants.businessStr,
            child: AppTextField(
              hintTxt: AddListingFormConstants.enterURL,
              keyboardType: TextInputType.url,
              textCapitalization: TextCapitalization.none,
              initialValue: widget.state.formDataMap?[AddListingFormConstants.productSellURL],
              onChanged: (value) {
                widget.addListingFormCubit
                    .onFieldsValueChanged(key: AddListingFormConstants.productSellURL, value: value);
              },
            ),
          ),
          /* LabelText(
            title: AddListingFormConstants.listingVisibility,
            textStyle: FontTypography.subTextStyle,
          ),
          DropDownWidget(
            hintText: AddListingFormConstants.selectVisibility,
            items: DropDownConstants.visibilityDropDownList,
            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.listingVisibility],
            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.listingVisibility],
            dropDownOnChange: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.listingVisibility, value: value ?? '');
            },
          ),*/
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
            title: AddListingFormConstants.location,
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
          Opacity(
            opacity: widget.state.formDataMap?[AddListingFormConstants.classifiedType] == AddListingFormConstants.free
                ? 0.5
                : 1,
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
                      isEnable: widget.state.formDataMap?[AddListingFormConstants.classifiedType] !=
                          AddListingFormConstants.free,
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
                        widget.addListingFormCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.price, value: value);
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
          code: item?.currencyCode);
    }

    var classifiedTypeIsFree = widget.state.formDataMap?[AddListingFormConstants.classifiedType] == AppConstants.free;
    if (classifiedTypeIsFree) {
      selectedItem?.name = '';
      selectCurrencyController.text = '';
    } else {
      selectCurrencyController.text = (selectedItem?.name ?? '');
    }

    /*return AppTextField(
      isEnable: widget.state.formDataMap?[AddListingFormConstants.classifiedType] != AddListingFormConstants.free,
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

  void handleValidation() {
    /// Handling case of Entering Street Address
    if (widget.state.formDataMap?[AddListingFormConstants.streetAddress] != null) {
      /// Adding Validations
      RequiredFieldsConstants.classifiedDeliveryDetailsRequiredFields.addAll({
        AddListingFormConstants.showStreetAddress: null,
      });
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {AddListingFormConstants.showStreetAddress: AppConstants.noStr},
      );
    } else {
      /// Removing validation and there values
      RequiredFieldsConstants.removeValidations(
        requiredFieldsList: RequiredFieldsConstants.classifiedDeliveryDetailsRequiredFields,
        deleteKeys: [AddListingFormConstants.showStreetAddress],
      );
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {AddListingFormConstants.showStreetAddress: AppConstants.noStr},
      );
    }
  }
}
