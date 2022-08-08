import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class Toasts {
  static void showErrorToast(message) async {
    showOverlayNotification(
      (context) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Material(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: double.maxFinite,
                height: 100,
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    message,
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      position: NotificationPosition.bottom,
      duration: const Duration(seconds: 4),
    );
  }

  static void showSuccessToast(message) async {
    showOverlayNotification((context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Material(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: double.maxFinite,
              height: 100,
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  message,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
        position: NotificationPosition.bottom,
        duration: const Duration(seconds: 4));
  }
}
