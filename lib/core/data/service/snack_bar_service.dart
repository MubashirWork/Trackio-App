import 'package:flutter/material.dart';
import 'package:trackio/core/constants/app_colors.dart';
import 'package:trackio/ui/widgets/app_text.dart';

class SnackBarService {
  static final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static void show(String message) {
    key.currentState?.hideCurrentSnackBar();
    key.currentState?.showSnackBar(
      SnackBar(
        content: AppText(data: message, color: AppColors.white),
        backgroundColor: AppColors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
