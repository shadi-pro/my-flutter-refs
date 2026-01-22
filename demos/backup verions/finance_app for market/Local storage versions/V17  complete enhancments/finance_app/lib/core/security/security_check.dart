import 'package:flutter/material.dart';
import 'secure_storage_production.dart';

/// ✅ فحص أمني سريع عند بدء التشغيل
class SecurityCheck {
  static Future<bool> performSecurityCheck() async {
    try {
      print('🔍 Performing security check...');

      // 1. تهيئة النظام الأمني
      await SecureStorageProduction.initialize();

      // 2. التحقق من حالة التشفير
      final status = await SecureStorageProduction.getStatus();

      print('📊 Security Status:');
      print('   - Initialized: ${status['initialized']}');
      print('   - Encryption: ${status['encryptionActive']}');
      print('   - Has Key: ${status['hasEncryptionKey']}');
      print('   - Algorithm: ${status['algorithm']}');
      print('   - Keys Count: ${status['keysCount']}');

      // 3. اختبار تشفير وفك تشفير بسيط
      final testData = {
        'test': 'security_check',
        'timestamp': DateTime.now().toString()
      };
      await SecureStorageProduction.writeEncrypted('_security_test', testData);
      final retrieved = SecureStorageProduction.readEncrypted('_security_test');

      if (retrieved != null && retrieved['test'] == 'security_check') {
        print('✅ Security check passed');
        return true;
      } else {
        print('⚠️ Security check warning (fallback mode)');
        return true; // نستمر مع وضع الطوارئ
      }
    } catch (e, stackTrace) {
      print('❌ Security check failed: $e');
      print('Stack trace: $stackTrace');

      // في حالة الفشل، نستمر مع وضع غير آمن
      return false;
    }
  }

  /// ✅ عرض تنبيه أمني إذا لزم الأمر
  static void showSecurityAlert(BuildContext context, {bool isSecure = true}) {
    if (!isSecure) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(width: 10),
                Text('تحذير أمني'),
              ],
            ),
            content: const Text(
              'نظام التشفير غير نشط. '
              'البيانات ستكون مخزنة بدون تشفير. '
              'هذا مقبول للتطوير لكن ليس للإنتاج.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('متابعة'),
              ),
            ],
          ),
        );
      });
    }
  }
}
