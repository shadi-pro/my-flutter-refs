import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import 'orders_page.dart';

class CartPage extends StatefulWidget {
  final List<Product> cartItems;
  final void Function(Product) onAddToCart;
  final void Function(Product) onRemoveFromCart;
  final void Function(Product) onDeleteFromCart;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onDeleteFromCart,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isLoading = false;

  Map<Product, int> get quantities {
    final map = <Product, int>{};
    for (var product in widget.cartItems) {
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

  Future<void> _checkout(BuildContext context) async {
    if (quantities.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Your cart is empty")));
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must be logged in to place an order"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final order = {
        "userId": user.uid,
        "items": quantities.entries
            .map(
              (entry) => {
                "title": entry.key.title,
                "price": entry.key.price,
                "quantity": entry.value,
                "imageUrl": entry.key.imageUrl,
              },
            )
            .toList(),
        "totalPrice": totalPrice,
        "itemCount": quantities.values.fold<int>(0, (sum, qty) => sum + qty),
        "status": "pending",
        "timestamp": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection("orders").add(order);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully")),
      );

      // Clear cart using the callback
      for (var product in widget.cartItems.toList()) {
        widget.onDeleteFromCart(product);
      }

      // ✅ Use push (not pushReplacement) so back arrow works
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OrdersPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to place order: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
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
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () =>
                                    widget.onRemoveFromCart(product), // ✅
                              ),
                              Text("$qty"),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () =>
                                    widget.onAddToCart(product), // ✅
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  widget.onDeleteFromCart(product); // ✅
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
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.payment),
                        label: Text(
                          _isLoading ? "Processing..." : "Proceed to Checkout",
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: _isLoading ? null : () => _checkout(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
