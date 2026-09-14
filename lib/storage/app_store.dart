import 'package:hive_ce_flutter/hive_flutter.dart';

/// Local key-value storage backed by Hive.
class AppStore {
  AppStore._();
  static final AppStore instance = AppStore._();

  static const _boxName = 'ludo_prefs';

  late final Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  String? getString(String key) => _box.get(key) as String?;

  Future<void> setString(String key, String value) => _box.put(key, value);
}
