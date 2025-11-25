/*    
  Order Cycle:
    Homepage → CartPage → CheckoutPage → Firestore Save → ConfirmationPage → OrdersPage
*/
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/homepage.dart';
import 'utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Robust init: initialize if empty, and ignore duplicate-app if a plugin auto-initialized
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } on FirebaseException catch (e) {
    // Ignore duplicate default app error and continue
    if (e.code != 'duplicate-app') {
      rethrow;
    }
  }

  runApp(const MyApp());
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
      debugShowCheckedModeBanner: false, // ✅ removes debug banner
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
