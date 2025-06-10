import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/subscription/cubit/subscription_cubit.dart';
import 'package:workapp/src/utils/in_app_purchase_utils.dart';

class PromoCodeScreen extends StatefulWidget {
  final int subscriptionId;
  final int countryId;
  final double price;
  final String duration;
  final String subscriptionName;
  final String symbol;
  final String iosSubscriptionPlanId;
  final String androidSubscriptionPlanId;
  final bool isActivePlan;

  const PromoCodeScreen({
    super.key,
    required this.subscriptionId,
    required this.price,
    required this.subscriptionName,
    required this.duration,
    required this.symbol,
    required this.countryId,
    required this.isActivePlan,
    required this.iosSubscriptionPlanId,
    required this.androidSubscriptionPlanId,
  });

  @override
  PromoCodeScreenState createState() => PromoCodeScreenState();
}

class PromoCodeScreenState extends State<PromoCodeScreen> {
  String? selectedPromo;
  String finalDiscountAmount = '';
  String? discountPercentage;
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchasesSubscription;
  final promoCodeController = TextEditingController();
  final SubscriptionCubit subscriptionCubit = SubscriptionCubit();

  @override
  void initState() {
    subscriptionCubit.promoCodeList(subscriberId: widget.subscriptionId);
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      bloc: subscriptionCubit,
      builder: (context, state) {
        if (state is SubscriptionLoadedState) {
          return Scaffold(
            appBar: const MyAppBar(title: AppConstants.checkoutStr),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.subscriptionName,
                                style: FontTypography.profileHeading.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.symbol}${widget.price}/${widget.duration}',
                                style: FontTypography.defaultTextStyle,
                              ),
                            ],
                          ),
                        ),

                        sizedBox30Height(),
                        Text(
                          AppConstants.promoCodeStr,
                          style: FontTypography.textFieldGreyTextStyle,
                        ),
                        sizedBox10Height(),
                        Visibility(
                          visible: !subscriptionCubit.isPromoApplied,
                          replacement: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.check_circle, color: AppColors.primaryColor, size: 20),
                                    sizedBox10Width(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '  ${promoCodeController.text} applied',
                                          style: FontTypography.priceStyle,
                                        ),
                                        sizedBox5Height(),
                                        Text(
                                          finalDiscountAmount.toString(),
                                          style: FontTypography.signUpRouteStyle.copyWith(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    promoCodeController.clear();
                                    subscriptionCubit.removePromoCode();
                                    discountPercentage = '';
                                    finalDiscountAmount = '';
                                    subscriptionCubit.isPromoApplied = false;
                                  },
                                  child: Text(
                                    AppConstants.removeStr,
                                    style: FontTypography.priceStyle.copyWith(color: AppColors.deleteColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  controller: promoCodeController,
                                  hintTxt: AppConstants.promoCodeHint,
                                ),
                              ),
                              sizedBox10Width(),
                              InkWell(
                                onTap: () async {
                                  if (promoCodeController.text.isNotEmpty) {
                                    bool promoApplied = await subscriptionCubit.promoCodeValidate(
                                      context,
                                      subscriptionCubit: subscriptionCubit,
                                      subscriberId: widget.subscriptionId,
                                      promoCode: promoCodeController.text,
                                    );
                                    if (promoApplied) {
                                      subscriptionCubit.isPromoApplied = true;
                                    } else {
                                      promoCodeController.clear();
                                      subscriptionCubit.isPromoApplied = false;
                                    }
                                  } else {
                                    AppUtils.showSnackBar(AppConstants.validPromoCode, SnackBarType.alert);
                                  }
                                },
                                child: Container(
                                  width: 100,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppConstants.applyCode,
                                    style: FontTypography.upgradeSubscriptionButtonText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        sizedBox30Height(),
                        Text(AppConstants.availablePromoCodeStr, style: FontTypography.insightTextBoldStyle),
                        sizedBox15Height(),
                        // Promo Code List
                        Visibility(
                          visible: state.promoCodeItems?.isNotEmpty ?? false,
                          replacement: const Center(
                              child: Text(
                            AppConstants.emptyPromoCode,
                          )),
                          child: SizedBox(
                            height: 67,
                            child: ListView.builder(
                              itemCount: state.promoCodeItems?.length ?? 0,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              // More natural scrolling
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              itemBuilder: (context, index) {
                                var item = state.promoCodeItems?[index];
                                return Padding(
                                  padding: EdgeInsets.only(left: index == 0 ? 0 : 10), // Add spacing between items
                                  child: promoCodeBox(
                                    item?.promoCode ?? '',
                                    '${item?.discountPercentage ?? ''}%',
                                    widget.symbol,
                                    item?.discountAmount.toString() ?? '',
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        sizedBox20Height(),
                        // Pricing Details
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              priceRow(AppConstants.originalPrice, widget.price.toString(), isTotal: false),
                              priceRow(
                                  AppConstants.discountStr,
                                  subscriptionCubit.isPromoApplied == true
                                      ? state.promoDetails?.discountAmount.toString() ?? '0'
                                      : '0',
                                  isDiscount: true),
                              const Divider(),
                              priceRow(
                                  AppConstants.totalStr,
                                  subscriptionCubit.isPromoApplied == false
                                      ? widget.price.toString()
                                      : state.promoDetails?.finalAmount.toString() ?? '0',
                                  isTotal: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.loader)
                  const Positioned.fill(
                    child: Center(
                      child: LoaderView(), // Ensure LoaderView is centered
                    ),
                  ),
              ],
            ),
            floatingActionButton: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: AppButton(
                  function: () async {
                    double amount = state.promoDetails?.finalAmount ?? widget.price;
                    bool upgradeSuccess = await subscriptionCubit.isUpgradable(context, amount);
                    if (upgradeSuccess) {
                      if (state.promoDetails?.finalAmount == 0.0) {
                        subscriptionCubit.buySubscriptionPlan(context,
                                countryId: state.promoDetails?.countryId ?? 0,
                                subscriptionPlanId: state.promoDetails?.subscriptionId ?? 0);
                      } else {
                        try {
                          ///Clear Pending transaction if any
                          InAppPurchaseUtils.instance.clearPendingTransactions();
                          InAppPurchaseUtils.instance
                              .upgradeSubscription(
                                  Platform.isIOS ? widget.iosSubscriptionPlanId : widget.androidSubscriptionPlanId)
                              .then((onValue) {})
                              .catchError((onError) {
                            if (onError is PlatformException) {
                              if (kDebugMode) {
                                print(' ${onError.message}');
                              }
                              AppUtils.showErrorSnackBar(onError.message ?? '');
                            } else {
                              if (kDebugMode) print(' $onError');
                              AppUtils.showErrorSnackBar(AppConstants.somethingWentWrong);
                            }
                          });
                        } finally {
                          /// closing the dialog
                          // AppRouter.pop();
                        }
                      }
                    }
                  },
                  title: '${AppConstants.proceedStr} ${subscriptionCubit.isPromoApplied == true
                      ? state.promoDetails?.finalAmount.toString() ?? '0'
                      : ''} ',
                )),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget promoCodeBox(String code, String discount, String currency, String discountAmount) {
    discountPercentage = discount.toString();
    finalDiscountAmount = '-$currency$discountAmount ($discountPercentage)off';
    return InkWell(
      onTap: () {
        promoCodeController.text = code;
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(6),
        dashPattern: const [5, 4],
        color: Colors.grey,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.local_offer, color: AppColors.promoCodeColor, size: 20),
                  sizedBox5Width(),
                  Text(code, style: FontTypography.priceStyle),
                ],
              ),
              sizedBox5Height(),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(discount, style: FontTypography.signUpRouteStyle),
              ), // Discount below
            ],
          ),
        ),
      ),
    );
  }

  Widget priceRow(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: isTotal
                  ? FontTypography.amountStyle
                  : isDiscount
                      ? FontTypography.discountStyle
                      : FontTypography.amountStyle),
          Text('${widget.symbol} $value',
              style: isTotal
                  ? FontTypography.amountStyle
                  : isDiscount
                      ? FontTypography.discountStyle
                      : FontTypography.amountStyle),
        ],
      ),
    );
  }

  Future<void> initialize() async {
    if (!(await _iap.isAvailable())) return;

    ///catch all purchase updates
    _purchasesSubscription = InAppPurchase.instance.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        handlePurchaseUpdates(purchaseDetailsList);
      },
      onDone: () {
        _purchasesSubscription?.cancel();
      },
      onError: (error) {
        AppUtils.showErrorSnackBar(AppConstants.somethingWentWrong);
        if (kDebugMode) print('InAppPurchaseUtils.initialize--${error.toString()}');
      },
    );
    // if (Platform.isIOS) {
    //   _iap.restorePurchases();
    // }
  }

  Future<void> handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    // Implement your logic for handling purchase updates here
    if (purchaseDetailsList.isEmpty) {
      return;
    }

    PurchaseDetails purchaseDetails = purchaseDetailsList.first;

    if (purchaseDetails.status == PurchaseStatus.purchased) {
      final String purchaseToken = purchaseDetails.verificationData.serverVerificationData;
      log('$this------->', error: '----> purchase token->1 ${purchaseDetails.status} <-');
      log('$this------->', error: '----> purchase token->2 $purchaseToken <-');

      if (!purchaseDetails.pendingCompletePurchase) {
        return;
      }
      _iap.completePurchase(purchaseDetails);
      subscriptionCubit.buySubscriptionPlan(
        context,
        countryId: widget.countryId,
        subscriptionPlanId: widget.subscriptionId,
        purchaseDetail: purchaseDetails,
      );
    } else if (purchaseDetails.status == PurchaseStatus.pending || purchaseDetails.pendingCompletePurchase) {
      await InAppPurchase.instance.completePurchase(purchaseDetails);
    } else {
      if (purchaseDetails.error?.message != null) {
        AppUtils.showErrorSnackBar(purchaseDetails.error?.message ?? '');
      }
    }
    if (purchaseDetails.pendingCompletePurchase) {
      await InAppPurchase.instance.completePurchase(purchaseDetails);
    }
  }

  @override
  void dispose() {
    _purchasesSubscription?.cancel();
    super.dispose();
  }
}
