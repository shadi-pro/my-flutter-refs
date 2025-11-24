import 'package:flutter/material.dart';

class ConfirmationPage extends StatelessWidget {
  final double totalPrice;
  final int itemCount;

  const ConfirmationPage({
    super.key,
    required this.totalPrice,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Order Confirmation")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 16),
              const Text(
                "Thank you for your order!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "Items: $itemCount\nTotal: \$${totalPrice.toStringAsFixed(2)}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: scheme.onSurface),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text("Back to Home"),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
