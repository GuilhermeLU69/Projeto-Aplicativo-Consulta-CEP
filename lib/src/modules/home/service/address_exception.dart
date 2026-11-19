/// Erro de negócio/comunicação com mensagem pronta para exibir ao usuário.
class AddressException implements Exception {
  AddressException(this.message);

  final String message;

  @override
  String toString() => message;
}
