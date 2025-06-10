import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:workapp/src/domain/models/add_listing_form_model.dart';
import 'package:workapp/src/presentation/modules/dynamic_add_listing_form/repo/add_listing_form_dynamic_repo.dart';

part 'add_listing_form_dynamic_state.dart';

class AddListingFormDynamicCubit extends Cubit<AddListingFormDynamicState> {
  AddListingFormDynamicCubit() : super(AddListingFormDynamicInitial());
  Map<String, dynamic> formValues = {};

  /// Fetch all Categories
  Future<void> fetchFormData(int formId,{int? listingId}) async {
    emit(const AddListingFormDynamicLoadedState());
    var oldState = state as AddListingFormDynamicLoadedState;
    try {
      emit(oldState.copyWith());
      var response = await AddListingDynamicFormRepository.instance.getDynamicFormData(formId,listingId:listingId);

      if (response.status) {
        emit(oldState.copyWith(
          listings: response.responseData?.result,
        ));
      } else {
        emit(oldState.copyWith(
          listings:response.responseData?.result,
        ));
      }
    } catch (e) {
      emit(oldState.copyWith());
    }
  }


  void updateFormValue(String controlName, dynamic value) {
    var oldState = state as AddListingFormDynamicLoadedState;
    formValues[controlName] = value;
    emit(oldState.copyWith(listings: oldState.listings,formValues: formValues));
  }
}
