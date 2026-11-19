import 'package:dio/dio.dart';

/// Configuração do Dio para comunicação com a API pública ViaCEP.
class DioClient {
  static const String baseUrl = 'https://viacep.com.br/ws';

  DioClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: 10000,
            receiveTimeout: 10000,
            responseType: ResponseType.json,
            headers: const {'Accept': 'application/json'},
          ),
        );

  final Dio dio;
}
