import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final Function(Product) onAddToCart;
  final Function(Product) onRemoveFromCart;
  final Function(Product) onToggleFavorite;
  final List<Product> wishlistItems;
  final List<Product> cartItems;
  final String? selectedCategory;
  final String searchQuery;

  const ProductGrid({
    super.key,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onToggleFavorite,
    required this.wishlistItems,
    required this.cartItems,
    this.selectedCategory,
    this.searchQuery = "",
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        var products = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Product.fromFirestore(data);
        }).toList();

        // ✅ Apply category + search filtering
        final q = searchQuery.trim().toLowerCase();
        products = products.where((p) {
          final byCategory =
              selectedCategory == null || p.category == selectedCategory;
          final bySearch =
              q.isEmpty ||
              p.title.toLowerCase().contains(q) ||
              (p.description ?? '').toLowerCase().contains(q);
          return byCategory && bySearch;
        }).toList();

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 260,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final isFavorite = wishlistItems.contains(product);
            final isInCart = cartItems.contains(product);

            return InkWell(
              onTap: () {
                // 🔜 Future: Navigate to ProductDetailsPage
              },
              child: ProductCard(
                product: product,
                onAddToCart: () => onAddToCart(product),
                onRemoveFromCart: () => onRemoveFromCart(product),
                onToggleFavorite: () => onToggleFavorite(product),
                isFavorite: isFavorite,
                isInCart: isInCart,
              ),
            );
          },
        );
      },
    );
  }
}
