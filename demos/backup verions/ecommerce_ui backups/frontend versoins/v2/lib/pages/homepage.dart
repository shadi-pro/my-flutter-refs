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






 */
// ============================
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';
import 'wishlist_page.dart';
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

  void addToCart(Product product) {
    setState(() {
      cartItems.add(product);
    });
  }

  void removeFromCart(Product product) {
    setState(() {
      cartItems.remove(product);
    });
  }

  void deleteFromCart(Product product) {
    setState(() {
      cartItems.removeWhere((item) => item == product);
    });
  }

  void toggleFavorite(Product product) {
    setState(() {
      if (wishlistItems.contains(product)) {
        wishlistItems.remove(product);
      } else {
        wishlistItems.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      // Home grid
      GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 220,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final isFavorite = wishlistItems.contains(product);
          final isInCart = cartItems.contains(product);
          return ProductCard(
            product: product,
            onAddToCart: () => addToCart(product),
            onRemoveFromCart: () => removeFromCart(product),
            onToggleFavorite: () => toggleFavorite(product),
            isFavorite: isFavorite,
            isInCart: isInCart,
          );
        },
      ),
      CartPage(
        cartItems: cartItems,
        onAddToCart: (product) => addToCart(product),
        onRemoveFromCart: (product) => removeFromCart(product),
        onDeleteFromCart: (product) => deleteFromCart(product),
      ),
      WishlistPage(wishlistItems: wishlistItems),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shadi Ecommerce Demo"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1; // switch to Cart tab
                  });
                },
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
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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
}
