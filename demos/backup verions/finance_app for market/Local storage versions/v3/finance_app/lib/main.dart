import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart'; // أضف هذا

import 'features/expense/presentation/controllers/expense_controller.dart';
import 'features/expense/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. تهيئة تنسيق التاريخ للغة العربية
  await initializeDateFormatting('ar_EG', null);

  // 2. تهيئة GetStorage
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ExpenseController());

    return GetMaterialApp(
      title: 'Finance App',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'EG'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.cairo().fontFamily,
      ),
      home: HomePage(),
    );
  }
}
