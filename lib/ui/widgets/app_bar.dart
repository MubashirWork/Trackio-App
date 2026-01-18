import 'package:flutter/material.dart';
import 'package:trackio/core/constants/app_colors.dart';
import 'package:trackio/ui/widgets/app_text.dart';

// App bar
class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? iconOnClick;
  final IconData? leadingIcon;
  final String text;

  const Appbar({
    super.key,
    this.iconOnClick,
    this.leadingIcon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leadingIcon != null
          ? GestureDetector(
              onTap: leadingIcon != null ? iconOnClick : null,
              child: Icon(leadingIcon),
            )
          : null,
      backgroundColor: AppColors.blue,
      title: AppText(data: text, color: AppColors.white, size: 18),
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.white),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
