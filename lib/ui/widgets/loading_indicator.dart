import 'package:flutter/material.dart';
import 'package:trackio/core/constants/app_colors.dart';

// App loading progress indicator
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: AppColors.white,
        strokeWidth: 1.3,
      ),
    );
  }
}
