import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/loader_view.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11/09/24
/// @Message : [PersonalDetailsScreen]

/// The `BasicDetailsScreen` class provides a user interface to display and edit a user's profile details.
/// It shows the user's personal profile information and allows editing of these details through a form.
///
/// Responsibilities:
/// - Display the current personal details of the user.
/// - Provide an edit mode where users can update their profile details.
/// - Manage the UI layout and styling of the profile details screen.
/// - Handle interaction with the `ProfileBasicDetailsCubit` to fetch and modify profile information.

class PersonalDetailsScreen extends StatefulWidget {
  final bool isFromProfile;
  final bool isFromBasicDetails;
  final String firstName;
  final String lastName;
  final String gender;
  final String accountType;
  final int dob;

  const PersonalDetailsScreen(
      {super.key,
      this.isFromProfile = false,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.dob,
      required this.isFromBasicDetails,
      required this.accountType});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  /// Instance of the `ProfileBasicDetailsCubit` to manage the state of profile details.
  late ProfilePersonalDetailsCubit profilePersonalDetailsCubit;

  @override
  void initState() {
    /// Initializes the cubit with the logged-in user's ID.
    /// Replace 'abc' with the actual logged-in user ID in the future.
    profilePersonalDetailsCubit = ProfilePersonalDetailsCubit(
        profilePersonalDetailsRepo: ProfilePersonalDetailsRepo.instance);
    profilePersonalDetailsCubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePersonalDetailsCubit, ProfilePersonalDetailsState>(
      bloc: profilePersonalDetailsCubit,
      builder: (context, state) {
        /// Check if the profile details are loaded
        if (state is ProfilePersonalDetailsLoaded) {
          /// Todo: Confirm the flow after click of app bar's back button if navigated from basic details to personal details.
          return Scaffold(
            appBar: MyAppBar(
              /// Set the title depending on whether the user is editing their profile.
              title: (state.isEditingProfile || widget.isFromBasicDetails)
                  ? AppConstants.editMyAccountDetailStr
                  : AppConstants.myAccountDetailStr,
              actionList: [
                /// Edit button to toggle the edit mode.
                Visibility(
                  visible: !(state.isEditingProfile || widget.isFromBasicDetails),
                  child: IconButton(
                    icon: const Icon(Icons.mode_edit_outline_outlined),
                    onPressed: () {
                      profilePersonalDetailsCubit.onEditButtonClicked();
                    },
                  ),
                )
              ],
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    /// Container to display static personal information header
                    Container(
                      color: AppColors.profileTileBgColor,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 26, 0, 26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Displays the title 'personal Details'
                            Text(
                              AppConstants.personalDetailsStr,
                              style: FontTypography.basicDetailsTitle,
                            ),
                            const SizedBox(height: 8),

                            /// Displays the subtitle 'Update or modify profile'
                            Text(
                              AppConstants.updateModifyProfileStr,
                              style: FontTypography.defaultLightTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Main content area to either show profile details or edit form
                    Expanded(
                      child: Visibility(
                        visible: state.profilePersonalDetailsModel != null,
                        child: Visibility(
                          visible: state.isEditingProfile || widget.isFromBasicDetails,

                          /// If not in edit mode, show the profile details
                          replacement: ProfilePersonalDetailsFormView(
                            profilePersonalDetailsModel: state.profilePersonalDetailsModel ?? LoginModel(),
                            state: state,
                            profilePersonalDetailsCubit: profilePersonalDetailsCubit,
                            isFromProfile: widget.isFromProfile,
                            firstName: widget.firstName,
                            lastName: widget.lastName,
                            dateOfBirth: widget.dob,
                            gender: widget.gender,
                          ),

                          /// If in edit mode, show the edit form
                          child: EditProfilePersonalDetailsFormView(
                            profilePersonalDetailsModel: state.profilePersonalDetailsModel ?? LoginModel(),
                            state: state,
                            profilePersonalDetailsCubit: profilePersonalDetailsCubit,
                            isFromProfile: widget.isFromProfile,
                            isFromBasicDetails: widget.isFromBasicDetails,
                            firstName: (widget.firstName.isNotEmpty)
                                ? widget.firstName
                                : (state.profilePersonalDetailsModel?.firstName ?? ''),
                            lastName: (widget.lastName.isNotEmpty)
                                ? widget.lastName
                                : (state.profilePersonalDetailsModel?.lastName ?? ''),
                            yearOfBirth:
                                (widget.dob != 0) ? widget.dob : (state.profilePersonalDetailsModel?.birthYear ?? 0),
                            gender: (widget.gender.isNotEmpty)
                                ? widget.gender
                                : state.profilePersonalDetailsModel?.gender ?? widget.gender,
                            accountType: (widget.accountType.isNotEmpty)
                                ? widget.accountType
                                : state.profilePersonalDetailsModel?.accountTypeValue ?? widget.gender,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                state.loader ? const LoaderView() : const SizedBox.shrink()
              ],
            ),
          );
        }

        /// Return an empty widget when the state is not loaded
        return const SizedBox.shrink();
      },
    );
  }
}
