import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/models/no_subscription_account_model.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/subscription/cubit/subscription_cubit.dart';
import 'package:workapp/src/presentation/modules/subscription/view/promo_code_apply_screen.dart';
import 'package:workapp/src/utils/date_time_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 12-09-2024
/// @Message : [SubscriptionListView]

///This `SubscriptionListView` view is for display 2 plan types 1 is personal plan and other one is work app platinum
///plan, it displays details of plans, its pricing.
///Typically it has option for subscription type which can be renewed later
/// The renew button only enables when the plan is expired.
///
/// Responsibilities:
/// - Displays 2 plan type and type for business plan and pro plan.
/// - One button for renewing subscription when plan is expired.

class SubscriptionListView extends StatefulWidget {
  const SubscriptionListView({super.key});

  @override
  State<SubscriptionListView> createState() => _SubscriptionListViewState();
}

class _SubscriptionListViewState extends State<SubscriptionListView> {
  SubscriptionCubit subscriptionCubit = SubscriptionCubit();
  int? countryId;
  int? subscriptionPlanId;
  final scrollController = ScrollController();

  @override
  void initState() {
    subscriptionCubit.init();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
            subscriptionCubit.hasNextPage) {
          subscriptionCubit.fetchSubscriptionPlan();
        }
      }
    });
    super.initState();
  }

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
              child: Stack(
                children: [
                  Scaffold(
                    appBar: MyAppBar(
                      title: AppConstants.subscriptionStr,
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      shadowColor: AppColors.borderColor,
                      actionList: [
                        InkWell(
                          onTap: () => AppRouter.push(AppRoutes.subscriptionHistory),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: SvgPicture.asset(AssetPath.historyIcon),
                            ),
                          ),
                        )
                      ],
                    ),
                    body: RefreshIndicator(
                        color: AppColors.primaryColor,
                        onRefresh: () async {
                          subscriptionCubit.currentPage = 1;
                          subscriptionCubit.fetchSubscriptionPlan(isRefresh: true);
                          subscriptionCubit.fetchTransferSubscriptionAvailable();
                        },
                        child: SingleChildScrollView(controller: scrollController, child: _mobileView(state))),
                  ),
                  state.loader == true ? const LoaderView() : const SizedBox.shrink()
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _mobileView(SubscriptionLoadedState state) {
    return Column(
      children: [
        Visibility(
          visible: state.mySubscriptionData != null &&
              state.mySubscriptionData?.isTransferable == true &&
              (state.noSubscriptionAccountData?.isNotEmpty ?? false),
          child: _planTitle(state),
        ),
        sizedBox10Height(),
        ListView.builder(
          itemCount: state.subscriptionData?.length ?? 0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var item = state.subscriptionData?[index];
            int? maxListingCount = item?.listingLimit ?? 0;
            int? boostListingLimit = item?.boostLimit ?? 0;
            int? transferableLimit = item?.transferLimit ?? 0;
            bool? isTransferable = item?.isTransferable ?? false;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                decoration: BoxDecoration(
                  color: item?.subscriptionStatus == AppConstants.activeStatus
                      ? AppColors.primaryColor.withValues(alpha: 0.07)
                      : AppColors.listingCardsBgColor,
                  borderRadius: BorderRadius.circular(8.0),
                  border: item?.subscriptionStatus == AppConstants.activeStatus
                      ? Border(
                          bottom: BorderSide(color: AppColors.primaryColor, width: 2.0),
                          left: BorderSide(color: AppColors.primaryColor, width: 2.0),
                          right: BorderSide(color: AppColors.primaryColor, width: 2.0),
                          top: BorderSide(color: AppColors.primaryColor, width: 2.0),
                        )
                      : const Border(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25.0,
                                backgroundColor: AppColors.whiteColor,
                                child: SizedBox(
                                    width: 25.0, height: 25.0, child: SvgPicture.asset(AssetPath.silverCrownIcon)),
                              ),
                              sizedBox10Width(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item?.title ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: FontTypography.enquiryNameTxtStyle.copyWith(fontSize: 14),
                                    ),
                                    Visibility(
                                      visible: item?.subscriptionStatus == AppConstants.activeStatus,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          '${AppConstants.expiringOn} ${DateTimeUtils.subscriptionDate(item?.endDate ?? '')}',
                                          style: FontTypography.enquiryCityTxtStyle.copyWith(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    sizedBox10Height(),
                    Text(
                        '${maxListingCount > 0 ? '\u2022 ${AppConstants.listingLimitTextStr.replaceAll('{maxListingLimit}', maxListingCount.toString())}\n' : ''}'
                        '${maxListingCount == 0 ? '\u2022 ${AppConstants.unlimitedLimitTextStr.replaceAll('{maxListingLimit}', maxListingCount.toString())}\n' : ''}'
                        '${boostListingLimit > 0 ? '\u2022 ${AppConstants.boostingLimitTextStr.replaceAll('{maxBoostingLimit}', boostListingLimit.toString())}\n' : ''}'
                        '${boostListingLimit == 0 ? '\u2022 ${AppConstants.unlimitedBoostingLimitTextStr.replaceAll('{maxBoostingLimit}', boostListingLimit.toString())}\n' : ''}'
                        '${(isTransferable && transferableLimit > 0) ? '\u2022 ${AppConstants.transferPlanLimitTextStr.replaceAll('{maxTransferPlanLimit}', transferableLimit.toString())}' : ''}'
                        '${(isTransferable && transferableLimit == 0) ? '\u2022 ${AppConstants.unlimitedTransferPlanLimitTextStr}' : ''}',
                        style: FontTypography.listingStatTxtStyle.copyWith(fontSize: 12)),
                    sizedBox10Height(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '${item?.currencySymbol ?? ''} ${item?.price} /${(item?.duration ?? 0) == 1 ? '' : item?.duration ?? ''} ${item?.durationTypeName}${(item?.duration ?? 0) > 1 ? 's' : ''}',
                            maxLines: 1,
                            style: FontTypography.snackBarTitleStyle
                                .copyWith(fontSize: 16)
                                .copyWith(color: AppColors.primaryColor),
                          ),
                        ),
                        Visibility(
                          visible: (item?.subscriptionStatus == AppConstants.inActiveStatus ||
                              item?.subscriptionStatus == AppConstants.expiredStatus),
                          replacement: Visibility(
                            visible: (item?.subscriptionStatus == AppConstants.activeStatus &&
                                item?.isCanceled == false &&
                                item?.purchaseToken != null),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () async {
                                  subscriptionCubit.cancelSubscription(context, item?.subscriptionId ?? 0);
                                },
                                child: SizedBox(
                                  width: 160,
                                  height: 30,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.deleteColor,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        AppConstants.cancelSubscription,
                                        style: FontTypography.cancelSubscriptionButtonText,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () async {
                                countryId = item?.countryId;
                                subscriptionPlanId = item?.subscriptionId;
                                bool? isActivePlan = state.subscriptionData
                                    ?.any((item) => item.subscriptionStatus == AppConstants.activeStatus);
                                bool upgradeSuccess = await subscriptionCubit.isUpgradable(context, item?.price);
                                if (isActivePlan == true) {
                                  if (upgradeSuccess) {
                                    ReusableWidgets.showConfirmationDialog(
                                      AppConstants.pleasConfirm,
                                      AppConstants.alertUpgradeSubscription,
                                      () async {
                                        AppRouter.pop(); // close the dialog

                                        await AppRouter.push(
                                          AppRoutes.promoCodeApplyScreen,
                                          args: PromoCodeScreen(
                                            subscriptionId: item?.subscriptionId ?? 0,
                                            price: item?.price,
                                            subscriptionName: item?.title ?? '',
                                            duration: item?.durationTypeName ?? '',
                                            symbol: item?.currencySymbol ?? '',
                                            isActivePlan: isActivePlan ?? false,
                                            iosSubscriptionPlanId: item?.iosSubscriptionPlanId ?? '',
                                            androidSubscriptionPlanId: item?.androidSubscriptionPlanId ?? '',
                                            countryId: item?.countryId ?? 0,
                                          ),
                                        );
                                        // After PromoCodeScreen is popped
                                        if (context.mounted) {
                                          await subscriptionCubit.fetchSubscriptionPlan(isRefresh: true);
                                          await subscriptionCubit.fetchTransferSubscriptionAvailable();
                                          await subscriptionCubit.getNoSubscriptionAccount();
                                        }
                                      },
                                    );
                                  }
                                } else {
                                  AppRouter.push(
                                    AppRoutes.promoCodeApplyScreen,
                                    args: PromoCodeScreen(
                                      subscriptionId: item?.subscriptionId ?? 0,
                                      price: item?.price,
                                      subscriptionName: item?.title ?? '',
                                      duration: item?.durationTypeName ?? '',
                                      symbol: item?.currencySymbol ?? '',
                                      isActivePlan: isActivePlan ?? false,
                                      iosSubscriptionPlanId: item?.iosSubscriptionPlanId ?? '',
                                      androidSubscriptionPlanId: item?.androidSubscriptionPlanId ?? '',
                                      countryId: item?.countryId ?? 0,
                                    ),
                                  )?.then((value) async {
                                    await subscriptionCubit.fetchSubscriptionPlan(isRefresh: true);
                                    await subscriptionCubit.fetchTransferSubscriptionAvailable();
                                    await subscriptionCubit.getNoSubscriptionAccount();
                                  });
                                }
                              },
                              child: SizedBox(
                                width: 100,
                                height: 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppConstants.upgradeStr,
                                      style: FontTypography.upgradeSubscriptionButtonText,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
        sizedBox50Height(),
      ],
    );
  }

  ///Plan title displayed below app bar that states upgrade text to business plan and pro plan.
  Widget _planTitle(SubscriptionLoadedState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sizedBox10Height(),
          Text(
            AppConstants.transferSubscriptionPlan,
            textAlign: TextAlign.left,
            style: FontTypography.popupMenuTxtStyle.copyWith(fontSize: 16),
          ),
          sizedBox10Height(),
          Row(
            children: [
              Flexible(
                flex: 8,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<NoSubscriptionAccountData>(
                    isExpanded: true,
                    hint: Text(
                      state.selectedAccount ?? AppConstants.selectAccount,
                      style: FontTypography.textFieldGreyTextStyle,
                    ),
                    customButton: Container(
                      height: AppConstants.constTxtFieldHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              state.selectedAccount ?? AppConstants.selectAccount,
                              style: FontTypography.textFieldGreyTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ReusableWidgets.createSvg(
                            path: AssetPath.iconDropDown,
                            size: 5,
                          ),
                        ],
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                      ),
                    ),
                    items: state.noSubscriptionAccountData?.map((account) {
                      return DropdownMenuItem<NoSubscriptionAccountData>(
                        value: account,
                        child: Text(
                          '${account.userName} (${account.email ?? ''})',
                          style: FontTypography.textFieldBlackStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      );
                    }).toList(),
                    onChanged: (NoSubscriptionAccountData? account) async {
                      if (account != null) {
                        subscriptionCubit.changeSubscriptionAccount(
                            '${account.userName} (${account.email ?? ''})', account.userId ?? 0);
                        await subscriptionCubit.activeListingCount(context,
                            selectedUserId: account.userId ?? 0,
                            subscriptionCubit: subscriptionCubit,
                            subscriptionID: state.mySubscriptionData?.subscriptionId ?? 0);
                      }
                    },
                  ),
                ),
              ),
              sizedBox10Width(),
              Flexible(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    if (state.selectedUserId != null) {
                      showTransferDialog(context, state, subscriptionCubit);
                    } else {
                      AppUtils.showSnackBar(AppConstants.selectAccount, SnackBarType.alert);
                    }
                  },
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          AppConstants.applyStr,
                          style: FontTypography.upgradeSubscriptionButtonText,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> showTransferDialog(
      BuildContext context, SubscriptionLoadedState state, SubscriptionCubit subscriptionCubit) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          title: Text(
            AppConstants.pleasConfirm,
            textAlign: TextAlign.center,
            style: FontTypography.bottomSheetHeading,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppConstants.planTransferMsg,
                textAlign: TextAlign.center,
                style: FontTypography.defaultLightTextStyle,
              ),
              const SizedBox(height: 16),
              Table(
                border: TableBorder.all(color: AppColors.borderColor),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                },
                children: [
                  _buildTableRow(AppConstants.currentPlan, state.mySubscriptionData?.title ?? ''),
                  // Dynamic
                  _buildTableRow(AppConstants.fromAccount,
                      '${state.mySubscriptionData?.userName ?? ''} (${state.mySubscriptionData?.email ?? ''})'),
                  // Dynamic
                  _buildTableRow(AppConstants.toAccount, state.selectedAccount ?? ''),
                  // Dynamic
                ],
              ),
              const SizedBox(height: 16),
              const Text(AppConstants.proceedMsg, textAlign: TextAlign.center),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                if ((state.listingCount ?? 0) > 0) {
                  AppRouter.push(
                    AppRoutes.chooseSubscriptionActiveListing,
                    args: {
                      ModelKeys.subscriptionCubit: subscriptionCubit,
                      ModelKeys.selectedUserId: state.selectedUserId ?? 0,
                    },
                  );
                } else {
                  subscriptionCubit.transferSubscriptionPlan(isFromActiveListing: false);
                  AppRouter.pop();
                }
              },
              child: Text(
                AppConstants.yesStr,
                style: FontTypography.chipStyle,
              ),
            ),
            TextButton(
              child: Text(
                AppConstants.noStr,
                style: FontTypography.chipStyle,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
