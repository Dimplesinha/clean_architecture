part of 'profile_personal_details_cubit.dart';

sealed class ProfilePersonalDetailsState extends Equatable {
  const ProfilePersonalDetailsState();
}

final class ProfilePersonalDetailsInitial extends ProfilePersonalDetailsState {
  @override
  List<Object> get props => [];
}

final class ProfilePersonalDetailsLoaded extends ProfilePersonalDetailsState {
  final bool loader;
  final bool isEditingProfile;
  final bool isFromBasicDetails;
  final bool emailNotification;
  final bool pushNotification;
  final bool showSnackBar;
  final bool isPasswordAvailable;
  final String? selectedNotification;
  String? selectedFlag;
  String? email;
  String? countryPhoneCode;
  String? mobileNumber;
  String? state;
  String? city;
  String? country;
  final List<Countries>? countryListing;

  final LoginModel? profilePersonalDetailsModel;

  ProfilePersonalDetailsLoaded({
    this.loader = false,
    this.isEditingProfile = false,
    this.isFromBasicDetails = false,
    this.pushNotification = false,
    this.emailNotification = false,
    this.showSnackBar = false,
    this.isPasswordAvailable = false,
    this.selectedNotification,
    this.email,
    this.profilePersonalDetailsModel,
    this.countryListing,
    this.selectedFlag,
    this.mobileNumber,
    this.countryPhoneCode,
    this.city,
    this.country,
    this.state,
  });

  // CopyWith method to create a new state with modified properties
  ProfilePersonalDetailsLoaded copyWith({
    bool? loader,
    bool? isEditingProfile,
    bool? isFromBasicDetails,
    bool? showSnackBar,
    bool? isPasswordAvailable,
    String? selectedNotification,
    String? email,
    bool? pushNotification,
    bool? emailNotification,
    LoginModel? profilePersonalDetailsModel,
    String? selectedFlag,
    String? countryPhoneCode,
    String? mobileNumber,
    String? city,
    String? country,
    String? state,
    List<Countries>? countryListing,
  }) {
    return ProfilePersonalDetailsLoaded(
      loader: loader ?? this.loader,
      isEditingProfile: isEditingProfile ?? this.isEditingProfile,
      isFromBasicDetails: isFromBasicDetails ?? this.isFromBasicDetails,
      showSnackBar: showSnackBar ?? this.showSnackBar,
      email: email ?? this.email,
      isPasswordAvailable: isPasswordAvailable ?? this.isPasswordAvailable,
      selectedNotification: selectedNotification ?? this.selectedNotification,
      pushNotification: pushNotification ?? this.pushNotification,
      emailNotification: emailNotification ?? this.emailNotification,
      profilePersonalDetailsModel: profilePersonalDetailsModel ?? this.profilePersonalDetailsModel,
      countryListing: countryListing ?? this.countryListing,
      selectedFlag: selectedFlag ?? this.selectedFlag,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      countryPhoneCode: countryPhoneCode ?? this.countryPhoneCode,
    );
  }

  @override
  List<Object?> get props => [
        loader,
        isEditingProfile,
        selectedNotification,
        profilePersonalDetailsModel,
        countryListing,
        selectedFlag,
        countryPhoneCode,
        city,
        state,
        country,
        showSnackBar,
    isPasswordAvailable
        // identityHashCode(this),
      ];
}
