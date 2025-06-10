import 'package:workapp/src/domain/models/login_model_profile.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/my_contact_profile/repo/contact_profile_repo.dart';

part 'my_contact_profile_state.dart';

class MyContactProfileCubit extends Cubit<MyContactProfileState> {
  ContactProfileRepo contactProfileRepo;

  MyContactProfileCubit({required this.contactProfileRepo}) : super(MyContactProfileInitial());

  void init(int contactId) async {
    try {
      emit(MyContactProfileLoaded(loader: true));
      var response = await contactProfileRepo.getContactProfileDetails(contactId: contactId);
      if (response.responseData?.statusCode == 200) {
        var oldState = state as MyContactProfileLoaded;
        emit(oldState.copyWith(
          loader: false,
          contactProfileModel: response.responseData,
        ));
      } else {
        AppRouter.pop(res: true);
        AppUtils.showSnackBar(response.message ?? '', SnackBarType.success);
      }
    } catch (ex) {
      if (kDebugMode) {
        print(this);
      }
    }
  }
}
