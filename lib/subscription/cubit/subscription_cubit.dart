import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:intl/intl.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/models/user/user_language.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/subscription/cubit/constants.dart';
import 'package:voccent/subscription/cubit/models/current_subscription/current_subscription.dart';
import 'package:voccent/subscription/cubit/models/current_subscription/value.dart';
import 'package:voccent/subscription/cubit/models/purchasable_product.dart';
import 'package:voccent/subscription/cubit/models/store_state.dart';
import 'package:voccent/subscription/cubit/models/thin_google_play_purchase_details.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit()
      : super(
          const SubscriptionState(
            storeState: StoreState.loading,
            products: [],
          ),
        ) {
    _subscription = iapConnection.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
  }

  final iapConnection = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late Client _client;

  @override
  void emit(SubscriptionState state) {
    if (isClosed) {
      return;
    }

    super.emit(state);
  }

  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    log(error.toString(), name: 'Subscription');
  }

  Future<void> buy(PurchasableProduct product) async {
    try {
      emit(state.copyWith(storeState: StoreState.loading));

      final PurchaseParam purchaseParam;

      unawaited(
        FirebaseAnalytics.instance.logEvent(
          name: 'billingChangePlanView',
          parameters: {
            'event_category': 'billing',
            'event_label':
                'Billing changePlan step 1: ${product.productDetails.id}',
          },
        ),
      );

      if (Platform.isAndroid &&
          (state.subscription?.subscriptionCurrent?.googlePlayProductId
                  ?.isNotEmpty ??
              false)) {
        purchaseParam = GooglePlayPurchaseParam(
          productDetails: product.productDetails,
          changeSubscriptionParam: ChangeSubscriptionParam(
            oldPurchaseDetails: ThinGooglePlayPurchaseDetails(
              productID:
                  state.subscription!.subscriptionCurrent!.googlePlayProductId!,
              serverVerificationData: state
                  .subscription!.subscriptionCurrent!.googlePlayPurchaseToken!,
            ),
            prorationMode: ProrationMode.immediateWithTimeProration,
          ),
        );
      } else {
        purchaseParam = PurchaseParam(
          productDetails: product.productDetails,
        );
      }

      if (Platform.isIOS) {
        final transactions = await SKPaymentQueueWrapper().transactions();

        for (final tx in transactions) {
          await SKPaymentQueueWrapper().finishTransaction(tx);
        }
      }

      final delays = <int>[1, 1, 2, 3, 5];
      for (final d in delays) {
        try {
          await iapConnection.buyNonConsumable(purchaseParam: purchaseParam);
          break;
        } on PlatformException catch (e) {
          if (e.code != 'UNAVAILABLE') rethrow;

          // Open issue: https://github.com/flutter/flutter/issues/125254
          await Future<void>.delayed(Duration(seconds: d));
        }
      }
    } catch (e) {
      emit(state.copyWith(storeState: StoreState.available));
      unawaited(
        FirebaseAnalytics.instance.logEvent(
          name: 'billingChangePlanUpgradePlanError',
          parameters: {
            'event_category': 'billing',
            'event_label': 'Billing changePlan step 3 error: $e',
          },
        ),
      );
      rethrow;
    }
  }

  Future<void> loadProducts(Client client) async {
    _client = client;

    emit(
      state.copyWith(
        subscription: CurrentSubscription.fromJson(
          await _client.get(
            Uri.parse('/billing/user_subscription_current'),
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          ).mapData(),
        ),
      ),
    );

    try {
      final available = await iapConnection.isAvailable();
      if (!available) {
        emit(state.copyWith(storeState: StoreState.notAvailable));
        return;
      }
    } catch (e) {
      emit(state.copyWith(storeState: StoreState.notAvailable));
      return;
    }

    const ids = <String>{
      storeKeySubscriptionBasic,
      storeKeySubscriptionStandard,
      storeKeySubscriptionAdvanced,
    };

    const tariffToProductMap = <String, String>{
      '00000000-0000-0000-0000-000000000000': storeKeySubscriptionFree,
      '00000000-0000-0000-0000-000000000001': storeKeySubscriptionBasic,
      '00000000-0000-0000-0000-000000000002': storeKeySubscriptionStandard,
      '00000000-0000-0000-0000-000000000003': storeKeySubscriptionAdvanced,
    };

    final curProductId = tariffToProductMap[
        state.subscription?.price?.tariffId ??
            '00000000-0000-0000-0000-000000000000'];
    final response = await iapConnection.queryProductDetails(ids);
    final currencyFormat = NumberFormat.simpleCurrency();
    final products = response.productDetails
        .map(
          (e) => PurchasableProduct(
            productDetails: e,
            status: e.id == curProductId
                ? ProductStatus.purchased
                : ProductStatus.purchasable,
          ),
        )
        .toList()
      ..add(
        PurchasableProduct(
          productDetails: ProductDetails(
            id: storeKeySubscriptionFree,
            title: S.current.subscriptionFree,
            description: S.current.subscriptionFreePlan,
            price: currencyFormat.format(0),
            rawPrice: 0,
            currencyCode: '',
          ),
          status: storeKeySubscriptionFree == curProductId
              ? ProductStatus.purchased
              : ProductStatus.purchasable,
        ),
      )
      ..sort(
        (a, b) => a.order - b.order,
      );

    emit(
      state.copyWith(
        storeState: StoreState.available,
        products: products,
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  Future<void> _onPurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    try {
      emit(state.copyWith(storeState: StoreState.loading));

      for (final purchaseDetails in purchaseDetailsList) {
        if (purchaseDetails.status == PurchaseStatus.purchased) {
          _sendEventToGoogleAnalytics(purchaseDetails);

          if (await _verifyPurchase(purchaseDetails)) {
            await loadProducts(_client);
          } else {
            throw Exception(
              'The payment cannot be verified. '
              'The payment will be refunded in full.',
            );
          }
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          emit(state.copyWith(storeState: StoreState.available));
          unawaited(
            FirebaseAnalytics.instance.logEvent(
              name: 'billingChangePlanUpgradePlanError',
              parameters: {
                'event_category': 'billing',
                'event_label': 'Purchase error: ${purchaseDetails.error}',
              },
            ),
          );
        } else if (purchaseDetails.status == PurchaseStatus.canceled ||
            purchaseDetails.status == PurchaseStatus.restored) {
          emit(state.copyWith(storeState: StoreState.available));
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await iapConnection.completePurchase(purchaseDetails);
        }
      }
    } catch (e) {
      emit(state.copyWith(storeState: StoreState.available));
      unawaited(
        FirebaseAnalytics.instance.logEvent(
          name: 'billingChangePlanUpgradePlanError',
          parameters: {
            'event_category': 'billing',
            'event_label': 'Billing changePlan payment verify error: $e',
          },
        ),
      );
      rethrow;
    }
  }

  void _sendEventToGoogleAnalytics(PurchaseDetails purchaseDetails) {
    try {
      if (state.products.isEmpty) return;

      final prevPrice = state.products
          .firstWhere(
            (element) => element.status == ProductStatus.purchased,
          )
          .productDetails
          .rawPrice;

      final curPrice = state.products
          .firstWhere(
            (element) => element.productDetails.id == purchaseDetails.productID,
          )
          .productDetails
          .rawPrice;

      if (prevPrice < curPrice) {
        unawaited(
          FirebaseAnalytics.instance.logEvent(
            name: 'billingChangePlanUpgradePlan',
            parameters: {
              'event_category': 'billing',
              'event_label': 'Billing changePlan step 2',
            },
          ),
        );
      } else if (prevPrice > curPrice) {
        unawaited(
          FirebaseAnalytics.instance.logEvent(
            name: 'billingChangePlanDowngradePlan',
            parameters: {
              'event_category': 'billing',
              'event_label': 'Billing changePlan step 2',
            },
          ),
        );
      }
    } catch (e, s) {
      unawaited(
        FirebaseCrashlytics.instance.recordError(
          e,
          s,
          reason: '492af5a4: Error occured while sending GA '
              'event about billingChangePlan',
        ),
      );
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    final data = purchaseDetails.verificationData.serverVerificationData;

    final uri = Platform.isIOS
        ? Uri.parse('/billing/app_store/verify_purchase')
        : Uri.parse('/billing/google_play/verify_purchase');

    return (await _client.post(
      uri,
      body: '{"PurchaseToken":"$data",'
          '"ProductId":"${purchaseDetails.productID}"}',
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    ).mapData())['Active'] as bool;
  }

  Value capabilityValue(String id, List<UserLanguage>? listWorkLang) {
    final index = state.subscription?.tariffTable?.capabilities
        ?.indexWhere((element) => element.id == id);

    final cap = index != null && index > 0
        ? state.subscription!.tariffTable!.values!.first[index]
        : Value();

    if (cap.toString() == Value.yes) {
      FirebaseAnalytics.instance.logEvent(
        name: 'PayWall',
        parameters: {
          'category': 'streamotion',
          'workLang': listWorkLang?.map((e) => e.name).toList(),
        },
      );
    }

    return cap;
  }
}
