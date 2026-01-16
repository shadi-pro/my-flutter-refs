import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorHandler {
  static bool _isShowingDialog = false;

  static void showError(String message, {String title = 'خطأ'}) {
    try {
      // التحقق من null قبل استخدام Get.isSnackbarOpen
      if (Get.isSnackbarOpen == true) {
        Get.back();
      }

      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
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
      );
    } catch (e) {
      print('Failed to show error snackbar: $e');
    }
  }

  static void showSuccess(String message, {String title = 'نجاح'}) {
    try {
      // التحقق من null
      if (Get.isSnackbarOpen == true) {
        Get.back();
      }

      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        icon: const Icon(Icons.check_circle, color: Colors.green),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
      );
    } catch (e) {
      print('Failed to show success snackbar: $e');
    }
  }

  static void showWarning(String message, {String title = 'تحذير'}) {
    try {
      // التحقق من null
      if (Get.isSnackbarOpen == true) {
        Get.back();
      }

      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[900],
        icon: const Icon(Icons.warning, color: Colors.orange),
        margin: const EdgeInsets.all(10),
      );
    } catch (e) {
      print('Failed to show warning snackbar: $e');
    }
  }

  static Future<bool> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'نعم',
    String cancelText = 'لا',
    Color confirmColor = Colors.red,
  }) async {
    if (_isShowingDialog) return false;

    _isShowingDialog = true;

    try {
      final result = await Get.dialog<bool>(
        WillPopScope(
          onWillPop: () async {
            _isShowingDialog = false;
            return true;
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
                child: Text(cancelText, style: const TextStyle(fontSize: 16)),
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
        barrierDismissible: false,
      );

      return result ?? false;
    } catch (e) {
      _isShowingDialog = false;
      print('Failed to show confirmation dialog: $e');
      return false;
    }
  }

  static void handleApiError(dynamic error) {
    if (error is String) {
      showError(error);
    } else if (error is Exception) {
      showError(error.toString());
    } else {
      showError('حدث خطأ غير متوقع');
    }
  }

  static void showLoading({String message = 'جاري التحميل...'}) {
    // التحقق من null باستخدام Get.isDialogOpen == true
    if (Get.isDialogOpen != true) {
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text(message),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  static void hideLoading() {
    // التحقق من null باستخدام Get.isDialogOpen == true
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }
}
