# flutter-admob-classifieds

Flutter classified ads platform POC. Demonstrates AdMob mediation + AdX integration,
banner/interstitial/native/rewarded ad units, in-app purchase paid boosts/featured
listings, multi-image upload, categories/subcategories, search + filters, saved ads.

## Stack

- Flutter + Dart
- Riverpod (state management)
- go_router (navigation)
- google_mobile_ads (AdMob + AdMob Mediation + AdX)
- in_app_purchase (Apple IAP / Google Play Billing)
- Hive (local cache for saved ads)
- image_picker (multi-image upload)

## Ad monetization

- Banner ads on home + category feed
- Interstitial ad between listing details
- Native ad cards inline in the listing feed (every 6th cell)
- Rewarded ad to unlock "Promote your ad for 24h"
- AdMob Mediation waterfall config (Meta / Unity / AppLovin) via app-ads.txt + mediation groups configured in AdMob console
- AdX integration via the same `google_mobile_ads` SDK using AdManager Ad Units

## IAP / Monetization tiers

- Consumable: "Boost listing 24h", "Featured for 7 days"
- Subscription-ready: monthly seller plan stub

## Architecture

- Repository pattern for listings, ad unit ids, IAP catalog
- Riverpod providers per feature
- Router with category browse / detail / saved / sell flows

## Run

```bash
flutter pub get
flutter run
```

Replace test ad unit IDs in `lib/providers/admob_provider.dart` with your production
AdMob / AdX unit IDs before release.
