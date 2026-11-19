import 'package:mobx/mobx.dart';

import '../model/address_model.dart';
import '../service/address_exception.dart';
import '../service/address_service.dart';

part 'home_controller.g.dart';

enum SearchMode { cep, address }

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  _HomeControllerBase(this._service);

  final AddressService _service;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  AddressModel? lastAddress;

  /// `true` quando a última busca não retornou nenhum resultado.
  @observable
  bool notFound = false;

  @observable
  SearchMode mode = SearchMode.cep;

  /// Resultados da busca por endereço (lista para o usuário escolher).
  final ObservableList<AddressModel> results = ObservableList<AddressModel>();

  @action
  void setMode(SearchMode value) {
    mode = value;
    notFound = false;
    errorMessage = null;
    results.clear();
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void loadLastAddress() {
    lastAddress = _service.getLastAddress();
  }

  @action
  Future<void> searchByCep(String cep) async {
    _start();
    try {
      final address = await _service.searchByCep(cep);
      if (address == null) {
        notFound = true;
      } else {
        lastAddress = address;
      }
    } on AddressException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Erro inesperado ao consultar o CEP.';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> searchByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    _start();
    try {
      final found = await _service.searchByAddress(
        uf: uf,
        city: city,
        street: street,
      );
      results.addAll(found);
      notFound = found.isEmpty;
    } on AddressException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Erro inesperado ao buscar o endereço.';
    } finally {
      isLoading = false;
    }
  }

  /// Escolhe um item da lista de resultados como endereço consultado.
  @action
  Future<void> selectAddress(AddressModel address) async {
    try {
      lastAddress = await _service.select(address);
      results.clear();
    } catch (_) {
      errorMessage = 'Não foi possível salvar o endereço no histórico.';
    }
  }

  void _start() {
    isLoading = true;
    errorMessage = null;
    notFound = false;
    results.clear();
  }
}
