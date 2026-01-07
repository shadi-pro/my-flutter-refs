import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../data/products.dart';
import 'cart_page.dart';
import 'wishlist_page.dart';
import 'product_details.dart';
import 'settings_page.dart';
import 'orders_page.dart';

// BLOC Imports
import '../blocs/theme/theme_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/wishlist/wishlist_bloc.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen for cart events to show snackbars
        BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!)));
            }
          },
        ),
      ],
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          final cartBloc = BlocProvider.of<CartBloc>(context);
          final scheme = Theme.of(context).colorScheme;

          final pages = [
            // Home Page with Product Grid
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, productState) {
                final productBloc = BlocProvider.of<ProductBloc>(context);

                return BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, wishlistState) {
                    return Column(
                      children: [
                        // Category Chips
                        SizedBox(
                          height: 84,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            children: [
                              _buildCategoryChip(
                                "All",
                                Icons.apps,
                                scheme,
                                null, // Use null for "All"
                                productBloc,
                                productState.selectedCategory,
                              ),
                              _buildCategoryChip(
                                "Electronics",
                                Icons.devices,
                                scheme,
                                "Electronics",
                                productBloc,
                                productState.selectedCategory,
                              ),
                              _buildCategoryChip(
                                "Fashion",
                                Icons.checkroom,
                                scheme,
                                "Fashion",
                                productBloc,
                                productState.selectedCategory,
                              ),
                              _buildCategoryChip(
                                "Books",
                                Icons.book,
                                scheme,
                                "Books",
                                productBloc,
                                productState.selectedCategory,
                              ),
                              _buildCategoryChip(
                                "Sports",
                                Icons.sports_soccer,
                                scheme,
                                "Sports",
                                productBloc,
                                productState.selectedCategory,
                              ),
                              _buildCategoryChip(
                                "Accessories",
                                Icons.shopping_bag,
                                scheme,
                                "Accessories",
                                productBloc,
                                productState.selectedCategory,
                              ),
                            ],
                          ),
                        ),

                        // Product Grid
                        Expanded(
                          child: _buildProductGrid(
                            context,
                            productState,
                            wishlistState,
                            cartState,
                            productBloc,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            // Cart Page - Now using CartBloc directly
            _buildCartPage(context, cartBloc, cartState),

            // Wishlist Page - Using WishlistBloc
            BlocBuilder<WishlistBloc, WishlistState>(
              builder: (context, wishlistState) {
                final wishlistBloc = BlocProvider.of<WishlistBloc>(context);
                return WishlistPage(
                  wishlistItems: wishlistState.wishlistItems,
                  onRemoveFromWishlist: (product) {
                    wishlistBloc.add(RemoveFromWishlist(product));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${product.title} removed from wishlist"),
                      ),
                    );
                  },
                );
              },
            ),

            // Orders Page
            const OrdersPage(),

            // Settings Page
            const SettingsPage(),
          ];

          return Scaffold(
            appBar: AppBar(
              title: const Text("Shadi Ecommerce Demo"),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, productState) {
                      final productBloc = BlocProvider.of<ProductBloc>(context);
                      return TextField(
                        decoration: InputDecoration(
                          hintText: "Search products...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: scheme.surface.withOpacity(0.06),
                        ),
                        onChanged: (value) {
                          productBloc.add(SearchProducts(value));
                        },
                      );
                    },
                  ),
                ),
              ),
              actions: [
                // Cart Icon with Badge
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () => setState(() => _selectedIndex = 1),
                    ),
                    if (cartState.itemCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: scheme.error,
                          child: Text(
                            cartState.itemCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // Wishlist Icon with Badge
                BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, wishlistState) {
                    return Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite),
                          onPressed: () => setState(() => _selectedIndex = 2),
                        ),
                        if (wishlistState.wishlistItems.isNotEmpty)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: scheme.primary,
                              child: Text(
                                wishlistState.wishlistItems.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),

            drawer: _buildDrawer(context, scheme),

            body: _selectedIndex < pages.length
                ? pages[_selectedIndex]
                : pages[0],

            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                if (index < pages.length) {
                  setState(() => _selectedIndex = index);
                }
              },
              selectedItemColor: scheme.secondary,
              unselectedItemColor: scheme.onSurface.withOpacity(0.6),
              backgroundColor: scheme.surface,
              type: BottomNavigationBarType.fixed,
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
                  icon: Icon(Icons.receipt_long),
                  label: "Orders",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "Settings",
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(
    BuildContext context,
    ProductState productState,
    WishlistState wishlistState,
    CartState cartState,
    ProductBloc productBloc,
  ) {
    if (productState.status == ProductStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (productState.status == ProductStatus.error) {
      return Center(child: Text("Error: ${productState.error}"));
    }

    final products = productState.filteredProducts.isNotEmpty
        ? productState.filteredProducts
        : productState.allProducts;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 260,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isFavorite = wishlistState.wishlistItems.contains(product);
        final isInCart = cartState.cartItems.contains(product);

        return ProductCard(
          product: product,
          isFavorite: isFavorite,
          isInCart: isInCart,
          onToggleFavorite: () {
            final wishlistBloc = BlocProvider.of<WishlistBloc>(context);
            final cartBloc = BlocProvider.of<CartBloc>(context);

            if (isFavorite) {
              wishlistBloc.add(RemoveFromWishlist(product));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${product.title} removed from wishlist"),
                ),
              );
            } else {
              wishlistBloc.add(AddToWishlist(product));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${product.title} added to wishlist")),
              );
            }
          },
          onAddToCart: () {
            final cartBloc = BlocProvider.of<CartBloc>(context);
            cartBloc.add(AddToCart(product));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${product.title} added to cart")),
            );
          },
          onRemoveFromCart: () {
            final cartBloc = BlocProvider.of<CartBloc>(context);
            cartBloc.add(RemoveFromCart(product));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${product.title} removed from cart")),
            );
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailsPage(
                  product: product,
                  onAddToCart: (p) {
                    final cartBloc = BlocProvider.of<CartBloc>(context);
                    cartBloc.add(AddToCart(p));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${p.title} added to cart")),
                    );
                  },
                  onRemoveFromCart: (p) {
                    final cartBloc = BlocProvider.of<CartBloc>(context);
                    cartBloc.add(RemoveFromCart(p));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${p.title} removed from cart")),
                    );
                  },
                  onToggleFavorite: (p) {
                    final wishlistBloc = BlocProvider.of<WishlistBloc>(context);
                    final isCurrentlyFavorite = wishlistState.wishlistItems
                        .contains(p);

                    if (isCurrentlyFavorite) {
                      wishlistBloc.add(RemoveFromWishlist(p));
                    } else {
                      wishlistBloc.add(AddToWishlist(p));
                    }
                  },
                  isInCart: isInCart,
                  isFavorite: isFavorite,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCartPage(
    BuildContext context,
    CartBloc cartBloc,
    CartState cartState,
  ) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return CartPage(
          cartItems: state.cartItems,
          onAddToCart: (product) {
            cartBloc.add(AddToCart(product));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${product.title} added to cart")),
            );
          },
          onRemoveFromCart: (product) {
            cartBloc.add(RemoveFromCart(product));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${product.title} removed from cart")),
            );
          },
          onDeleteFromCart: (product) {
            // Remove all instances of this product
            for (final item in state.cartItems) {
              if (item.title == product.title && item.price == product.price) {
                cartBloc.add(RemoveFromCart(item));
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${product.title} removed from cart")),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryChip(
    String category,
    IconData icon,
    ColorScheme scheme,
    String? categoryValue,
    ProductBloc productBloc,
    String? selectedCategory,
  ) {
    // ✅ FIXED LOGIC: "All" highlights when selectedCategory is null
    // Other categories highlight when selectedCategory matches
    final bool isSelected =
        (category == "All" && selectedCategory == null) ||
        (category != "All" && selectedCategory == categoryValue);

    final bg = isSelected
        ? scheme.secondary.withOpacity(0.20)
        : scheme.surface.withOpacity(0.06);
    final iconColor = isSelected ? scheme.secondary : scheme.onSurface;

    return GestureDetector(
      onTap: () {
        // ✅ For "All" send null, for others send the category value
        final filterValue = category == "All" ? null : categoryValue;
        productBloc.add(FilterProductsByCategory(filterValue));
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

  Drawer _buildDrawer(BuildContext context, ColorScheme scheme) {
    return Drawer(
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
            leading: const Icon(Icons.receipt_long),
            title: const Text("Orders"),
            onTap: () {
              setState(() => _selectedIndex = 3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              setState(() => _selectedIndex = 4);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
