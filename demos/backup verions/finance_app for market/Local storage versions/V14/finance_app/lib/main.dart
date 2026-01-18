import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/security/simple_encryption.dart';
import 'features/expense/presentation/controllers/expense_controller.dart';
import 'features/expense/presentation/controllers/budget_controller.dart';
import 'features/alerts/presentation/controllers/alert_controller.dart';
import 'features/backup/presentation/controllers/backup_controller.dart';
import 'features/search/presentation/controllers/expense_search_controller.dart';
import 'features/expense/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 Finance App - Starting...');

  try {
    // 1. تهيئة التواريخ العربية
    await initializeDateFormatting('ar_EG', null);
    print('✅ Dates initialized');

    // 2. ✅ تهيئة التشفير
    await SimpleEncryption.initialize();

    // ✅ FIXED: Use .status instead of .encryptionStatus
    final encryptionStatus = SimpleEncryption.status;
    print('✅ Encryption ready: $encryptionStatus');

    // 3. تشغيل التطبيق
    runApp(const MyApp());

    print('✅ App started successfully');
  } catch (e) {
    print('❌ App startup error: $e');
    runApp(const EmergencyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن المتحكمات
    Get.put(ExpenseController());
    Get.put(BudgetController());
    Get.put(AlertController());
    Get.put(BackupController());
    Get.put(ExpenseSearchController(), tag: ExpenseSearchController.TAG);

    return GetMaterialApp(
      title: 'مالي - Finance App',
      debugShowCheckedModeBanner: false,

      // ============ إعدادات اللغة والتوطين ============
      locale: const ui.Locale('ar', 'EG'), // اللغة الافتراضية
      fallbackLocale: const ui.Locale('ar', 'EG'), // اللغة الاحتياطية
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        ui.Locale('ar', 'EG'), // العربية - مصر
        ui.Locale('en', 'US'), // الإنجليزية - أمريكا
      ],
      // ==============================================

      themeMode: ThemeMode.system,

      // ✅ Light mode :
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xFF1565C0), // ✅ Darker primary blue
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF1565C0), // ✅ Dark blue
          secondary: const Color(0xFF42A5F5), // ✅ Lighter blue
          background: Colors.grey[50]!,
          surface: Colors.white,
          onPrimary: Colors.white, // ✅ White text on primary
        ),
        textTheme: GoogleFonts.cairoTextTheme(
          ThemeData.light().textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1565C0), // ✅ Dark blue
          foregroundColor: Colors.white, // ✅ White text
          elevation: 4,
          centerTitle: true,
          titleTextStyle: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1565C0)),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          hintStyle: TextStyle(color: Colors.grey[600]),
          labelStyle: TextStyle(color: Colors.grey[700]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            textStyle: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      // Dark mode :
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF0D47A1), // ✅ Very dark blue
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF0D47A1),
          secondary: const Color(0xFF64B5F6),
          background: const Color(0xFF121212),
          surface: const Color(0xFF1E1E1E),
          onPrimary: Colors.white,
        ),
        textTheme: GoogleFonts.cairoTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0D47A1), // ✅ Very dark blue
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.blue),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF64B5F6)),
          ),
          filled: true,
          fillColor: const Color(0xFF2D2D2D),
          hintStyle: TextStyle(color: Colors.grey[400]),
          labelStyle: TextStyle(color: Colors.grey[300]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D47A1),
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            textStyle: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      home: HomePage(),
    );
  }
}

//  Emeregency Mode :
class EmergencyApp extends StatelessWidget {
  const EmergencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Finance App - Emergency Mode'),
        ),
      ),
    );
  }
}
