enum AdSlotType { banner, interstitial, native, rewarded }

class AdSlotConfig {
  final AdSlotType type;
  final String iosUnitId;
  final String androidUnitId;
  final bool useAdManager;

  const AdSlotConfig({
    required this.type,
    required this.iosUnitId,
    required this.androidUnitId,
    this.useAdManager = false,
  });

  String unitId(bool isIos) => isIos ? iosUnitId : androidUnitId;
}
