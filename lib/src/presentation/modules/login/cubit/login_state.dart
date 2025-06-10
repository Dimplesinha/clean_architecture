part of 'login_cubit.dart';

@immutable
sealed class LoginState extends Equatable {
  const LoginState();
}

final class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

final class LoginLoadedState extends LoginState {
  final bool loading;
  final bool isChecked;
  final bool showPassword;

   const LoginLoadedState({
    this.loading = false,
    this.isChecked = false,
    this.showPassword = false,
  });

  @override
  List<Object?> get props => [
        loading,
        isChecked,
        showPassword,
      ];

  LoginLoadedState copyWith({bool? isChecked, bool? loading, bool? showPassword}) {
    return LoginLoadedState(
      isChecked: isChecked ?? this.isChecked,
      loading: loading ?? this.loading,
      showPassword: showPassword ?? this.showPassword,
    );
  }
}
