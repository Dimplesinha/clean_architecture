import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/cubit/profile_personal_details_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/presentation/widgets/snackBar_view.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 09/09/24
/// @Message : [EditEmailBottomSheetScreen]
///
/// The `EditEmailBottomSheetScreen`  class provides a user interface to edit email
class EditEmailBottomSheetScreen extends StatefulWidget {
  final ProfilePersonalDetailsCubit profilePersonalDetailsCubit;
  final LoginModel profilePersonalDetailsModel;
  final Function() callBackOnTap;

  const EditEmailBottomSheetScreen({
    super.key,
    required this.callBackOnTap,
    required this.profilePersonalDetailsCubit,
    required this.profilePersonalDetailsModel,
  });

  @override
  State<EditEmailBottomSheetScreen> createState() => _EditEmailBottomSheetScreenState();
}

class _EditEmailBottomSheetScreenState extends State<EditEmailBottomSheetScreen> {
  final TextEditingController _currentEmailAddressController = TextEditingController();
  final TextEditingController _newEmailAddressController = TextEditingController();
  final TextEditingController _confirmEmailAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _currentEmailAddressController.text = widget.profilePersonalDetailsModel.email ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePersonalDetailsCubit, ProfilePersonalDetailsState>(
      bloc: widget.profilePersonalDetailsCubit,
      builder: (context, state) {
        if (state is ProfilePersonalDetailsLoaded) {
          return Stack(
            children: [
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 7,
                          width: 59,
                          decoration: BoxDecoration(
                            color: AppColors.bottomSheetBarColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        const SizedBox(height: 17),
                        Text(
                          AppConstants.changeEmailStr,
                          style: FontTypography.changeEmailHeadingStyle,
                        ),
                        sizedBox20Width(),
                        LabelText(
                          title: AppConstants.currentEmailStr,
                          textStyle: FontTypography.subTextStyle,
                        ),
                        AppTextField(
                          isReadOnly: true,
                          fillColor: AppColors.appFieldColor,
                          controller: _currentEmailAddressController,
                          height: 40,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          hintTxt: AppConstants.currentEmailStr,
                          maxLines: 1,
                        ),
                        LabelText(
                          title: AppConstants.newEmailStr,
                          textStyle: FontTypography.subTextStyle,
                        ),
                        AppTextField(
                          controller: _newEmailAddressController,
                          height: 40,
                          keyboardType: TextInputType.emailAddress,
                          fillColor: AppColors.whiteColor,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.none,
                          hintTxt: AppConstants.newEmailStr,
                          maxLines: 1,
                        ),
                        LabelText(
                          title: AppConstants.confirmEmailStr,
                          textStyle: FontTypography.subTextStyle,
                        ),
                        AppTextField(
                          controller: _confirmEmailAddressController,
                          fillColor: AppColors.whiteColor,
                          height: 40,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.none,
                          hintTxt: AppConstants.confirmEmailStr,
                          maxLines: 1,
                        ),
                        LabelText(
                          title: AppConstants.emailPasswordStr,
                          textStyle: FontTypography.subTextStyle,
                        ),
                        AppTextField(
                          controller: _passwordController,
                          fillColor: AppColors.whiteColor,
                          height: 40,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          hintTxt: AppConstants.emailPasswordStr,
                          maxLines: 1,
                        ),
                        sizedBox30Height(),
                        Row(
                          children: [
                            Expanded(
                              child: CancelButton(
                                onPressed: () {
                                  AppRouter.pop();
                                },
                                title: AppConstants.cancelStr,
                                bgColor: AppColors.whiteColor,
                              ),
                            ),
                            sizedBox20Width(),
                            Expanded(
                              child: AppButton(
                                function: () {
                                  final validationMessage = validateEmailFields();
                                  if (validationMessage != null) {
                                    AppUtils.showSnackBar(validationMessage, SnackBarType.alert);
                                    widget.profilePersonalDetailsCubit.showCustomSnackBar();
                                  } else {
                                    widget.profilePersonalDetailsCubit.onChangeEmailTap(
                                      context,
                                      email: _currentEmailAddressController.text,
                                      newEmail: _newEmailAddressController.text,
                                      confirmedEmail: _confirmEmailAddressController.text,
                                      password: _passwordController.text,
                                    );
                                  }
                                },
                                title: AppConstants.changeEmailStr.toUpperCase(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (state.loader)
                const Positioned.fill(
                  child: LoaderView(),
                ),
              if (state.showSnackBar == true)
                CustomSnackBar(
                  message: validateEmailFields() ?? '',
                  snackBarType: CustomSnackBarType.fail,
                  isSnackBarShown: true,
                  onPressed: () {
                    // Handle dismiss action
                  },
                )
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  String? validateEmailFields() {
    if (_newEmailAddressController.text.trim().isEmpty) {
      return AppConstants.plsEnterNewEmail;
    } else if (!_newEmailAddressController.text.trim().isValidEmail()) {
      return AppConstants.invalidEmailStr;
    } else if (_confirmEmailAddressController.text.trim().isEmpty) {
      return AppConstants.plsEnterConfirmEmailStr;
    } else if (!_confirmEmailAddressController.text.trim().isValidEmail()) {
      return AppConstants.invalidConfirmEmailStr;
    } else if (_newEmailAddressController.text.trim() != _confirmEmailAddressController.text.trim()) {
      return AppConstants.matchNewEmailStr;
    } else if (widget.profilePersonalDetailsModel.email?.toLowerCase() ==
        _newEmailAddressController.text.trim().toLowerCase()) {
      return AppConstants.matchCurrentEmailStr;
    } else if (_passwordController.text.trim().isEmpty) {
      return AppConstants.plsEnterPasswordStr;
    } else if (!_passwordController.text.trim().isValidPassword()) {
      return AppConstants.passwordValidStr;
    }
    return null;
  }
}
