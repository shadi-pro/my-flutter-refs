import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  final Function(Product) onAddToCart;
  final Function(Product) onRemoveFromCart;
  final Function(Product) onToggleWishlist;
  final bool isInCart;
  final bool isFavorite;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onToggleWishlist,
    required this.isInCart,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? scheme.primary : scheme.onSurface,
            ),
            onPressed: () => onToggleWishlist(product),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Product image
            Center(
              child: Image.network(
                product.imageUrl,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 100),
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Title
            Text(
              product.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            // ✅ Category
            Text(
              "Category: ${product.category}",
              style: TextStyle(
                fontSize: 16,
                color: scheme.onSurface.withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 8),

            // ✅ Price
            Text(
              "\$${product.price.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: scheme.secondary,
              ),
            ),

            const SizedBox(height: 12),

            // ✅ Stock status
            Row(
              children: [
                Icon(
                  product.inStock ? Icons.check_circle : Icons.cancel,
                  color: product.inStock ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  product.inStock ? "Available" : "Out of Stock",
                  style: TextStyle(
                    fontSize: 16,
                    color: product.inStock ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔜 Future fields (extend Firestore schema later)
            Text(
              "Description: ${product.description ?? 'No description yet'}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              "Brand: ${product.brand ?? 'Unknown'}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(
                  product.rating != null
                      ? "${product.rating}/5"
                      : "No rating yet",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ✅ Cart button
            Center(
              child: ElevatedButton.icon(
                icon: Icon(
                  isInCart
                      ? Icons.remove_shopping_cart
                      : Icons.add_shopping_cart,
                ),
                label: Text(isInCart ? "Remove from Cart" : "Add to Cart"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInCart ? scheme.error : scheme.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () =>
                    isInCart ? onRemoveFromCart(product) : onAddToCart(product),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
