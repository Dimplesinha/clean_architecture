part of 'invite_contact_form_cubit.dart';

@immutable
sealed class InviteContactFormState extends Equatable {
  const InviteContactFormState();
}

final class InviteContactFormInitial extends InviteContactFormState {
  @override
  List<Object> get props => [];
}

final class InviteContactFormLoadedState extends InviteContactFormState {
  final List<String>? invitedEmails;
  bool? loader = false;

  InviteContactFormLoadedState({
    this.loader,
    this.invitedEmails,
  });

  @override
  List<Object?> get props => [invitedEmails, loader];

  InviteContactFormLoadedState copyWith({
    List<String>? invitedEmails,
    bool? loader = false,
  }) {
    return InviteContactFormLoadedState(
      loader: loader ?? this.loader,
      invitedEmails: invitedEmails ?? this.invitedEmails,
    );
  }
}
