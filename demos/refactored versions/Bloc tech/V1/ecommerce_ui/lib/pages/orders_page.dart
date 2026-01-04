import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'login_page.dart';
import 'homepage.dart'; // ✅ import homepage

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String? _userName;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      final data = doc.data();
      setState(() {
        _userName = data?["name"] ?? user.email;
      });
    }
  }

  Future<void> _updateOrderStatus(String orderId, String value) async {
    setState(() => _isUpdating = true);
    try {
      await FirebaseFirestore.instance.collection("orders").doc(orderId).update(
        {"status": value},
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Order marked as $value")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update order: $e")));
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders (${_userName ?? "Loading..."})"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // ✅ Always go back to Homepage instead of pop
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Homepage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("userId", isEqualTo: user.uid)
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "You haven’t placed any orders yet",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final orderId = orders[index].id;

              final totalPrice = order["totalPrice"] ?? 0.0;
              final itemCount = order["itemCount"] ?? 0;
              final status = order["status"] ?? "pending";
              final items = order["items"] as List<dynamic>? ?? [];

              String formattedDate = "";
              if (order["timestamp"] != null) {
                final ts = order["timestamp"] as Timestamp;
                formattedDate = DateFormat(
                  'dd MMM yyyy, HH:mm',
                ).format(ts.toDate());
              }

              Color chipColor;
              switch (status.toLowerCase()) {
                case "completed":
                  chipColor = Colors.green.shade100;
                  break;
                case "cancelled":
                  chipColor = Colors.red.shade100;
                  break;
                default:
                  chipColor = Colors.orange.shade100;
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text(
                    "Order #${orderId.substring(0, 6)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Items: $itemCount • Total: \$${totalPrice.toStringAsFixed(2)} • $formattedDate",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(
                        label: Text(
                          status,
                          style: TextStyle(
                            color: chipColor.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        backgroundColor: chipColor,
                      ),
                      PopupMenuButton<String>(
                        icon: _isUpdating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.more_vert),
                        onSelected: (value) =>
                            _updateOrderStatus(orderId, value),
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
                    return Column(
                      children: [
                        ListTile(
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
                        ),
                        const Divider(height: 1),
                      ],
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
