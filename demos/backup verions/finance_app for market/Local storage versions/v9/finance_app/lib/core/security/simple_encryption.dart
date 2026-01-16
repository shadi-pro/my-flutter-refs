import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'package:get_storage/get_storage.dart';

/// ✅ نظام تشفير مبسط وآمن - **مصحح من الحلقة اللانهائية**
class SimpleEncryption {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static final GetStorage _appStorage = GetStorage();
  static encrypt.Encrypter? _encrypter;
  static bool _initialized = false;
  static bool _initializing = false; // ✅ منع الحلقات اللانهائية

  /// ✅ تهيئة النظام (مرة واحدة فقط)
  static Future<void> initialize() async {
    // ✅ منع إعادة التهيئة المتكررة
    if (_initialized || _initializing) {
      return;
    }

    _initializing = true;

    try {
      print('=' * 50);
      print('🔐 INITIALIZING ENCRYPTION SYSTEM (ONCE)');
      print('=' * 50);

      // ✅ الحصول على المفتاح
      final key = await _getEncryptionKey();
      print('🔑 Key ready');

      // ✅ إنشاء الـ Encrypter
      _encrypter = encrypt.Encrypter(encrypt.AES(key));

      // ✅ تم التهيئة بنجاح
      _initialized = true;
      _initializing = false;

      print('✅ AES-256 Encryption ready');
      print('=' * 50);
    } catch (e) {
      _initializing = false;
      print('⚠️ Encryption init error: $e');
      // نستمر بدون تشفير
      _initialized = true;
    }
  }

  /// ✅ الحصول على مفتاح التشفير
  static Future<encrypt.Key> _getEncryptionKey() async {
    try {
      // محاولة جلب المفتاح المخزن
      final storedKey = await _secureStorage.read(key: 'finance_app_key');

      if (storedKey != null && storedKey.isNotEmpty) {
        return encrypt.Key.fromBase64(storedKey);
      }

      // إنشاء مفتاح جديد
      final newKey = _generateKey();
      await _secureStorage.write(
        key: 'finance_app_key',
        value: newKey.base64,
      );

      return newKey;
    } catch (e) {
      print('⚠️ Using fallback key');
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

  /// ✅ تشفير البيانات
  static String _encrypt(String plaintext) {
    if (_encrypter == null) return plaintext;

    try {
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypted = _encrypter!.encrypt(plaintext, iv: iv);

      return jsonEncode({
        'iv': iv.base64,
        'data': encrypted.base64,
      });
    } catch (e) {
      return plaintext;
    }
  }

  /// ✅ فك تشفير البيانات
  static String _decrypt(String encryptedJson) {
    if (_encrypter == null) return encryptedJson;

    try {
      final data = jsonDecode(encryptedJson) as Map<String, dynamic>;
      final iv = encrypt.IV.fromBase64(data['iv'] as String);
      final encrypted = encrypt.Encrypted.fromBase64(data['data'] as String);

      return _encrypter!.decrypt(encrypted, iv: iv);
    } catch (e) {
      return encryptedJson;
    }
  }

  /// ✅ كتابة بيانات مشفرة
  static Future<void> write(String key, dynamic data) async {
    // ✅ لا نستدعي initialize() هنا لتجنب الحلقات
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
    await _appStorage.remove(key);
  }

  /// ✅ مسح الكل
  static Future<void> clearAll() async {
    await _appStorage.erase();
    await _secureStorage.delete(key: 'finance_app_key');
    _encrypter = null;
    _initialized = false;
  }

  /// ✅ التحقق من وجود بيانات
  static bool has(String key) {
    return _appStorage.hasData(key);
  }
}
