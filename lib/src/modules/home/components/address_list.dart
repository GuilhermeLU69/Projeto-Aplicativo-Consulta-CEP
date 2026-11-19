import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../model/address_model.dart';

/// Lista de endereços consultados / encontrados.
class AddressList extends StatelessWidget {
  const AddressList({Key? key, required this.addresses, this.onTap})
      : super(key: key);

  final List<AddressModel> addresses;
  final ValueChanged<AddressModel>? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final address in addresses)
          Card(
            margin: const EdgeInsets.only(bottom: AppMetrics.spaceSm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppMetrics.radius),
            ),
            child: ListTile(
              onTap: onTap == null ? null : () => onTap!(address),
              leading: const Icon(Icons.location_on, color: AppColors.primary),
              title: Text(address.street),
              subtitle: Text('${address.cityState}\nCEP ${address.cep}'),
              isThreeLine: true,
              trailing: onTap == null ? null : const Icon(Icons.chevron_right),
            ),
          ),
      ],
    );
  }
}
