part of 'my_contact_profile_cubit.dart';

@immutable
sealed class MyContactProfileState extends Equatable {}

final class MyContactProfileInitial extends MyContactProfileState {
  @override
  List<Object> get props => [];
}

final class MyContactProfileLoaded extends MyContactProfileState {
  final bool loader;
  final ContactProfileModel? contactProfileModel;
  final Uri? file;

  MyContactProfileLoaded({
    this.loader = false,
    this.contactProfileModel,
    this.file,
  });

  // CopyWith method to create a new state with modified properties
  MyContactProfileLoaded copyWith({
    bool? loader,
    ContactProfileModel? contactProfileModel,
    Uri? file,
  }) {
    return MyContactProfileLoaded(
      loader: loader ?? this.loader,
      contactProfileModel: contactProfileModel ?? this.contactProfileModel,
      file: file ?? this.file,
    );
  }

  @override
  List<Object?> get props => [
        loader,
        contactProfileModel,
        file,
      ];
}
