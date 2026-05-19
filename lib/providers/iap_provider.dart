import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

const kBoost24h = 'boost_24h';
const kFeatured7d = 'featured_7d';
const kSellerMonthly = 'seller_monthly';

class IapController {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  Future<bool> available() => _iap.isAvailable();

  Future<Set<ProductDetails>> loadProducts() async {
    final r = await _iap.queryProductDetails(
      {kBoost24h, kFeatured7d, kSellerMonthly},
    );
    return r.productDetails.toSet();
  }

  Future<void> buy(ProductDetails p, {required bool consumable}) async {
    final param = PurchaseParam(productDetails: p);
    if (consumable) {
      await _iap.buyConsumable(purchaseParam: param);
    } else {
      await _iap.buyNonConsumable(purchaseParam: param);
    }
  }

  void listen(void Function(PurchaseDetails) onPurchase) {
    _sub = _iap.purchaseStream.listen((events) {
      for (final p in events) {
        onPurchase(p);
        if (p.pendingCompletePurchase) {
          _iap.completePurchase(p);
        }
      }
    });
  }

  void dispose() => _sub?.cancel();
}

final iapControllerProvider = Provider<IapController>((ref) {
  final c = IapController();
  ref.onDispose(c.dispose);
  return c;
});
