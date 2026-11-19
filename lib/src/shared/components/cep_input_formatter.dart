import 'package:flutter/services.dart';

/// Aplica a máscara 00000-000 e aceita somente dígitos.
class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 8) digits = digits.substring(0, 8);

    final text = digits.length > 5
        ? '${digits.substring(0, 5)}-${digits.substring(5)}'
        : digits;

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
