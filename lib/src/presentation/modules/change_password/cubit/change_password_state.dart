part of 'change_password_cubit.dart';

@immutable
sealed class ChangePasswordState extends Equatable {
  const ChangePasswordState();
}

final class ChangePasswordInitial extends ChangePasswordState {
  @override
  List<Object?> get props => [];
}

final class ChangePasswordLoadedState extends ChangePasswordState {
  final bool loading;
  final bool showCurrentPassword;
  final bool showNewPassword;
  final bool showConfirmPassword;
  final bool isPasswordAvailable;
  final TextEditingController currentPassTxtController = TextEditingController();
  final TextEditingController newPassTxtController = TextEditingController();
  final TextEditingController confirmNewPassTxtController = TextEditingController();
  final FocusNode currentPasswordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  ChangePasswordLoadedState({
    this.loading = false,
    this.showCurrentPassword = false,
    this.showNewPassword = false,
    this.showConfirmPassword = false,
    this.isPasswordAvailable = false,
  });

  @override
  List<Object?> get props => [
        loading,
        showCurrentPassword,
        showNewPassword,
        showConfirmPassword,
        isPasswordAvailable,
        currentPassTxtController,
        newPassTxtController,
        confirmNewPassTxtController
      ];

  ChangePasswordLoadedState copyWith({
    bool? loading,
    bool? showCurrentPassword,
    bool? showNewPassword,
    bool? showConfirmPassword,
    bool? isPasswordAvailable,
    TextEditingController? currentPassTxtController,
  }) {
    return ChangePasswordLoadedState(
      loading: loading ?? this.loading,
      showCurrentPassword: showCurrentPassword ?? this.showCurrentPassword,
      showNewPassword: showNewPassword ?? this.showNewPassword,
      isPasswordAvailable: isPasswordAvailable ?? this.isPasswordAvailable,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
    );
  }
}
