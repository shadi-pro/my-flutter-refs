import 'dart:async'; //  for  TimeoutException
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Remove the Logger import for now  :
// import 'package:logger/logger.dart';

class ErrorHandler {
  static bool _isShowingDialog = false;

  // Simple logging methods until we add the logger package
  static void _log(String level, String message,
      {dynamic error, dynamic stackTrace}) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] [$level] $message');
    if (error != null) {
      print('Error: $error');
    }
    if (stackTrace != null) {
      print('Stack trace: $stackTrace');
    }
  }

  static void showError(String message, {String title = 'خطأ'}) {
    try {
      // Close any existing snackbars
      if (Get.isSnackbarOpen == true) {
        Get.back();
      }

      _log('ERROR', '$title - $message');

      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        icon: const Icon(Icons.error, color: Colors.red),
        shouldIconPulse: true,
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
        animationDuration: const Duration(milliseconds: 300),
        mainButton: TextButton(
          onPressed: () => Get.back(),
          child: const Text('إغلاق', style: TextStyle(color: Colors.red)),
        ),
        onTap: (_) => Get.back(),
      );
    } catch (e) {
      _log('ERROR', 'Failed to show error snackbar: $e');
      // Fallback to console
      print('ERROR: $title - $message');
    }
  }

  static void showSuccess(String message, {String title = 'نجاح'}) {
    try {
      if (Get.isSnackbarOpen == true) {
        Get.back();
      }

      _log('INFO', '$title - $message');

      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        icon: const Icon(Icons.check_circle, color: Colors.green),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (_) => Get.back(),
      );
    } catch (e) {
      _log('ERROR', 'Failed to show success snackbar: $e');
      print('SUCCESS: $title - $message');
    }
  }

  static void showWarning(String message, {String title = 'تحذير'}) {
    try {
      if (Get.isSnackbarOpen == true) {
        Get.back();
      }

      _log('WARNING', '$title - $message');

      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[900],
        icon: const Icon(Icons.warning, color: Colors.orange),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (_) => Get.back(),
      );
    } catch (e) {
      _log('ERROR', 'Failed to show warning snackbar: $e');
      print('WARNING: $title - $message');
    }
  }

  static Future<bool> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'نعم',
    String cancelText = 'لا',
    Color confirmColor = Colors.red,
    bool barrierDismissible = false,
  }) async {
    if (_isShowingDialog) return false;

    _isShowingDialog = true;
    _log('DEBUG', 'Showing confirmation dialog: $title');

    try {
      final result = await Get.dialog<bool>(
        WillPopScope(
          onWillPop: () async {
            _isShowingDialog = false;
            return barrierDismissible;
          },
          child: AlertDialog(
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Text(message),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _isShowingDialog = false;
                  Get.back(result: false);
                },
                child: Text(cancelText,
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  _isShowingDialog = false;
                  Get.back(result: true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: confirmColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(confirmText, style: const TextStyle(fontSize: 16)),
              ),
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        barrierDismissible: barrierDismissible,
      );

      final bool finalResult = result ?? false;
      _log('DEBUG', 'Confirmation dialog result: $finalResult');
      return finalResult;
    } catch (e) {
      _isShowingDialog = false;
      _log('ERROR', 'Failed to show confirmation dialog: $e');
      return false;
    }
  }

  static void handleApiError(dynamic error, {String? context}) {
    String errorMessage = 'حدث خطأ غير متوقع';

    if (error is String) {
      errorMessage = error;
    } else if (error is FormatException) {
      errorMessage = 'خطأ في تنسيق البيانات';
    } else if (error is TimeoutException) {
      errorMessage = 'انتهت مهلة الاتصال';
    } else if (error is Exception) {
      errorMessage = error.toString();
    }

    _log('ERROR', 'API Error${context != null ? " in $context" : ""}: $error');
    showError(errorMessage);
  }

  static void showLoading({String message = 'جاري التحميل...'}) {
    try {
      if (Get.isDialogOpen != true) {
        _log('DEBUG', 'Showing loading dialog: $message');

        Get.dialog(
          WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(message),
                    ],
                  ),
                ),
              ),
            ),
          ),
          barrierDismissible: false,
        );
      }
    } catch (e) {
      _log('ERROR', 'Failed to show loading dialog: $e');
    }
  }

  static void hideLoading() {
    try {
      if (Get.isDialogOpen == true) {
        _log('DEBUG', 'Hiding loading dialog');
        Get.back();
      }
    } catch (e) {
      _log('ERROR', 'Failed to hide loading dialog: $e');
    }
  }

  static void logInfo(String message, {String? tag}) {
    _log('INFO', '${tag != null ? '[$tag] ' : ''}$message');
  }

  static void logWarning(String message, {String? tag}) {
    _log('WARNING', '${tag != null ? '[$tag] ' : ''}$message');
  }

  static void logError(String message,
      {String? tag, dynamic error, dynamic stackTrace}) {
    _log('ERROR', '${tag != null ? '[$tag] ' : ''}$message',
        error: error, stackTrace: stackTrace);
  }

  static void logDebug(String message, {String? tag}) {
    _log('DEBUG', '${tag != null ? '[$tag] ' : ''}$message');
  }
}
