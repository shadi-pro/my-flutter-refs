import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  Future<void> cacheData(String key, dynamic data, Duration duration) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheItem = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiry': duration.inSeconds,
    };
    await prefs.setString(key, jsonEncode(cacheItem));
  }

  Future<dynamic> getCachedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedString = prefs.getString(key);

    if (cachedString == null) return null;

    try {
      final cacheItem = jsonDecode(cachedString);
      final timestamp = cacheItem['timestamp'] as int;
      final expiry = cacheItem['expiry'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;

      if (now - timestamp < expiry * 1000) {
        return cacheItem['data'];
      } else {
        await prefs.remove(key);
        return null;
      }
    } catch (e) {
      await prefs.remove(key);
      return null;
    }
  }

  Future<void> clearCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
