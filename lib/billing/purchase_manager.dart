import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PurchaseOutcome { purchased, restored, nothingToRestore, canceled, failed }

class PurchaseManager {
  PurchaseManager._();
  static final PurchaseManager instance = PurchaseManager._();

  static const productId = 'remove_ads';
  static const _entitlementKey = 'ludostars.adsRemoved';

  final ValueNotifier<bool> adsRemoved = ValueNotifier(false);
  final ValueNotifier<bool> busy = ValueNotifier(false);

  ProductDetails? _product;
  String? get price => _product?.price;
  bool get hasProduct => _product != null;

  bool _storeAvailable = false;
  bool get storeAvailable => _storeAvailable;

  StreamSubscription<List<PurchaseDetails>>? _sub;
  SharedPreferences? _prefs;
  bool _silentRestore = false;

  void Function(PurchaseOutcome outcome)? onResult;

  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    adsRemoved.value = _prefs?.getBool(_entitlementKey) ?? false;

    if (!_supported) return;

    try {
      _storeAvailable = await InAppPurchase.instance.isAvailable();
    } catch (_) {
      _storeAvailable = false;
    }
    if (!_storeAvailable) return;

    _sub = InAppPurchase.instance.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (_) => busy.value = false,
    );

    await _loadProduct();

    if (defaultTargetPlatform == TargetPlatform.android) {
      _silentRestore = true;
      try {
        await InAppPurchase.instance.restorePurchases();
      } catch (_) {
        _silentRestore = false;
      }
    }
  }

  Future<void> _loadProduct() async {
    try {
      final response = await InAppPurchase.instance.queryProductDetails({
        productId,
      });
      if (response.productDetails.isNotEmpty) {
        _product = response.productDetails.first;
      }
    } catch (_) {
      _product = null;
    }
  }

  Future<void> buy() async {
    if (adsRemoved.value || busy.value) return;
    if (!_storeAvailable) {
      onResult?.call(PurchaseOutcome.failed);
      return;
    }
    if (_product == null) {
      await _loadProduct();
      if (_product == null) {
        onResult?.call(PurchaseOutcome.failed);
        return;
      }
    }

    busy.value = true;
    try {
      await InAppPurchase.instance.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: _product!),
      );
    } catch (_) {
      busy.value = false;
      onResult?.call(PurchaseOutcome.failed);
    }
  }

  Future<void> restore() async {
    if (!_storeAvailable || busy.value) {
      onResult?.call(PurchaseOutcome.failed);
      return;
    }
    busy.value = true;
    final alreadyOwned = adsRemoved.value;
    try {
      await InAppPurchase.instance.restorePurchases();
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      if (!adsRemoved.value && !alreadyOwned) {
        onResult?.call(PurchaseOutcome.nothingToRestore);
      }
    } catch (_) {
      onResult?.call(PurchaseOutcome.failed);
    } finally {
      busy.value = false;
    }
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          busy.value = true;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final restored = purchase.status == PurchaseStatus.restored;
          if (purchase.productID == productId) {
            await _grant();
            if (!(_silentRestore && restored)) {
              onResult?.call(
                restored ? PurchaseOutcome.restored : PurchaseOutcome.purchased,
              );
            }
          }
          await _finish(purchase);
          busy.value = false;

        case PurchaseStatus.canceled:
          await _finish(purchase);
          busy.value = false;
          onResult?.call(PurchaseOutcome.canceled);

        case PurchaseStatus.error:
          await _finish(purchase);
          busy.value = false;
          onResult?.call(PurchaseOutcome.failed);
      }
    }
    _silentRestore = false;
  }

  Future<void> _finish(PurchaseDetails purchase) async {
    if (!purchase.pendingCompletePurchase) return;
    try {
      await InAppPurchase.instance.completePurchase(purchase);
    } catch (_) {}
  }

  Future<void> _grant() async {
    adsRemoved.value = true;
    await _prefs?.setBool(_entitlementKey, true);
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
