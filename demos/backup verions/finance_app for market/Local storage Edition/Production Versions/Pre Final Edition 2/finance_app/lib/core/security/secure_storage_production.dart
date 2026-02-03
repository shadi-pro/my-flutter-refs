// finance_app\lib\core\security\secure_storage_production.dart

import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'package:get_storage/get_storage.dart';
// ----------------------------------------

///   Simple and secure encryping system for production
class SecureStorageProduction {
  static const FlutterSecureStorage _secureStorage =
      FlutterSecureStorage();
  static final GetStorage _appStorage = GetStorage();
  static encrypt.Encrypter? _encrypter;
  static bool _initialized = false;

  // Disabling  Intializer
  SecureStorageProduction._();

  // Sytstem  Inaitializer
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      if (kDebugMode) {
        debugPrint('🔐 Starting encryption system...');
      }

      // 1. Inaitializing  GetStorage
      await GetStorage.init();

      // 2. Geting  EncryptionKey
      final encryptionKey = await _getOrCreateEncryptionKey();

      // 3.  Inaitializing   Encrypter
      _encrypter = encrypt.Encrypter(encrypt.AES(
        encrypt.Key.fromBase64(encryptionKey),
      ));

      // 4. Old Data Migration
      await _migrateOldData();

      _initialized = true;
      if (kDebugMode) {
        debugPrint('✅ Encryption system ready (AES-256)');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Encryption init warning: $e');
      }
      // continue wihtout Encryption as  alternative
      _initialized = true;
    }
  }

  /// Geting the Encryption key or create a new one
  static Future<String> _getOrCreateEncryptionKey() async {
    try {
      //  Try get the key from a Secure Storage
      final String? storedKey = await _secureStorage.read(key: 'aes_256_key');

      if (storedKey != null && storedKey.length >= 32) {
        return storedKey;
      }

      //  Generate new EncryptionKey
      final String newKey = _generateEncryptionKey();
      await _secureStorage.write(key: 'aes_256_key', value: newKey);

      return newKey;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Using fallback encryption key');
      }
      //  Alternactive key  (to be changed in the production)
      return 'ZmFuYW5jZV9hcHBfc2VjdXJlX2tleQ=='; // base64 لـ "finance_app_secure_key"
    }
  }

  ///  Generate Encryption strong Key
  static String _generateEncryptionKey() {
    final Random random = Random.secure();
    final List<int> bytes = List<int>.generate(32, (_) => random.nextInt(256));

    //  using  SHA-256  for more random
    final String timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    final Uint8List combined =
        Uint8List.fromList([...bytes, ...utf8.encode(timestamp)]);
    final Digest hash = sha256.convert(combined);

    return base64Encode(hash.bytes.sublist(0, 32));
  }

  // Encrypting Data
  static String _encryptData(String plaintext) {
    if (_encrypter == null) {
      throw Exception('Encryption system not ready');
    }

    try {
      // using IV  for each encryption processs
      final encrypt.IV iv = encrypt.IV.fromSecureRandom(16);

      // Encrypting  proecess
      final encrypt.Encrypted encrypted =
          _encrypter!.encrypt(plaintext, iv: iv);

      // تخزين IV مع البيانات (base64)
      return jsonEncode(<String, String>{
        'iv': iv.base64,
        'data': encrypted.base64,
        'v': '1.0', // إصدار التشفير
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Encryption failed: $e');
      }
      throw Exception('فشل في تشفير البيانات');
    }
  }

  //  Decrypt Data
  static String _decryptData(String encryptedJson) {
    if (_encrypter == null) {
      throw Exception('Encryption system not ready');
    }

    try {
      final Map<String, dynamic> data =
          jsonDecode(encryptedJson) as Map<String, dynamic>;

      final encrypt.IV iv = encrypt.IV.fromBase64(data['iv'] as String);
      final encrypt.Encrypted encrypted =
          encrypt.Encrypted.fromBase64(data['data'] as String);

      return _encrypter!.decrypt(encrypted, iv: iv);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Decryption failed: $e');
      }
      throw Exception('فشل في فك تشفير البيانات');
    }
  }

  ///  write Encrypted data
  static Future<void> writeEncrypted(String key, dynamic data) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      String jsonData;

      if (data is Map || data is List) {
        jsonData = jsonEncode(data);
      } else if (data is String) {
        jsonData = data;
      } else {
        jsonData = jsonEncode(data);
      }

      //   EncryptData + Storing
      final String encrypted = _encryptData(jsonData);
      await _appStorage.write(key, encrypted);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Writing unencrypted data for key: $key');
      }
      //  UnEncripted Storing  (alternavtive solution )
      await _appStorage.write(key, data);
    }
  }

  // Read Encrypted data
  static dynamic readEncrypted(String key) {
    if (!_initialized) {
      throw Exception('Storage not initialized');
    }

    try {
      final dynamic data = _appStorage.read(key);

      if (data == null) return null;

      //   Decrypting data if data is exisited and  contain iv
      if (data is String && data.contains('"iv"') && data.contains('"data"')) {
        final String decrypted = _decryptData(data);
        return jsonDecode(decrypted);
      }

      // if the old data non encrypted
      return data;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error reading key $key: $e');
      }
      return _appStorage.read(key); // returning non encrypted
    }
  }

  //  Remove  Data
  static Future<void> remove(String key) async {
    try {
      await _appStorage.remove(key);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error removing key $key: $e');
      }
    }
  }

  // Removing all data
  static Future<void> erase() async {
    try {
      await _appStorage.erase();
      await _secureStorage.delete(key: 'aes_256_key');
      if (kDebugMode) {
        debugPrint('✅ All data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error clearing data: $e');
      }
    }
  }

  // Checking if data  existance
  static bool hasData(String key) {
    return _appStorage.hasData(key);
  }

  // Migrate Old Data
  static Future<void> _migrateOldData() async {
    try {
      final List<String> migrationKeys = <String>[
        'expenses',
        'monthlyBudget',
        'categoryBudgets'
      ];

      for (final String key in migrationKeys) {
        final dynamic oldData = _appStorage.read(key);

        if (oldData != null) {
          if (kDebugMode) {
            debugPrint('🔄 Migrating $key...');
          }
          await writeEncrypted(key, oldData);
          if (kDebugMode) {
            debugPrint('✅ $key migrated');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Migration error: $e');
      }
    }
  }

  // Get systyem state
  static Future<Map<String, dynamic>> getStatus() async {
    final bool hasKey = await _secureStorage.containsKey(key: 'aes_256_key');

    return <String, dynamic>{
      'initialized': _initialized,
      'encryptionActive': _encrypter != null,
      'hasEncryptionKey': hasKey,
      'algorithm': _encrypter != null ? 'AES-256-CBC' : 'None',
      'storageProvider': 'GetStorage + FlutterSecureStorage',
      'keysCount': _appStorage.getKeys().length,
    };
  }
}
