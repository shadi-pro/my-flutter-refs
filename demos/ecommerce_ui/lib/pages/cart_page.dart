import 'package:flutter/material.dart';
import '../models/product.dart';

class CartPage extends StatelessWidget {
  final List<Product> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, i) {
                final product = cartItems[i];
                return ListTile(
                  leading: Image.asset(
                    product.image,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.title),
                  subtitle: Text(product.price),
                  trailing: const Icon(Icons.delete, color: Colors.red),
                );
              },
            ),
    );
  }
}
