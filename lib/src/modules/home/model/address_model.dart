import 'package:hive/hive.dart';

part 'address_model.g.dart';

/// Endereço retornado pela API ViaCEP (https://viacep.com.br/ws).
@HiveType(typeId: 0)
class AddressModel {
  const AddressModel({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.ibge,
    required this.ddd,
    this.consultedAt,
  });

  @HiveField(0)
  final String cep;
  @HiveField(1)
  final String logradouro;
  @HiveField(2)
  final String complemento;
  @HiveField(3)
  final String bairro;
  @HiveField(4)
  final String localidade;
  @HiveField(5)
  final String uf;
  @HiveField(6)
  final String ibge;
  @HiveField(7)
  final String ddd;
  @HiveField(8)
  final DateTime? consultedAt;

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    String read(String key) => (map[key] ?? '').toString();
    return AddressModel(
      cep: read('cep'),
      logradouro: read('logradouro'),
      complemento: read('complemento'),
      bairro: read('bairro'),
      localidade: read('localidade'),
      uf: read('uf'),
      ibge: read('ibge'),
      ddd: read('ddd'),
    );
  }

  AddressModel copyWith({DateTime? consultedAt}) {
    return AddressModel(
      cep: cep,
      logradouro: logradouro,
      complemento: complemento,
      bairro: bairro,
      localidade: localidade,
      uf: uf,
      ibge: ibge,
      ddd: ddd,
      consultedAt: consultedAt ?? this.consultedAt,
    );
  }

  /// CEP somente com dígitos (usado como chave de armazenamento).
  String get cepDigits => cep.replaceAll(RegExp(r'\D'), '');

  /// Linha principal: "Rua X, Bairro".
  String get street {
    final parts = [logradouro, bairro].where((e) => e.isNotEmpty);
    return parts.isEmpty ? 'Logradouro não informado' : parts.join(', ');
  }

  /// Linha secundária: "Cidade - UF".
  String get cityState => '$localidade - $uf';

  /// Endereço completo, usado também para geocodificação.
  String get fullAddress {
    final parts = [
      logradouro,
      bairro,
      localidade,
      uf,
      'Brasil',
    ].where((e) => e.isNotEmpty);
    return parts.join(', ');
  }
}
