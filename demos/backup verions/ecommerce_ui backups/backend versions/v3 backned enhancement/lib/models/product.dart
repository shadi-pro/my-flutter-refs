class Product {
  final String imageUrl;
  final String title;
  final String category;
  final double price;
  final bool inStock;

  // 🔜 New optional backend fields
  final String? description;
  final String? brand;
  final double? rating;

  Product({
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.price,
    required this.inStock,
    this.description,
    this.brand,
    this.rating,
  });

  // ✅ Factory to create Product from Firestore document
  factory Product.fromFirestore(Map<String, dynamic> data) {
    return Product(
      imageUrl: data['imageUrl'] ?? '',
      title: data['name'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] is int)
          ? (data['price'] as int).toDouble()
          : (data['price'] ?? 0.0).toDouble(),
      inStock: data['inStock'] ?? false,
      description: data['description'], // optional field
      brand: data['brand'], // optional field
      rating: (data['rating'] is int)
          ? (data['rating'] as int).toDouble()
          : data['rating'], // optional field
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          imageUrl == other.imageUrl &&
          title == other.title &&
          category == other.category &&
          price == other.price &&
          inStock == other.inStock &&
          description == other.description &&
          brand == other.brand &&
          rating == other.rating;

  @override
  int get hashCode =>
      imageUrl.hashCode ^
      title.hashCode ^
      category.hashCode ^
      price.hashCode ^
      inStock.hashCode ^
      description.hashCode ^
      brand.hashCode ^
      rating.hashCode;
}
