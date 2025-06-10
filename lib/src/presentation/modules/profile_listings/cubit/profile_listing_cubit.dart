import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/presentation/modules/profile_listings/repo/profile_listing_repo.dart';

part 'profile_listing_state.dart';

class ProfileListingCubit extends Cubit<ProfileListingState> {
  ProfileListingRepo profileListingRepo;

  ProfileListingCubit({required this.profileListingRepo}) : super(ProfileListingInitial());

  void init({required String userId}) async {
    try {
      emit(const ProfileListingLoaded(loader: true));
      var response = await profileListingRepo.getProfileListing(userId: userId);
      if (response.status) {
        var oldState = state as ProfileListingLoaded;
        emit(oldState.copyWith(
          loader: false,
          listings: response.responseData,
        ));
      }
    } catch (ex) {
      if (kDebugMode) {
        print(this);
      }
    }
  }
}
