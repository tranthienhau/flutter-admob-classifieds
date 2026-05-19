import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/listing.dart';
import '../providers/listings_provider.dart';

class PostListingScreen extends ConsumerStatefulWidget {
  const PostListingScreen({super.key});
  @override
  ConsumerState<PostListingScreen> createState() => _PostListingScreenState();
}

class _PostListingScreenState extends ConsumerState<PostListingScreen> {
  final _title = TextEditingController();
  final _price = TextEditingController();
  final _desc = TextEditingController();
  String _category = 'Electronics';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post listing')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 12),
          TextField(
            controller: _price,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Price (USD)'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _category,
            items: const ['Electronics', 'Vehicles', 'Real Estate', 'Jobs']
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _category = v ?? 'Electronics'),
            decoration: const InputDecoration(labelText: 'Category'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _desc,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              final l = Listing(
                id: const Uuid().v4(),
                title: _title.text,
                description: _desc.text,
                price: double.tryParse(_price.text) ?? 0,
                currency: 'USD',
                category: _category,
                subcategory: '',
                imageUrls: const [],
                location: 'Local',
                createdAt: DateTime.now(),
              );
              ref.read(listingsProvider.notifier).addListing(l);
              Navigator.of(context).pop();
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }
}
