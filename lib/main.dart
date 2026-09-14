import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ads/ad_manager.dart';
import 'audio/audio_controller.dart';
import 'billing/purchase_manager.dart';
import 'l10n/app_lang.dart';
import 'screens/splash_screen.dart';
import 'storage/app_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await AppStore.instance.init();
  AppLang.instance.init();
  await PurchaseManager.instance.init();
  AdManager.instance.init();
  await AudioController.instance.init();
  AudioController.instance.startMusic();
  runApp(const LudoApp());
}

class LudoApp extends StatefulWidget {
  const LudoApp({super.key});

  @override
  State<LudoApp> createState() => _LudoAppState();
}

class _LudoAppState extends State<LudoApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AudioController.instance.handleLifecycle(state);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLang.instance.code,
      builder: (context, _, _) => MaterialApp(
        title: 'Ludo Stars',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFFFFC107),
          useMaterial3: true,
        ),
        builder: (context, child) => Directionality(
          textDirection: AppLang.instance.direction,
          child: child!,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
