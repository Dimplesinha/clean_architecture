import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
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
import 'package:workapp/src/presentation/widgets/text_field_dummy.dart';
import 'package:workapp/src/utils/add_listing_form_utils/decimal_input_formatter.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solution Pvt Ltd.
/// @DATE : 10-10-2024
/// @Message : [RealEstateContactDetails]

class RealEstateCostDetails extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const RealEstateCostDetails({super.key, required this.addListingFormCubit, required this.state});

  @override
  State<RealEstateCostDetails> createState() => _RealEstateCostDetailsState();
}

class _RealEstateCostDetailsState extends State<RealEstateCostDetails> {
  final searchController = TextEditingController();
  final selectCurrencyController = TextEditingController();
  List<Countries>? currencyList;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      selectCurrencyController.text = selectCurrencyController.text;
    });
    handleInitialValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Date and time Key created to handle date field as per type of sale
    String dateKey = widget.state.formDataMap?[AddListingFormConstants.typeOfSale] == DropDownConstants.auction
        ? AddListingFormConstants.auctionDate
        : AddListingFormConstants.inspectionDate;
    String timeKey = widget.state.formDataMap?[AddListingFormConstants.typeOfSale] == DropDownConstants.auction
        ? AddListingFormConstants.auctionTime
        : AddListingFormConstants.inspectionTime;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelText(
            title: AddListingFormConstants.propertyOnSaleRent,
            textStyle: FontTypography.subTextStyle,
          ),
          Row(
            children: [
              RadioButtonWidget(
                state: widget.state,
                formConstantKey: AddListingFormConstants.propertyOnSaleRent,
                addListingFormCubit: widget.addListingFormCubit,
                title: AddListingFormConstants.sale,
                onChangeAdditionalMethod: handleInitialValues,
              ),
              sizedBox29Width(),
              RadioButtonWidget(
                state: widget.state,
                formConstantKey: AddListingFormConstants.propertyOnSaleRent,
                addListingFormCubit: widget.addListingFormCubit,
                title: AddListingFormConstants.rent,
                onChangeAdditionalMethod: handleInitialValues,
              ),
            ],
          ),
          Visibility(
            visible:
                widget.state.formDataMap?[AddListingFormConstants.propertyOnSaleRent] == AddListingFormConstants.sale,
            replacement: Column(
              children: [
                /// If [Rent] Selected
                LabelText(
                  title: AddListingFormConstants.website,
                  textStyle: FontTypography.subTextStyle,
                  isRequired: false,
                ),
                AppTextField(
                  textCapitalization: TextCapitalization.none,
                  hintTxt: AddListingFormConstants.websiteHint,
                  initialValue: widget.state.formDataMap?[AddListingFormConstants.website],
                  onChanged: (value) {
                    widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.website, value: value);
                  },
                ),
                LabelText(
                  title: AddListingFormConstants.bondDeposit,
                  textStyle: FontTypography.subTextStyle,
                  isRequired: false,
                ),
                AppTextField(
                  hintTxt: AddListingFormConstants.bondDeposit,
                  initialValue: widget.state.formDataMap?[AddListingFormConstants.bondDeposit],
                  onChanged: (value) {
                    widget.addListingFormCubit
                        .onFieldsValueChanged(key: AddListingFormConstants.bondDeposit, value: value);
                  },
                ),
                LabelText(
                  title: AddListingFormConstants.priceRange,
                  textStyle: FontTypography.subTextStyle,
                  isRequired: false,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: AppTextField(
                          hintTxt: AddListingFormConstants.from,
                          initialValue: widget.state.formDataMap?[AddListingFormConstants.priceFrom],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            DecimalInputFormatter(
                              maxDigitsBeforeDecimal: AppConstants.maxDigitsBeforeDecimalValue,
                              maxDigitsAfterDecimal: AppConstants.maxDigitsAfterDecimalValue,
                            ),
                          ],
                          onChanged: (value) {
                            widget.addListingFormCubit
                                .onFieldsValueChanged(key: AddListingFormConstants.priceFrom, value: value);
                            handleValidation();
                          },
                        ),
                      ),
                      sizedBox5Width(),
                      Flexible(
                        child: AppTextField(
                          hintTxt: AddListingFormConstants.to,
                          initialValue: widget.state.formDataMap?[AddListingFormConstants.priceTo],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            DecimalInputFormatter(
                              maxDigitsBeforeDecimal: AppConstants.maxDigitsBeforeDecimalValue,
                              maxDigitsAfterDecimal: AppConstants.maxDigitsAfterDecimalValue,
                            ),
                          ],
                          onChanged: (value) {
                            widget.addListingFormCubit
                                .onFieldsValueChanged(key: AddListingFormConstants.priceTo, value: value);
                            handleValidation();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            child: Column(
              children: [
                /// If [Sale] Selected
                LabelText(
                  title: AddListingFormConstants.typeOfSale,
                  textStyle: FontTypography.subTextStyle,
                  isRequired: false,
                ),
                DropDownWidget(
                  items: DropDownConstants.typeOfSaleList.values.toList(),
                  dropDownOnChange: (value) {
                    widget.addListingFormCubit
                        .onFieldsValueChanged(key: AddListingFormConstants.typeOfSale, value: value ?? '');
                  },
                  hintText: AddListingFormConstants.typeOfSale,
                  displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.typeOfSale] ??
                      AddListingFormConstants.typeOfSale,
                  dropDownValue: widget.state.formDataMap?[AddListingFormConstants.typeOfSale],
                ),
                Visibility(
                  visible: widget.state.formDataMap?[AddListingFormConstants.typeOfSale] ==
                          DropDownConstants.saleByNegotiation ||
                      widget.state.formDataMap?[AddListingFormConstants.typeOfSale] == DropDownConstants.forSale,
                  child: Column(
                    children: [
                      LabelText(
                        title: AddListingFormConstants.typeOfInspection,
                        textStyle: FontTypography.subTextStyle,
                        isRequired: false,
                      ),
                      DropDownWidget(
                        items: DropDownConstants.inspectionTypeList.values.toList(),
                        dropDownOnChange: (value) {
                          widget.addListingFormCubit
                              .onFieldsValueChanged(key: AddListingFormConstants.typeOfInspection, value: value ?? '');
                        },
                        hintText: AddListingFormConstants.typeOfInspection,
                        displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.typeOfInspection] ??
                            AddListingFormConstants.typeOfInspection,
                        dropDownValue: widget.state.formDataMap?[AddListingFormConstants.typeOfInspection],
                      ),
                      Visibility(
                        visible: widget.state.formDataMap?[AddListingFormConstants.typeOfInspection] ==
                            AddListingFormConstants.inspectionTime,
                        child: LabelText(
                          title: AddListingFormConstants.inspectionDate,
                          textStyle: FontTypography.subTextStyle,
                          isRequired: false,
                        ),
                      ),
                      Visibility(
                        visible: widget.state.formDataMap?[AddListingFormConstants.typeOfInspection] ==
                            AddListingFormConstants.inspectionTime,
                        child: TextFieldDummy(
                          value: AppUtils.formatDate(widget.state.formDataMap?[dateKey]) ??
                              AddListingFormConstants.selectYourDate,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: SizedBox(
                              child: ReusableWidgets.createSvg(path: AssetPath.calendarIcon, size: 15),
                            ),
                          ),
                          onTap: () {
                            widget.addListingFormCubit.openDateFromPicker(
                              context,
                              key: dateKey,
                              initialDate: widget.state.getFormattedDateTime(dateKey),
                            );
                            widget.state.formDataMap?[AddListingFormConstants.auctionDate] = null;
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.state.formDataMap?[AddListingFormConstants.typeOfInspection] ==
                            AddListingFormConstants.inspectionTime,
                        child: LabelText(
                          title: AddListingFormConstants.inspectionTime,
                          textStyle: FontTypography.subTextStyle,
                          isRequired: false,
                        ),
                      ),
                      Visibility(
                        visible: widget.state.formDataMap?[AddListingFormConstants.typeOfInspection] ==
                            AddListingFormConstants.inspectionTime,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFieldDummy(
                                value: widget.state.formDataMap?[AddListingFormConstants.startTime] ??
                                    AddListingFormConstants.hhMM,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                  child: ReusableWidgets.createSvg(path: AssetPath.timerIcon),
                                ),
                                onTap: () {
                                  widget.addListingFormCubit.selectTime(
                                    context: context,
                                    formKey: AddListingFormConstants.startTime,
                                    isStartTime: true,
                                    timeOfDay: TimeOfDay(
                                      hour: widget.state
                                          .getTimeInHH(widget.state.formDataMap?[AddListingFormConstants.startTime]),
                                      minute: widget.state
                                          .getTimeInMM(widget.state.formDataMap?[AddListingFormConstants.startTime]),
                                    ),
                                  );
                                  widget.state.formDataMap?[AddListingFormConstants.auctionTime] = null;
                                },
                              ),
                            ),
                            sizedBox20Width(),
                            Expanded(
                              child: TextFieldDummy(
                                value: widget.state.formDataMap?[AddListingFormConstants.endTime] ??
                                    AddListingFormConstants.hhMM,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                  child: ReusableWidgets.createSvg(path: AssetPath.timerIcon),
                                ),
                                onTap: () {
                                  widget.addListingFormCubit.selectTime(
                                    context: context,
                                    formKey: AddListingFormConstants.endTime,
                                    isStartTime: false,
                                    timeOfDay: TimeOfDay(
                                      hour: widget.state
                                          .getTimeInHH(widget.state.formDataMap?[AddListingFormConstants.endTime]),
                                      minute: widget.state
                                          .getTimeInMM(widget.state.formDataMap?[AddListingFormConstants.endTime]),
                                    ),
                                  );
                                  widget.state.formDataMap?[AddListingFormConstants.auctionTime] = null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Visibility(
                  visible: widget.state.formDataMap?[AddListingFormConstants.typeOfSale] == DropDownConstants.auction,
                  child: Column(
                    children: [
                      LabelText(
                        title: dateKey,
                        textStyle: FontTypography.subTextStyle,
                        isRequired: false,
                      ),
                      TextFieldDummy(
                        value: AppUtils.formatDate(widget.state.formDataMap?[dateKey]) ??
                            AddListingFormConstants.selectYourDate,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: SizedBox(
                            child: ReusableWidgets.createSvg(path: AssetPath.calendarIcon, size: 15),
                          ),
                        ),
                        onTap: () {
                          widget.addListingFormCubit.openDateFromPicker(
                            context,
                            key: dateKey,
                            initialDate: widget.state.getFormattedDateTime(dateKey),
                          );
                          widget.state.formDataMap?[AddListingFormConstants.inspectionDate] = null;
                        },
                      ),
                      LabelText(
                        title: timeKey,
                        textStyle: FontTypography.subTextStyle,
                        isRequired: false,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFieldDummy(
                              value: widget.state.formDataMap?[AddListingFormConstants.auctionTime] ??
                                  AddListingFormConstants.hhMM,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                child: ReusableWidgets.createSvg(path: AssetPath.timerIcon),
                              ),
                              onTap: () {
                                widget.addListingFormCubit.selectTimeFromPicker(
                                  context: context,
                                  formKey: AddListingFormConstants.auctionTime,
                                  timeOfDay: TimeOfDay(
                                    hour: widget.state
                                        .getTimeInHH(widget.state.formDataMap?[AddListingFormConstants.auctionTime]),
                                    minute: widget.state
                                        .getTimeInMM(widget.state.formDataMap?[AddListingFormConstants.auctionTime]),
                                  ),
                                );
                                widget.state.formDataMap?[AddListingFormConstants.startTime] = null;
                                widget.state.formDataMap?[AddListingFormConstants.endTime] = null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                LabelText(
                  title: AddListingFormConstants.streetAddress,
                  textStyle: FontTypography.subTextStyle,
                  isRequired: false,
                ),
                AppTextField(
                  hintTxt: AddListingFormConstants.enterStreetAddress,
                  initialValue: widget.state.formDataMap?[AddListingFormConstants.streetAddress],
                  onChanged: (value) {
                    widget.addListingFormCubit
                        .onFieldsValueChanged(key: AddListingFormConstants.streetAddress, value: value);
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
                        widget.addListingFormCubit.longitude =
                            double.parse(json[ModelKeys.longitudeGoogleApi] ?? '0.0');

                        // Update form fields with extracted values
                      } catch (e) {
                        if (kDebugMode) {
                          print('_ContactDetailsFormViewState.build-->${e.toString()}');
                        }
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
                    widget.addListingFormCubit
                        .onFieldsValueChanged(key: AddListingFormConstants.country, value: country);
                  },
                ),
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
                        hintTxt: AddListingFormConstants.from,
                        initialValue: widget.state.formDataMap?[AddListingFormConstants.priceFrom],
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          DecimalInputFormatter(
                            maxDigitsBeforeDecimal: AppConstants.maxDigitsBeforeDecimalValue,
                            maxDigitsAfterDecimal: AppConstants.maxDigitsAfterDecimalValue,
                          ),
                        ],
                        onChanged: (value) {
                          widget.addListingFormCubit
                              .onFieldsValueChanged(key: AddListingFormConstants.priceFrom, value: value);
                          handleValidation();
                        },
                      ),
                    ),
                    sizedBox5Width(),
                    Expanded(
                      child: AppTextField(
                        hintTxt: AddListingFormConstants.to,
                        initialValue: widget.state.formDataMap?[AddListingFormConstants.priceTo],
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          DecimalInputFormatter(
                            maxDigitsBeforeDecimal: AppConstants.maxDigitsBeforeDecimalValue,
                            maxDigitsAfterDecimal: AppConstants.maxDigitsAfterDecimalValue,
                          ),
                        ],
                        onChanged: (value) {
                          widget.addListingFormCubit
                              .onFieldsValueChanged(key: AddListingFormConstants.priceTo, value: value);
                          handleValidation();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _currencyDropdown(),
          Visibility(
            visible: widget.state.formDataMap?.containsKey(AddListingFormConstants.streetAddress) ?? false,
            child: Column(
              children: [
                LabelText(
                  title: AddListingFormConstants.showStreetAddress,
                  textStyle: FontTypography.subTextStyle,
                ),
                Row(
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
              ],
            ),
          ),
          Visibility(
            visible:
                widget.state.formDataMap?[AddListingFormConstants.propertyOnSaleRent] == AddListingFormConstants.rent,
            child: Column(
              children: [
                LabelText(
                  title: AddListingFormConstants.duration,
                  textStyle: FontTypography.subTextStyle,
                  isRequired: false,
                ),
                DropDownWidget(
                  items: DropDownConstants.estimatedSalaryPeriodDropDown.values.toList(),
                  dropDownOnChange: (value) {
                    widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
                      AddListingFormConstants.duration: value,
                    });
                  },
                  displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.duration],
                  dropDownValue: widget.state.formDataMap?[AddListingFormConstants.duration] != ''
                      ? (widget.state.formDataMap?[AddListingFormConstants.duration])
                      : null,
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

    selectCurrencyController.text = (selectedItem?.name ?? '');
    return Column(
      children: [
        LabelText(
          title: AddListingFormConstants.currency,
          textStyle: FontTypography.subTextStyle,
        ),
        /*AppTextField(
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
        )*/
        AppTextField(
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
        ),
      ],
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

  void handleTypeOfSale() {
    if (widget.state.formDataMap?[AddListingFormConstants.propertyOnSaleRent] == AddListingFormConstants.sale) {
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.duration: '',
        AddListingFormConstants.website: '',
        AddListingFormConstants.bondDeposit: '',
      });
    } else {
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.duration: DropDownConstants.perHour,
        AddListingFormConstants.typeOfSale: '',
        AddListingFormConstants.typeOfInspection: '',
        AddListingFormConstants.inspectionDate: '',
        AddListingFormConstants.inspectionTime: '',
      });
    }
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
    } else if (widget.state.formDataMap?[AddListingFormConstants.priceFrom] != null &&
        widget.state.formDataMap?[AddListingFormConstants.priceTo] != 0.0) {
      RequiredFieldsConstants.realEstateCostDetailsRequiredFields.addAll({
        AddListingFormConstants.priceFrom: null,
        AddListingFormConstants.priceTo: null,
      });
    } else {
      /// Removing validation and there values

      RequiredFieldsConstants.removeValidations(
        requiredFieldsList: RequiredFieldsConstants.realEstateCostDetailsRequiredFields,
        deleteKeys: [
          AddListingFormConstants.showStreetAddress,
          AddListingFormConstants.priceFrom,
          AddListingFormConstants.priceTo
        ],
      );
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {
          AddListingFormConstants.showStreetAddress: AppConstants.noStr,
          AddListingFormConstants.priceFrom: '',
          AddListingFormConstants.priceTo: '',
        },
      );
    }
  }

  void handleInitialValues() {
    if (widget.state.apiResultId == null) {
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.propertyOnSaleRent: AddListingFormConstants.sale,
        AddListingFormConstants.typeOfSale: AddListingFormConstants.forSale,
        AddListingFormConstants.typeOfInspection: AddListingFormConstants.inspectionTime,
      });
      handleTypeOfSale();
    } else {
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.propertyOnSaleRent:
            widget.state.formDataMap?[AddListingFormConstants.propertyOnSaleRent] ?? AddListingFormConstants.sale,
        AddListingFormConstants.typeOfSale:
            widget.state.formDataMap?[AddListingFormConstants.typeOfSale] ?? AddListingFormConstants.forSale,
        AddListingFormConstants.typeOfInspection: widget.state.formDataMap?[AddListingFormConstants.typeOfInspection] ??
            AddListingFormConstants.inspectionTime,
        AddListingFormConstants.priceFrom: widget.state.formDataMap?[AddListingFormConstants.priceFrom] ?? '',
        AddListingFormConstants.priceTo: widget.state.formDataMap?[AddListingFormConstants.priceTo] ?? '',
      });
    }
  }
}
