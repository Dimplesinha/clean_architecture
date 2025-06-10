import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/app_btn.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/review_screen/cubit/review_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 15/01/25
/// @Message : [TransferSubscription]
///
/// The `TransferSubscription`  class provides a user interface to displays a bottom to sheet to transfer Subscription to another link account
class TransferSubscription extends StatefulWidget {
  const TransferSubscription({super.key});

  @override
  State<TransferSubscription> createState() => _TransferSubscriptionState();
}

class _TransferSubscriptionState extends State<TransferSubscription> {
  ReviewCubit reviewCubit = ReviewCubit();

  @override
  void initState() {
    reviewCubit.init(listingId: 0, categoryId: 0);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      bloc: reviewCubit,
      builder: (context, state) {
        if (state is ReviewLoadedState) {
          return Container(
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
                    const SizedBox(height: 26),
                    Text( AppConstants.accountChange,
                      style: FontTypography.profileHeading
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  sizedBox20Height(),
                    Text( AppConstants.areYouSureChangePlanStr,
                      style: FontTypography.listingStatTxtStyle,textAlign: TextAlign.center,
                    ),
                    sizedBox50Height(),
                    Row(
                      children: [
                        Expanded(
                          child: CancelButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            title: AppConstants.noStr.toUpperCase(),
                            bgColor: AppColors.whiteColor,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: AppButton(
                            function: () async {
                            },
                            title: AppConstants.yesStr.toUpperCase(),
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
        return const SizedBox.shrink();
      },
    );
  }
}
