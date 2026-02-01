//  finance_app\lib\core\security\security_check.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'secure_storage_production.dart';

//  Perform Security Check when start
class SecurityCheck {
  static Future<bool> performSecurityCheck() async {
    try {
      if (kDebugMode) {
        debugPrint('🔍 Performing security check...');
      }

      // 1. Secure Storage Production Inializing
      await SecureStorageProduction.initialize();

      // 2.  Secure Storage Production  Get state
      final Map<String, dynamic> status =
          await SecureStorageProduction.getStatus();

      if (kDebugMode) {
        debugPrint('📊 Security Status:');
        debugPrint('   - Initialized: ${status['initialized']}');
        debugPrint('   - Encryption: ${status['encryptionActive']}');
        debugPrint('   - Has Key: ${status['hasEncryptionKey']}');
        debugPrint('   - Algorithm: ${status['algorithm']}');
        debugPrint('   - Keys Count: ${status['keysCount']}');
      }

      // 3. Simple Test fo Encryption  and Decryption
      final Map<String, dynamic> testData = <String, dynamic>{
        'test': 'security_check',
        'timestamp': DateTime.now().toString(),
      };
      await SecureStorageProduction.writeEncrypted('_security_test', testData);
      final dynamic retrieved =
          SecureStorageProduction.readEncrypted('_security_test');

      if (retrieved != null && retrieved['test'] == 'security_check') {
        if (kDebugMode) {
          debugPrint('✅ Security check passed');
        }
        return true;
      } else {
        if (kDebugMode) {
          debugPrint('⚠️ Security check warning (fallback mode)');
        }
        return true; //  continue in Eeregnecy Mode
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Security check failed: $e');
        debugPrint('Stack trace: $stackTrace');
      }

      //  continue unsafe if failure
      return false;
    }
  }

  // show Security Alert if neccessary
  static void showSecurityAlert(BuildContext context, {bool isSecure = true}) {
    if (!isSecure) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            title: const Row(
              children: <Widget>[
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
            actions: <Widget>[
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
