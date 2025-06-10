import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/domain/models/google_location_model.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/repo/google_location_repo.dart';
part 'google_location_view_state.dart';

class GoogleLocationViewCubit extends Cubit<GoogleLocationViewState> {
  FetchGoogleLocationRepo fetchGoogleLocationRepo;

  GoogleLocationViewCubit({required this.fetchGoogleLocationRepo}) : super(const GoogleLocationViewLoaded());

  void fetchSuggestion({required String input}) async {
    var oldState = state as GoogleLocationViewLoaded;
    try {
      var response = await fetchGoogleLocationRepo.fetchSuggestions(input: input);
      if (response.status == true && response.responseData != null) {
        var oldState = state as GoogleLocationViewLoaded;
        emit(oldState.copyWith(placesList: response.responseData?.predictions));
      } else {
        emit(oldState.copyWith(placesList: response.responseData?.predictions));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void onLocationSelected() {
    var oldState = state as GoogleLocationViewLoaded;
    try {
      emit(oldState.copyWith(placesList: []));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void onLocationCleared() {
    var oldState = state as GoogleLocationViewLoaded;
    try {
      emit(oldState.copyWith(placesList: []));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<Map<String, String>> fetchLatLongFromAddressPlaceId({required String placeId}) async {
    var latLongResp = await fetchGoogleLocationRepo.getLatLongFromPlaceId(placeId: placeId);
    return latLongResp;
  }
}
