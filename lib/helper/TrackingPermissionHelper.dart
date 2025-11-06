import 'package:flutter/material.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'dart:io';

class TrackingPermissionHelper {
  static bool _shownThisSession = false;

  static Future<void> requestTrackingPermission() async {
    // Only request on iOS
    if (!Platform.isIOS) {
      debugPrint('Tracking permission only available on iOS, skipping...');
      return;
    }

    // prevent multiple popups in same session
    if (_shownThisSession) return;
    _shownThisSession = true;

    try {
      // optional: wait for UI load
      await Future.delayed(const Duration(milliseconds: 500));

      // check status
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;

      if (status == TrackingStatus.notDetermined) {
        // show the iOS popup
        await AppTrackingTransparency.requestTrackingAuthorization();
      }

      final newStatus =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      debugPrint('Tracking permission status: $newStatus');
    } catch (e) {
      // Handle any errors gracefully
      debugPrint('Error requesting tracking permission: $e');
      // Continue execution even if tracking permission fails
    }
  }
}
