import 'package:flutter/foundation.dart';

class AppLang {
  AppLang._();
  static final AppLang instance = AppLang._();

  final ValueNotifier<String> code = ValueNotifier('en');

  bool get isId => code.value == 'id';

  void set(String c) => code.value = c;
  void toggle() => code.value = isId ? 'en' : 'id';
}
