import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/otp_verify_screen/view/otp_verify_view.dart';

class AddAccountView extends StatelessWidget {
  final AddSwitchAccountCubit addSwitchAccountCubit;
  final AddSwitchAccountLoadedState state;

  const AddAccountView({
    super.key,
    required this.addSwitchAccountCubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddSwitchAccountCubit, AddSwitchAccountLoadedState>(
      bloc: addSwitchAccountCubit,
      listener: (context, state) {
        if (state.addSwitchAccountResult != null) {

          AppRouter.pushReplacement(
            AppRoutes.otpVerify,
            args: OtpVerifyScreen(email: state.email ?? '', userUUID: state.addSwitchAccountResult?.result ?? ''),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppConstants.createAddAccount, style: FontTypography.bottomSheetHeading),
              LabelText(title: AppConstants.accountType, textStyle: FontTypography.subTextStyle),
              AccountTypeWidget(state: state, addSwitchAccountCubit: addSwitchAccountCubit),
              LabelText(title: AppConstants.newEmailStr, textStyle: FontTypography.subTextStyle),
              AppTextField(
                hintTxt: AppConstants.newEmailStr,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                onChanged: (value) {
                  addSwitchAccountCubit.onEmailChange(email: value);
                },
              ),
              LabelText(title: AppConstants.emailPasswordStr, textStyle: FontTypography.subTextStyle),
              AppTextField(
                hintTxt: AppConstants.emailPasswordStr,
                obscureText: !state.showPassword,
                maxLines: 1,
                onChanged: (value) {
                  addSwitchAccountCubit.onPasswordChange(password: value);
                },
                suffixIcon: InkWell(
                  onTap: () {
                    addSwitchAccountCubit.onChangePasswordVisibility();
                  },
                  child: Icon(
                    state.showPassword ? Icons.visibility : Icons.visibility_off,
                    size: 18.0,
                  ),
                ),
              ),
              LabelText(title: AppConstants.confirmNewPasswordStr, textStyle: FontTypography.subTextStyle),
              AppTextField(
                hintTxt: AppConstants.confirmNewPasswordStr,
                obscureText: !state.showConfirmPassword,
                maxLines: 1,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  addSwitchAccountCubit.onConfirmPasswordChange(confirmPassword: value);
                },
                suffixIcon: InkWell(
                  onTap: () {
                    addSwitchAccountCubit.onChangeNewPasswordVisibility();
                  },
                  child: Icon(
                    state.showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    size: 18.0,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: CancelButton(
                      title: AppConstants.cancelStr,
                      bgColor: AppColors.whiteColor,
                      onPressed: () => navigatorKey.currentState?.pop(),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: AppButton(
                      title: AppConstants.createAccount,
                      function: () => addSwitchAccountCubit.onCreateAccount(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
