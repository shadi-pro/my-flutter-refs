import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistPage extends StatelessWidget {
  final List<Product> wishlistItems;
  final Function(Product) onRemoveFromWishlist;

  const WishlistPage({
    super.key,
    required this.wishlistItems,
    required this.onRemoveFromWishlist,
  });

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
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        onRemoveFromWishlist(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${product.title} removed from wishlist",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
