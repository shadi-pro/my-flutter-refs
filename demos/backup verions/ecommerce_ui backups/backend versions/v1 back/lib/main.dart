/*  [ E-commerce] project :
  - UI flutter design of a close real project  with same functionalities of real  E-commerce project   
  - This proejct will be applied wit real api and backend side  withrfuturistic versions    
   
     
   A]  project structure :
      assets/
        images/
          laptop.jpg
          smartphone.jpg
          watch.jpg
          bag.jpg
          tshirt.jpg
          shoes.jpg
      lib/
        main.dart
        models/
          product.dart
        data/
          products.dart
        pages/
          homepage.dart
          cart_page.dart
          product_details.dart
          wishlist_page.dart
        widgets/
          product_card.dart
          category_item.dart
        utils/
          app_colors.dart
          app_styles.dart

  // -----------------------------------
  B]  Project Features :

  🔹 Core Structure
  1- Main Entry (main.dart) :
    - Initializes the app with MaterialApp.
    - Sets theme and routes into Homepage.

  2- Data Layer
    - models/product.dart: Defines Product model with equality overrides.
    - data/products.dart: Static product list with images, titles, subtitles, and prices.

  3- UI Pages (pages/) :
    - homepage.dart:
    - Displays product grid.

Integrates cart and wishlist state.

Bottom navigation for Home, Cart, Wishlist.

Cart badge on AppBar.

cart_page.dart:

Shows cart items with quantities.

Calculates and displays total price.

Allows removing items from cart.

wishlist_page.dart:

Displays favorited products.

Simple list view with product info.

product_details.dart:

Shows product image, title, subtitle, and price.

“Add to Cart” button with snackbar feedback.

Reusable Widgets (widgets/)

product_card.dart:

Displays product image, title, price.

Supports add/remove from cart.

Wishlist toggle (favorite icon).

Navigates to product details page.

category_item.dart:

Circular icon + label for product categories.

Ready for homepage category row integration.

Utils (utils/)

app_colors.dart: Centralized color palette (primary, accent, background).

app_styles.dart: Reusable text styles (heading, price).

Assets (assets/images/)

Contains product images (laptop, smartphone, watch, bag, tshirt, shoes).

🚀 Current Functionalities
Product grid with cart and wishlist integration.

Cart page with dynamic quantities and total price calculation.

Wishlist page for favorites.

Product details page with add‑to‑cart action.

Reusable widgets for products and categories.

Consistent design system with centralized colors and styles.



  // -----------------------------------
  C]




*/
//===================================================
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // NEW: Firebase core import
import 'firebase_options.dart'; // NEW: Generated options file
import 'pages/homepage.dart';
import 'utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // NEW: ensures async setup works
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // NEW: initialize Firebase
  );
  runApp(const MyApp()); // unchanged: your UI entry point
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() => isDarkMode = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadi Ecommerce Demo',
      theme: ThemeData(
        primaryColor: isDarkMode
            ? AppColors.primaryDark
            : AppColors.primaryLight,
        scaffoldBackgroundColor: isDarkMode
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        colorScheme: isDarkMode
            ? ColorScheme.dark(
                primary: AppColors.primaryDark,
                secondary: AppColors.accentDark,
                background: AppColors.backgroundDark,
                onBackground: AppColors.textDark,
              )
            : ColorScheme.light(
                primary: AppColors.primaryLight,
                secondary: AppColors.accentLight,
                background: AppColors.backgroundLight,
                onBackground: AppColors.textLight,
              ),
      ),
      home: Homepage(onToggleTheme: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}
