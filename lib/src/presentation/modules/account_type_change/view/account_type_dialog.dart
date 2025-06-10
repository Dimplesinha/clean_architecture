
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/account_type_change/account_type_repo/account_type_repo.dart';
import 'package:workapp/src/presentation/modules/account_type_change/cubit/account_type_change_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';

class AccountTypeBottomSheet extends StatefulWidget {
  final VoidCallback onOkPressed;
  final String? accountType;
  final bool isFromMyProfile;

  const AccountTypeBottomSheet({
    Key? key,
    required this.onOkPressed,
    this.accountType,
    this.isFromMyProfile = false,
  }) : super(key: key);

  @override
  State<AccountTypeBottomSheet> createState() => _AccountTypeBottomSheetState();
}

class _AccountTypeBottomSheetState extends State<AccountTypeBottomSheet> {
  AccountTypeChangeCubit accountTypeChangeCubit =
      AccountTypeChangeCubit(accountTypeRepo: AccountTypeRepo.instance);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountTypeChangeCubit, AccountTypeChangeLoadedState>(
      bloc: accountTypeChangeCubit,
      builder: (context, state) {
        return Stack(
          children: [
            PopScope(
              canPop: false,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 7,
                          width: 59,
                          decoration: BoxDecoration(
                            color: AppColors.bottomSheetBarColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          AppConstants.selectAccountType,
                          style: FontTypography.profileHeading
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        sizedBox20Height(),
                        ReusableWidgets.accountType(context, state,
                            accountTypeChangeCubit, widget.accountType),
                        sizedBox30Height(),
                        AppButton(
                          function: () async {
                            if (widget.isFromMyProfile) {
                              if (DropDownConstants
                                      .accountType[widget.accountType] !=
                                  state.accountType) {
                                // Fetch active listing count before showing the dialog
                                await accountTypeChangeCubit.activeListingCount(
                                    context,
                                    accountType: state.accountType ?? 0,
                                    accountTypeChangeCubit:
                                        accountTypeChangeCubit);
                              }
                            } else {
                              // For cases where it's not from MyProfile
                              await accountTypeChangeCubit.onSelectAccountType(
                                context,
                                accountType: state.accountType ?? 0,
                              );
                            }
                          },
                          title: AppConstants.applyStr,
                        ),
                        sizedBox30Height(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (state.isLoading)
              const Positioned.fill(
                child: Center(
                  child: LoaderView(), // Ensure LoaderView is centered
                ),
              ),
          ],
        );
      },
    );
  }
}
