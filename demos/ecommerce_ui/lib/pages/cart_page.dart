import 'package:flutter/material.dart';
import '../models/product.dart';

class CartPage extends StatefulWidget {
  final List<Product> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Map<Product, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    for (var product in widget.cartItems) {
      _quantities[product] = (_quantities[product] ?? 0) + 1;
    }
  }

  double get totalPrice {
    double total = 0;
    for (var entry in _quantities.entries) {
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
      body: _quantities.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _quantities.length,
                    itemBuilder: (context, index) {
                      final product = _quantities.keys.elementAt(index);
                      final qty = _quantities[product] ?? 1;

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: Image.asset(product.image, width: 50),
                          title: Text(product.title),
                          subtitle: Text("${product.price} • Qty: $qty"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (qty > 1) {
                                      _quantities[product] = qty - 1;
                                    } else {
                                      _quantities.remove(product);
                                    }
                                  });
                                },
                              ),
                              Text("$qty"),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    _quantities[product] = qty + 1;
                                  });
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
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Checkout not implemented yet"),
                            ),
                          );
                        },
                        icon: const Icon(Icons.payment),
                        label: const Text("Proceed to Checkout"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
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
