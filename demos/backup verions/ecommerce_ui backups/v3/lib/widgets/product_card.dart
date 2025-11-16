import 'package:flutter/material.dart';
import '../models/product.dart';
import '../pages/product_details.dart';

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
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsPage(
                product: product,
                onAddToCart: onAddToCart,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(product.image, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                product.price,
                style: const TextStyle(color: Colors.orange, fontSize: 14),
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
                TextButton.icon(
                  onPressed: isInCart ? onRemoveFromCart : onAddToCart,
                  icon: Icon(
                    isInCart
                        ? Icons.remove_shopping_cart
                        : Icons.add_shopping_cart,
                  ),
                  label: Text(isInCart ? "Remove" : "Add"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
