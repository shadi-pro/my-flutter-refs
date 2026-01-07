import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onRemoveFromCart;
  final VoidCallback? onToggleFavorite;
  final VoidCallback? onTap; // ✅ added for navigation
  final bool isFavorite;
  final bool isInCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onAddToCart,
    this.onRemoveFromCart,
    this.onToggleFavorite,
    this.onTap, // ✅ include in constructor
    required this.isFavorite,
    required this.isInCart,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap, // ✅ navigation callback
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Product image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),

                // Replace Image.network with  Image.asset for testing:
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150, // Fixed height for consistency
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    height: 150,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Image not found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

                // child: Image.network(
                //   product.imageUrl,
                //   fit: BoxFit.cover,
                //   width: double.infinity,
                //   errorBuilder: (context, error, stackTrace) =>
                //       const Icon(Icons.image_not_supported, size: 80),
                // ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Title
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // ✅ Price
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 13,
                      color: scheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
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
          ],
        ),
      ),
    );
  }
}
