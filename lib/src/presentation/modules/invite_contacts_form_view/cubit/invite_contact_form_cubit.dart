import 'package:workapp/src/domain/models/invite_email_request_model.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/invite_contacts_form_view/repo/invite_contacts_form_repo.dart';

part 'invite_contact_form_state.dart';

class InviteContactFormCubit extends Cubit<InviteContactFormState> {
  final InviteContactFormRepository? inviteContactFormRepository;

  InviteContactFormCubit({this.inviteContactFormRepository}) : super(InviteContactFormInitial());
  List<String> invitedEmails = [];

  void init() async {
    emit(InviteContactFormLoadedState(
      loader: false,
      invitedEmails: []
    ));
  }

  void addEmail(String email) {
    var oldState = state as InviteContactFormLoadedState;
    invitedEmails.add(email);
    emit(oldState.copyWith(invitedEmails: invitedEmails, loader: false));
  }

  void removeEmail(int index) {
    var oldState = state as InviteContactFormLoadedState;
    invitedEmails.removeAt(index);
    emit(oldState.copyWith(invitedEmails: invitedEmails, loader: false));
  }

  ///Used when clicking on resend button on forgot password view
  Future<bool> checkEmailValidation(String email) async {
    var oldState = state as InviteContactFormLoadedState;
    try {
      emit(oldState.copyWith(loader: true));
     var emailRequest = EmailRequest(email: email);
      final Map<String, dynamic> requestBody = emailRequest.toJson();
      var response = await InviteContactFormRepository.instance.checkEmailValidation(requestBody: requestBody);
      if (response.status) {
        emit(oldState.copyWith(loader: false));
        AppUtils.showSnackBar(response.message, SnackBarType.success);
        return true;
      } else {
        emit(oldState.copyWith(loader: false));
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
        return false;
      }
    } catch (e) {
      emit(oldState.copyWith(loader: false));
      return false;
    }
  }

  ///Used when clicking on resend button on forgot password view
  Future<void> inviteContacts() async {
    var oldState = state as InviteContactFormLoadedState;
    try {
      emit(oldState.copyWith(loader: true));

      List<EmailRequest> emails = [];
      for (var email in invitedEmails) {
        emails.add(EmailRequest(email: email));
      }

      final List<Map<String, dynamic>> requestBody = emails.map((e) => e.toJson()).toList();
      var response = await InviteContactFormRepository.instance.inviteContacts(requestBody: requestBody);
      if (response.status) {
        emit(oldState.copyWith(loader: false));
        AppRouter.pop(res: AppConstants.emailSubmitDone);
        AppRouter.pop(res: AppConstants.emailSubmitDone);
        AppUtils.showSnackBar(response.message, SnackBarType.success);
      } else {
        emit(oldState.copyWith(loader: false));
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
      }
    } catch (e) {
      emit(oldState.copyWith(loader: false));
    }
  }
}
