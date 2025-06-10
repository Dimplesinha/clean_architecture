part of 'app_mobile_text_field_cubit.dart';

sealed class AppMobileTextFieldState extends Equatable {
  const AppMobileTextFieldState();
}

final class AppMobileTextFieldInitial extends AppMobileTextFieldState {
  @override
  List<Object?> get props => [];
}

final class AppMobileTextFiledLoadedState extends AppMobileTextFieldState {
  final List<Countries>? countryListing;
  String? selectedFlag;
  String? mobileNumber;
  String? countryPhoneCode;
  String? countryCode;
  int? maxLength;

  AppMobileTextFiledLoadedState({
    this.countryListing,
    this.countryPhoneCode,
    this.mobileNumber,
    this.selectedFlag,
    this.countryCode,
    this.maxLength,
  });

  @override
  List<Object?> get props => [
        countryListing,
        selectedFlag,
        countryPhoneCode,
        mobileNumber,
        countryCode,
        maxLength,
      ];

  AppMobileTextFiledLoadedState copyWith({
    List<Countries>? countryListing,
    String? selectedFlag,
    String? mobileNumber,
    String? countryPhoneCode,
    String? countryCode,
    int? maxLength,
  }) {
    return AppMobileTextFiledLoadedState(
      countryListing: countryListing ?? this.countryListing,
      selectedFlag: selectedFlag ?? this.selectedFlag,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      countryPhoneCode: countryPhoneCode ?? this.countryPhoneCode,
      countryCode: countryCode ?? this.countryCode,
      maxLength: maxLength ?? this.maxLength,
    );
  }
}
