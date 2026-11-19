import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../modules/home/model/address_model.dart';

/// Configuração do armazenamento local (Hive).
class LocalStorage {
  LocalStorage._();

  static const String addressBoxName = 'address_history';

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(p.join(dir.path, 'fastlocation_db'));

    if (!Hive.isAdapterRegistered(AddressModelAdapter().typeId)) {
      Hive.registerAdapter(AddressModelAdapter());
    }
    await Hive.openBox<AddressModel>(addressBoxName);
  }
}
