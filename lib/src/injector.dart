import 'http/dio_client.dart';
import 'modules/home/repositories/address_api_repository.dart';
import 'modules/home/repositories/address_local_repository.dart';
import 'modules/home/service/address_service.dart';

/// Composição manual das dependências (sem framework de DI).
class Injector {
  Injector._();

  static final AddressService addressService = AddressService(
    AddressApiRepository(DioClient().dio),
    AddressLocalRepository(),
  );
}
