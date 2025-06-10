import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/repo/profile_basic_details_repo.dart';

part 'profile_basic_details_state.dart';

class ProfileBasicDetailsCubit extends Cubit<ProfileBasicDetailsState> {
  ProfileBasicDetailsRepo profileBasicDetailsRepo;

  ProfileBasicDetailsCubit({required this.profileBasicDetailsRepo}) : super(ProfileBasicDetailsInitial());

  void init() async {
    try {
      emit(const ProfileBasicDetailsLoaded(loader: true));
      var response = await profileBasicDetailsRepo.getProfileBasicDetails();
        var oldState = state as ProfileBasicDetailsLoaded;
        emit(oldState.copyWith(
          loader: false,
          profileBasicDetailsModel: response.responseData,
        ));
    } catch (ex) {
      if (kDebugMode) {
        print(this);
      }
    }
  }

  void onEditButtonClicked() {
    var oldState = state as ProfileBasicDetailsLoaded;
    emit(oldState.copyWith(
      isEditingProfile: !oldState.isEditingProfile,
      profileBasicDetailsModel: oldState.profileBasicDetailsModel,
    ));
  }

  void onDobChanged({required int timestamp}) {
    var oldState = state as ProfileBasicDetailsLoaded;
    oldState.profileBasicDetailsModel?.birthYear = timestamp;
    emit(oldState.copyWith(profileBasicDetailsModel: oldState.profileBasicDetailsModel));
  }

  void onApplyButtonClicked(LoginModel profileBasicDetailsModel) {
    var oldState = state as ProfileBasicDetailsLoaded;
    emit(oldState.copyWith(
      isEditingProfile: !oldState.isEditingProfile,
      profileBasicDetailsModel: profileBasicDetailsModel,
    ));
  }

  void onCancelButtonClicked() {
    var oldState = state as ProfileBasicDetailsLoaded;
    emit(oldState.copyWith(
      isEditingProfile: !oldState.isEditingProfile,
      gender: ''
    ));
  }

  void onGenderChanged(String value) {
    var oldState = state as ProfileBasicDetailsLoaded;
    emit(oldState.copyWith(gender: value));
  }

  void accountTypeChange(int value) async {
    var oldState = state as ProfileBasicDetailsLoaded;
    try {
      emit(oldState.copyWith(accountType: value));
    } catch (e) {
      emit(const ProfileBasicDetailsLoaded());
    }
  }
}
