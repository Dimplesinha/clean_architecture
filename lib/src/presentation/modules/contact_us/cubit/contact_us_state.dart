import 'package:equatable/equatable.dart';
import 'package:workapp/src/domain/domain_exports.dart';

class ContactUsState extends Equatable {
  const ContactUsState();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class ContactUsInitial extends ContactUsState {}

final class ContactUsLoadedState extends ContactUsState {
  final bool loading;
  final ContactModel? data;

  @override
  List<Object?> get props => [loading, data];

  const ContactUsLoadedState({this.data, this.loading = false});

  ContactUsLoadedState copyWith({bool? loading, ContactModel? data}) {
    return ContactUsLoadedState(
      loading: loading ?? this.loading,
      data: data ?? this.data,
    );
  }
}
