import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../billing/purchase_manager.dart';

class AdManager {
  AdManager._();
  static final AdManager instance = AdManager._();

  /// Kill switch for the whole ads feature (interstitial + rewarded + banner).
  static const bool adsFeatureEnabled = false;

  bool get _adsRemoved => PurchaseManager.instance.adsRemoved.value;

  bool get adsEnabled => adsFeatureEnabled && supported && !_adsRemoved;

  static String get _interstitialUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  static String get _rewardedUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  static String get bannerUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;
  bool _initialized = false;

  bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> init() async {
    if (!adsFeatureEnabled || !supported || _initialized) return;
    _initialized = true;
    await MobileAds.instance.initialize();
    if (_adsRemoved) return;
    _loadInterstitial();
    _loadRewarded();
  }

  void _loadInterstitial() {
    if (!supported) return;
    InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (_) => _interstitial = null,
      ),
    );
  }

  void _loadRewarded() {
    if (!supported) return;
    RewardedAd.load(
      adUnitId: _rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewarded = ad,
        onAdFailedToLoad: (_) => _rewarded = null,
      ),
    );
  }

  void showInterstitial({VoidCallback? onDismissed}) {
    final ad = _interstitial;
    if (!adsEnabled || ad == null) {
      onDismissed?.call();
      return;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitial = null;
        _loadInterstitial();
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _interstitial = null;
        _loadInterstitial();
        onDismissed?.call();
      },
    );
    ad.show();
    _interstitial = null;
  }

  void showRewarded({required VoidCallback onReward}) {
    if (!adsEnabled) {
      onReward();
      return;
    }
    final ad = _rewarded;
    if (ad == null) {
      onReward();
      _loadRewarded();
      return;
    }
    var earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewarded = null;
        _loadRewarded();
        if (earned) onReward();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _rewarded = null;
        _loadRewarded();
      },
    );
    ad.show(onUserEarnedReward: (ad, reward) => earned = true);
    _rewarded = null;
  }
}
