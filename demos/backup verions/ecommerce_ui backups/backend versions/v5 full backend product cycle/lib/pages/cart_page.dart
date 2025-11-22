import 'package:flutter/material.dart';
import '../models/product.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  final List<Product> cartItems;
  final Function(Product) onAddToCart;
  final Function(Product) onRemoveFromCart;
  final Function(Product) onDeleteFromCart;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onDeleteFromCart,
  });

  Map<Product, int> get quantities {
    final map = <Product, int>{};
    for (var product in cartItems) {
      map[product] = (map[product] ?? 0) + 1;
    }
    return map;
  }

  double get totalPrice {
    double total = 0;
    for (var entry in quantities.entries) {
      total += entry.key.price * entry.value;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: quantities.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: quantities.length,
                    itemBuilder: (context, index) {
                      final product = quantities.keys.elementAt(index);
                      final qty = quantities[product] ?? 1;

                      return Card(
                        margin: const EdgeInsets.all(8),
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
                                    product.inStock
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: product.inStock
                                        ? Colors.green
                                        : Colors.red,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.inStock
                                        ? "In Stock"
                                        : "Out of Stock",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: product.inStock
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => onRemoveFromCart(
                                  product,
                                ), // ✅ always remove
                              ),
                              Text("$qty"),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => onAddToCart(product),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  onDeleteFromCart(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("${product.title} removed"),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.payment),
                        label: const Text("Proceed to Checkout"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CheckoutPage(cartItems: cartItems),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
