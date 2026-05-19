import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/listing.dart';

class ListingsNotifier extends StateNotifier<List<Listing>> {
  ListingsNotifier() : super(_seed());

  static List<Listing> _seed() {
    final now = DateTime.now();
    return List.generate(20, (i) {
      return Listing(
        id: 'l$i',
        title: 'Item ${i + 1}',
        description: 'High quality item ${i + 1} in great condition.',
        price: 50.0 + i * 25,
        currency: 'USD',
        category: ['Electronics', 'Vehicles', 'Real Estate', 'Jobs'][i % 4],
        subcategory: 'Featured',
        imageUrls: const [],
        location: ['Berlin', 'Paris', 'Madrid', 'Rome'][i % 4],
        createdAt: now.subtract(Duration(hours: i)),
        isFeatured: i % 5 == 0,
        isBoosted: i % 7 == 0,
      );
    });
  }

  void addListing(Listing l) => state = [l, ...state];

  void boost(String id) {
    state = [
      for (final l in state)
        if (l.id == id)
          Listing(
            id: l.id,
            title: l.title,
            description: l.description,
            price: l.price,
            currency: l.currency,
            category: l.category,
            subcategory: l.subcategory,
            imageUrls: l.imageUrls,
            location: l.location,
            createdAt: l.createdAt,
            isFeatured: l.isFeatured,
            isBoosted: true,
          )
        else
          l,
    ];
  }
}

final listingsProvider =
    StateNotifierProvider<ListingsNotifier, List<Listing>>((ref) {
  return ListingsNotifier();
});

final filteredListingsProvider =
    Provider.family<List<Listing>, String?>((ref, category) {
  final all = ref.watch(listingsProvider);
  if (category == null || category.isEmpty) return all;
  return all.where((l) => l.category == category).toList();
});
