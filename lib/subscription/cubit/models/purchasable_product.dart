import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/subscription/cubit/constants.dart';

enum ProductStatus {
  purchasable,
  purchased,
  pending,
}

class PurchasableProduct extends Equatable {
  const PurchasableProduct({
    required this.productDetails,
    required this.status,
  });

  String get id => productDetails.id;
  String get title {
    switch (productDetails.id) {
      case storeKeySubscriptionAdvanced:
        return S.current.subscriptionAdvanced;
      case storeKeySubscriptionStandard:
        return S.current.subscriptionStandard;
      case storeKeySubscriptionBasic:
        return S.current.subscriptionBasic;
      case storeKeySubscriptionFree:
        return S.current.subscriptionFree;
      default:
        return productDetails.id;
    }
  }

  String get description => productDetails.description;
  String get price => productDetails.price;
  final ProductStatus status;
  final ProductDetails productDetails;
  int get order {
    switch (productDetails.id) {
      case storeKeySubscriptionAdvanced:
        return 4;
      case storeKeySubscriptionStandard:
        return 3;
      case storeKeySubscriptionBasic:
        return 2;
      case storeKeySubscriptionFree:
        return 1;
      default:
        return 0;
    }
  }

  PurchasableProduct copyWith({
    ProductDetails? productDetails,
    ProductStatus? status,
  }) {
    return PurchasableProduct(
      productDetails: productDetails ?? this.productDetails,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [id, status];
}
