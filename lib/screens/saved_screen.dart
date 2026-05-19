import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/listings_provider.dart';
import '../widgets/listing_card.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(listingsProvider);
    final saved = all.where((l) => l.isFeatured || l.isBoosted).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: saved.isEmpty
          ? const Center(child: Text('No saved ads yet'))
          : ListView.builder(
              itemCount: saved.length,
              itemBuilder: (_, i) => ListingCard(listing: saved[i]),
            ),
    );
  }
}
