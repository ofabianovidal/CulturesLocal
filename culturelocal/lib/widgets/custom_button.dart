import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CulturePillButton extends StatelessWidget {
  const CulturePillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.green,
    this.foregroundColor = Colors.white,
    this.width = 210,
    this.height = 44,
    this.fontSize = 18,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double width;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: foregroundColor,
          ),
        ),
      ),
    );
  }
}

class CultureSocialButton extends StatelessWidget {
  const CultureSocialButton({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.yellow,
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.green, width: 1.2),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 34, height: 34, child: Center(child: child)),
      ),
    );
  }
}
