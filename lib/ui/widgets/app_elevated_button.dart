import 'package:flutter/material.dart';
import 'package:trackio/core/constants/app_colors.dart';

// App elevated button
class AppElevatedButton extends StatelessWidget {
  final VoidCallback onClick;
  final Widget child;
  final Color backgroundColor;

  const AppElevatedButton({
    super.key,
    required this.onClick,
    required this.child,
    this.backgroundColor = AppColors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(
          double.infinity,
          MediaQuery.of(context).size.height * 0.05,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      child: child,
    );
  }
}
