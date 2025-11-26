import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import 'product_details.dart';

class WishlistPage extends StatefulWidget {
  final List<Product> wishlistItems;
  final Function(Product) onRemoveFromWishlist;

  const WishlistPage({
    super.key,
    required this.wishlistItems,
    required this.onRemoveFromWishlist,
  });

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  bool _isLoading = false;

  Future<void> _removeFromWishlist(
    BuildContext context,
    Product product,
  ) async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // ✅ remove from Firestore wishlist collection
        final snapshot = await FirebaseFirestore.instance
            .collection("wishlist")
            .where("userId", isEqualTo: user.uid)
            .where("title", isEqualTo: product.title)
            .get();

        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }

      widget.onRemoveFromWishlist(product);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${product.title} removed from wishlist")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to remove: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (widget.wishlistItems.isEmpty) {
      return const Center(
        child: Text("Your wishlist is empty", style: TextStyle(fontSize: 18)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: widget.wishlistItems.length,
      itemBuilder: (context, index) {
        final product = widget.wishlistItems[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Image.network(
              product.imageUrl,
              width: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported),
            ),
            title: Text(product.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Category: ${product.category}"),
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: scheme.secondary,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      product.inStock ? Icons.check_circle : Icons.cancel,
                      color: product.inStock ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.inStock ? "In Stock" : "Out of Stock",
                      style: TextStyle(
                        fontSize: 12,
                        color: product.inStock ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: _isLoading
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.delete, color: Colors.red),
              onPressed: _isLoading
                  ? null
                  : () => _removeFromWishlist(context, product),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailsPage(
                    product: product,
                    onAddToCart: (_) {}, // can be wired later
                    onRemoveFromCart: (_) {},
                    onToggleFavorite: (_) =>
                        _removeFromWishlist(context, product),
                    isInCart: false,
                    isFavorite: true,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
