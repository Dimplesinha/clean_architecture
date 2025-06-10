part of 'profile_basic_details_cubit.dart';

sealed class ProfileBasicDetailsState extends Equatable {
  const ProfileBasicDetailsState();
}

final class ProfileBasicDetailsInitial extends ProfileBasicDetailsState {
  @override
  List<Object> get props => [];
}

final class ProfileBasicDetailsLoaded extends ProfileBasicDetailsState {
  final bool loader;
  final bool isEditingProfile;
  final String? gender;
  final int? accountType;
  final LoginModel? profileBasicDetailsModel;

  const ProfileBasicDetailsLoaded({
    this.loader = false,
    this.isEditingProfile = false,
    this.gender,
    this.accountType,
    this.profileBasicDetailsModel,
  });

  // CopyWith method to create a new state with modified properties
  ProfileBasicDetailsLoaded copyWith({
    bool? loader,
    bool? isEditingProfile,
    String? gender,
    int? accountType,
    LoginModel? profileBasicDetailsModel,
  }) {
    return ProfileBasicDetailsLoaded(
      loader: loader ?? this.loader,
      gender: gender ?? this.gender,
      accountType: accountType ?? this.accountType,
      isEditingProfile: isEditingProfile ?? this.isEditingProfile,
      profileBasicDetailsModel: profileBasicDetailsModel ?? this.profileBasicDetailsModel,
    );
  }

  @override
  List<Object?> get props => [
        loader,
        isEditingProfile,
        profileBasicDetailsModel,
        gender,
        accountType,
        // identityHashCode(this),
      ];
}
