part of 'otp_verify_cubit.dart';

class OtpVerifyLoadedState extends Equatable {
  final bool isLoading;
  final String timerDisplay;
  final String otpCode;

  const OtpVerifyLoadedState({
    this.isLoading = false,
    this.timerDisplay = '00:60',
    this.otpCode = '',
  });

  @override
  List<Object?> get props => [
        isLoading,
        timerDisplay,
        otpCode,
      ];

  OtpVerifyLoadedState copyWith({
    bool? isLoading,
    String? timerDisplay,
    String? otpCode,
  }) {
    return OtpVerifyLoadedState(
      isLoading: isLoading ?? this.isLoading,
      timerDisplay: timerDisplay ?? this.timerDisplay,
      otpCode: otpCode ?? this.otpCode,
    );
  }
}
