import 'app_lang.dart';

S get tr => S(AppLang.instance.isId);

class S {
  const S(this.id);
  final bool id;

  String get tagline => id ? 'Main bareng 2-4 pemain' : 'Play with 2-4 players';
  String get continueGame => id ? 'LANJUTKAN' : 'CONTINUE';
  String get mode => 'Mode';
  String get vsComputer => id ? 'vs Komputer' : 'vs Computer';
  String get local => id ? 'Lokal (1 HP)' : 'Local (1 device)';
  String get chooseYourColor => id ? 'Pilih warnamu' : 'Choose your color';
  String get choosePlayerColors =>
      id ? 'Pilih warna pemain (min. 2)' : 'Choose player colors (min. 2)';
  String get playerCount => id ? 'Jumlah pemain' : 'Number of players';
  String get yourName => id ? 'Nama kamu' : 'Your name';
  String get playerNames => id ? 'Nama pemain' : 'Player names';
  String rank(int place) => id ? 'Peringkat $place' : 'Rank $place';
  String get newGame => id ? 'MULAI BARU' : 'NEW GAME';
  String get start => id ? 'MULAI MAIN' : 'START';

  String get rollDice => id ? 'LEMPAR DADU' : 'ROLL DICE';
  String get watchAdReroll =>
      id ? 'Tonton iklan → Lempar ulang' : 'Watch ad → Re-roll';
  String get tapHighlighted =>
      id ? 'Ketuk bidak yang menyala' : 'Tap the highlighted token';
  String get computerPlaying =>
      id ? 'Komputer sedang bermain…' : 'Computer is playing…';
  String get finished => id ? 'Selesai' : 'Finished';

  String get gameOver => id ? 'Permainan Selesai' : 'Game Over';
  String get menu => 'Menu';
  String get playAgain => id ? 'Main Lagi' : 'Play Again';

  String get removeAds => id ? 'Hapus Iklan' : 'Remove Ads';
  String get removeAdsSubtitle =>
      id ? 'Bebas iklan selamanya' : 'Ad-free forever';
  String get removeAdsPerkBanner =>
      id ? 'Tanpa banner iklan' : 'No banner ads';
  String get removeAdsPerkInterstitial =>
      id ? 'Tanpa iklan sela antar permainan' : 'No ads between games';
  String get removeAdsPerkReroll => id
      ? 'Lempar ulang tanpa tonton iklan'
      : 'Re-roll without watching ads';
  String get removeAdsPerkSupport =>
      id ? 'Dukung pengembangan game ini' : 'Support the developer';
  String get removeAdsOneTime =>
      id ? 'Sekali bayar, bukan langganan' : 'One-time payment, not a subscription';
  String get buyNow => id ? 'BELI SEKARANG' : 'BUY NOW';
  String get restorePurchase => id ? 'Pulihkan pembelian' : 'Restore purchase';
  String get adsRemovedTitle => id ? 'Iklan sudah hilang!' : 'Ads are gone!';
  String get adsRemovedBody => id
      ? 'Terima kasih sudah mendukung. Selamat main tanpa gangguan!'
      : 'Thanks for the support. Enjoy the uninterrupted game!';
  String get purchaseRestored =>
      id ? 'Pembelian berhasil dipulihkan.' : 'Purchase restored.';
  String get purchaseNothingToRestore => id
      ? 'Tidak ada pembelian yang bisa dipulihkan.'
      : 'No purchase found to restore.';
  String get purchaseCanceled =>
      id ? 'Pembelian dibatalkan.' : 'Purchase canceled.';
  String get purchaseFailed => id
      ? 'Pembelian gagal. Coba lagi nanti.'
      : 'Purchase failed. Please try again later.';
  String get storeUnavailable => id
      ? 'Toko tidak tersedia di perangkat ini.'
      : 'Store is unavailable on this device.';

  String get settings => id ? 'Pengaturan' : 'Settings';
  String get language => id ? 'Bahasa' : 'Language';
  String get music => id ? 'Musik' : 'Music';
  String get sound => id ? 'Suara' : 'Sound';
  String get on => id ? 'Aktif' : 'On';
  String get off => id ? 'Nonaktif' : 'Off';
  String get close => id ? 'Tutup' : 'Close';

  String turnOf(String c) => id ? 'Giliran $c' : "$c's turn";
  String wins(String c) => id ? '$c menang! 🎉' : '$c wins! 🎉';

  String thinking(String c) =>
      id ? '$c (Komputer) sedang berpikir…' : '$c (Computer) is thinking…';
  String turnRoll(String c) =>
      id ? 'Giliran $c — lempar dadu!' : "$c's turn — roll the dice!";
  String get threeSixes => id
      ? 'Tiga angka 6 beruntun! Giliran hangus.'
      : 'Three 6s in a row! Turn forfeited.';
  String sixNoMove(String c) =>
      id ? '$c: dapat 6 tapi tak ada langkah.' : '$c: rolled a 6 but no moves.';
  String noMove(String c, int dice) =>
      id ? '$c: dadu $dice, tidak ada langkah.' : '$c: rolled $dice, no moves.';
  String botMoves(String c, int dice) =>
      id ? '$c (Komputer) jalan $dice…' : '$c (Computer) moves $dice…';
  String rolledTap(int dice) => id
      ? 'Dadu $dice — ketuk bidak yang menyala.'
      : 'Rolled $dice — tap a highlighted token.';
  String freeReroll(String c) =>
      id ? '$c: lempar ulang gratis!' : '$c: free re-roll!';
  String captured(String c) =>
      id ? '🎯 $c menangkap bidak lawan!' : '🎯 $c captured an opponent!';
  String reachedHome(String c) =>
      id ? '🏠 $c: satu bidak sampai rumah!' : '🏠 $c: a token reached home!';
  String anotherTurn(String c) =>
      id ? '$c: dapat giliran lagi!' : '$c: gets another turn!';
}
