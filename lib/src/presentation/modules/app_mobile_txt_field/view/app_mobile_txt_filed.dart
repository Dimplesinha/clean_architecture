import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/app_carousel/app_carousel_exports.dart';
import 'package:workapp/src/presentation/modules/app_mobile_txt_field/cubit/app_mobile_text_field_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/country_list.dart';

/// Created by
/// @AUTHOR : Prakash Software Solution
/// @DATE : 09-10-2024
/// @Message :

class AppMobileTextField extends StatefulWidget {
  final FocusNode? focusNode;
  final void Function()? onSubmitted;
  final void Function(String)? onChanged;
  final void Function(String coutnryCode, String countryPhoneCode, bool isApply)? onPhoneCountryChanged;
  final TextEditingController mobileTextEditController;
  final TextEditingController phoneCodeController;
  final TextEditingController countryCodeController;
  final TextInputAction? textInputAction;
  final String? hintText;
  final String? phoneDialCode;
  bool? isEnable = true;
  final String? phoneCountryCode;
  AppMobileTextFiledLoadedState? state;

  AppMobileTextField(
      {super.key,
      this.isEnable,
      this.focusNode,
      this.onSubmitted,
      this.onChanged,
      required this.mobileTextEditController,
      this.hintText,
      this.textInputAction,
      this.phoneDialCode,
      this.phoneCountryCode,
      this.onPhoneCountryChanged,
      required this.phoneCodeController,
      required this.countryCodeController});

  @override
  State<AppMobileTextField> createState() => _AppMobileTextFieldState();
}

class _AppMobileTextFieldState extends State<AppMobileTextField> {
  final StreamController<int> _currentLengthController = StreamController<int>.broadcast();
  AppMobileTextFieldCubit appMobileTextFieldCubit = AppMobileTextFieldCubit();
  final searchController = TextEditingController();
  List<Countries> countries = [];

  @override
  void initState() {
    super.initState();
    appMobileTextFieldCubit.init(
      widget.mobileTextEditController.text,
      widget.phoneCodeController.text,
      widget.countryCodeController.text,
    );

    // Add a listener to update the current length in the StreamController
    widget.mobileTextEditController.addListener(() {
      final text = widget.mobileTextEditController.text.trim();
      final effectiveLength = text.startsWith('0') ? text.length + 1 : text.length;
      _currentLengthController.add(effectiveLength);
    });

    appMobileTextFieldCubit.stream.listen((state) {
      if (state is AppMobileTextFiledLoadedState) {
        _currentLengthController.add(widget.mobileTextEditController.text.trim().length); // Initial length
        if (state.countryCode != null && state.countryPhoneCode != null) {
          String? countryPhoneCode = state.countryPhoneCode; //Keep original nullable for checking later

          if (countryPhoneCode != null) {
            // Check for null before proceeding
            countryPhoneCode = countryPhoneCode.replaceAll('+', ''); // Remove all '+' signs

            if (state.countryPhoneCode?.startsWith('+') == true) {
              // Check the original
              countryPhoneCode = '+$countryPhoneCode'; // Add a single '+' at the beginning
            }
          }

          widget.onPhoneCountryChanged!(state.countryCode ?? '', countryPhoneCode ?? '', false);
        }
      }
    });
  }

