import 'package:flutter/material.dart';
import '../models/product.dart';

class CartPage extends StatelessWidget {
  final List<Product> cartItems;
  final Function(Product) onRemoveFromCart;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onRemoveFromCart,
  });

  // 👇 Always derive quantities directly from cartItems
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
      final product = entry.key;
      final qty = entry.value;
      final priceValue =
          double.tryParse(product.price.replaceAll(RegExp(r'[^0-9.]'), '')) ??
          0;
      total += priceValue * qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
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
                          leading: Image.asset(product.image, width: 50),
                          title: Text(product.title),
                          subtitle: Text("${product.price} • Qty: $qty"),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              onRemoveFromCart(
                                product,
                              ); // 👈 directly updates Homepage
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${product.title} removed"),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
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
                ),
              ],
            ),
    );
  }
}
