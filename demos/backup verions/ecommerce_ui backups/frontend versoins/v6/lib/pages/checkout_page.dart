import 'package:flutter/material.dart';
import '../models/product.dart';
import 'confirmation_page.dart';

class CheckoutPage extends StatelessWidget {
  final List<Product> cartItems;

  const CheckoutPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Cart summary
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartItems[index];
                  return ListTile(
                    leading: Image.asset(product.image, width: 50),
                    title: Text(product.title),
                    subtitle: Text(product.price),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Mock form fields
            TextField(decoration: const InputDecoration(labelText: "Name")),
            TextField(decoration: const InputDecoration(labelText: "Address")),
            TextField(
              decoration: const InputDecoration(labelText: "Payment Method"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ConfirmationPage()),
                );
              },
              child: const Text("Place Order"),
            ),
          ],
        ),
      ),
    );
  }
}
