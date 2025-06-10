import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/core/routes/app_router.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/my_profile/cubit/my_account_cubit.dart';
import 'package:workapp/src/presentation/modules/my_profile/view/more_button.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/repo/profile_basic_details_repo.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/style/style.dart';
import 'package:workapp/src/presentation/widgets/image_picker_selection.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Widget that displays the user's profile information and settings.
///
/// Provides options to view and edit basic details, personal details,
/// and user listings.

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 05/09/24
/// @Message : [myProfile]

class MyProfile extends StatefulWidget {
  final bool isFromProfile;

  const MyProfile({Key? key, this.isFromProfile = true}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final MyAccountCubit myAccountCubit = MyAccountCubit(profileBasicDetailsRepo: ProfileBasicDetailsRepo.instance);
  String location = '';
  String firstName = '';
  String lastName = '';
  String profilePic = '';

  @override
  void initState() {
    /// Initializes the cubit with the logged-in user's ID.
    /// Replace 'abc' with the actual logged-in user ID in the future.
    myAccountCubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyAccountCubit, MyAccountState>(
      bloc: myAccountCubit,
      builder: (context, state) {
        /// Check if the profile details are loaded
        if (state is MyAccountLoaded) {
          location = [
                state.profileBasicDetailsModel?.location,
                state.profileBasicDetailsModel?.city,
                state.profileBasicDetailsModel?.state,
                state.profileBasicDetailsModel?.countryName
              ].firstWhere((element) => element?.trim().isNotEmpty == true, orElse: () => '') ??
              '';
          firstName = state.profileBasicDetailsModel?.firstName ?? '';
          lastName = state.profileBasicDetailsModel?.lastName ?? '';
          profilePic = state.profileBasicDetailsModel?.profilepic ?? '';

          PreferenceHelper.instance.updatedUserData(state.profileBasicDetailsModel);

          return Stack(
            children: [
              Scaffold(
                appBar: MyAppBar(
                  title: widget.isFromProfile ? AppConstants.myAccountStr : AppConstants.viewProfileStr,
                  backGroundColor: AppColors.primaryColor,
                  appBarTitleTextStyle: FontTypography.appBarStyle.copyWith(color: AppColors.whiteColor),
                  elevation: 0,
                  actionList: [
                    Visibility(
                      visible: widget.isFromProfile == false,
                      replacement: const SizedBox.shrink(),
                      child: MoreButton(
                        onBlock: () {},
                        onCall: () {},
                        onDelete: () {},
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProfileHeader(state), // Builds the user profile header section.
                      const SizedBox(height: 16.0),
                      Visibility(
                        visible: widget.isFromProfile == true,
                        replacement: const SizedBox.shrink(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              _buildOptionTile(
                                title: AppConstants.basicDetailsStr,
                                subtitle: AppConstants.updateProfileStr,
                                onTap: () {
                                  AppRouter.push(
                                    AppRoutes.profileBasicDetailsScreenRoute,
                                  )?.then((result) {
                                    if (result == true) {
                                      myAccountCubit.init();
                                    }
                                  });
                                },
                              ),
                              const Divider(thickness: 0.3, height: 1),
                              _buildOptionTile(
                                title: AppConstants.personalDetailsStr,
                                subtitle: AppConstants.updateProfileStr,
                                onTap: () {
                                  AppRouter.push(AppRoutes.profilePersonalDetailsScreenRoute,
                                      args: {ModelKeys.isFromProfile: true})?.then((result) {
                                    if (result == true) {
                                      myAccountCubit.init();
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      sizedBox20Height(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Visibility(
                          visible: !widget.isFromProfile,
                          child: _buildOptionTile(
                            title: 'Client\'s Listings',
                            subtitle: AppConstants.exploreListingStr,
                            onTap: () {},
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.isFromProfile == false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                          child: _buildOptionTile(
                            title: AppConstants.sharedMediaStr, // Display user's listings
                            subtitle: AppConstants.exploreSharedMediaStr,
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              state.loader ? const LoaderView() : const SizedBox.shrink(),
            ],
          );
        }

        /// Return an empty widget when the state is not loaded
        return const SizedBox.shrink();
      },
    );
  }

  /// Builds the header section of the profile screen.
  ///
  /// Includes the user's avatar, name, location, and premium status indicator.
  Widget _buildProfileHeader(MyAccountLoaded state) {
    String displayDate = '';

    if (state.profileBasicDetailsModel?.dateCreated != null) {
      // If dateCreated is a string, parse it to DateTime
      DateTime dateTime = DateTime.parse(state.profileBasicDetailsModel?.dateCreated ?? '');
      // Format the date to get only the year
      displayDate = AppUtils.getDateTimeFormated(dateTime);
    }
    return Column(
      children: [
        Stack(
          children: [
            Container(height: 87, color: AppColors.primaryColor), // Colored background for the top portion
            const SizedBox(height: 137),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: AppColors.primaryColor,
                    child: SizedBox(
                      height: 95,
                      width: 95,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: LoadProfileImage(url: profilePic),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.isFromProfile == true,
                    replacement: const SizedBox.shrink(),
                    child: Stack(
                      children: [
                        const SizedBox(height: 100, width: 110), // Sized box for positioning the edit icon
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: ReusableWidgets.createSvg(path: AssetPath.pencilIcon, color: AppColors.whiteColor),
                              // Edit icon for changing profile picture
                              iconSize: 16.0,
                              onPressed: () async {
                                if (kIsWeb) {
                                  // Handle image picking on web platform
                                  final ImagePicker picker = ImagePicker();
                                  final image = await picker.pickImage(source: ImageSource.gallery);
                                  if (image != null) {
                                    onImageSelected(filePath: image.path);
                                  } else {
                                    AppUtils.showErrorSnackBar(AppConstants.somethingWentWrong);
                                  }
                                } else {
                                  // Handle image picking on mobile platforms
                                  ImagePickerSelection.instance.showActionSheet(
                                    cameraFun: () => pickImageFromSource(imageSource: ImageSource.camera),
                                    galleryFun: () => pickImageFromSource(imageSource: ImageSource.gallery),
                                  );
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: widget.isFromProfile == true,
              replacement: Text(
                'Client Name',
                style: FontTypography.profileHeading,
              ),
              child: Expanded(
                child: Text(
                  '$firstName $lastName',
                  style: FontTypography.profileHeading,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Visibility(
              visible: widget.isFromProfile == true,
              replacement: SizedBox(
                height: 14.0,
                width: 14.0,
                child: ReusableWidgets.createSvg(path: AssetPath.editIconBlack, size: 15.0),
              ),
              child: Visibility(
                visible: AppUtils.loginUserModel?.subscriberPlan != null?true:false || AppUtils.loginUserModel?.planPurchased==true,
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White background for the button
                      padding: const EdgeInsets.symmetric(vertical: 4), // Button padding
                      elevation: 3, // Elevation for shadow effect
                    ),
                    onPressed: () {}, // Action for the button (currently empty)
                    child: ReusableWidgets.createSvg(size: 20, path: AssetPath.diamondIcon), // Icon inside the button
                  ),
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: location.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              location,
              style: FontTypography.profileSUbTitle,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
        Text(
          '${AppConstants.memberSinceStr} $displayDate',
          style: FontTypography.profileSUbTitle,
        ),
      ],
    );
  }

  /// Creates a list tile widget for displaying profileoptions.
  ///
  /// [title]: The main title of the option.
  /// [subtitle]: A descriptive subtitle for the option.
  /// [onTap]: The function to be executed when the tile is tapped.
  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.profileTileBgColor),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: Text(
          title,
          style: FontTypography.profileTitleHeading,
        ),
        subtitle: Text(subtitle, style: FontTypography.defaultLightTextStyle),
        trailing: const Icon(Icons.arrow_forward_ios),
        // Navigation indicator
        onTap: onTap,
      ),
    );
  }

  void pickImageFromSource({required ImageSource imageSource}) async {
    await ImagePickerSelection.instance.onImageButtonPressed(
      from: AppConstants.profile,
      mediaSource: imageSource,
      resultCallback: (List<XFile?>? images) {
        if (images != null || images!.isNotEmpty) {
          for (var image in images) {
            onImageSelected(filePath: image!.path);
          }
        }
      },
    );
  }

  void onImageSelected({required String filePath}) {
    myAccountCubit.onSelectImage(
      context,
      imagePath: filePath,
    );
  }
}
