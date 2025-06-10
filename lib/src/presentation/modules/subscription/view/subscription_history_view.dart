import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/modules/subscription/cubit/subscription_cubit.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 12-09-2024
/// @Message : [SubscriptionHistoryView]
///

///This `SubscriptionHistoryView` view is for displaying history list of subscription with its plan type, plan price
///and plan date
/// Typically we can view this from subscription screen when clicking on history icon from app bar.
class SubscriptionHistoryView extends StatefulWidget {
  const SubscriptionHistoryView({super.key});

  @override
  State<SubscriptionHistoryView> createState() => _SubscriptionHistoryViewState();
}

class _SubscriptionHistoryViewState extends State<SubscriptionHistoryView> {
  SubscriptionCubit subscriptionCubit = SubscriptionCubit();
  final scrollController = ScrollController();

  ///init state for cubit init call and calling methods when UI loading
  @override
  void initState() {
    subscriptionCubit.initialise();
    subscriptionCubit.fetchHistoryItems();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
            subscriptionCubit.hasNextPage) {
          subscriptionCubit.fetchHistoryItems();
        }
      }
    });
    super.initState();
  }

  ///Build method with cubit call and state management with layout builder for mobile view and tab view
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        bloc: subscriptionCubit,
        builder: (context, state) {
          if (state is SubscriptionLoadedState) {
            return SafeArea(
              bottom: false,
              child: Scaffold(
                appBar: MyAppBar(
                  title: AppConstants.historyStr,
                  centerTitle: true,
                  backBtn: true,
                  automaticallyImplyLeading: false,
                  shadowColor: AppColors.dropShadowColor.withValues(alpha: 0.5),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  child: state.loader ? const LoaderView() : _historyListView(state),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  ///History List view for displaying history of subscription and its details.
  Widget _historyListView(SubscriptionLoadedState state) {
    if (state.mySubscriptionHistoryData == null || state.mySubscriptionHistoryData!.isEmpty) {
      return Center(
        child: Text(
          AppConstants.noHistoryStr,
          style: FontTypography.defaultTextStyle,
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: () async {
        subscriptionCubit.currentPage = 1;
        await subscriptionCubit.fetchHistoryItems(isRefresh: true);
      },
      child: ListView.builder(
        controller: scrollController,
        itemCount: state.mySubscriptionHistoryData?.length,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var item = state.mySubscriptionHistoryData?[index];
          return Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
                color: AppColors.locationButtonBackgroundColor,
                borderRadius: BorderRadius.circular(constEnquiryContactRadius)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableWidgets.createCircularShadowBox(
                  iconPath: AssetPath.silverCrownIcon,
                  boxSize: 46,
                  elevation: 2,
                ),
                sizedBox10Width(),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item?.planName ?? '',
                              maxLines: 1,
                              style: FontTypography.enquiryNameTxtStyle.copyWith(fontSize: 14),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '${item?.currencySymbol ?? ''} ${item?.price ?? ''} /${item?.durationTypeName ?? ''}',
                              style: FontTypography.planTxtStyle.copyWith(fontSize: 14.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      sizedBox8Height(),
                      Text(
                        AppUtils.currentDateTime(item?.purchaseDate ?? ''),
                        style: FontTypography.dateTimeTxtStyle
                            .copyWith(fontSize: 12)
                            .copyWith(overflow: TextOverflow.ellipsis),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
