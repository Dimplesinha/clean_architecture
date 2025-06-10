import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
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

class JobSalaryAndLocationView extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const JobSalaryAndLocationView({super.key, required this.addListingFormCubit, required this.state});

  @override
  State<JobSalaryAndLocationView> createState() => _JobSalaryAndLocationViewState();
}

class _JobSalaryAndLocationViewState extends State<JobSalaryAndLocationView> {
  final searchController = TextEditingController();
  final selectCurrencyController = TextEditingController();
  List<Countries>? currencyList;

  void handleShowStreetAddress() {
    if (widget.state.formDataMap?.containsKey(AddListingFormConstants.streetAddress) ?? false) {
      RequiredFieldsConstants.jobSalaryDetailsRequiredFields = RequiredFieldsConstants.jobSalaryDetailsRequiredFields
        ..addAll(
          {AddListingFormConstants.showStreetAddress: null},
        );
    } else {
      widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.showStreetAddress, value: '');
      RequiredFieldsConstants.jobSalaryDetailsRequiredFields = RequiredFieldsConstants.jobSalaryDetailsRequiredFields
        ..remove(
          AddListingFormConstants.showStreetAddress,
        );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      selectCurrencyController.text = selectCurrencyController.text;
    });

    /// Setting initial values
    widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
      AddListingFormConstants.selectVisibility:
          widget.state.formDataMap?[AddListingFormConstants.selectVisibility] ?? DropDownConstants.countrywide,
      AddListingFormConstants.estimatedSalary:
          widget.state.formDataMap?[AddListingFormConstants.estimatedSalary] ?? DropDownConstants.perHour,
      AddListingFormConstants.selectCurrency:
          widget.state.formDataMap?[AddListingFormConstants.selectCurrency] ?? DropDownConstants.inr,
    });

    if (widget.state.formDataMap?[AddListingFormConstants.showStreetAddress] == null) {
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.showStreetAddress: widget.state.formDataMap?[AddListingFormConstants.no]
      });
    }
    if (widget.state.formDataMap?[AddListingFormConstants.selectYourDate] == null) {
      widget.addListingFormCubit.selectedDateTime();
    } else {
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {
          AddListingFormConstants.selectYourDate: widget.state.formDataMap?[AddListingFormConstants.selectYourDate],
          AddListingFormConstants.selectTime: '00:00',
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddListingFormCubit, AddListingFormLoadedState>(
      bloc: widget.addListingFormCubit,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabelText(
                title: AddListingFormConstants.estimatedSalary,
                textStyle: FontTypography.subTextStyle,
                isRequired: false,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: AppTextField(
                      hintTxt: AddListingFormConstants.minSalary,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        DecimalInputFormatter(
                          maxDigitsBeforeDecimal: AppConstants.maxDigitsBeforeDecimalValue,
                          maxDigitsAfterDecimal: AppConstants.maxDigitsAfterDecimalValue,
                        ),
                      ],
                      initialValue: widget.state.formDataMap?[AddListingFormConstants.minSalary],
                      onChanged: (value) {
                        widget.addListingFormCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.minSalary, value: value);
                        handlePriceValidation();
                      },
                    ),
                  ),
                  sizedBox10Width(),
                  Flexible(
                    child: AppTextField(
                      hintTxt: AddListingFormConstants.maxSalary,
                      initialValue: widget.state.formDataMap?[AddListingFormConstants.maxSalary],
                      textInputAction: TextInputAction.done,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        DecimalInputFormatter(
                          maxDigitsBeforeDecimal: AppConstants.maxDigitsBeforeDecimalValue,
                          maxDigitsAfterDecimal: AppConstants.maxDigitsAfterDecimalValue,
                        ),
                      ],
                      onChanged: (value) {
                        widget.addListingFormCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.maxSalary, value: value);
                        handlePriceValidation();
                      },
                    ),
                  ),
                ],
              ),
              sizedBox10Height(),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: DropDownWidget(
                      items: DropDownConstants.estimatedSalaryPeriodDropDown.values.toList(),
                      dropDownOnChange: (value) {
                        final estimationDuration = DropDownConstants.estimatedSalaryPeriodDropDown.entries
                            .firstWhere((entry) => entry.value == value)
                            .key;

                        widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
                          AddListingFormConstants.estimatedSalary: value ?? '',
                          AddListingFormConstants.duration: estimationDuration.toString(),
                        });
                      },
                      displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.estimatedSalary],
                      dropDownValue: widget.state.formDataMap?[AddListingFormConstants.estimatedSalary] != ''
                          ? (widget.state.formDataMap?[AddListingFormConstants.estimatedSalary])
                          : null,
                    ),
                  ),
                  sizedBox10Width(),
                  Flexible(child: _currencyDropdown()),
                ],
              ),
              LabelText(
                title: AddListingFormConstants.endDate,
                textStyle: FontTypography.subTextStyle,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        DateTime? initialDate;
                        var selectYourDate = state.formDataMap?[AddListingFormConstants.selectYourDate];
                        if (selectYourDate != null) {
                          initialDate = DateTime.parse(selectYourDate);
                        }
                        widget.addListingFormCubit.openDatePicker(
                          context,
                          hasStartEndDate: false,
                          initialDate: initialDate,
                        );
                      },
                      child: AppTextField(
                        isReadOnly: true,
                        isEnable: false,
                        hintTxt: state.selectedDate ?? state.formDataMap?[AddListingFormConstants.selectYourDate],
                        hintStyle: FontTypography.textFieldBlackStyle,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3.0,
                          ),
                          child: ReusableWidgets.createSvg(path: AssetPath.calendarIcon),
                        ),
                      ),
                    ),
                  ),
                  sizedBox10Width(),
                  // Flexible(
                  //   child: InkWell(
                  //     onTap: () {
                  //       widget.addListingFormCubit.selectTime(context: context, isStartTime: false);
                  //     },
                  //     child: AppTextField(
                  //       isReadOnly: true,
                  //       isEnable: false,
                  //       suffixIcon: Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 3.0),
                  //         child: ReusableWidgets.createSvg(path: AssetPath.timerIcon),
                  //       ),
                  //       hintTxt: state.endTime ?? AddListingFormConstants.selectTime,
                  //       initialValue: '',
                  //     ),
                  //   ),
                  // )
                ],
              ),

              ///Visibility
              LabelText(
                title: AddListingFormConstants.selectVisibility,
                textStyle: FontTypography.subTextStyle,
              ),
              DropDownWidget(
                hintText: AddListingFormConstants.selectVisibility,
                items: DropDownConstants.visibilityDropDownList.values.toList(),
                displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.selectVisibility],
                dropDownValue: widget.state.formDataMap?[AddListingFormConstants.selectVisibility],
                dropDownOnChange: (value) {
                  widget.addListingFormCubit
                      .onFieldsValueChanged(key: AddListingFormConstants.selectVisibility, value: value ?? '');
                },
              ),

              ///Street Address
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
                },
              ),

              ///Location
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

              ///Show Street Address
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
      },
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
        code: item?.currencyCode,
      );
      /*selectedItem = CommonDropdownModel(
        id: int.tryParse(item?.uuid ?? ''),
        name: '${item?.currencyName} (${item?.currencySymbol})',
        code: item?.currencyCode,
        currencySymbol: item?.currencySymbol,
      );*/
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

    /* return DropDownWidget2(
      hintText: AddListingFormConstants.selectCurrency,
      items: widget.state.currencyList
          ?.map(
            (item) => CommonDropdownModel(
              id: int.tryParse(item.uuid ?? ''),
              name: '${item.currencyName} (${item.currencySymbol})',
              code: item.currencyCode,
            ),
          )
          .toList(),
      dropDownValue: selectedItem,
      dropDownOnChange: (CommonDropdownModel? value) {
        try {
          String? currencyCode = value?.code;

          widget.addListingFormCubit.onFieldsValueChanged(
            key: AddListingFormConstants.currencyINR,
            value: currencyCode,
          );
        } catch (e) {
          if (kDebugMode) print('_ClassifiedBasicDetailsState.build---${e.toString()}');
        }
      },
    );*/
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
    /*return AlertDialog(
      backgroundColor: AppColors.backgroundColor,
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                AppTextField(
                  height: 40,
                  hintTxt: AppConstants.searchCurrency,
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  suffix: ReusableWidgets.createSvg(path: AssetPath.searchIconSvg),
                  onChanged: (value) {
                    setState(() {
                      setState(() {
                        currencyList = (widget.state.currencyList ?? []).where((currency) {
                          return (currency.countryName?.toLowerCase() ?? '').contains(value.toLowerCase());
                        }).toList();
                      });
                    });
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: currencyList?.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = currencyList?[index];

                      return ListTile(
                        title: Text('${item?.currencyName} (${item?.currencySymbol})'),
                        onTap: () {
                          selectCurrencyController.text = '${item?.countryName} ${item?.currencyName}';
                          String? currencyCode = item?.currencyCode;
                          widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.currencyINR, value: currencyCode);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );*/
  }

  void handlePriceValidation() {
    if (widget.state.formDataMap?[AddListingFormConstants.minSalary] != null ||
        widget.state.formDataMap?[AddListingFormConstants.minSalary] != 0.0 &&
            widget.state.formDataMap?[AddListingFormConstants.maxSalary] != null ||
        widget.state.formDataMap?[AddListingFormConstants.maxSalary] != 0.0) {
      RequiredFieldsConstants.jobSalaryDetailsRequiredFields.addAll({
        AddListingFormConstants.minSalary: null,
        AddListingFormConstants.maxSalary: null,
      });
    }
  }
}
