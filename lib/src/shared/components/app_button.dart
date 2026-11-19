import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../metrics/app_metrics.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.outlined = false,
  }) : super(key: key);

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppMetrics.radius),
    );
    final size = const Size.fromHeight(AppMetrics.buttonHeight);
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: AppMetrics.spaceSm),
        ],
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );

    if (outlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: size,
          shape: shape,
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
        ),
        child: child,
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: size,
        shape: shape,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      child: child,
    );
  }
}