  @override
  void dispose() {
    _currentLengthController.close(); // Close the StreamController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppMobileTextFieldCubit, AppMobileTextFieldState>(
      bloc: appMobileTextFieldCubit,
      builder: (context, state) {
        if (state is AppMobileTextFiledLoadedState) {
          MyCountry firstDefaultCountry = myCountryList.first;
          try {
            firstDefaultCountry = myCountryList.firstWhere((country) => country.name == AppConstants.unitedStatesStr);
          } catch (e) {
            if (kDebugMode) {
              print('_AppMobileTextFieldState.build-${e.toString()}');
            }
          }

          widget.phoneCodeController.text = state.countryPhoneCode ?? '+1';
          widget.countryCodeController.text = state.countryCode ?? '';
          if (state.mobileNumber?.isNotEmpty ?? false) {
            widget.mobileTextEditController.text = state.mobileNumber ?? '';
          }

          return Column(
            children: [
              StreamBuilder<int>(
                stream: _currentLengthController.stream,
                builder: (context, snapshot) {

                  final currentLength = widget.mobileTextEditController.text.trim().length;
                  final maxLength =widget.mobileTextEditController.text.trim().startsWith('0')? (state.maxLength ?? firstDefaultCountry.maxLength)+1:(state.maxLength ?? firstDefaultCountry.maxLength);

                  return Column(
                    children: [
                      AppTextField(
                        fillColor: widget.mobileTextEditController.text.isNotEmpty && widget.isEnable == false
                            ? AppColors.extraLightGreyColor
                            : null,
                        topPadding: 0,
                        keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                        textAlignVertical: TextAlignVertical.center,
                        focusNode: widget.focusNode,
                        onEditingComplete: widget.onSubmitted,
                        hintTxt: widget.hintText ?? 'Enter Mobile Number',
                        textInputAction: widget.textInputAction ?? TextInputAction.next,
                        height: AppConstants.constTxtFieldHeight,
                        controller: widget.mobileTextEditController,
                        maxLines: 1,
                        maxLength: maxLength,
                        onChanged: (value) {
                          widget.mobileTextEditController.text.trim();
                          final trimmed = value.trim();
                          final withoutLeadingZero = trimmed.startsWith('0') ? trimmed.substring(1) : trimmed;
                          widget.onChanged?.call(withoutLeadingZero);

                          if (!checkPhoneNo(widget.countryCodeController.text)) {
                          }
                        },
                        prefixIcon: buildPrefixIcon(context, state, firstDefaultCountry),
                        inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly, // Enforces numeric only input
                          ]
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            '$currentLength/${maxLength.toString()}',
                            style: FontTypography.textFieldHintStyle,
                          )),
                    ],
                  );
                },
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget buildPrefixIcon(BuildContext context, AppMobileTextFiledLoadedState state, MyCountry firstDefaultCountry) {
    return SizedBox(
      width: 120.0,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              searchController.clear();
              countries = state.countryListing ?? [];
              if (countries.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return buildCountrySearchDialog(context, state);
                  },
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    state.selectedFlag?.isEmpty ?? false ? AppUtils.getFlag('US') : state.selectedFlag ?? '',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(
            color: AppColors.borderColor,
            width: 0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              state.countryPhoneCode ?? '+${firstDefaultCountry.dialCode}',
              style: FontTypography.textFieldBlackStyle,
            ),
          ),
        ],
      ),
    );
  }

  AlertDialog buildCountrySearchDialog(BuildContext context, AppMobileTextFiledLoadedState state) {
    return AlertDialog(
      backgroundColor: AppColors.backgroundColor,
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                AppTextField(
                  height: 40,
                  hintTxt: 'Search Country',
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  suffix: ReusableWidgets.createSvg(path: AssetPath.searchIconSvg),
                  onChanged: (value) {
                    setState(() {
                      countries = (state.countryListing ?? []).where((country) {
                        return (country.countryName?.toLowerCase() ?? '').contains(value.toLowerCase());
                      }).toList();
                    });
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: countries.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = countries[index];
                      String flag = AppUtils.getFlag(item.countryCode ?? '');

                      return ListTile(
                        leading: Text(flag, style: const TextStyle(fontSize: 18.0)),
                        title: Text(item.countryName ?? ''),
                        trailing: Text('+${item.countryPhoneCode}'),
                        onTap: () {
                          if (widget.onPhoneCountryChanged != null) {
                            widget.onPhoneCountryChanged!(
                              item.countryCode ?? '',
                              item.countryPhoneCode ?? '',
                              true,
                            );
                          }
                          appMobileTextFieldCubit.selectedCountry(
                            countryCode: item.countryCode ?? 'US',
                            countryPhoneCode: item.countryPhoneCode ?? '1',
                          );
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
    );
  }

  bool checkPhoneNo(String countryCode) {
    var country = myCountryList.firstWhere((element) => element.code == countryCode);
    var minLength = country.minLength;
    var maxLength = country.maxLength;

    final text = widget.mobileTextEditController.text.trim();
    final effectiveLength = text.startsWith('0') ? text.length + 1 : text.length;

    return effectiveLength >= minLength && effectiveLength <= maxLength;
  }
}
