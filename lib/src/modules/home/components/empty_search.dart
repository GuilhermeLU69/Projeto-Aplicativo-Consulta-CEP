import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/metrics/app_metrics.dart';

/// Componente exibido quando a busca não retorna resultados.
class EmptySearch extends StatelessWidget {
  const EmptySearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppMetrics.spaceXl),
      child: Column(
        children: const [
          Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
          SizedBox(height: AppMetrics.spaceMd),
          Text(
            'Nenhum endereço encontrado',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: AppMetrics.spaceSm),
          Text(
            'Confira os dados informados e tente novamente.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
