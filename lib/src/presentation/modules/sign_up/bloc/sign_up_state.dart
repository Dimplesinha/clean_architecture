part of 'sign_up_cubit.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();
}

final class SignUpInitial extends SignUpState {
  @override
  List<Object?> get props => [];
}

final class SignUpLoadedState extends SignUpState {
  final bool loading;
  late final bool showPassword;
  late final bool showConfirmPassword;
  final bool isFromGoogleAuth;
  final bool isTNCChecked;
  final int? accountType;
  String? selectedFlag;
  String? countryPhoneCode;
  final List<Countries>? countryListing;

  SignUpLoadedState({
    this.showPassword = false,
    this.loading = false,
    this.showConfirmPassword = false,
    this.isFromGoogleAuth = false,
    this.isTNCChecked = false,
    this.accountType,
    this.countryListing,
    this.selectedFlag,
    this.countryPhoneCode,
  });

  @override
  List<Object?> get props => [
        loading,
        showPassword,
        showConfirmPassword,
        isFromGoogleAuth,
        isTNCChecked,
        accountType,
        countryListing,
        selectedFlag,
        countryPhoneCode,
      ];

  SignUpLoadedState copyWith({
    bool? loading,
    bool? showPassword,
    bool? showConfirmPassword,
    bool? isFromGoogleAuth,
    bool? isTNCChecked,
    int? accountType,
    String? selectedFlag,
    String? countryPhoneCode,
    List<Countries>? countryListing,
  }) {
    return SignUpLoadedState(
      loading: loading ?? this.loading,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      isFromGoogleAuth: isFromGoogleAuth ?? this.isFromGoogleAuth,
      isTNCChecked: isTNCChecked ?? this.isTNCChecked,
      accountType: accountType ?? this.accountType,
      countryListing: countryListing ?? this.countryListing,
      selectedFlag: selectedFlag ?? this.selectedFlag,
      countryPhoneCode: countryPhoneCode ?? this.countryPhoneCode,
    );
  }
}
