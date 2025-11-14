import 'package:flutter/material.dart';
import '../data/products.dart';
import '../widgets/product_card.dart';
import '../widgets/category_item.dart';
import '../pages/cart_page.dart';
import '../models/product.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  final List<Product> _cartItems = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [_buildHomePage(), CartPage(cartItems: _cartItems)];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Search bar
        TextFormField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: "Search products...",
            border: InputBorder.none,
            fillColor: Colors.grey[200],
            filled: true,
          ),
        ),
        const SizedBox(height: 20),

        // Categories
        const Text(
          "Categories",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CategoryItem(icon: Icons.laptop, title: "Laptop"),
              CategoryItem(icon: Icons.phone_android, title: "Mobile"),
              CategoryItem(icon: Icons.electric_bike, title: "Bike"),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Products grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 220,
          ),
          itemCount: products.length,
          itemBuilder: (context, i) {
            return ProductCard(
              product: products[i],
              onAddToCart: () {
                setState(() {
                  _cartItems.add(products[i]);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${products[i].title} added to cart")),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
