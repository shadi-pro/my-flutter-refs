// lib/core/utils/data_migrator.dart

import 'package:finance_app/core/security/simple_encryption.dart';
import 'package:flutter/foundation.dart';

class DataMigrator {
  static Future<void> migrateCategories() async {
    try {
      SimpleEncryption.read('expenses');
      // ... migration logic (as provided earlier)
    } catch (e) {
      debugPrint('❌ Migration error: $e'); // FIXED: Changed print to debugPrint
      rethrow;
    }
  }
}
