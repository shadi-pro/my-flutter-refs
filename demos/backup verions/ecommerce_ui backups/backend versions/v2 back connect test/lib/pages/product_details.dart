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
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(product.image, height: 220)),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              product.subtitle,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              "Category: ${product.category}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              product.price,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            // Cart button
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart),
              label: Text(isInCart ? "Remove from Cart" : "Add to Cart"),
              onPressed: () {
                if (isInCart) {
                  onRemoveFromCart(product);
                } else {
                  onAddToCart(product);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isInCart
                          ? "${product.title} removed from cart"
                          : "${product.title} added to cart",
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Wishlist button
            ElevatedButton.icon(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              label: Text(
                isFavorite ? "Remove from Wishlist" : "Add to Wishlist",
              ),
              onPressed: () {
                onToggleWishlist(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? "${product.title} removed from wishlist"
                          : "${product.title} added to wishlist",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
