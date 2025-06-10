import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/new_message/cubit/new_message_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 19/09/24
/// @Message : [InviteScreen]
///
/// The `InviteScreen` class provides for displaying list of  contact
///
/// Responsibilities:
/// Gives two option phone number and email
///
class InviteScreen extends StatefulWidget {
  final NewMessageCubit newMessageCubit;
  final PageController pageController;
  final NewMessageLoadedState state;

  const InviteScreen({super.key, required this.newMessageCubit, required this.pageController, required this.state});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      AppUtils.showBottomSheetWithData(
        context,
        child: InviteBottomSheet(
          newMessageCubit: widget.newMessageCubit,
          pageController: widget.pageController,
        ),
        onCancelWithData: (action) {
          widget.newMessageCubit.selectTab(0);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: const Center(),
      ),
    );
  }
}

class InviteBottomSheet extends StatefulWidget {
  final NewMessageCubit newMessageCubit;
  final PageController pageController;

  const InviteBottomSheet({super.key, required this.newMessageCubit, required this.pageController});

  @override
  State<InviteBottomSheet> createState() => _InviteBottomSheetState();
}

class _InviteBottomSheetState extends State<InviteBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewMessageCubit, NewMessageState>(
      bloc: widget.newMessageCubit,
      builder: (context, state) {
        if (state is NewMessageLoadedState) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 23, 20, 20),
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
                    sizedBox20Height(),
                    Text(
                      AppConstants.inviteByStr,
                      style: FontTypography.profileHeading.copyWith(fontWeight: FontWeight.w700),
                    ),
                    sizedBox20Height(),
                    LabelText(
                      title: AppConstants.inviteByStr,
                      isRequired: false,
                      textStyle: FontTypography.socialBtnStyle.copyWith(color: AppColors.blackColor),
                    ),
                    Row(
                      children: [
                        _buildRadio(AppConstants.emailStr, state),
                        const SizedBox(width: 26),
                        //_buildRadio(AppConstants.phoneNumberStr, state),
                      ],
                    ),
                    sizedBox40Height(),
                    Row(
                      children: [
                        Expanded(
                          child: CancelButton(
                            onPressed: () {
                              AppRouter.pop();
                            },
                            title: AppConstants.cancelStr,
                            bgColor: AppColors.whiteColor,
                          ),
                        ),
                        sizedBox20Width(),
                        Expanded(
                          child: AppButton(
                            function: () {
                              AppRouter.push(AppRoutes.inviteContactFormView)?.then((value) {
                                AppRouter.pop(res: value);
                              });
                            },
                            title: AppConstants.inviteStr,
                          ),
                        ),
                      ],
                    ),
                    sizedBox30Height(),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildRadio(String title, NewMessageLoadedState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      child: InkWell(
        onTap: () {
          widget.newMessageCubit.changeInviteBy(title);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16.0,
              width: 16.0,
              child: Radio<String>(
                toggleable: true,
                value: title,
                groupValue: state.inviteBy,
                onChanged: (value) {
                  widget.newMessageCubit.changeInviteBy(value);
                },
                activeColor: AppColors.primaryColor,
              ),
            ),
            sizedBox5Width(),
            Text(title, style: FontTypography.defaultTextStyle),
          ],
        ),
      ),
    );
  }
}
