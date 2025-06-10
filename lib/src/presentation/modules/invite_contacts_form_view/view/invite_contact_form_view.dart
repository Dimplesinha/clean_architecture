import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/invite_contacts_form_view/cubit/invite_contact_form_cubit.dart';
import 'package:workapp/src/presentation/modules/invite_contacts_form_view/repo/invite_contacts_form_repo.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 26/03/25
/// @Message : [InviteContactFormView]
///
/// The `InviteContactFormView` class provides user interface to select workapp contact tab
/// workapp group tab, and invite
///

class InviteContactFormView extends StatefulWidget {
  const InviteContactFormView({super.key});

  @override
  State<InviteContactFormView> createState() => _InviteContactFormViewState();
}

class _InviteContactFormViewState extends State<InviteContactFormView> with SingleTickerProviderStateMixin {
  InviteContactFormCubit inviteContactFormCubit =
      InviteContactFormCubit(inviteContactFormRepository: InviteContactFormRepository.instance);
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inviteContactFormCubit.init();
  }

  Future<void> addEmail() async {
    var email = emailController.text.trim();
    if (email.isEmpty) {
      AppUtils.showSnackBar(AppConstants.emptyEmailStr, SnackBarType.alert);
    } else if (!email.isValidEmail()) {
      AppUtils.showSnackBar(AppConstants.emailValidationStr, SnackBarType.alert);
    } else if (inviteContactFormCubit.invitedEmails.contains(email)) {
      // Check if email already exists
      AppUtils.showSnackBar(AppConstants.valMsgEmailExist, SnackBarType.alert);
    } else {
      var checkEmail = await inviteContactFormCubit.checkEmailValidation(email);
      if (checkEmail) {
        setState(() {
          inviteContactFormCubit.addEmail(email);
          emailController.text = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InviteContactFormCubit, InviteContactFormState>(
      bloc: inviteContactFormCubit,
      builder: (context, state) {
        if (state is InviteContactFormLoadedState) {
          return Stack(
            children: [
              Container(
                color: AppColors.primaryColor,
                child: SafeArea(
                  bottom: false,
                  child: Scaffold(
                    backgroundColor: AppColors.whiteColor,
                    appBar: AppBar(
                      backgroundColor: AppColors.whiteColor,
                      surfaceTintColor: AppColors.whiteColor,
                      elevation: 2,
                      centerTitle: true,
                      title: Text(
                        AppConstants.inviteContacts,
                        style: FontTypography.appBarStyle,
                      ),
                      actions: [
                        InkWell(
                          onTap: () {
                            if (inviteContactFormCubit.invitedEmails.isEmpty) {
                              AppUtils.showSnackBar(
                                AppConstants.valEmailRequired,
                                SnackBarType.alert,
                              );
                              return;
                            }
                            inviteContactFormCubit.inviteContacts();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              AppConstants.submitSmallStr,
                              style: FontTypography.subTextBoldStyle,
                            ),
                          ),
                        )
                      ],
                    ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sizedBox15Height(),
                          Center(
                            child: Text(
                              AppConstants.inviteByEmailContact,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FontTypography.subTextBoldStyle.copyWith(fontSize: 20),
                            ),
                          ),
                          sizedBox30Height(),
                          const Text(
                            AppConstants.emailAddress,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          sizedBox10Height(),
                          AppTextField(
                            height: 39,
                            maxLines: 1,
                            hintTxt: AppConstants.emailAddress,
                            hintStyle: FontTypography.textFieldBlackStyle.copyWith(fontSize: 14.0),
                            textCapitalization: TextCapitalization.none,
                            suffixIconConstraints: const BoxConstraints(
                              minHeight: 25,
                              maxHeight: 39,
                              minWidth: 40,
                              maxWidth: 40,
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    emailController.text = '';
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    height: 39,
                                    child: ReusableWidgets.createSvg(
                                      width: 15,
                                      height: 15,
                                      path: AssetPath.inviteCrossIcon,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            controller: emailController,
                            textInputAction: TextInputAction.search,
                            keyboardType: TextInputType.text,
                            fillColor: AppColors.locationButtonBackgroundColor,
                          ),
                          sizedBox10Height(),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                addEmail();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5), // Apply border radius
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max, // Important to wrap content
                                children: <Widget>[
                                  Text(
                                    AppConstants.inviteContact,
                                    style: FontTypography.subTextBoldStyle.copyWith(color: AppColors.whiteColor),
                                  ),
                                  const SizedBox(width: 5), // Add some spacing between text and icon
                                  ReusableWidgets.createSvg(
                                    color: AppColors.whiteColor,
                                    width: 15,
                                    height: 15,
                                    path: AssetPath.addIcon,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          sizedBox40Height(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: inviteContactFormCubit.invitedEmails.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.extraLightGreyColor, width: 0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                                  constraints: const BoxConstraints(maxHeight: 35.0), // Add maxHeight constraint
                                  child: ListTile(
                                    minTileHeight: 30,
                                    title: Text(inviteContactFormCubit.invitedEmails[index]),
                                    trailing: InkWell(
                                      onTap: () {
                                        setState(() {
                                          inviteContactFormCubit.removeEmail(index);
                                        });
                                      },
                                      child: ReusableWidgets.createSvg(
                                        color: AppColors.blackColor,
                                        width: 15,
                                        height: 15,
                                        path: AssetPath.deleteIcon,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              state.loader! ? const LoaderView() : const SizedBox.shrink()
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
