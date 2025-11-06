import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateUsHelper {
  static const String _keyShown = 'rate_us_shown';

  /// Call this on button click
  static Future<void> showRateUsPopupOnce() async {
    // final prefs = await SharedPreferences.getInstance();
    // final alreadyShown = prefs.getBool(_keyShown) ?? false;

    // if (alreadyShown) {
    //   debugPrint("Rate Us popup already shown once.");
    //   return;
    // }

    final inAppReview = InAppReview.instance;

    // if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview(); // shows system popup
      // await prefs.setBool(_keyShown, true); // mark as shown
    // } else {
      // fallback: open app store page
      // await inAppReview.openStoreListing(appStoreId: Common.appBundleId);
      // await prefs.setBool(_keyShown, true);
    // }
  }
}
