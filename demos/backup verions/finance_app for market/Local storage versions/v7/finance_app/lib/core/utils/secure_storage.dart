import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class SecureStorage {
  static encrypt.Encrypter? _encrypter;
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // ✅ مفتاح 32 حرف بالضبط
      final keyString = '00001111222233334444555566667777';

      print('🔑 Key: $keyString');
      print('🔑 Key length: ${keyString.length}');

      final key = encrypt.Key.fromUtf8(keyString);
      _encrypter = encrypt.Encrypter(encrypt.AES(key));
      _initialized = true;
      print('✅ Encryption initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize encryption: $e');
      _initialized = false;
    }
  }

  static Future<void> writeEncrypted(String key, dynamic data) async {
    try {
      if (!_initialized) {
        await initialize();
      }

      if (_encrypter == null) {
        print('⚠️ Encrypter not initialized, saving without encryption');
        await GetStorage().write(key, data);
        return;
      }

      final jsonString = jsonEncode(data);
      final iv = encrypt.IV.fromLength(16);
      final encrypted = _encrypter!.encrypt(jsonString, iv: iv);

      await GetStorage().write(key, encrypted.base64);
      await GetStorage().write('${key}_iv', iv.base64);
      print('✅ Data encrypted and saved for key: $key');
    } catch (e) {
      print('❌ Error writing encrypted data: $e');
      // Fallback: حفظ بدون تشفير
      await GetStorage().write(key, data);
    }
  }

  static dynamic readEncrypted(String key) {
    try {
      if (!_initialized) {
        initialize();
      }

      final encryptedBase64 = GetStorage().read(key);
      final ivBase64 = GetStorage().read('${key}_iv');

      if (encryptedBase64 == null) {
        return GetStorage().read(key); // حاول قراءة غير مشفرة
      }

      if (_encrypter == null) {
        return GetStorage().read(key);
      }

      final encrypted = encrypt.Encrypted.fromBase64(encryptedBase64);
      final iv = ivBase64 != null
          ? encrypt.IV.fromBase64(ivBase64)
          : encrypt.IV.fromLength(16);

      final decrypted = _encrypter!.decrypt(encrypted, iv: iv);
      return jsonDecode(decrypted);
    } catch (e) {
      print('❌ Error reading encrypted data for key $key: $e');
      // Fallback: قراءة بدون تشفير
      return GetStorage().read(key);
    }
  }

  static Future<void> remove(String key) async {
    await GetStorage().remove(key);
    await GetStorage().remove('${key}_iv');
  }

  static Future<void> erase() async {
    await GetStorage().erase();
  }

  static bool hasData(String key) {
    return GetStorage().hasData(key);
  }

  // دالة لتحويل البيانات القديمة
  static Future<void> migrateOldData() async {
    try {
      final storage = GetStorage();
      final oldData = storage.read('expenses');

      if (oldData != null && oldData is List) {
        await writeEncrypted('expenses', oldData);
        await storage.remove('expenses');
      }
    } catch (e) {
      print('❌ Error migrating old data: $e');
    }
  }
}
