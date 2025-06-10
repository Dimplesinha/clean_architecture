import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/account_type_change/view/account_type_dialog.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/presentation/widgets/year_picker.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 06/09/24
/// @Message : [EditProfileDetailsFormView]

class EditProfileDetailsFormView extends StatefulWidget {
  final LoginModel profileBasicDetails;
  final ProfileBasicDetailsCubit profileBasicDetailsCubit;

  const EditProfileDetailsFormView(
      {super.key,
      required this.profileBasicDetails,
      required this.profileBasicDetailsCubit});

  @override
  State<EditProfileDetailsFormView> createState() =>
      _EditProfileDetailsFormViewState();
}

class _EditProfileDetailsFormViewState
    extends State<EditProfileDetailsFormView> {
  final TextEditingController _accountTypeController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? gender;
  String? selectedGender;

  final List<TextInputFormatter> _nameInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
  ];

  @override
  void initState() {
    _accountTypeController.text = widget.profileBasicDetails.accountTypeValue ?? '';
    _firstNameController.text = widget.profileBasicDetails.firstName ?? '';
    _lastNameController.text = widget.profileBasicDetails.lastName ?? '';
    _dobController.text = widget.profileBasicDetails.getBirthYear;
    gender = widget.profileBasicDetails.gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBasicDetailsCubit, ProfileBasicDetailsState>(
      bloc: widget.profileBasicDetailsCubit,
      builder: (context, state) {
        /// Check if the profile details are loaded
        if (state is ProfileBasicDetailsLoaded) {
          return Stack(
            children: [
              Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        LabelText(
                          title: AppConstants.accountType,
                          textStyle: FontTypography.textFieldBlackStyle,
                        ),
                        AppTextField(
                          isReadOnly: true,
                          controller: _accountTypeController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          fillColor: AppColors.appFieldColor,
                          suffix: SizedBox(
                            width: 15.32,
                            height: 15.22,
                            child: InkWell(
                                onTap: () {
                                  AppUtils.showBottomSheet(context,
                                      isDismissible: true,
                                      child: AccountTypeBottomSheet(
                                        onOkPressed: () {},
                                        accountType: _accountTypeController.text,
                                        isFromMyProfile: true,
                                      ));
                                },
                                child: ReusableWidgets.createSvg(
                                    path: AssetPath.editPenIcon, size: 16)),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                      title: AppConstants.firstNameStr,
                                      textStyle:
                                          FontTypography.textFieldBlackStyle,
                                    ),
                                    AppTextField(
                                      controller: _firstNameController,
                                      inputFormatters: _nameInputFormatter,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                      hintTxt: AppConstants.enterFirstNameStr,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                      title: AppConstants.lastNameStr,
                                      textStyle:
                                          FontTypography.textFieldBlackStyle,
                                    ),
                                    AppTextField(
                                      controller: _lastNameController,
                                      inputFormatters: _nameInputFormatter,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                      hintTxt: AppConstants.enterLastNameStr,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                      title: AppConstants.yearOfBirthStr,
                                      textStyle:
                                          FontTypography.textFieldBlackStyle,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _selectDate(context);
                                      },
                                      child: AbsorbPointer(
                                        child: TextFormField(
                                          controller: _dobController,
                                          style: FontTypography
                                              .textFieldGreyTextStyle,
                                          decoration: InputDecoration(
                                            suffixIcon: const Icon(
                                                Icons.calendar_today,
                                                size: 16),
                                            hintText: _dobController.text,
                                            hintStyle: FontTypography
                                                .textFieldHintStyle,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 15, right: 15),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.borderColor),
                                            ),
                                            errorStyle: TextStyle(
                                                color: AppColors.errorColor),
                                          ),
                                          validator: (value) {
                                            if (_dobController.text == '') {
                                              return AppConstants.selectDobStr;
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                      title: AppConstants.genderStr,
                                      textStyle:
                                          FontTypography.textFieldBlackStyle,
                                    ),
                                    genderDropDown(state),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Use SizedBox instead of Spacer here
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CancelButton(
                              onPressed: () {
                                widget.profileBasicDetailsCubit
                                    .onCancelButtonClicked();
                              },
                              title: AppConstants.cancelStr,
                              bgColor: AppColors.whiteColor,
                            ),
                          ),
                          sizedBox20Width(),
                          Expanded(
                            child: AppButton(
                              function: () {
                                _onNext(context, state);
                              },
                              title: AppConstants.nextStr,
                            ),
                          ),
                        ],
                      ),
                      sizedBox30Height(),
                    ],
                  ),
                ),
              ),
              state.loader ? const LoaderView() : const SizedBox.shrink()
            ],
          );
        }

        /// Return an empty widget when the state is not loaded
        return const SizedBox.shrink();
      },
    );
  }

  void _onNext(BuildContext context, ProfileBasicDetailsLoaded state) {
    final String? validationError = _validateRequiredFields(state);
    if (validationError != null) {
      AppUtils.showSnackBar(validationError, SnackBarType.alert);
      return;
    }
    int dob = int.parse(_dobController.text.split('-').last);
    AppRouter.push(AppRoutes.profilePersonalDetailsScreenRoute, args: {
      // ModelKeys.isFromProfile: true,
      ModelKeys.isFromBasicDetails: true,
      ModelKeys.firstName: _firstNameController.text.trim(),
      ModelKeys.lastName: _lastNameController.text.trim(),
      ModelKeys.birthYear: dob,
      ModelKeys.gender: state.gender ?? gender,
      ModelKeys.accountType: state.accountType ??
          state.profileBasicDetailsModel?.accountTypeValue ??
          '',
    });
  }

  String? _validateRequiredFields(ProfileBasicDetailsLoaded state) {
    if (_firstNameController.text.isEmpty) {
      return AppConstants.firstNameRequired;
    }

    if (_lastNameController.text.isEmpty) {
      return AppConstants.lastNameRequired;
    }

    if (_dobController.text.isEmpty ||
        widget.profileBasicDetails.birthYear == null) {
      return AppConstants.birthRequired;
    }

    if ((gender?.isEmpty ?? false) || (gender == null)) {
      return AppConstants.addGender;
    }

    return null;
  }

  Widget genderDropDown(ProfileBasicDetailsLoaded state) {
    // Mapping of gender options
    final genderOptions = {
      'Male': AppConstants.maleStr,
      'Female': AppConstants.femaleStr,
    };
    final String? genderCode = widget.profileBasicDetails.gender;

// Use the utility method to get the display value
    selectedGender = AppUtils.getGenderFromCode(genderCode);
    // Determine the selected gender or fallback to default if empty or null
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          selectedGender?.isNotEmpty ?? false
              ? selectedGender ?? ''
              : AppConstants.genderStr,
          style: FontTypography.textFieldGreyTextStyle,
        ),
        customButton: Container(
          height: AppConstants.constTxtFieldHeight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  // Display the selected gender or default hint if none selected
                  state.gender != null &&
                          genderOptions.containsKey(state.gender)
                      ? genderOptions[state.gender]!
                      : selectedGender ?? AppConstants.genderStr,
                  style: FontTypography.textFieldGreyTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ReusableWidgets.createSvg(path: AssetPath.iconDropDown, size: 5),
            ],
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
          ),
        ),
        items: genderOptions.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(
              entry.value,
              style: FontTypography.textFieldBlackStyle,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        value: genderOptions.containsKey(state.gender) ? state.gender : null,
        // Ensure non-empty value
        onChanged: (String? value) {
          if (value != null) {
            // Update gender in the cubit if value is not null
            widget.profileBasicDetailsCubit.onGenderChanged(value);
            gender = value;
          }
        },
      ),
    );
  }

  // Date Picker Function
  Future<void> _selectDate(BuildContext context) async {
    int currentYear = DateTime.now().year;
    int startYear = 1900;
    int endYear = currentYear - 16;
    final int? selectedYear = int.tryParse(_dobController.text);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectYear(
          startYear: startYear,
          endYear: endYear,
          selectedYear: selectedYear,
          onYearSelected: (selectedYear) {
            DateTime picked = DateTime(selectedYear);

            // Update the text field and notify the cubit
            _dobController.text = AppUtils.getDateTimeFormated(picked);
            int timestamp = int.parse(_dobController.text);

            widget.profileBasicDetailsCubit.onDobChanged(timestamp: timestamp);
            // Close the dialog after selection
            AppRouter.pop();
          },
        );
      },
    );
  }

  /// Account Type Dropdown
