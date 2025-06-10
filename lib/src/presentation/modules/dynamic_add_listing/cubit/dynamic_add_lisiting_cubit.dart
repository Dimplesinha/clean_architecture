import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/add_listing_category.dart';
import 'package:workapp/src/domain/models/asset_model.dart';
import 'package:workapp/src/master_data/master_data_api.dart';
import 'package:workapp/src/presentation/modules/dynamic_add_listing/repo/dynamic_add_listing_repo.dart';

part 'dynamic_add_lisiting_state.dart';



class DynamicAddListingCubit extends Cubit<DynamicAddListingState> {
  DynamicAddListingCubit() : super(DynamicAddListingInitial());

  void init() async {
    emit(const DynamicAddListingLoadedState());
    fetchCategories();
  }

  /// Fetch all Categories
  Future<void> fetchCategories() async {
    var oldState = state as DynamicAddListingLoadedState;
    try {
      emit(oldState.copyWith(isLoading: true));
      /*var response =  await DynamicAddListingRepository.instance.getListOfCategory();*/
      var user = await PreferenceHelper.instance.getUserData();
      String? accountType = user.result?.accountTypeValue ?? '';

      var response = await PreferenceHelper.instance.getCategoryList();

      //if (response.status ) {
        emit(oldState.copyWith(listings: response.result, accountType: accountType));
      /*} else {
        emit(oldState.copyWith(listings:  response.responseData?.result ?? [], accountType: accountType,isLoading: false));
      }*/
    } catch (e) {
      emit(oldState.copyWith(listings: [],isLoading: false));
    }
  }
}
