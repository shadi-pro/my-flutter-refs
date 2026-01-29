import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/security/simple_encryption.dart';
import 'core/localization/app_translations.dart';
import 'features/expense/presentation/controllers/expense_controller.dart';
import 'features/expense/presentation/controllers/budget_controller.dart';
import 'features/goals/presentation/controllers/goal_controller.dart';
import 'features/alerts/presentation/controllers/alert_controller.dart';
import 'features/backup/presentation/controllers/backup_controller.dart';
import 'features/search/presentation/controllers/expense_search_controller.dart';
import 'features/expense/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // print('🚀 Finance App - Starting...');

  try {
    // 1. Initialize Arabic dates
    await initializeDateFormatting('ar_EG', null);
    // print('✅ Dates initialized');

    // 2. Initialize encryption (with fallback)
    try {
      await SimpleEncryption.initialize();
      final encryptionStatus = SimpleEncryption.status;
      // print('✅ Encryption ready: $encryptionStatus');
    } catch (e) {
      // print('⚠️ Encryption warning: $e - Continuing in fallback mode');
    }

    // 3. Initialize translations (with fallback)
    bool translationsReady = false;
    try {
      await AppTranslations.init();
      translationsReady = true;
      // print('✅ Translations initialized');

      // Debug: Check translations
      // print('🔍 Translation check:');
      // print('   - Arabic keys: ${AppTranslations.translations['ar']?.length ?? 0}');
      // print('   - English keys: ${AppTranslations.translations['en']?.length ?? 0}');
    } catch (e) {
      // print('⚠️ Translations init warning: $e');
      // print('⚠️ Continuing without translations');
    }

    // 4. Run the app
    runApp(MyApp(translationsReady: translationsReady));

    // print('✅ App started successfully');
  } catch (e) {
    // } catch (e, stackTrace) {
    // print('❌ App startup error: $e');
    // print('Stack trace: $stackTrace');
    runApp(const EmergencyApp());
  }
}

class MyApp extends StatelessWidget {
  final bool translationsReady;

  const MyApp({super.key, this.translationsReady = false});

  @override
  Widget build(BuildContext context) {
    // Inject controllers
    Get.put(ExpenseController());
    Get.put(BudgetController());
    Get.put(AlertController());
    Get.put(BackupController());
    Get.put(ExpenseSearchController(), tag: ExpenseSearchController.TAG);
    Get.put(GoalController());

    return GetMaterialApp(
      title: translationsReady ? 'app_title'.tr : 'مالي - Finance App',
      debugShowCheckedModeBanner: false,

      // ============ Language & Localization Settings ============
      translations: translationsReady ? AppTranslations() : null,
      locale: const Locale('ar', 'EG'), // Default language (Arabic)
      fallbackLocale: const Locale('ar', 'EG'), // Fallback language
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'EG'), // Arabic - Egypt
        Locale('en', 'US'), // English - USA
      ],
      // GetMaterialApp automatically handles RTL for Arabic, LTR for English
      // ==========================================================

      themeMode: ThemeMode.system,

      // ✅ Light mode:
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xFF1565C0),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF1565C0),
          secondary: const Color(0xFF42A5F5),
          background: Colors.grey[50]!,
          surface: Colors.white,
          onPrimary: Colors.white,
        ),
        textTheme: GoogleFonts.cairoTextTheme(
          ThemeData.light().textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1565C0),
          foregroundColor: Colors.white,
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

      // ✅ Dark mode:
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF0D47A1),
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
          backgroundColor: const Color(0xFF0D47A1),
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

// Emergency Mode (if app fails to start)
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
