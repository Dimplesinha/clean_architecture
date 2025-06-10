import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';

class InAppPurchaseUtils {
  String priceCurrencyPremium = '';
  double pricePremium = 0.0;

  // Private constructor
  InAppPurchaseUtils._();

  // Singleton instance
  static final InAppPurchaseUtils _instance = InAppPurchaseUtils._();

  // Getter to access the instance
  static InAppPurchaseUtils get instance => _instance;

  // Create a private variable
  final InAppPurchase _iap = InAppPurchase.instance;

  Future<void> upgradeSubscription(String productKeyPremium) async {
    // ReusableWidgets.showLoaderDialog();
    clearPendingTransactions();
    Set<String> productIds = {productKeyPremium};
    final ProductDetailsResponse productDetails = await _iap.queryProductDetails(productIds);

    ProductDetails details = productDetails.productDetails.first;
    print('-------------${details.id}');
    print('-------------${details.price}');
    priceCurrencyPremium = details.currencyCode;
    pricePremium = details.rawPrice;
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: details,
      applicationUserName: AppUtils.loginUserModel?.email??'',
    );
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> clearPendingTransactions() async {
    try {
      if (Platform.isAndroid) {
        return;
      }
      // Fetch all transactions from the payment queue
      final transactions = await SKPaymentQueueWrapper().transactions();

      for (var transaction in transactions) {
        // Finish each transaction
        await SKPaymentQueueWrapper().finishTransaction(transaction);
      }
    } catch (e) {
      if (kDebugMode) {
        print('$this clearPendingTransactions Error while clearing pending transactions: $e');
      }
    }
  }
}
