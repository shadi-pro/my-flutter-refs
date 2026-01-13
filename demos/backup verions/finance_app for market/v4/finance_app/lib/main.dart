import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'features/expense/presentation/controllers/expense_controller.dart';
import 'features/expense/presentation/pages/home_page.dart';
import 'features/expense/presentation/controllers/budget_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('ar_EG', null);
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ExpenseController());
    Get.put(BudgetController());

    return GetMaterialApp(
      title: 'Finance App',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'EG'),
      fallbackLocale: const Locale('ar', 'EG'),
      theme: ThemeData.from(
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
        textTheme: GoogleFonts.cairoTextTheme(
          Theme.of(context).textTheme,
        ),
      ).copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue[800],
          centerTitle: true,
          titleTextStyle: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
      home: HomePage(),
    );
  }
}


      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   fontFamily: GoogleFonts.cairo().fontFamily,
      //   textTheme: GoogleFonts.cairoTextTheme(
      //     Theme.of(context).textTheme,
      //   ),

      //   appBarTheme: AppBarTheme(
      //     backgroundColor: Colors.white,
      //     foregroundColor: Colors.blue[800],
      //     elevation: 2,
      //     centerTitle: true,
      //     titleTextStyle: GoogleFonts.cairo(
      //       fontSize: 18,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),

      //   inputDecorationTheme: InputDecorationTheme(
      //     border: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(12),
      //     ),
      //     filled: true,
      //     fillColor: Colors.grey[50],
      //     contentPadding: const EdgeInsets.symmetric(
      //       horizontal: 16,
      //       vertical: 14,
      //     ),
      //   ),

      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Colors.blue,
      //       foregroundColor: Colors.white,
      //       elevation: 4,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(12),
      //       ),
      //       padding: const EdgeInsets.symmetric(
      //         horizontal: 24,
      //         vertical: 14,
      //       ),
      //     ),
      //   ),

      //   // التصحيح هنا: استخدم هذا الـ CardTheme
      //   cardTheme: CardTheme(
      //     elevation: 4,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(16),
      //     ),
      //     margin: const EdgeInsets.all(8),
      //   ),
      // ),