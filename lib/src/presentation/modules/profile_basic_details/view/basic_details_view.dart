import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/repo/profile_basic_details_repo.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 06/09/24
/// @Message : [BasicDetailsScreen]

/// The `BasicDetailsScreen` class provides a user interface to display and edit a user's profile details.
/// It shows the user's basic profile information and allows editing of these details through a form.
///
/// Responsibilities:
/// - Display the current basic details of the user.
/// - Provide an edit mode where users can update their profile details.
/// - Manage the UI layout and styling of the profile details screen.
/// - Handle interaction with the `ProfileBasicDetailsCubit` to fetch and modify profile information.

class BasicDetailsScreen extends StatefulWidget {
  const BasicDetailsScreen({super.key});

  @override
  State<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends State<BasicDetailsScreen> {
  /// Instance of the `ProfileBasicDetailsCubit` to manage the state of profile details.
  final ProfileBasicDetailsCubit profileBasicDetailsCubit =
      ProfileBasicDetailsCubit(profileBasicDetailsRepo: ProfileBasicDetailsRepo.instance);

  @override
  void initState() {
    /// Initializes the cubit with the logged-in user's ID.
    /// Replace 'abc' with the actual logged-in user ID in the future.
    profileBasicDetailsCubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBasicDetailsCubit, ProfileBasicDetailsState>(
      bloc: profileBasicDetailsCubit,
      builder: (context, state) {
        /// Check if the profile details are loaded
        if (state is ProfileBasicDetailsLoaded) {
          return Scaffold(
            appBar: MyAppBar(
              /// Set the title depending on whether the user is editing their profile.
              title: state.isEditingProfile ? AppConstants.editMyAccountDetailStr : AppConstants.myAccountDetailStr,
              actionList: [
                /// Edit button to toggle the edit mode.
                Visibility(
                  visible: !state.isEditingProfile,
                  child: IconButton(
                    icon: ReusableWidgets.createSvg(path: AssetPath.pencilIcon), // Edit icon for changing profile picture
                    onPressed: () {
                      state.profileBasicDetailsModel != null? profileBasicDetailsCubit.onEditButtonClicked():null;
                    },
                  ),
                )
              ],
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    /// Container to display static basic information header
                    Container(
                      color: AppColors.profileTileBgColor,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 26, 0, 26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Displays the title 'Basic Details'
                            Text(
                              AppConstants.basicDetailsStr,
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
                        visible: state.isEditingProfile,

                        /// If not in edit mode, show the profile details
                        replacement: ProfileDetailsFormView(
                          profileBasicDetails: state.profileBasicDetailsModel ?? LoginModel(),
                          profileBasicDetailsCubit: profileBasicDetailsCubit,
                        ),

                        /// If in edit mode, show the edit form
                        child: EditProfileDetailsFormView(
                          profileBasicDetails: state.profileBasicDetailsModel ?? LoginModel(),
                          profileBasicDetailsCubit: profileBasicDetailsCubit,
                        ),
                      ),
                    ),
                  ],
                ),
                state.loader?const LoaderView():const SizedBox.shrink(),
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
