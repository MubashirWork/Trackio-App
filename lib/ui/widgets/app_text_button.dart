import 'package:flutter/material.dart';
import 'package:trackio/core/constants/app_colors.dart';
import 'package:trackio/ui/widgets/app_text.dart';

// App text button
class AppTextButton extends StatelessWidget {

  final VoidCallback onClick;
  final String text;
  final Color textColor;

  const AppTextButton({
    super.key,
    required this.onClick,
    required this.text,
    this.textColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClick,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        overlayColor: Colors.transparent,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: AppText(data: text, weight: FontWeight.w500, color: textColor,),
    );
  }
}
