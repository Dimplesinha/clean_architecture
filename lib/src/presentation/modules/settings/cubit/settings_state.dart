import 'package:equatable/equatable.dart';
import 'package:workapp/src/domain/domain_exports.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
}

final class SettingsInitial extends SettingsState {
  @override
  List<Object?> get props => [];
}

final class SettingsLoadedState extends SettingsState {
  bool loading = false;
  bool? isFromGoogleAuth = false;
  LoginResponse? loginResponse;

  SettingsLoadedState({this.loading = false, this.isFromGoogleAuth, this.loginResponse});

  SettingsLoadedState copyWith({bool loading = false, bool? isFromGoogleAuth = false, LoginResponse? loginResponse}) {
    return SettingsLoadedState(loading: loading, isFromGoogleAuth: isFromGoogleAuth, loginResponse: loginResponse);
  }

  @override
  List<Object?> get props => [loading, isFromGoogleAuth, loginResponse];
}
