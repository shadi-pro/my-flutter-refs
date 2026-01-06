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
      imageUrl:
          (data['imageUrl'] != null && (data['imageUrl'] as String).isNotEmpty)
          ? data['imageUrl']
          : 'https://via.placeholder.com/250x250.png?text=No+Image', // ✅ fallback placeholder
      title: data['title'] ?? '', // ✅ fixed field name
      category: data['category'] ?? '',
      price: (data['price'] is int)
          ? (data['price'] as int).toDouble()
          : (data['price'] ?? 0.0).toDouble(),
      inStock: data['inStock'] ?? false,
      description: data['description'],
      brand: data['brand'],
      rating: (data['rating'] is int)
          ? (data['rating'] as int).toDouble()
          : data['rating'],
    );
  }

  // ✅ CopyWith method for BLOC state updates
  Product copyWith({
    String? imageUrl,
    String? title,
    String? category,
    double? price,
    bool? inStock,
    String? description,
    String? brand,
    double? rating,
  }) {
    return Product(
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      category: category ?? this.category,
      price: price ?? this.price,
      inStock: inStock ?? this.inStock,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      rating: rating ?? this.rating,
    );
  }

  // ✅ Override equality for proper list operations in BLOC
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        runtimeType == other.runtimeType &&
        imageUrl == other.imageUrl &&
        title == other.title &&
        category == other.category &&
        price == other.price &&
        inStock == other.inStock &&
        description == other.description &&
        brand == other.brand &&
        rating == other.rating;
  }

  @override
  int get hashCode {
    return imageUrl.hashCode ^
        title.hashCode ^
        category.hashCode ^
        price.hashCode ^
        inStock.hashCode ^
        description.hashCode ^
        brand.hashCode ^
        rating.hashCode;
  }

  // ✅ Optional: ToString for debugging
  @override
  String toString() {
    return 'Product{title: $title, category: $category, price: $price, inStock: $inStock}';
  }
}
