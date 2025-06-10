import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/app_mobile_txt_field/view/app_mobile_txt_filed.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/view/google_location_view.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/cubit/profile_personal_details_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/widgets/edit_email_bottom_sheet.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 06/09/24
/// @Message : [EditProfilePersonalDetailsFormView]

class EditProfilePersonalDetailsFormView extends StatefulWidget {
  final LoginModel profilePersonalDetailsModel;
  final ProfilePersonalDetailsLoaded state;
  final ProfilePersonalDetailsCubit profilePersonalDetailsCubit;
  final bool isFromProfile;
  final bool isFromBasicDetails;
  final String firstName;
  final String lastName;
  final String gender;
  final String accountType;
  final int yearOfBirth;

  const EditProfilePersonalDetailsFormView({
    super.key,
    required this.state,
    required this.isFromProfile,
    required this.isFromBasicDetails,
    required this.profilePersonalDetailsModel,
    required this.profilePersonalDetailsCubit,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.accountType,
    required this.yearOfBirth,
  });

  @override
  State<EditProfilePersonalDetailsFormView> createState() => _EditProfilePersonalDetailsFormViewState();
}

class _EditProfilePersonalDetailsFormViewState extends State<EditProfilePersonalDetailsFormView> {
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _businessEmailController = TextEditingController();
  final TextEditingController _businessPhoneController = TextEditingController();
  final TextEditingController _phoneCodeController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  late final ProfilePersonalDetailsCubit profilePersonalDetailsCubit;

  // String phoneDialCode = '';
  // String phoneCountryCode = '';

  bool _isStreetAddressEdited = false;
  bool _isLocationEdited = false;
  bool _isPhoneEdited = false;

  @override
  void initState() {
    profilePersonalDetailsCubit = widget.profilePersonalDetailsCubit;
    _streetAddressController.addListener(() {
      _isStreetAddressEdited = true;
    });
    _locationController.addListener(() {
      _isLocationEdited = true;
    });
    _businessPhoneController.addListener(() {
      _isPhoneEdited = true;
    });
    super.initState();
  }

