import 'package:flutter/material.dart';
import 'package:trackio/core/constants/app_colors.dart';

// App container
class AppContainer extends StatelessWidget {
  final double padding;
  final Color containerColor;
  final Color borderColor;
  final double borderWidth;
  final Widget child;

  const AppContainer({
    super.key,
    this.padding = 16,
    this.containerColor = Colors.transparent,
    this.borderColor = AppColors.lightGray,
    this.borderWidth = 1,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: child,
    );
  }
}
