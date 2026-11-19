import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/components/app_button.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../model/address_model.dart';

/// Componente com o retorno do último endereço consultado.
class LastAddressCard extends StatelessWidget {
  const LastAddressCard({Key? key, required this.address, required this.onRoute})
      : super(key: key);

  final AddressModel address;
  final VoidCallback onRoute;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppMetrics.radius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppMetrics.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Último endereço consultado',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppMetrics.spaceSm),
            Text(
              address.cep,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppMetrics.spaceSm),
            _line('Logradouro', address.logradouro),
            _line('Complemento', address.complemento),
            _line('Bairro', address.bairro),
            _line('Cidade/UF', address.cityState),
            _line('DDD', address.ddd),
            const SizedBox(height: AppMetrics.spaceMd),
            AppButton(
              label: 'Traçar rota',
              icon: Icons.directions,
              onPressed: onRoute,
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(String label, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppMetrics.spaceXs),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
