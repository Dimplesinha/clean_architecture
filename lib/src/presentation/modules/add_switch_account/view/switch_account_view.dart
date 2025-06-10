import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';

class SwitchAccountView extends StatelessWidget {
  final AddSwitchAccountCubit addSwitchAccountCubit;
  final AddSwitchAccountLoadedState state;

  const SwitchAccountView({super.key, required this.addSwitchAccountCubit, required this.state});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
          child: Visibility(
            visible: state.selectedSwitchingAccount == null,
            replacement: switchAccountDialog(state: state),
            child: ListView.separated(
              itemCount: state.subAccountModelResult?.count ?? 0,
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 110),
              itemBuilder: (BuildContext context, int index) {
                SubAccountItems? userDetails = state.subAccountModelResult?.items?[index];
                return Container(
                  color: AppUtils.loginUserModel?.id == userDetails?.userId ? AppColors.tileSelectedColor : null,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: SizedBox(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: LoadProfileImage(url: userDetails?.profilePic),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userDetails?.userName ?? '',
                          style: FontTypography.textFieldsValueStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userDetails?.email ?? '',
                          style: FontTypography.defaultTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${userDetails?.accountTypeValue} ${AppConstants.account}',
                                style: FontTypography.defaultTextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Visibility(
                              visible: AppUtils.loginUserModel?.id == userDetails?.userId,
                              replacement: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  border: Border.all(color: AppColors.tabBorderColor),
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    addSwitchAccountCubit.onSwitchAccount(selectedSwitchingAccount: userDetails);
                                  },
                                  child: Text(
                                    AppConstants.switchAccount,
                                    style: FontTypography.listingTimeStyle,
                                  ),
                                ),
                              ),
                              child: Text(
                                AppConstants.activeStr,
                                style:
                                    FontTypography.insightTextBoldStyle.copyWith(color: AppColors.activeAccountColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return ReusableWidgets.createDivider();
              },
            ),
          ),
        ),
        Visibility(
          visible: state.selectedSwitchingAccount == null,
          child: Container(
            color: AppColors.whiteColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: AppButton(
                title: AppConstants.createAddAccount,
                function: () {
                  addSwitchAccountCubit.onAddAccount(addAccount: true);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget switchAccountDialog({required AddSwitchAccountLoadedState? state}) {
    SubAccountItems? userDetails = state?.selectedSwitchingAccount;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 44),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppConstants.switchAccount,
            style: FontTypography.bottomSheetHeading,
          ),
          const SizedBox(height: 16),
          Text(AppConstants.switchAccountMsg.replaceAll('{email}', userDetails?.email ?? ''),
              textAlign: TextAlign.center, style: FontTypography.listingStatTxtStyle),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CancelButton(
                  bgColor: AppColors.whiteColor,
                  title: AppConstants.cancelStr,
                  onPressed: () => addSwitchAccountCubit.onSwitchAccount(selectedSwitchingAccount: null),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(
                  title: AppConstants.switchAccount,
                  function: () {
                    /// Checking for account is Otp verified or not
                    if (userDetails?.otpVerified != true && (userDetails?.email?.isNotEmpty ?? false)) {
                      /// If not verified then calling the account verify API
                      addSwitchAccountCubit.verifyAccountOnSwitch(
                        email: userDetails?.email ?? '',
                        uuid: userDetails?.uuid ?? '',
                        isFromSwitchAccount: true,
                      );
                    } else {
                      /// If Verified
                      /// Switching to the selected Account
                      addSwitchAccountCubit.switchAccount(uuid: userDetails?.uuid ?? '');
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
