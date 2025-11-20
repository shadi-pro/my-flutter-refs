import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromCart;
  final VoidCallback onToggleFavorite;
  final bool isFavorite;
  final bool isInCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onToggleFavorite,
    required this.isFavorite,
    required this.isInCart,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // ✅ Product image
            Expanded(
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 60),
              ),
            ),
            const SizedBox(height: 8),

            // ✅ Title
            Text(
              product.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // ✅ Category
            Text(
              product.category,
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurface.withOpacity(0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // ✅ Price
            Text(
              "\$${product.price.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 14,
                color: scheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // ✅ Stock status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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

            const SizedBox(height: 8),

            // ✅ Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? scheme.primary : scheme.onSurface,
                  ),
                  onPressed: onToggleFavorite,
                ),
                IconButton(
                  icon: Icon(
                    isInCart
                        ? Icons.remove_shopping_cart
                        : Icons.add_shopping_cart,
                    color: isInCart ? scheme.error : scheme.secondary,
                  ),
                  onPressed: isInCart ? onRemoveFromCart : onAddToCart,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
