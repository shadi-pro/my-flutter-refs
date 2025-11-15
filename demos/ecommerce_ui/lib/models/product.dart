class Product {
  final String image;
  final String title;
  final String subtitle;
  final String price;

  Product({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          image == other.image &&
          title == other.title &&
          subtitle == other.subtitle &&
          price == other.price;

  @override
  int get hashCode =>
      image.hashCode ^ title.hashCode ^ subtitle.hashCode ^ price.hashCode;
}
