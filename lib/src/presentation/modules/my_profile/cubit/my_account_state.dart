part of 'my_account_cubit.dart';

@immutable
sealed class MyAccountState extends Equatable{}

final class MyAccountInitial extends MyAccountState {
  @override
  List<Object> get props => [];
}

final class MyAccountLoaded extends MyAccountState {
  final bool loader;
  final LoginModel? profileBasicDetailsModel;
  final Uri? file;

  MyAccountLoaded({
    this.loader = false,
    this.profileBasicDetailsModel,
    this.file,
  });

  // CopyWith method to create a new state with modified properties
  MyAccountLoaded copyWith({
    bool? loader,
    LoginModel? profileBasicDetailsModel,
    Uri? file,
  }) {
    return MyAccountLoaded(
      loader: loader ?? this.loader,
      profileBasicDetailsModel: profileBasicDetailsModel ?? this.profileBasicDetailsModel,
      file: file ?? this.file,
    );
  }

  @override
  List<Object?> get props => [
        loader,
        profileBasicDetailsModel,
        file,
      ];
}