  @override
  void dispose() {
    _phoneCodeController.dispose();
    _locationController.dispose();
    _businessEmailController.dispose();
    _businessPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: BlocBuilder<ProfilePersonalDetailsCubit, ProfilePersonalDetailsState>(
        bloc: widget.profilePersonalDetailsCubit,
        builder: (context, state) {
          if (state is ProfilePersonalDetailsLoaded) {
            // Update fields only if they are not manually edited
            if (!_isStreetAddressEdited) {
              _streetAddressController.text = state.profilePersonalDetailsModel?.address ?? '';
            }
            if (!_isLocationEdited) {
              _locationController.text = [
                    state.profilePersonalDetailsModel?.location,
                    state.profilePersonalDetailsModel?.city,
                    state.profilePersonalDetailsModel?.state,
                    state.profilePersonalDetailsModel?.countryName,
                  ].firstWhere((element) => element?.trim().isNotEmpty == true, orElse: () => '') ??
                  '';
            }
            if (!_isPhoneEdited) {
              _businessPhoneController.text = state.profilePersonalDetailsModel?.phoneNumber ?? '';
            }
            _businessEmailController.text = state.profilePersonalDetailsModel?.email ?? '';
            _phoneCodeController.text = _phoneCodeController.text.isNotEmpty
                ? _phoneCodeController.text
                : state.profilePersonalDetailsModel?.phoneDialCode ?? '';
            countryCodeController.text = countryCodeController.text.isNotEmpty
                ? countryCodeController.text
                : state.profilePersonalDetailsModel?.phoneCountryCode ?? '';

            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Street Address
                    const LabelText(title: AppConstants.streetAddressStr, isRequired: false),
                    AppTextField(
                      controller: _streetAddressController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      hintTxt: AppConstants.enterStreetAddressStr,
                      maxLines: 1,
                    ),

                    /// Location
                    const LabelText(title: AppConstants.locationStr),
                    GoogleLocationView(
                      locationController: _locationController,
                      onLocationChanged: (Map<String, String?>? json) {
                        if (json != null) {
                          // final locationParts = value.split(',').map((e) => e.trim()).toList();
                          // String? description = json[ModelKeys.description];
                          widget.state.city = json[ModelKeys.city];
                          widget.state.state = json[ModelKeys.administrativeAreaLevel_1];
                          widget.state.country = json[ModelKeys.country];
                        }
                      },
                    ),

                    /// Business Email
                    const LabelText(title: AppConstants.businessEmailStr),
                    AppTextField(
                      isReadOnly: true,
                      fillColor: AppColors.appFieldColor,
                      controller: _businessEmailController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      hintTxt: AppConstants.businessEmailStr,
                      suffix: SizedBox(
                        width: 15.32,
                        height: 15.22,
                        child: InkWell(
                            onTap: () {
                              if (state.profilePersonalDetailsModel?.isPasswordAvailable == true ||
                                  state.isPasswordAvailable == true) {
                                AppUtils.showBottomSheetWithData(
                                  context,
                                  child: EditEmailBottomSheetScreen(
                                      callBackOnTap: () {},
                                      profilePersonalDetailsCubit: profilePersonalDetailsCubit,
                                      profilePersonalDetailsModel: widget.profilePersonalDetailsModel),
                                  onCancelWithData: (email) {
                                    _businessEmailController.text = email;
                                    widget.profilePersonalDetailsModel.email=email;
                                  },
                                );
                              } else if (state.profilePersonalDetailsModel?.isPasswordAvailable == false) {
                                AppRouter.push(AppRoutes.changePasswordRoute)?.then((result) {
                                  if (result == true) {
                                    profilePersonalDetailsCubit.onSetPassword(true);
                                  }
                                });
                              }
                            },
                            child: ReusableWidgets.createSvg(path: AssetPath.editPenIcon, size: 16)),
                      ),
                    ),
                    const LabelText(title: AppConstants.businessPhoneStr),
                    AppMobileTextField(
                        mobileTextEditController: _businessPhoneController,
                        phoneCodeController: _phoneCodeController,
                        countryCodeController: countryCodeController,
                        onPhoneCountryChanged: (String countryCode, String countryPhoneCode, bool isApply) {
                          if (isApply) _businessPhoneController.text = '';
                          countryCodeController.text = countryCode;
                          _phoneCodeController.text = '+$countryPhoneCode';
                        }),

                    /// Notification
                    const LabelText(title: AppConstants.notificationStr),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildRadio(AppConstants.emailStr, AppConstants.emailStr),
                        sizedBox29Width(),
                        _buildRadio(AppConstants.mobileStr, AppConstants.mobileStr),
                        sizedBox29Width(),
                        _buildRadio(AppConstants.bothStr, AppConstants.bothStr),
                      ],
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CancelButton(
                          onPressed: () {
                            if (widget.isFromBasicDetails) {
                              AppRouter.pop();
                            } else {
                              widget.profilePersonalDetailsCubit.onCancelButtonClicked();
                            }
                          },
                          title: AppConstants.cancelStr,
                          bgColor: AppColors.whiteColor,
                        ),
                      ),
                      sizedBox20Width(),
                      Expanded(
                        child: AppButton(
                          function: () {
                            _onSubmit(context, state);
                          },
                          title: AppConstants.applyStr,
                        ),
                      ),
                    ],
                  ),
                  sizedBox20Height(),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _onSubmit(BuildContext context, ProfilePersonalDetailsState state) {
    bool emailNotification = widget.state.profilePersonalDetailsModel?.emailNotification ?? false;
    bool pushNotification = widget.state.profilePersonalDetailsModel?.pushNotification ?? false;

    // Use the selected notification to set the values
    if (widget.state.selectedNotification == AppConstants.emailStr) {
      emailNotification = true;
      pushNotification = false;
    } else if (widget.state.selectedNotification == AppConstants.mobileStr) {
      emailNotification = false;
      pushNotification = true;
    } else if (widget.state.selectedNotification == AppConstants.bothStr) {
      emailNotification = true;
      pushNotification = true;
    }

    final String? validationError = _validateRequiredFields();
    if (validationError != null) {
      AppUtils.showSnackBar(validationError, SnackBarType.alert);
      return;
    }

    var trimmed = _businessPhoneController.text.trim();
    final withoutLeadingZero = trimmed.startsWith('0') ? trimmed.substring(1) : trimmed;
    widget.profilePersonalDetailsCubit.onSubmitTap(
      context,
      currencyUUID: '',
      countryUUID: '',
      firstName: (widget.firstName.isNotEmpty)
          ? widget.firstName
          : (widget.state.profilePersonalDetailsModel?.firstName ?? ''),
      lastName:
          (widget.lastName.isNotEmpty) ? widget.lastName : (widget.state.profilePersonalDetailsModel?.lastName ?? ''),
      birthYear:
          (widget.yearOfBirth != 0) ? widget.yearOfBirth : (widget.state.profilePersonalDetailsModel?.birthYear ?? 0),
      gender: (widget.gender.isNotEmpty)
          ? widget.gender
          : widget.state.profilePersonalDetailsModel?.gender ?? widget.gender,
      email: _businessEmailController.text.trim(),
      address: _streetAddressController.text.trim(),
      city: widget.state.city ?? widget.state.profilePersonalDetailsModel?.city ?? '' ,
      profilePic: widget.state.profilePersonalDetailsModel?.profilepic ?? '',
      phoneDialCode: _phoneCodeController.text.trim(),
      phoneCountryCode: countryCodeController.text.trim(),
      country: widget.state.country ?? widget.state.profilePersonalDetailsModel?.countryName ??'',
      phoneNumber: withoutLeadingZero,
      states: widget.state.state ?? widget.state.profilePersonalDetailsModel?.state ?? '',
      countryCode: _phoneCodeController.text.trim(),
      emailNotification: emailNotification,
      pushNotification: pushNotification,
      location: _locationController.text.trim(),
      accountTypeValue: (widget.accountType.isNotEmpty)
          ? widget.accountType
          : (widget.state.profilePersonalDetailsModel?.accountTypeValue ?? ''),
      isFromProfile: widget.isFromProfile,
    );
  }


