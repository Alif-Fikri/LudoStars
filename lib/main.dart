import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ads/ad_manager.dart';
import 'audio/audio_controller.dart';
import 'billing/purchase_manager.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await PurchaseManager.instance.init();
  AdManager.instance.init();
  await AudioController.instance.init();
  AudioController.instance.startMusic();
  runApp(const LudoApp());
}

class LudoApp extends StatelessWidget {
  const LudoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ludo Stars',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFFFC107),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
