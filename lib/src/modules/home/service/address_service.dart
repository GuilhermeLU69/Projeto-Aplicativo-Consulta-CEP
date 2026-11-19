import 'package:geocoding/geocoding.dart';

import '../model/address_model.dart';
import '../repositories/address_api_repository.dart';
import '../repositories/address_local_repository.dart';
import 'address_exception.dart';

/// Regras de negócio da consulta de endereços.
class AddressService {
  AddressService(this._api, this._local);

  final AddressApiRepository _api;
  final AddressLocalRepository _local;

  /// Consulta por CEP. Retorna `null` se o CEP não existir.
  /// Lança [AddressException] para entrada inválida ou falha de comunicação.
  Future<AddressModel?> searchByCep(String rawCep) async {
    final cep = rawCep.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) {
      throw AddressException('Informe um CEP com 8 dígitos.');
    }
    final address = await _api.fetchByCep(cep);
    if (address == null) return null;
    return _local.save(address);
  }

  /// Busca CEPs por endereço completo ou parcial.
  Future<List<AddressModel>> searchByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    final cleanUf = uf.trim().toUpperCase();
    final cleanCity = city.trim();
    final cleanStreet = street.trim();

    if (cleanUf.length != 2) {
      throw AddressException('Informe a UF com 2 letras (ex.: SP).');
    }
    if (cleanCity.length < 3) {
      throw AddressException('Informe a cidade (mínimo 3 caracteres).');
    }
    if (cleanStreet.length < 3) {
      throw AddressException('Informe o logradouro (mínimo 3 caracteres).');
    }
    return _api.fetchByAddress(
      uf: cleanUf,
      city: cleanCity,
      street: cleanStreet,
    );
  }

  /// Registra o endereço escolhido como último consultado e no histórico.
  Future<AddressModel> select(AddressModel address) => _local.save(address);

  AddressModel? getLastAddress() => _local.getLast();

  List<AddressModel> getHistory() => _local.getAll();

  /// Converte o endereço em coordenadas para traçar rota.
  Future<Location> locate(AddressModel address) async {
    try {
      final locations = await locationFromAddress(address.fullAddress);
      if (locations.isEmpty) {
        throw AddressException('Não foi possível localizar o endereço no mapa.');
      }
      return locations.first;
    } on AddressException {
      rethrow;
    } catch (_) {
      throw AddressException('Não foi possível localizar o endereço no mapa.');
    }
  }
}
