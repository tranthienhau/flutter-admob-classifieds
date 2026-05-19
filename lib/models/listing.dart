class Listing {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String category;
  final String subcategory;
  final List<String> imageUrls;
  final String location;
  final DateTime createdAt;
  final bool isFeatured;
  final bool isBoosted;

  const Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.category,
    required this.subcategory,
    required this.imageUrls,
    required this.location,
    required this.createdAt,
    this.isFeatured = false,
    this.isBoosted = false,
  });
}
