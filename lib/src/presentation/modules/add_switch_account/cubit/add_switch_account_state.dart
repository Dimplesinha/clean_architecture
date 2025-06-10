part of 'add_switch_account_cubit.dart';

final class AddSwitchAccountLoadedState extends Equatable {
  final bool isLoading;
  final bool? isInitialLoading;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final int? accountType;
  final SubAccountModelResult? subAccountModelResult;
  final bool? addAccount;
  final AddSubAccountModel? addSwitchAccountResult;
  SubAccountItems? selectedSwitchingAccount;
  bool showPassword;
  bool showConfirmPassword;

  AddSwitchAccountLoadedState({
    this.isLoading = false,
    this.isInitialLoading,
    this.email,
    this.password,
    this.confirmPassword,
    this.accountType = 1,
    this.subAccountModelResult,
    this.addAccount = false,
    this.addSwitchAccountResult,
    this.selectedSwitchingAccount,
    this.showPassword = false,
    this.showConfirmPassword = false,
  });

  @override
  List<Object?> get props => [
        isLoading,
        isInitialLoading,
        email,
        password,
        confirmPassword,
        accountType,
        subAccountModelResult,
        addAccount,
        addSwitchAccountResult,
        selectedSwitchingAccount,
        identityHashCode(this),
        showPassword,
        showConfirmPassword,
      ];

  AddSwitchAccountLoadedState copyWith({
    bool? isLoading,
    bool? isInitialLoading,
    String? email,
    String? password,
    String? confirmPassword,
    int? accountType,
    SubAccountModelResult? subAccountModelResult,
    bool? addAccount,
    AddSubAccountModel? addSwitchAccountResult,
    SubAccountItems? selectedSwitchingAccount,
    bool? showPassword,
    bool? showConfirmPassword,
  }) {
    return AddSwitchAccountLoadedState(
      isLoading: isLoading ?? this.isLoading,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      accountType: accountType ?? this.accountType,
      subAccountModelResult: subAccountModelResult ?? this.subAccountModelResult,
      addAccount: addAccount ?? this.addAccount,
      addSwitchAccountResult: addSwitchAccountResult ?? this.addSwitchAccountResult,
      selectedSwitchingAccount: selectedSwitchingAccount ?? this.selectedSwitchingAccount,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
    );
  }
}
