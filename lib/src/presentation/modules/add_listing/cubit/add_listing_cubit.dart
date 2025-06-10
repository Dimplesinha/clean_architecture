import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/data/storage/preference/preference_helper.dart';
import 'package:workapp/src/domain/models/models_export.dart';

part 'add_listing_state.dart';

class AddListingCubit extends Cubit<AddListingState> {
  AddListingCubit() : super(AddListingInitial());

  void init() async {
    emit(const AddListingLoadedState());
    fetchCategories();
  }

  /// Fetch all Categories
  Future<void> fetchCategories() async {
    var oldState = state as AddListingLoadedState;
    try {
      emit(oldState.copyWith());

      var response = await PreferenceHelper.instance.getCategoryList();
      var user = await PreferenceHelper.instance.getUserData();
      String? accountType = user.result?.accountTypeValue ?? '';

      if (response.statusCode == 200 && response.result != null) {
        // var filteredListings = user.result?.accountType == AppConstants.personalStr
        //     ? response.result
        //         ?.where((category) => category.categoryName != AddListingFormConstants.business)
        //         .where((category) => category.categoryName != AddListingFormConstants.promo)
        //         .toList()
        //     : response.result;
        emit(oldState.copyWith(listings: response.result, accountType: accountType));
      } else {
        emit(oldState.copyWith(listings: response.result ?? [], accountType: accountType));
      }
    } catch (e) {
      emit(oldState.copyWith(listings: []));
    }
  }
}