//   Widget chooseAccountType(ProfileBasicDetailsLoaded state) {
//     // Mapping account type strings from the backend to corresponding display strings
//     final accountTypeOptions = {
//       'Business': AppConstants.businessStr,
//       'Personal': AppConstants.personalStr,
//     };
//
//     String selectedAccountType = state.accountType ?? state.profileBasicDetailsModel?.accountType ?? '';
//
//     // Determine the display text for the selected account type
//
//     return DropdownButtonHideUnderline(
//       child: DropdownButton2<String>(
//         isExpanded: true,
//         hint: Text(
//           selectedAccountType,
//           style: FontTypography.textFieldGreyTextStyle,
//         ),
//         customButton: Container(
//           height: AppConstants.constTxtFieldHeight,
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           decoration: BoxDecoration(
//             color: AppColors.whiteColor,
//             borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
//             border: Border.all(color: AppColors.borderColor),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   selectedAccountType,
//                   style: FontTypography.textFieldGreyTextStyle,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               ReusableWidgets.createSvg(path: AssetPath.iconDropDown, size: 5),
//             ],
//           ),
//         ),
//         dropdownStyleData: DropdownStyleData(
//           decoration: BoxDecoration(
//             color: AppColors.backgroundColor,
//           ),
//         ),
//         items: accountTypeOptions.keys.map((key) {
//           return DropdownMenuItem<String>(
//             value: key,
//             child:
//             Row(
//               children: [
//                 // Add icon based on the entry key
//                 ReusableWidgets.createSvg(
//                   path: accountTypeOptions[key] == AppConstants.personalStr ? AssetPath.personalAccountTypeIcon : AssetPath.businessAccountTypeIcon,
//                   color: AppColors.blackColor,
//                 ),
//                 const SizedBox(width: 10), // Space between icon and text
//                 Text(
//                   accountTypeOptions[key]!, // Display the corresponding string
//                   style: FontTypography.textFieldBlackStyle,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//         value: selectedAccountType,
//         onChanged: (String? value) {
//           if (value != null) {
//             // widget.profileBasicDetailsCubit.accountTypeChange(value); // Pass the string value to the cubit
//           }
//         },
//       ),
//     );
//   }
}
