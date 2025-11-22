/*   

  a- main features :
   1- navigation button to  in-delaited [product_details] page => wihtin each product  main card 
 
   2- navigattion button to  [wishlist] page => 
      - by each product card 
       
   3- navigattion button to  [Cartlist] page =>  
      - by appbar icon 
      - wihtin each product card 
      - wihtin bottom navigation bar button icon   

   
   4-  
  -------------------------------------

  b-  : 


    // ============================
 */
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';
import 'wishlist_page.dart';
import 'product_details.dart';
import '../data/products.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Product> cartItems = [];
  final List<Product> wishlistItems = [];
  int _selectedIndex = 0;
  String? selectedCategory;

  // Cart actions
  void addToCart(Product product) {
    setState(() => cartItems.add(product));
  }

  void removeFromCart(Product product) {
    setState(() => cartItems.remove(product));
  }

  void deleteFromCart(Product product) {
    setState(() => cartItems.removeWhere((item) => item == product));
  }

  // Wishlist actions
  void toggleFavorite(Product product) {
    setState(() {
      if (wishlistItems.contains(product)) {
        wishlistItems.remove(product);
      } else {
        wishlistItems.add(product);
      }
    });
  }

  void removeFromWishlist(Product product) {
    setState(() => wishlistItems.remove(product));
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = selectedCategory == null
        ? products
        : products.where((p) => p.category == selectedCategory).toList();

    final pages = [
      Column(
        children: [
          // Categories row
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryIcon("All", Icons.apps),
                _buildCategoryIcon("Electronics", Icons.devices),
                _buildCategoryIcon("Fashion", Icons.checkroom),
                _buildCategoryIcon("Books", Icons.book),
                _buildCategoryIcon("Sports", Icons.sports_soccer),
                _buildCategoryIcon("Accessories", Icons.shopping_bag),
              ],
            ),
          ),
          // Product grid
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
                          onAddToCart: (p) => addToCart(p),
                          onRemoveFromCart: (p) => removeFromCart(p),
                          onToggleWishlist: (p) => toggleFavorite(p),
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
      CartPage(
        cartItems: cartItems,
        onAddToCart: (product) => addToCart(product),
        onRemoveFromCart: (product) => removeFromCart(product),
        onDeleteFromCart: (product) => deleteFromCart(product),
      ),
      WishlistPage(
        wishlistItems: wishlistItems,
        onRemoveFromWishlist: (product) => removeFromWishlist(product),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shadi Ecommerce Demo"),
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
                    backgroundColor: Colors.red,
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
                    backgroundColor: Colors.red,
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
              accountEmail: const Text("shadisayed68911@gmail.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/shadi.jpg"),
              ),
              decoration: const BoxDecoration(color: Colors.blue),
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
          ],
        ),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
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
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(String category, IconData icon) {
    final isSelected =
        selectedCategory == category ||
        (category == "All" && selectedCategory == null);
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category == "All" ? null : category;
        });
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.orange : Colors.black),
            const SizedBox(height: 4),
            Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
