import 'package:flutter/cupertino.dart';
import 'package:trackio/core/constants/app_colors.dart';

// App text
class AppText extends StatelessWidget {
  final String data;
  final Color color;
  final double size;
  final FontWeight weight;
  final TextAlign textAlign;

  const AppText({
    super.key,
    required this.data,
    this.color = AppColors.darkGray,
    this.size = 14,
    this.weight = FontWeight.normal,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(data, style: TextStyle(
      color: color, fontSize: size, fontWeight: weight,
    ),textAlign: textAlign,);
  }
}
