import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/my_contact_profile/cubit/my_contact_profile_cubit.dart';
import 'package:workapp/src/presentation/my_contact_profile/repo/contact_profile_repo.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/style/style.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Widget that displays the user's profile information and settings.
///
/// Provides options to view and edit basic details, personal details,
/// and user listings.

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 25/03/25
/// @Message : [myContactProfile]

class MyContactProfile extends StatefulWidget {
  final int contactId;

  const MyContactProfile({Key? key, this.contactId = 0}) : super(key: key);

  @override
  State<MyContactProfile> createState() => _MyContactProfileState();
}

class _MyContactProfileState extends State<MyContactProfile> {
  final MyContactProfileCubit myContactProfileCubit =
      MyContactProfileCubit(contactProfileRepo: ContactProfileRepo.instance);
  String location = '';
  String userName = '';
  String lastName = '';
  String profilePic = '';

  @override
  void initState() {
    /// Initializes the cubit with the logged-in user's ID.
    /// Replace 'abc' with the actual logged-in user ID in the future.
    myContactProfileCubit.init(widget.contactId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyContactProfileCubit, MyContactProfileState>(
      bloc: myContactProfileCubit,
      builder: (context, state) {
        /// Check if the profile details are loaded
        if (state is MyContactProfileLoaded) {
          location = [state.contactProfileModel?.result.location]
                  .firstWhere((element) => element?.trim().isNotEmpty == true, orElse: () => '') ??
              '';
          userName =
              '${state.contactProfileModel?.result.firstName ?? ''} ${state.contactProfileModel?.result.lastName ?? ''}';
          profilePic = state.contactProfileModel?.result.profilePic ?? '';

          return Stack(
            children: [
              Scaffold(
                appBar: MyAppBar(
                  title: AppConstants.viewProfileStr,
                  backGroundColor: AppColors.primaryColor,
                  appBarTitleTextStyle: FontTypography.appBarStyle.copyWith(color: AppColors.whiteColor),
                  elevation: 0,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProfileHeader(state), // Builds the user profile header section.
                      sizedBox20Height(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Visibility(
                          visible: state.contactProfileModel == null ? false : true,
                          child: _buildOptionTile(
                            title: '${state.contactProfileModel?.result.firstName ?? ''}\'s ${AppConstants.listings}',
                            subtitle: AppConstants.exploreContactListingStr,
                            onTap: () {
                              var title =
                                  '${state.contactProfileModel?.result.firstName ?? ''}\'s ${AppConstants.listings}';
                              var userId = widget.contactId;
                              AppRouter.push(AppRoutes.myContactUserListing, args: {
                                ModelKeys.title: title,
                                ModelKeys.userId: userId,
                              });
                            },
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
  Widget _buildProfileHeader(MyContactProfileLoaded state) {
    String displayDate = '';

    if (state.contactProfileModel?.utcTimeStamp != null) {
      // If dateCreated is a string, parse it to DateTime
      DateTime dateTime = DateTime.parse(state.contactProfileModel?.utcTimeStamp ?? '');
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
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userName,
              style: FontTypography.profileHeading,
            ),
            const SizedBox(width: 8.0),
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
      ],
    );
  }

  /// Creates a list tile widget for displaying profile options.
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
}
