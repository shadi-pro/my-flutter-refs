import '../models/product.dart';

final List<Product> demoProducts = [
  Product(
    imageUrl: "https://via.placeholder.com/150",
    title: "Demo Laptop",
    category: "Electronics",
    price: 999.99,
    inStock: true,
    description: "A powerful demo laptop for testing.",
    brand: "DemoBrand",
    rating: 4.5,
  ),
  Product(
    imageUrl: "https://via.placeholder.com/150",
    title: "Demo Shoes",
    category: "Fashion",
    price: 59.99,
    inStock: false,
    description: "Comfortable demo shoes.",
    brand: "DemoBrand",
    rating: 3.8,
  ),
  Product(
    imageUrl: "https://via.placeholder.com/150",
    title: "Demo Book",
    category: "Books",
    price: 19.99,
    inStock: true,
    description: "An engaging demo book for testing.",
    brand: "DemoPublisher",
    rating: 4.2,
  ),
];
