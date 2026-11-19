import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../injector.dart';
import '../../../shared/colors/app_colors.dart';
import '../../../shared/components/loading_view.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../../home/components/address_list.dart';
import '../controller/history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryController controller =
      HistoryController(Injector.addressService);

  @override
  void initState() {
    super.initState();
    // Carregamento automático ao acessar a página.
    controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de consultas')),
      body: Observer(
        builder: (_) {
          if (controller.isLoading) {
            return const LoadingView(message: 'Carregando histórico...');
          }
          if (controller.errorMessage != null) {
            return Center(
              child: Text(
                controller.errorMessage!,
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }
          if (controller.items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppMetrics.spaceLg),
                child: Text(
                  'Nenhum endereço consultado ainda.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppMetrics.spaceMd),
            children: [AddressList(addresses: controller.items.toList())],
          );
        },
      ),
    );
  }
}
