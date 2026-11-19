import 'package:mobx/mobx.dart';

import '../../home/model/address_model.dart';
import '../../home/service/address_service.dart';

part 'history_controller.g.dart';

class HistoryController = _HistoryControllerBase with _$HistoryController;

abstract class _HistoryControllerBase with Store {
  _HistoryControllerBase(this._service);

  final AddressService _service;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  final ObservableList<AddressModel> items = ObservableList<AddressModel>();

  /// Carrega o histórico do armazenamento local.
  @action
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    try {
      final history = _service.getHistory();
      items
        ..clear()
        ..addAll(history);
    } catch (_) {
      errorMessage = 'Não foi possível carregar o histórico.';
    } finally {
      isLoading = false;
    }
  }
}
