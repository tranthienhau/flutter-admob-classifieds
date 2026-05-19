import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/ad_slot.dart';

const _testBannerIos = 'ca-app-pub-3940256099942544/2934735716';
const _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
const _testInterstitialIos = 'ca-app-pub-3940256099942544/4411468910';
const _testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
const _testNativeIos = 'ca-app-pub-3940256099942544/3986624511';
const _testNativeAndroid = 'ca-app-pub-3940256099942544/2247696110';
const _testRewardedIos = 'ca-app-pub-3940256099942544/1712485313';
const _testRewardedAndroid = 'ca-app-pub-3940256099942544/5224354917';

final adSlotsProvider = Provider<Map<AdSlotType, AdSlotConfig>>((ref) {
  return const {
    AdSlotType.banner: AdSlotConfig(
      type: AdSlotType.banner,
      iosUnitId: _testBannerIos,
      androidUnitId: _testBannerAndroid,
    ),
    AdSlotType.interstitial: AdSlotConfig(
      type: AdSlotType.interstitial,
      iosUnitId: _testInterstitialIos,
      androidUnitId: _testInterstitialAndroid,
    ),
    AdSlotType.native: AdSlotConfig(
      type: AdSlotType.native,
      iosUnitId: _testNativeIos,
      androidUnitId: _testNativeAndroid,
      useAdManager: true,
    ),
    AdSlotType.rewarded: AdSlotConfig(
      type: AdSlotType.rewarded,
      iosUnitId: _testRewardedIos,
      androidUnitId: _testRewardedAndroid,
    ),
  };
});

class InterstitialController {
  InterstitialAd? _ad;
  final String unitId;
  InterstitialController(this.unitId);

  Future<void> load() async {
    await InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _ad = ad,
        onAdFailedToLoad: (_) => _ad = null,
      ),
    );
  }

  Future<void> show() async {
    final ad = _ad;
    if (ad == null) return;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _ad = null;
        load();
      },
    );
    await ad.show();
    _ad = null;
  }
}

final interstitialControllerProvider = Provider<InterstitialController>((ref) {
  final slots = ref.watch(adSlotsProvider);
  final cfg = slots[AdSlotType.interstitial]!;
  final ctrl = InterstitialController(cfg.unitId(Platform.isIOS));
  ctrl.load();
  return ctrl;
});

class RewardedController {
  RewardedAd? _ad;
  final String unitId;
  RewardedController(this.unitId);

  Future<void> load() async {
    await RewardedAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _ad = ad,
        onAdFailedToLoad: (_) => _ad = null,
      ),
    );
  }

  Future<bool> show() async {
    final ad = _ad;
    if (ad == null) return false;
    var granted = false;
    await ad.show(onUserEarnedReward: (_, __) => granted = true);
    _ad = null;
    load();
    return granted;
  }
}

final rewardedControllerProvider = Provider<RewardedController>((ref) {
  final slots = ref.watch(adSlotsProvider);
  final cfg = slots[AdSlotType.rewarded]!;
  final ctrl = RewardedController(cfg.unitId(Platform.isIOS));
  ctrl.load();
  return ctrl;
});
