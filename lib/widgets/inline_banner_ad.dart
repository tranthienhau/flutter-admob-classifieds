import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/ad_slot.dart';
import '../providers/admob_provider.dart';

class InlineBannerAd extends ConsumerStatefulWidget {
  const InlineBannerAd({super.key});

  @override
  ConsumerState<InlineBannerAd> createState() => _InlineBannerAdState();
}

class _InlineBannerAdState extends ConsumerState<InlineBannerAd> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    final cfg = ref.read(adSlotsProvider)[AdSlotType.banner]!;
    _ad = BannerAd(
      adUnitId: cfg.unitId(Platform.isIOS),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _loaded = true),
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) {
      return const SizedBox(height: 50);
    }
    return SizedBox(
      width: _ad!.size.width.toDouble(),
      height: _ad!.size.height.toDouble(),
      child: AdWidget(ad: _ad!),
    );
  }
}
