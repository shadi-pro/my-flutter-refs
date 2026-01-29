import 'dart:ui' as ui;

class AppConfig {
  // App Information
  static const String appName = 'مالي';
  static const String appNameEn = 'Finance App';
  static const String version = '1.1.0';
  static const int buildNumber = 1;

  // Localization
  static const ui.Locale defaultLocale = ui.Locale('ar', 'EG');
  static const ui.Locale fallbackLocale = ui.Locale('ar', 'EG');
  static const List<ui.Locale> supportedLocales = [
    ui.Locale('ar', 'EG'),
    ui.Locale('en', 'US'),
  ];

  // Currency
  static const String currencySymbol = 'ج.م';
  static const String currencyCode = 'EGP';
  static const int decimalPlaces = 2;

  // Security
  static const String encryptionKeyStorageKey = 'finance_app_key';
  static const int encryptionKeyLength = 32; // 256-bit for AES

  // Storage Keys
  static const String expensesKey = 'expenses';
  static const String monthlyBudgetKey = 'monthlyBudget';
  static const String categoryBudgetsKey = 'categoryBudgets';
  static const String lastBackupDateKey = 'lastBackupDate';

  // Default Values
  static const double defaultMonthlyBudget = 0.0;
  static const double largeExpenseThreshold = 500.0;
  static const double budgetAlertThreshold = 80.0; // Percentage

  // Date & Time
  static const String dateFormat = 'yyyy/MM/dd';
  static const String dateTimeFormat = 'yyyy/MM/dd HH:mm';
  static const String backupDateFormat = 'yyyyMMdd_HHmmss';

  // File Export
  static const String csvExportPrefix = 'مالي_تصدير_';
  static const String jsonExportPrefix = 'مالي_تصدير_';
  static const String backupFilePrefix = 'finance_backup_';

  // UI Constants
  static const double defaultBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double cardElevation = 2.0;

  // Chart Configuration
  static const int chartMonthsToShow = 6;
  static const double chartBarWidth = 16.0;
  static const int chartMaxAmountDivisions = 5;

  // Search & Filter
  static const double defaultMinAmount = 0.0;
  static const double defaultMaxAmount = 1000000.0;
  static const int searchResultsLimit = 50;

  // Backup & Export
  static const int backupKeepDays = 7;
  static const int maxBackupFiles = 10;

  // Alerts
  static const bool defaultBudgetAlerts = true;
  static const bool defaultLargeExpenseAlerts = true;
  static const bool defaultDailySummary = false;

  // Categories (Arabic)
  static const List<String> expenseCategories = [
    'طعام',
    'مواصلات',
    'تسوق',
    'ترفيه',
    'صحة',
    'تعليم',
    'سكن',
    'فواتير',
    'مرتب',
    'استثمار',
    'هدايا',
    'أخرى'
  ];

  static const List<String> budgetCategories = [
    'طعام',
    'مواصلات',
    'تسوق',
    'ترفيه',
    'صحة',
    'تعليم',
    'سكن',
    'فواتير'
  ];

  // Payment Methods (Arabic)
  static const List<String> paymentMethods = [
    'نقدي',
    'بطاقة ائتمان',
    'تحويل بنكي',
    'محفظة إلكترونية',
    'شيك'
  ];

  // Theme Colors
  static const Map<String, dynamic> lightThemeColors = {
    'primary': 0xFF2196F3,
    'secondary': 0xFF03A9F4,
    'background': 0xFFFAFAFA,
    'surface': 0xFFFFFFFF,
    'error': 0xFFF44336,
    'success': 0xFF4CAF50,
    'warning': 0xFFFF9800,
    'income': 0xFF4CAF50,
    'expense': 0xFFF44336,
  };

  static const Map<String, dynamic> darkThemeColors = {
    'primary': 0xFF64B5F6,
    'secondary': 0xFF4FC3F7,
    'background': 0xFF121212,
    'surface': 0xFF1E1E1E,
    'error': 0xFFCF6679,
    'success': 0xFF81C784,
    'warning': 0xFFFFB74D,
    'income': 0xFF81C784,
    'expense': 0xFFCF6679,
  };

  // App URLs (Update these for production)
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String supportEmail = 'support@example.com';
  static const String websiteUrl = 'https://example.com';

  // Feature Flags (Enable/Disable features)
  static const bool enableBackup = true;
  static const bool enableExport = true;
  static const bool enableAlerts = true;
  static const bool enableAnalytics = true;
  static const bool enableDarkMode = true;
}
