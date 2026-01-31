// FILE: lib/core/utils/error_handler.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorHandler {
  static bool _isShowingDialog = false;

  // Simple logging methods
  static void _log(String level, String message,
      {dynamic error, dynamic stackTrace}) {
    final timestamp = DateTime.now().toIso8601String();

    if (error != null) {}
    if (stackTrace != null) {}
  }

  static void showError(String message, {String title = ''}) {
    try {
      // Close any existing snackbars
      if (Get.isSnackbarOpen == true) {
        Get.back();
      }

      final finalTitle = title.isNotEmpty ? title : 'error'.tr;
      _log('ERROR', '$finalTitle - $message');

      Get.snackbar(
        finalTitle,
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
          child: Text('close'.tr, style: const TextStyle(color: Colors.red)),
        ),
        onTap: (_) => Get.back(),
      );
    } catch (e) {
      _log('ERROR', 'Failed to show error snackbar: $e');
    }
  }

  static void showSuccess(String message, {String title = ''}) {
    try {
      if (Get.isSnackbarOpen == true) {
        Get.back();
      }

      final finalTitle = title.isNotEmpty ? title : 'success'.tr;
      _log('INFO', '$finalTitle - $message');

      Get.snackbar(
        finalTitle,
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
    }
  }

  static void showWarning(String message, {String title = ''}) {
    try {
      if (Get.isSnackbarOpen == true) {
        Get.back();
      }

      final finalTitle = title.isNotEmpty ? title : 'warning'.tr;
      _log('WARNING', '$finalTitle - $message');

      Get.snackbar(
        finalTitle,
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
    }
  }

  static Future<bool> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = '',
    String cancelText = '',
    Color confirmColor = Colors.red,
    bool barrierDismissible = false,
  }) async {
    if (_isShowingDialog) return false;

    _isShowingDialog = true;
    _log('DEBUG', 'Showing confirmation dialog: $title');

    try {
      final finalConfirmText = confirmText.isNotEmpty ? confirmText : 'yes'.tr;
      final finalCancelText = cancelText.isNotEmpty ? cancelText : 'no'.tr;

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
                child: Text(
                  finalCancelText,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
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
                child: Text(
                  finalConfirmText,
                  style: const TextStyle(fontSize: 16),
                ),
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
    String errorMessage = 'unexpected_error'.tr;

    if (error is String) {
      errorMessage = error;
    } else if (error is FormatException) {
      errorMessage = 'data_format_error'.tr;
    } else if (error is TimeoutException) {
      errorMessage = 'connection_timeout'.tr;
    } else if (error is Exception) {
      errorMessage = error.toString();
    }

    _log('ERROR', 'API Error${context != null ? " in $context" : ""}: $error');
    showError(errorMessage);
  }

  static void showLoading({String message = ''}) {
    try {
      if (Get.isDialogOpen != true) {
        final finalMessage = message.isNotEmpty ? message : 'loading'.tr;
        _log('DEBUG', 'Showing loading dialog: $finalMessage');

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
                      Text(finalMessage),
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
