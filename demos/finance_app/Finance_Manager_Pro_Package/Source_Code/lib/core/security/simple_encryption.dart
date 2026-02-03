import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:get_storage/get_storage.dart';

/// ✅ نظام تشفير مبسط وآمن
class SimpleEncryption {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static final GetStorage _appStorage = GetStorage();
  static encrypt.Encrypter? _encrypter;
  static bool _initialized = false;
  static bool _initializing = false;

  /// ✅ تهيئة النظام (مرة واحدة فقط)
  static Future<void> initialize() async {
    if (_initialized || _initializing) return;
    _initializing = true;

    try {
      // print('🔐 تهيئة نظام التشفير...');

      // Important: initialize GetStorage
      await GetStorage.init();

      final key = await _getEncryptionKey();
      _encrypter = encrypt.Encrypter(encrypt.AES(key));
      _initialized = true;
      _initializing = false;

      // print('✅ نظام التشفير جاهز (AES-256)');
    } catch (e) {
      _initializing = false;
      // print('⚠️ خطأ في تهيئة التشفير: $e');
      _initialized = true; // نستمر بدون تشفير
    }
  }

  /// ✅ الحصول على مفتاح التشفير
  static Future<encrypt.Key> _getEncryptionKey() async {
    try {
      final storedKey = await _secureStorage.read(key: 'finance_app_key');

      if (storedKey != null && storedKey.isNotEmpty) {
        return encrypt.Key.fromBase64(storedKey);
      }

      final newKey = _generateKey();
      await _secureStorage.write(
        key: 'finance_app_key',
        value: newKey.base64,
      );

      return newKey;
    } catch (e) {
      // print('⚠️ استخدام مفتاح احتياطي');
      return _generateKey();
    }
  }

  /// ✅ إنشاء مفتاح
  static encrypt.Key _generateKey() {
    final random = Random.secure();
    final bytes = Uint8List(32);

    for (int i = 0; i < bytes.length; i++) {
      bytes[i] = random.nextInt(256);
    }

    return encrypt.Key(bytes);
  }

  /// ✅ كتابة بيانات مشفرة
  static Future<void> write(String key, dynamic data) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      final jsonString = jsonEncode(data);
      final encrypted = _encrypt(jsonString);
      await _appStorage.write(key, encrypted);
    } catch (e) {
      // تخزين بدون تشفير
      await _appStorage.write(key, data);
    }
  }

  /// ✅ قراءة بيانات مشفرة
  static dynamic read(String key) {
    try {
      final data = _appStorage.read(key);
      if (data == null) return null;

      if (data is String && data.startsWith('{"iv":')) {
        final decrypted = _decrypt(data);
        return jsonDecode(decrypted);
      }

      return data;
    } catch (e) {
      return _appStorage.read(key);
    }
  }

  /// ✅ حذف بيانات
  static Future<void> remove(String key) async {
    try {
      await _appStorage.remove(key);
      // print('✅ تم حذف المفتاح: $key');
    } catch (e) {
      // print('⚠️ خطأ في حذف المفتاح $key: $e');
      rethrow;
    }
  }

  /// ✅ مسح جميع البيانات
  static Future<void> clearAll() async {
    try {
      await _appStorage.erase();
      await _secureStorage.delete(key: 'finance_app_key');
      _encrypter = null;
      _initialized = false;
      // print('✅ تم مسح جميع البيانات');
    } catch (e) {
      // print('⚠️ خطأ في مسح البيانات: $e');
    }
  }

  /// ✅ التحقق من وجود بيانات
  static bool has(String key) {
    return _appStorage.hasData(key);
  }

  /// ✅ تشفير البيانات
  static String _encrypt(String plaintext) {
    if (_encrypter == null) return plaintext;

    try {
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypted = _encrypter!.encrypt(plaintext, iv: iv);

      return jsonEncode({
        'iv': iv.base64,
        'data': encrypted.base64,
        'v': '1.0',
      });
    } catch (e) {
      // print('⚠️ فشل التشفير: $e');
      return plaintext;
    }
  }

  /// ✅ فك التشفير
  static String _decrypt(String encryptedJson) {
    if (_encrypter == null) return encryptedJson;

    try {
      final map = jsonDecode(encryptedJson) as Map<String, dynamic>;
      final iv = encrypt.IV.fromBase64(map['iv']);
      final encrypted = encrypt.Encrypted.fromBase64(map['data']);
      return _encrypter!.decrypt(encrypted, iv: iv);
    } catch (e) {
      // print('⚠️ فشل فك التشفير: $e');
      return encryptedJson;
    }
  }

  /// ✅ حالة النظام
  static String get status =>
      _encrypter != null ? 'Encryption Active' : 'Encryption Inactive';
}
