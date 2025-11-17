import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';
import 'wishlist_page.dart';
import 'product_details.dart';
import '../data/products.dart';
import 'settings_page.dart';

class Homepage extends StatefulWidget {
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  const Homepage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Product> cartItems = [];
  final List<Product> wishlistItems = [];
  int _selectedIndex = 0;
  String? selectedCategory;
  String searchQuery = "";

  void addToCart(Product product) {
    setState(() => cartItems.add(product));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("${product.title} added to cart")));
  }

  void removeFromCart(Product product) {
    setState(() => cartItems.remove(product));
  }

  void deleteFromCart(Product product) {
    setState(() => cartItems.removeWhere((item) => item == product));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product.title} removed from cart")),
    );
  }

  void toggleFavorite(Product product) {
    setState(() {
      if (wishlistItems.contains(product)) {
        wishlistItems.remove(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${product.title} removed from wishlist")),
        );
      } else {
        wishlistItems.add(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${product.title} added to wishlist")),
        );
      }
    });
  }

  void removeFromWishlist(Product product) {
    setState(() => wishlistItems.remove(product));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final q = searchQuery.trim().toLowerCase();
    final filteredProducts = products.where((p) {
      final byCategory =
          selectedCategory == null || p.category == selectedCategory;
      final bySearch =
          q.isEmpty ||
          p.title.toLowerCase().contains(q) ||
          p.subtitle.toLowerCase().contains(q);
      return byCategory && bySearch;
    }).toList();

    final pages = [
      // Home page
      Column(
        children: [
          SizedBox(
            height: 84,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _buildCategoryChip("All", Icons.apps, scheme),
                _buildCategoryChip("Electronics", Icons.devices, scheme),
                _buildCategoryChip("Fashion", Icons.checkroom, scheme),
                _buildCategoryChip("Books", Icons.book, scheme),
                _buildCategoryChip("Sports", Icons.sports_soccer, scheme),
                _buildCategoryChip("Accessories", Icons.shopping_bag, scheme),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 260,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final isFavorite = wishlistItems.contains(product);
                final isInCart = cartItems.contains(product);

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsPage(
                          product: product,
                          onAddToCart: addToCart,
                          onRemoveFromCart: removeFromCart,
                          onToggleWishlist: toggleFavorite,
                          isInCart: isInCart,
                          isFavorite: isFavorite,
                        ),
                      ),
                    );
                  },
                  child: ProductCard(
                    product: product,
                    onAddToCart: () => addToCart(product),
                    onRemoveFromCart: () => removeFromCart(product),
                    onToggleFavorite: () => toggleFavorite(product),
                    isFavorite: isFavorite,
                    isInCart: isInCart,
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Cart page
      CartPage(
        cartItems: cartItems,
        onAddToCart: addToCart,
        onRemoveFromCart: removeFromCart,
        onDeleteFromCart: deleteFromCart,
      ),

      // Wishlist page
      WishlistPage(
        wishlistItems: wishlistItems,
        onRemoveFromWishlist: removeFromWishlist,
      ),

      // Settings tab
      SettingsPage(
        onToggleTheme: widget.onToggleTheme,
        isDarkMode: widget.isDarkMode,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shadi Ecommerce Demo"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: scheme.surface.withOpacity(0.06),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
        ),
        actions: [
          // Cart badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => setState(() => _selectedIndex = 1),
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: scheme.error,
                    child: Text(
                      "${cartItems.length}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          // Wishlist badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () => setState(() => _selectedIndex = 2),
              ),
              if (wishlistItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: scheme.primary,
                    child: Text(
                      "${wishlistItems.length}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Shadi User"),
              accountEmail: const Text("shadisayed.68911@gmail.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/shadi.jpg"),
              ),
              decoration: BoxDecoration(color: scheme.primary),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("Cart"),
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Wishlist"),
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                setState(() => _selectedIndex = 3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      body: pages[_selectedIndex],

      // ✅ Fixed BottomNavigationBar colors
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: scheme.secondary,
        unselectedItemColor: scheme.onSurface.withOpacity(0.6),
        backgroundColor: scheme.surface,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    String category,
    IconData icon,
    ColorScheme scheme,
  ) {
    final isSelected =
        selectedCategory == category ||
        (category == "All" && selectedCategory == null);

    final bg = isSelected
        ? scheme.secondary.withOpacity(0.20)
        : scheme.surface.withOpacity(0.06);
    final iconColor = isSelected ? scheme.secondary : scheme.onSurface;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category == "All" ? null : category;
        });
      },
      child: Container(
        width: 90,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? scheme.secondary
                : scheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(height: 4),
            Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: iconColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
