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
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  product.subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  product.price,
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: onToggleFavorite,
              ),
              IconButton(
                icon: Icon(
                  isInCart
                      ? Icons.remove_shopping_cart
                      : Icons.add_shopping_cart,
                  color: Colors.blue,
                ),
                onPressed: isInCart ? onRemoveFromCart : onAddToCart,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
