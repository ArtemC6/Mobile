import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class ThinGooglePlayPurchaseDetails implements GooglePlayPurchaseDetails {
  ThinGooglePlayPurchaseDetails({
    required this.productID,
    required String serverVerificationData,
  }) : verificationData = PurchaseVerificationData(
          serverVerificationData: serverVerificationData,
          localVerificationData: 'info-e6eae5b2: Unimplemented',
          source: 'info-1ee83aba: unimplemented',
        );

  @override
  late IAPError? error;

  @override
  late bool pendingCompletePurchase;

  @override
  late PurchaseStatus status;

  @override
  PurchaseWrapper get billingClientPurchase => throw UnimplementedError();

  @override
  String productID;

  @override
  String? get purchaseID => throw UnimplementedError();

  @override
  String? get transactionDate => throw UnimplementedError();

  @override
  PurchaseVerificationData verificationData;
}
