part of 'add_listing_form_dynamic_cubit.dart';

@immutable
sealed class AddListingFormDynamicState extends Equatable {
  const AddListingFormDynamicState();
}

final class AddListingFormDynamicInitial extends AddListingFormDynamicState {
  @override
  List<Object> get props => [];
}

final class AddListingFormDynamicLoadedState extends AddListingFormDynamicState {
  final DynamicFormData? listings;
  final String? accountType;
  final bool isUpdatingInitialData;
  final Map<String, dynamic>? formValues;

  const AddListingFormDynamicLoadedState({this.listings, this.accountType, this.isUpdatingInitialData = false,this.formValues});

  @override
  List<Object?> get props => [listings, accountType, isUpdatingInitialData,formValues];

  AddListingFormDynamicLoadedState copyWith({
   DynamicFormData? listings,
    String? accountType,
    bool? isUpdatingInitialData,
    Map<String, dynamic>? formValues,
  }) {
    return AddListingFormDynamicLoadedState(
      listings: listings ?? this.listings,
      accountType: accountType ?? this.accountType,
      isUpdatingInitialData: isUpdatingInitialData ?? this.isUpdatingInitialData,
        formValues:formValues??this.formValues
    );
  }
}
