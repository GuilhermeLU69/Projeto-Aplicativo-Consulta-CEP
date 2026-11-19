import 'package:fastlocation/src/modules/home/model/address_model.dart';
import 'package:fastlocation/src/modules/home/repositories/address_api_repository.dart';
import 'package:fastlocation/src/modules/home/repositories/address_local_repository.dart';
import 'package:fastlocation/src/modules/home/service/address_exception.dart';
import 'package:fastlocation/src/modules/home/service/address_service.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeApi implements AddressApiRepository {
  AddressModel? byCep;
  List<AddressModel> byAddress = [];

  @override
  Future<AddressModel?> fetchByCep(String cep) async => byCep;

  @override
  Future<List<AddressModel>> fetchByAddress({
    required String uf,
    required String city,
    required String street,
  }) async =>
      byAddress;
}

class FakeLocal implements AddressLocalRepository {
  final saved = <AddressModel>[];

  @override
  Future<AddressModel> save(AddressModel address) async {
    final s = address.copyWith(consultedAt: DateTime.now());
    saved.add(s);
    return s;
  }

  @override
  List<AddressModel> getAll() => saved.reversed.toList();

  @override
  AddressModel? getLast() => saved.isEmpty ? null : saved.last;
}

const _sample = AddressModel(
  cep: '01001-000',
  logradouro: 'Praça da Sé',
  complemento: 'lado ímpar',
  bairro: 'Sé',
  localidade: 'São Paulo',
  uf: 'SP',
  ibge: '3550308',
  ddd: '11',
);

void main() {
  late FakeApi api;
  late FakeLocal local;
  late AddressService service;

  setUp(() {
    api = FakeApi();
    local = FakeLocal();
    service = AddressService(api, local);
  });

  test('fromMap lê os campos do ViaCEP', () {
    final m = AddressModel.fromMap({
      'cep': '01001-000',
      'logradouro': 'Praça da Sé',
      'localidade': 'São Paulo',
      'uf': 'SP',
    });
    expect(m.cepDigits, '01001000');
    expect(m.cityState, 'São Paulo - SP');
    expect(m.bairro, '');
  });

  test('CEP inválido lança AddressException', () {
    expect(() => service.searchByCep('123'), throwsA(isA<AddressException>()));
  });

  test('CEP não encontrado retorna null e não salva', () async {
    api.byCep = null;
    expect(await service.searchByCep('01001-000'), isNull);
    expect(local.saved, isEmpty);
  });

  test('CEP encontrado é salvo no histórico', () async {
    api.byCep = _sample;
    final result = await service.searchByCep('01001-000');
    expect(result?.consultedAt, isNotNull);
    expect(service.getLastAddress()?.cep, '01001-000');
  });

  test('busca por endereço valida campos', () {
    expect(
      () => service.searchByAddress(uf: 'S', city: 'São Paulo', street: 'Sé'),
      throwsA(isA<AddressException>()),
    );
  });

  test('busca por endereço retorna lista', () async {
    api.byAddress = [_sample];
    final r = await service.searchByAddress(
      uf: 'sp',
      city: 'São Paulo',
      street: 'Praça',
    );
    expect(r, hasLength(1));
  });
}
