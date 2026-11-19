import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:mobx/mobx.dart';

import '../../../injector.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/colors/app_colors.dart';
import '../../../shared/components/app_button.dart';
import '../../../shared/components/cep_input_formatter.dart';
import '../../../shared/components/loading_view.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../components/address_list.dart';
import '../components/empty_search.dart';
import '../components/last_address_card.dart';
import '../controller/home_controller.dart';
import '../model/address_model.dart';
import '../service/address_exception.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = HomeController(Injector.addressService);

  final _cepController = TextEditingController();
  final _ufController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();

  late final ReactionDisposer _errorReaction;

  @override
  void initState() {
    super.initState();
    controller.loadLastAddress();

    // Reação MobX: exibe erros das consultas.
    _errorReaction = reaction<String?>((_) => controller.errorMessage, (msg) {
      if (msg == null || !mounted) return;
      _showSnack(msg);
      controller.clearError();
    });
  }

  @override
  void dispose() {
    _errorReaction();
    _cepController.dispose();
    _ufController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.error),
      );
  }

  void _search() {
    FocusScope.of(context).unfocus();
    if (controller.mode == SearchMode.cep) {
      controller.searchByCep(_cepController.text);
    } else {
      controller.searchByAddress(
        uf: _ufController.text,
        city: _cityController.text,
        street: _streetController.text,
      );
    }
  }

  /// Nova consulta: limpa campos e resultados.
  void _newSearch() {
    _cepController.clear();
    _ufController.clear();
    _cityController.clear();
    _streetController.clear();
    controller.setMode(controller.mode);
  }

  Future<void> _traceRoute(AddressModel address) async {
    try {
      final location = await Injector.addressService.locate(address);
      final maps = await MapLauncher.installedMaps;
      if (!mounted) return;
      if (maps.isEmpty) {
        _showSnack('Nenhum aplicativo de mapas instalado no dispositivo.');
        return;
      }

      final destination = Coords(location.latitude, location.longitude);
      Future<void> open(AvailableMap map) => map.showDirections(
            destination: destination,
            destinationTitle: address.street,
          );

      if (maps.length == 1) {
        await open(maps.first);
        return;
      }
      await showModalBottomSheet<void>(
        context: context,
        builder: (sheetContext) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const ListTile(
                title: Text(
                  'Abrir rota com',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              for (final map in maps)
                ListTile(
                  leading: const Icon(Icons.map, color: AppColors.primary),
                  title: Text(map.mapName),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    open(map);
                  },
                ),
            ],
          ),
        ),
      );
    } on AddressException catch (e) {
      if (mounted) _showSnack(e.message);
    } catch (_) {
      if (mounted) _showSnack('Não foi possível traçar a rota.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FastLocation'),
        actions: [
          IconButton(
            tooltip: 'Nova consulta',
            icon: const Icon(Icons.refresh),
            onPressed: _newSearch,
          ),
          IconButton(
            tooltip: 'Histórico',
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.of(context)
                .pushNamed(AppRoutes.history)
                .then((_) => controller.loadLastAddress()),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(AppMetrics.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildModeSelector(),
                    const SizedBox(height: AppMetrics.spaceMd),
                    if (controller.mode == SearchMode.cep)
                      _buildCepFields()
                    else
                      _buildAddressFields(),
                    const SizedBox(height: AppMetrics.spaceMd),
                    AppButton(
                      label: 'Consultar',
                      icon: Icons.search,
                      onPressed: controller.isLoading ? null : _search,
                    ),
                    const SizedBox(height: AppMetrics.spaceLg),
                    ..._buildResults(),
                  ],
                ),
              ),
              if (controller.isLoading) const LoadingView(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildModeSelector() {
    final isCep = controller.mode == SearchMode.cep;
    return ToggleButtons(
      isSelected: [isCep, !isCep],
      borderRadius: BorderRadius.circular(AppMetrics.radius),
      selectedColor: Colors.white,
      fillColor: AppColors.primary,
      constraints: BoxConstraints(
        minHeight: AppMetrics.buttonHeight,
        minWidth: (MediaQuery.of(context).size.width - 2 * AppMetrics.spaceMd - 4) / 2,
      ),
      onPressed: (index) =>
          controller.setMode(index == 0 ? SearchMode.cep : SearchMode.address),
      children: const [Text('Buscar por CEP'), Text('Buscar por endereço')],
    );
  }

  Widget _buildCepFields() {
    return TextField(
      controller: _cepController,
      keyboardType: TextInputType.number,
      inputFormatters: [CepInputFormatter()],
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _search(),
      decoration: const InputDecoration(
        labelText: 'CEP',
        hintText: '00000-000',
        prefixIcon: Icon(Icons.pin_drop),
      ),
    );
  }

  Widget _buildAddressFields() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 90,
              child: TextField(
                controller: _ufController,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                ],
                decoration: const InputDecoration(labelText: 'UF'),
              ),
            ),
            const SizedBox(width: AppMetrics.spaceSm),
            Expanded(
              child: TextField(
                controller: _cityController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Cidade'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppMetrics.spaceSm),
        TextField(
          controller: _streetController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _search(),
          decoration: const InputDecoration(
            labelText: 'Logradouro (completo ou parcial)',
            prefixIcon: Icon(Icons.signpost),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildResults() {
    final widgets = <Widget>[];

    if (controller.notFound) {
      widgets.add(const EmptySearch());
    }

    if (controller.results.isNotEmpty) {
      widgets
        ..add(Text(
          '${controller.results.length} resultado(s) — toque para selecionar',
          style: const TextStyle(color: AppColors.textSecondary),
        ))
        ..add(const SizedBox(height: AppMetrics.spaceSm))
        ..add(AddressList(
          addresses: controller.results.toList(),
          onTap: controller.selectAddress,
        ));
    }

    final last = controller.lastAddress;
    if (last != null && controller.results.isEmpty && !controller.notFound) {
      widgets.add(LastAddressCard(
        address: last,
        onRoute: () => _traceRoute(last),
      ));
    }
    return widgets;
  }
}