  String? _validateRequiredFields() {
    if (_locationController.text.isEmpty) {
      return AppConstants.locationRequired;
    }
    if (_businessEmailController.text.isEmpty) {
      return AppConstants.emptyEmailStr;
    }
    if (_phoneCodeController.text.isEmpty) {
      return AppConstants.emptyMobileStr;
    }
    if (countryCodeController.text.isEmpty) {
      return AppConstants.emptyCountryCodeStr;
    }
    if (!AppUtils.checkPhoneNo(countryCodeController.text.trim(), _businessPhoneController.text.trim())) {
      return AppConstants.validMobileStr;
    }

    if ((widget.state.profilePersonalDetailsModel?.emailNotification == null ||
            widget.state.profilePersonalDetailsModel?.pushNotification == null) &&
        widget.state.selectedNotification == null) {
      return AppConstants.notificationRequired;
    }

    return null;
  }

  ///radio button ui
  Widget _buildRadio(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      child: InkWell(
        onTap: () => profilePersonalDetailsCubit.onNotificationChanged(title),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16.0,
              width: 16.0,
              child: Radio<String>(
                value: value,
                groupValue: widget.state.selectedNotification?.isNotEmpty ?? false
                    ? widget.state.selectedNotification
                    : AppUtils.getNotification(
                        widget.state.profilePersonalDetailsModel?.emailNotification ?? false,
                        widget.state.profilePersonalDetailsModel?.pushNotification ?? false,
                      ),
                activeColor: AppColors.primaryColor,
                onChanged: (value) => profilePersonalDetailsCubit.onNotificationChanged(value),
              ),
            ),
            sizedBox5Width(),
            Text(title, style: FontTypography.defaultTextStyle),
          ],
        ),
      ),
    );
  }
}
