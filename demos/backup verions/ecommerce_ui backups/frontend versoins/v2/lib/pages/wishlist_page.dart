import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistPage extends StatelessWidget {
  final List<Product> wishlistItems;

  const WishlistPage({super.key, required this.wishlistItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Wishlist")),
      body: wishlistItems.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final product = wishlistItems[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.asset(product.image, width: 50),
                    title: Text(product.title),
                    subtitle: Text(product.price),
                  ),
                );
              },
            ),
    );
  }
}
