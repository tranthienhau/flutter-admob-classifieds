import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/listings_provider.dart';
import '../widgets/listing_card.dart';
import '../widgets/inline_banner_ad.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _category;
  final _categories = const ['All', 'Electronics', 'Vehicles', 'Real Estate', 'Jobs'];

  @override
  Widget build(BuildContext context) {
    final listings = ref.watch(filteredListingsProvider(_category));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classifieds'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () => context.push('/saved'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/post'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemBuilder: (_, i) {
                final c = _categories[i];
                final selected = (_category ?? 'All') == c;
                return ChoiceChip(
                  label: Text(c),
                  selected: selected,
                  onSelected: (_) => setState(() => _category = c == 'All' ? null : c),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: _categories.length,
            ),
          ),
          const InlineBannerAd(),
          Expanded(
            child: ListView.builder(
              itemCount: listings.length,
              itemBuilder: (_, i) {
                if (i > 0 && i % 6 == 0) {
                  return Column(
                    children: [
                      const InlineBannerAd(),
                      ListingCard(listing: listings[i]),
                    ],
                  );
                }
                return ListingCard(listing: listings[i]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
