import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_details.dart';

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
    final scheme = Theme.of(context).colorScheme;

    if (wishlistItems.isEmpty) {
      return const Center(
        child: Text("Your wishlist is empty", style: TextStyle(fontSize: 18)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: wishlistItems.length,
      itemBuilder: (context, index) {
        final product = wishlistItems[index];

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
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                onRemoveFromWishlist(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${product.title} removed from wishlist"),
                  ),
                );
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailsPage(
                    product: product,
                    onAddToCart: (_) {},
                    onRemoveFromCart: (_) {},
                    onToggleWishlist: (_) => onRemoveFromWishlist(product),
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
