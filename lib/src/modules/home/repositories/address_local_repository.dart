import 'package:hive_flutter/hive_flutter.dart';

import '../../../shared/storage/local_storage.dart';
import '../model/address_model.dart';

/// Comunicação com o armazenamento local (Hive).
class AddressLocalRepository {
  Box<AddressModel> get _box =>
      Hive.box<AddressModel>(LocalStorage.addressBoxName);

  /// Salva (ou atualiza) o endereço como o mais recente consultado.
  Future<AddressModel> save(AddressModel address) async {
    final saved = address.copyWith(consultedAt: DateTime.now());
    await _box.put(saved.cepDigits, saved);
    return saved;
  }

  /// Histórico ordenado do mais recente para o mais antigo.
  List<AddressModel> getAll() {
    final items = _box.values.toList();
    items.sort((a, b) => _time(b).compareTo(_time(a)));
    return items;
  }

  AddressModel? getLast() {
    final items = getAll();
    return items.isEmpty ? null : items.first;
  }

  DateTime _time(AddressModel a) =>
      a.consultedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
}
