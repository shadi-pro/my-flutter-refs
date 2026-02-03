// main.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/security/simple_encryption.dart';
import 'core/localization/app_translations.dart';
import 'core/utils/data_migrator.dart';
import 'features/expense/presentation/controllers/expense_controller.dart';
import 'features/expense/presentation/controllers/budget_controller.dart';
import 'features/goals/presentation/controllers/goal_controller.dart';
import 'features/alerts/presentation/controllers/alert_controller.dart';
import 'features/backup/presentation/controllers/backup_controller.dart';
import 'features/search/presentation/controllers/expense_search_controller.dart';
import 'features/expense/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    debugPrint('🚀 Finance App - Starting...');
  }

  try {
    // 1. Initialize Arabic dates
    await initializeDateFormatting('ar_EG', null);
    if (kDebugMode) {
      debugPrint('✅ Dates initialized');
    }

    // 2. Initialize encryption (with fallback)
    try {
      await SimpleEncryption.initialize();
      final String encryptionStatus = SimpleEncryption.status;
      if (kDebugMode) {
        debugPrint('✅ Encryption ready: $encryptionStatus');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Encryption warning: $e - Continuing in fallback mode');
      }
    }

    // 3. Initialize translations (with fallback)
    bool translationsReady = false;
    bool migrationCompleted = false;

    try {
      await AppTranslations.init();
      translationsReady = true;
      if (kDebugMode) {
        debugPrint('✅ Translations initialized');
      }

      // 4. ✅ RUN DATA MIGRATION  - Only if translations are ready
      try {
        if (kDebugMode) {
          debugPrint('🔄 Starting data migration...');
        }
        await DataMigrator.migrateCategories();
        migrationCompleted = true;
        if (kDebugMode) {
          debugPrint('✅ Data migration completed successfully');
        }
      } catch (migrationError) {
        if (kDebugMode) {
          debugPrint('⚠️ Data migration warning: $migrationError');
          debugPrint('⚠️ Continuing with existing data format');
        }
      }

      // Debug: Check translations
      if (kDebugMode) {
        debugPrint('🔍 Translation check:');
        debugPrint(
            '   - Arabic keys: ${AppTranslations.translations['ar']?.length ?? 0}');
        debugPrint(
            '   - English keys: ${AppTranslations.translations['en']?.length ?? 0}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Translations init warning: $e');
        debugPrint('⚠️ Continuing without translations');
      }
    }

    // 5. Run the app
    runApp(MyApp(
      translationsReady: translationsReady,
      migrationCompleted: migrationCompleted,
    ));

    if (kDebugMode) {
      debugPrint('✅ App started successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('❌ App startup error: $e');
    }
    runApp(const EmergencyApp());
  }
}

class MyApp extends StatelessWidget {
  final bool translationsReady;
  final bool migrationCompleted;

  const MyApp({
    super.key,
    this.translationsReady = false,
    this.migrationCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    // Inject controllers
    Get.put(ExpenseController());
    Get.put(BudgetController());
    Get.put(AlertController());
    Get.put(BackupController());
    Get.put(ExpenseSearchController());
    Get.put(GoalController());

    // Show migration status in console
    if (migrationCompleted) {
      if (kDebugMode) {
        debugPrint('✅ App running with migrated data');
      }
    } else if (translationsReady) {
      if (kDebugMode) {
        debugPrint('⚠️ App running with existing data format');
      }
    }

    return GetMaterialApp(
      title: translationsReady ? 'app_title'.tr : 'مالي - Finance App',
      debugShowCheckedModeBanner: false,

      // ============ Language & Localization Settings ============
      translations: translationsReady ? AppTranslations() : null,
      locale: const Locale('ar', 'EG'), // Default language (Arabic)
      fallbackLocale: const Locale('ar', 'EG'), // Fallback language
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('ar', 'EG'), // Arabic - Egypt
        Locale('en', 'US'), // English - USA
      ],
      // GetMaterialApp automatically handles RTL for Arabic, LTR for English
      // ==========================================================

      themeMode: ThemeMode.system,

      // ✅ Light mode:
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xFF1565C0),
        colorScheme: const ColorScheme.light().copyWith(
          primary: const Color(0xFF1565C0),
          secondary: const Color(0xFF42A5F5),
          surface: const Color(0xFFF5F5F5),
          onPrimary: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        textTheme: GoogleFonts.cairoTextTheme(
          ThemeData.light().textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF757575)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1565C0)),
          ),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          hintStyle: const TextStyle(color: Color(0xFF616161)),
          labelStyle: const TextStyle(color: Color(0xFF424242)),
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
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      // ✅ Dark mode:
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF0D47A1),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: const Color(0xFF0D47A1),
          secondary: const Color(0xFF64B5F6),
          surface: const Color(0xFF121212),
          onPrimary: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: GoogleFonts.cairoTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Color(0xFF64B5F6)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF616161)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF64B5F6)),
          ),
          filled: true,
          fillColor: const Color(0xFF2D2D2D),
          hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
          labelStyle: const TextStyle(color: Color(0xFFE0E0E0)),
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
            textStyle: const TextStyle(
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
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Finance App - Emergency Mode'),
        ),
      ),
    );
  }
}
