import 'package:dio/dio.dart';

import '../model/address_model.dart';
import '../service/address_exception.dart';

/// Comunicação com a API externa ViaCEP.
class AddressApiRepository {
  AddressApiRepository(this._dio);

  final Dio _dio;

  /// Consulta endereço por CEP (8 dígitos). Retorna `null` se não encontrado.
  Future<AddressModel?> fetchByCep(String cep) async {
    try {
      final response = await _dio.get<dynamic>('/$cep/json/');
      final data = response.data;
      if (data is! Map<String, dynamic>) return null;
      if (_isNotFound(data)) return null;
      return AddressModel.fromMap(data);
    } on DioError catch (e) {
      throw _mapError(e);
    }
  }

  /// Busca endereços (completos ou parciais) por UF, cidade e logradouro.
  Future<List<AddressModel>> fetchByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    try {
      final path = '/${Uri.encodeComponent(uf)}'
          '/${Uri.encodeComponent(city)}'
          '/${Uri.encodeComponent(street)}/json/';
      final response = await _dio.get<dynamic>(path);
      final data = response.data;
      if (data is! List) return [];
      return data
          .whereType<Map<String, dynamic>>()
          .where((m) => !_isNotFound(m))
          .map(AddressModel.fromMap)
          .toList();
    } on DioError catch (e) {
      throw _mapError(e);
    }
  }

  bool _isNotFound(Map<String, dynamic> data) {
    final erro = data['erro'];
    return erro == true || erro == 'true';
  }

  AddressException _mapError(DioError e) {
    if (e.response?.statusCode == 400) {
      return AddressException('Dados de consulta inválidos.');
    }
    return AddressException(
      'Falha na comunicação com o servidor. Verifique sua conexão e tente novamente.',
    );
  }
}
