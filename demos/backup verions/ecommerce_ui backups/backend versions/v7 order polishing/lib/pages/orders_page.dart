/*  
  Page Features :
   1- Live Firestore stream: Uses StreamBuilder to listen to orders collection.

   2- Order summary: Shows order ID, item count, total price, and status.

   3- Expandable details: Tap to expand and see product list inside the order.

   4- Status chip: Displays order status (pending, shipped, etc.).

 Error handling: Shows spinner while loading, message if no orders exist.
 */

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // ✅ for date formatting

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders yet"));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;

              final totalPrice = order["totalPrice"] ?? 0.0;
              final itemCount = order["itemCount"] ?? 0;
              final status = order["status"] ?? "pending";
              final items = order["items"] as List<dynamic>? ?? [];

              // ✅ Format timestamp
              String formattedDate = "";
              if (order["timestamp"] != null) {
                final ts = order["timestamp"] as Timestamp;
                formattedDate = DateFormat(
                  'dd MMM yyyy, HH:mm',
                ).format(ts.toDate());
              }

              // ✅ Status color logic
              Color chipColor;
              switch (status.toLowerCase()) {
                case "completed":
                  chipColor = Colors.green.shade100;
                  break;
                case "cancelled":
                  chipColor = Colors.red.shade100;
                  break;
                default:
                  chipColor = Colors.orange.shade100; // pending
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text(
                    "Order #${orders[index].id.substring(0, 6)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Items: $itemCount • Total: \$${totalPrice.toStringAsFixed(2)} • $formattedDate",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(label: Text(status), backgroundColor: chipColor),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) async {
                          await FirebaseFirestore.instance
                              .collection("orders")
                              .doc(orders[index].id)
                              .update({"status": value});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Order marked as $value")),
                          );
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: "completed",
                            child: Text("Mark as Completed"),
                          ),
                          const PopupMenuItem(
                            value: "cancelled",
                            child: Text("Mark as Cancelled"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  children: items.map((item) {
                    return ListTile(
                      leading: Image.network(
                        item["imageUrl"],
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported),
                      ),
                      title: Text(item["title"]),
                      subtitle: Text(
                        "\$${(item["price"] as num).toStringAsFixed(2)} x ${item["quantity"]}",
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
