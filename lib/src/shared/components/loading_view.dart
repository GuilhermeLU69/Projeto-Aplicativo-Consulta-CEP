import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../metrics/app_metrics.dart';

/// Tela/overlay de loading exibida durante consultas externas.
class LoadingView extends StatelessWidget {
  const LoadingView({Key? key, this.message = 'Consultando...'})
      : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.35),
      alignment: Alignment.center,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppMetrics.radius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppMetrics.spaceLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: AppMetrics.spaceMd),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}
