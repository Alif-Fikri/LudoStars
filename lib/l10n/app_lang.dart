import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';

import '../storage/app_store.dart';

class LangOption {
  const LangOption(this.code, this.flag, this.label);

  final String code;
  final String flag;
  final String label;
}

class AppLang {
  AppLang._();
  static final AppLang instance = AppLang._();

  static const supported = <LangOption>[
    LangOption('en', '🇬🇧', 'English'),
    LangOption('id', '🇮🇩', 'Indonesia'),
    LangOption('hi', '🇮🇳', 'हिन्दी'),
    LangOption('pt', '🇧🇷', 'Português'),
    LangOption('es', '🇪🇸', 'Español'),
    LangOption('ar', '🇸🇦', 'العربية'),
    LangOption('zh', '🇨🇳', '简体中文'),
  ];

  static const _rtlCodes = {'ar'};
  static const _storeKey = 'app_lang';

  final ValueNotifier<String> code = ValueNotifier('en');

  bool get isRtl => _rtlCodes.contains(code.value);

  TextDirection get direction => isRtl ? TextDirection.rtl : TextDirection.ltr;

  void init() {
    code.value = AppStore.instance.getString(_storeKey) ?? _deviceDefault();
  }

  static String _deviceDefault() {
    final device = PlatformDispatcher.instance.locale.languageCode;
    return supported.any((l) => l.code == device) ? device : 'en';
  }

  void set(String c) {
    if (code.value == c) return;
    code.value = c;
    AppStore.instance.setString(_storeKey, c);
  }
}
