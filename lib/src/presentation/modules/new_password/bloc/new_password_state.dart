part of 'new_password_cubit.dart';

@immutable
sealed class NewPasswordState extends Equatable {}

final class NewPasswordInitial extends NewPasswordState {
  @override
  List<Object?> get props => [];
}

final class NewPasswordLoadedState extends NewPasswordState {
  final bool loading;
  late final bool showPassword;
  late final bool showConfirmPassword;

  NewPasswordLoadedState({this.loading = false, this.showConfirmPassword = false, this.showPassword = false});

  @override
  List<Object?> get props => [
        loading,
        showConfirmPassword,
        showPassword,
      ];

  NewPasswordLoadedState copyWith({bool? loading, bool? showPassword, bool? showConfirmPassword}) {
    return NewPasswordLoadedState(
        loading: loading ?? this.loading,
        showPassword: showPassword ?? this.showPassword,
        showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword);
  }
}
