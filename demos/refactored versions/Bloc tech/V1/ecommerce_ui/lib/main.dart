import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'pages/homepage.dart';
import 'utils/app_colors.dart';
import 'blocs/theme/theme_bloc.dart';
import 'blocs/cart/cart_bloc.dart'; // Add this import
import 'repositories/cart_repository.dart'; // Add this import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      rethrow;
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Theme Bloc
        BlocProvider(create: (context) => ThemeBloc()),
        // Cart Bloc
        BlocProvider(
          create: (context) => CartBloc(cartRepository: MockCartRepository()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shadi Ecommerce Demo',

            // Theme configuration
            theme: ThemeData(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryLight,
                secondary: AppColors.accentLight,
                background: AppColors.backgroundLight,
                onBackground: AppColors.textLight,
              ),
              scaffoldBackgroundColor: AppColors.backgroundLight,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.dark(
                primary: AppColors.primaryDark,
                secondary: AppColors.accentDark,
                background: AppColors.backgroundDark,
                onBackground: AppColors.textDark,
              ),
              scaffoldBackgroundColor: AppColors.backgroundDark,
            ),
            themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            home: Homepage(),
          );
        },
      ),
    );
  }
}
