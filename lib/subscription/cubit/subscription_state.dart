part of 'subscription_cubit.dart';

class SubscriptionState extends Equatable {
  const SubscriptionState({
    required this.storeState,
    required this.products,
    this.subscription,
  });

  final StoreState storeState;
  final List<PurchasableProduct> products;
  final CurrentSubscription? subscription;

  SubscriptionState copyWith({
    StoreState? storeState,
    List<PurchasableProduct>? products,
    CurrentSubscription? subscription,
  }) {
    return SubscriptionState(
      storeState: storeState ?? this.storeState,
      products: products ?? this.products,
      subscription: subscription ?? this.subscription,
    );
  }

  @override
  List<Object?> get props => [storeState, products, subscription];
}
