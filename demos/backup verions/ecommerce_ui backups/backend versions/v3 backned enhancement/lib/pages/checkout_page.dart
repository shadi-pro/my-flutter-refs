import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import 'confirmation_page.dart';

class CheckoutPage extends StatelessWidget {
  final List<Product> cartItems;

  const CheckoutPage({super.key, required this.cartItems});

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
      total += product.price * qty;
    }
    return total;
  }

  Future<void> _placeOrder(BuildContext context) async {
    try {
      final orderData = {
        "items": quantities.entries.map((entry) {
          final product = entry.key;
          final qty = entry.value;
          return {
            "title": product.title,
            "category": product.category,
            "price": product.price,
            "quantity": qty,
            "imageUrl": product.imageUrl,
          };
        }).toList(),
        "totalPrice": totalPrice,
        "itemCount": cartItems.length,
        "timestamp": FieldValue.serverTimestamp(),
        "status": "pending",
      };

      await FirebaseFirestore.instance.collection("orders").add(orderData);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmationPage(
            totalPrice: totalPrice,
            itemCount: cartItems.length,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error placing order: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
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
                          subtitle: Text(
                            "\$${product.price.toStringAsFixed(2)} x $qty",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: scheme.secondary,
                            ),
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
                        icon: const Icon(Icons.check_circle),
                        label: const Text("Place Order"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () => _placeOrder(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
