import 'package:flutter/material.dart';
import 'package:trackio/core/constants/app_colors.dart';

// App text field
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged? onChange;
  final IconData? leadingIcon;
  final VoidCallback? trailingOnClick;
  final IconData? trailingIcon;
  final Widget? hint;
  final Color textColor;
  final Color iconColor;
  final bool showBorder;
  final double horizontalPadding;
  final double verticalPadding;
  final bool isDense;
  final String? errorText;
  final TextInputType keyboardType;
  final TextInputAction keyboardAction;
  final VoidCallback? onComplete;
  final bool obscureText;

  const AppTextField({
    super.key,
    required this.controller,
    this.onChange,
    this.leadingIcon,
    this.trailingIcon,
    this.trailingOnClick,
    this.hint,
    this.textColor = AppColors.lightGray,
    this.iconColor = AppColors.lightGray,
    this.horizontalPadding = 14,
    this.verticalPadding = 12,
    this.isDense = false,
    required this.showBorder,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.keyboardAction = TextInputAction.next,
    this.onComplete,
    this.obscureText = false,

  });

  @override
  Widget build(BuildContext context) {
    final border = showBorder
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.lightGray, width: 1),
          )
        : InputBorder.none;
    return TextField(
      style: TextStyle(fontSize: 14, color: textColor),
      controller: controller,
      onChanged: onChange,
      decoration: InputDecoration(
        prefixIcon: leadingIcon != null
            ? Icon(leadingIcon, color: iconColor)
            : null,
        suffixIcon: trailingIcon != null
            ? GestureDetector(
                onTap: trailingIcon != null ? trailingOnClick : null,
                child: Icon(trailingIcon, color: iconColor),
              )
            : null,
        hint: hint,
        filled: false,
        focusedBorder: border,
        enabledBorder: border,
        contentPadding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        isDense: isDense,
        errorText: errorText,
        errorStyle: TextStyle(color: Colors.red),
        errorBorder: border,
        focusedErrorBorder: border,
      ),
      keyboardType: keyboardType,
      textInputAction: keyboardAction,
      onEditingComplete: onComplete,
      obscureText: obscureText,
    );
  }
}
