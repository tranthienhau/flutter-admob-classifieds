import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/listings_provider.dart';
import '../providers/admob_provider.dart';

class ListingDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const ListingDetailScreen({super.key, required this.id});
  @override
  ConsumerState<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends ConsumerState<ListingDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(interstitialControllerProvider).show();
    });
  }

  Future<void> _boostWithRewarded() async {
    final granted = await ref.read(rewardedControllerProvider).show();
    if (granted && mounted) {
      ref.read(listingsProvider.notifier).boost(widget.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Boost unlocked for 24h')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final listing = ref.watch(listingsProvider).firstWhere((l) => l.id == widget.id);
    return Scaffold(
      appBar: AppBar(title: Text(listing.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black12,
              child: const Icon(Icons.image, size: 64, color: Colors.black26),
            ),
          ),
          const SizedBox(height: 16),
          Text(listing.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('${listing.currency} ${listing.price.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 20, color: Colors.blue)),
          const SizedBox(height: 8),
          Text('${listing.category} · ${listing.location}'),
          const SizedBox(height: 16),
          Text(listing.description),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _boostWithRewarded,
            icon: const Icon(Icons.flash_on),
            label: const Text('Watch rewarded ad to boost'),
          ),
        ],
      ),
    );
  }
}
