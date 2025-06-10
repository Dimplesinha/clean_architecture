import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/cubit/profile_personal_details_cubit.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';

class ProfilePersonalDetailsFormView extends StatefulWidget {
  final bool isFromProfile;
  final LoginModel profilePersonalDetailsModel;
  final ProfilePersonalDetailsCubit profilePersonalDetailsCubit;
  final ProfilePersonalDetailsState state;
  final String firstName;
  final String lastName;
  final String gender;
  final int dateOfBirth;

  const ProfilePersonalDetailsFormView({
    super.key,
    required this.profilePersonalDetailsModel,
    this.isFromProfile = false,
    required this.profilePersonalDetailsCubit,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.state,
  });

  @override
  State<ProfilePersonalDetailsFormView> createState() => _ProfilePersonalDetailsFormViewState();
}

class _ProfilePersonalDetailsFormViewState extends State<ProfilePersonalDetailsFormView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePersonalDetailsCubit, ProfilePersonalDetailsState>(
      bloc: widget.profilePersonalDetailsCubit,
      builder: (context, state) {
        if (state is ProfilePersonalDetailsLoaded) {
          return Stack(
            children: [
              Scaffold(
                body: _buildBody(state),
                bottomNavigationBar: _buildBottomNavigationBar(context, state),
              ),
              Visibility(visible: state.loader == true, child: const LoaderView()),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBody(ProfilePersonalDetailsLoaded state) {
    state.email = widget.profilePersonalDetailsModel.email ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ReadOnlyTextField(
              title: AppConstants.streetAddressStr,
              value: widget.profilePersonalDetailsModel.address ?? '',
              maxLine: 2,
              isRequired: false,
            ),
            ReadOnlyTextField(
              title: AppConstants.locationStr,
              value:  [
                state.profilePersonalDetailsModel?.location,
                state.profilePersonalDetailsModel?.city,
                state.profilePersonalDetailsModel?.state,
                state.profilePersonalDetailsModel?.countryName,
              ].firstWhere((element) => element?.trim().isNotEmpty == true, orElse: () => '') ?? '',
            ),
            ReadOnlyTextField(
              title: AppConstants.businessEmailStr,
              value: state.email ?? '',
            ),
            ReadOnlyTextField(
              title: AppConstants.businessPhoneStr,
              value: (widget.profilePersonalDetailsModel.phoneDialCode ?? '')+(widget.profilePersonalDetailsModel.phoneNumber ?? ''),
            ),
            ReadOnlyTextField(
              title: AppConstants.notificationStr,
              value: (state.selectedNotification?.isNotEmpty ?? false)
                  ? state.selectedNotification ?? ''
                  : getNotification(
                      widget.profilePersonalDetailsModel.emailNotification ?? false,
                      widget.profilePersonalDetailsModel.pushNotification ?? false,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, ProfilePersonalDetailsState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        children: [
          Expanded(
            child: AppBackButton(
              bgColor: AppColors.whiteColor,
              function: () {
                AppRouter.pop();
              },
              title: AppConstants.backStr,
            ),
          ),
          sizedBox20Width(),
          Expanded(
            child: AppButton(
              function: () {
                 AppRouter.pop();
              },
              title: AppConstants.doneStr,
            ),
          ),
        ],
      ),
    );
  }

  String getNotification(bool emailNotification, bool pushNotification) {
    if (emailNotification && !pushNotification) {
      return AppConstants.emailStr;
    } else if (!emailNotification && pushNotification) {
      return AppConstants.mobileStr; // Mobile only
    } else if (emailNotification && pushNotification) {
      return AppConstants.emailMobileStr; // Both Email and Mobile
    } else {
      return '';
    }
  }
}
