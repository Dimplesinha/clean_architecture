part of 'forgot_password_cubit.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
}

final class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();

  @override
  List<Object?> get props => [];
}

final class ForgotPasswordLoadedState extends ForgotPasswordState {
  final bool isLoading;
  final String timerDisplay;
  final String otpCode;

  const ForgotPasswordLoadedState({
    this.isLoading = false,
    this.timerDisplay = '00:60', //Timer for otp resend
    this.otpCode = '',
  });

  @override
  List<Object?> get props => [
        isLoading,
        timerDisplay,
        otpCode,
      ];

  ForgotPasswordLoadedState copyWith({
    bool? isLoading,
    String? timerDisplay,
    String? otpCode,
  }) {
    return ForgotPasswordLoadedState(
      isLoading: isLoading ?? this.isLoading,
      timerDisplay: timerDisplay ?? this.timerDisplay,
      otpCode: otpCode ?? this.otpCode,
    );
  }
}
