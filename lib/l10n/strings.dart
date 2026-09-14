import 'app_lang.dart';

S get tr => S._(_tables[AppLang.instance.code.value] ?? _en);

class S {
  const S._(this._m);

  final Map<String, String> _m;

  String _s(String k) => _m[k] ?? _en[k] ?? k;

  String _f(String k, Map<String, Object> args) {
    var out = _s(k);
    for (final e in args.entries) {
      out = out.replaceAll('{${e.key}}', '${e.value}');
    }
    return out;
  }

  String get tagline => _s('tagline');
  String get continueGame => _s('continueGame');
  String get mode => _s('mode');
  String get vsComputer => _s('vsComputer');
  String get local => _s('local');
  String get chooseYourColor => _s('chooseYourColor');
  String get choosePlayerColors => _s('choosePlayerColors');
  String get playerCount => _s('playerCount');
  String get yourName => _s('yourName');
  String get playerNames => _s('playerNames');
  String rank(int place) => _f('rank', {'n': place});
  String get newGame => _s('newGame');
  String get start => _s('start');

  String get rollDice => _s('rollDice');
  String get watchAdReroll => _s('watchAdReroll');
  String get tapHighlighted => _s('tapHighlighted');
  String get computerPlaying => _s('computerPlaying');
  String get finished => _s('finished');

  String get gameOver => _s('gameOver');
  String get menu => _s('menu');
  String get playAgain => _s('playAgain');

  String get removeAds => _s('removeAds');
  String get removeAdsSubtitle => _s('removeAdsSubtitle');
  String get removeAdsPerkBanner => _s('removeAdsPerkBanner');
  String get removeAdsPerkInterstitial => _s('removeAdsPerkInterstitial');
  String get removeAdsPerkForever => _s('removeAdsPerkForever');
  String get removeAdsPerkSupport => _s('removeAdsPerkSupport');
  String get removeAdsOneTime => _s('removeAdsOneTime');
  String get buyNow => _s('buyNow');
  String get restorePurchase => _s('restorePurchase');
  String get adsRemovedTitle => _s('adsRemovedTitle');
  String get adsRemovedBody => _s('adsRemovedBody');
  String get purchaseRestored => _s('purchaseRestored');
  String get purchaseNothingToRestore => _s('purchaseNothingToRestore');
  String get purchaseCanceled => _s('purchaseCanceled');
  String get purchaseFailed => _s('purchaseFailed');
  String get storeUnavailable => _s('storeUnavailable');

  String get settings => _s('settings');
  String get language => _s('language');
  String get music => _s('music');
  String get sound => _s('sound');
  String get on => _s('on');
  String get off => _s('off');
  String get close => _s('close');

  String get colorRed => _s('colorRed');
  String get colorGreen => _s('colorGreen');
  String get colorYellow => _s('colorYellow');
  String get colorBlue => _s('colorBlue');

  String turnOf(String c) => _f('turnOf', {'c': c});
  String wins(String c) => _f('wins', {'c': c});
  String thinking(String c) => _f('thinking', {'c': c});
  String turnRoll(String c) => _f('turnRoll', {'c': c});
  String get threeSixes => _s('threeSixes');
  String sixNoMove(String c) => _f('sixNoMove', {'c': c});
  String noMove(String c, int dice) => _f('noMove', {'c': c, 'n': dice});
  String botMoves(String c, int dice) => _f('botMoves', {'c': c, 'n': dice});
  String rolledTap(int dice) => _f('rolledTap', {'n': dice});
  String freeReroll(String c) => _f('freeReroll', {'c': c});
  String captured(String c) => _f('captured', {'c': c});
  String reachedHome(String c) => _f('reachedHome', {'c': c});
  String anotherTurn(String c) => _f('anotherTurn', {'c': c});
}

const _tables = <String, Map<String, String>>{
  'en': _en,
  'id': _id,
  'hi': _hi,
  'pt': _pt,
  'es': _es,
  'ar': _ar,
  'zh': _zh,
};

const _en = <String, String>{
  'tagline': 'Play with 2-4 players',
  'continueGame': 'CONTINUE',
  'mode': 'Mode',
  'vsComputer': 'vs Computer',
  'local': 'Local (1 device)',
  'chooseYourColor': 'Choose your color',
  'choosePlayerColors': 'Choose player colors (min. 2)',
  'playerCount': 'Number of players',
  'yourName': 'Your name',
  'playerNames': 'Player names',
  'rank': 'Rank {n}',
  'newGame': 'NEW GAME',
  'start': 'START',
  'rollDice': 'ROLL DICE',
  'watchAdReroll': 'Watch ad → Re-roll',
  'tapHighlighted': 'Tap the highlighted token',
  'computerPlaying': 'Computer is playing…',
  'finished': 'Finished',
  'gameOver': 'Game Over',
  'menu': 'Menu',
  'playAgain': 'Play Again',
  'removeAds': 'Remove Ads',
  'removeAdsSubtitle': 'Ad-free forever',
  'removeAdsPerkBanner': 'No banner ads',
  'removeAdsPerkInterstitial': 'No ads between games',
  'removeAdsPerkForever': 'Yours forever, on any device',
  'removeAdsPerkSupport': 'Support the developer',
  'removeAdsOneTime': 'One-time payment, not a subscription',
  'buyNow': 'BUY NOW',
  'restorePurchase': 'Restore purchase',
  'adsRemovedTitle': 'Ads are gone!',
  'adsRemovedBody': 'Thanks for the support. Enjoy the uninterrupted game!',
  'purchaseRestored': 'Purchase restored.',
  'purchaseNothingToRestore': 'No purchase found to restore.',
  'purchaseCanceled': 'Purchase canceled.',
  'purchaseFailed': 'Purchase failed. Please try again later.',
  'storeUnavailable': 'Store is unavailable on this device.',
  'settings': 'Settings',
  'language': 'Language',
  'music': 'Music',
  'sound': 'Sound',
  'on': 'On',
  'off': 'Off',
  'close': 'Close',
  'colorRed': 'Red',
  'colorGreen': 'Green',
  'colorYellow': 'Yellow',
  'colorBlue': 'Blue',
  'turnOf': "{c}'s turn",
  'wins': '{c} wins! 🎉',
  'thinking': '{c} (Computer) is thinking…',
  'turnRoll': "{c}'s turn — roll the dice!",
  'threeSixes': 'Three 6s in a row! Turn forfeited.',
  'sixNoMove': '{c}: rolled a 6 but no moves.',
  'noMove': '{c}: rolled {n}, no moves.',
  'botMoves': '{c} (Computer) moves {n}…',
  'rolledTap': 'Rolled {n} — tap a highlighted token.',
  'freeReroll': '{c}: free re-roll!',
  'captured': '🎯 {c} captured an opponent!',
  'reachedHome': '🏠 {c}: a token reached home!',
  'anotherTurn': '{c}: gets another turn!',
};

const _id = <String, String>{
  'tagline': 'Main bareng 2-4 pemain',
  'continueGame': 'LANJUTKAN',
  'mode': 'Mode',
  'vsComputer': 'vs Komputer',
  'local': 'Lokal (1 HP)',
  'chooseYourColor': 'Pilih warnamu',
  'choosePlayerColors': 'Pilih warna pemain (min. 2)',
  'playerCount': 'Jumlah pemain',
  'yourName': 'Nama kamu',
  'playerNames': 'Nama pemain',
  'rank': 'Peringkat {n}',
  'newGame': 'MULAI BARU',
  'start': 'MULAI MAIN',
  'rollDice': 'LEMPAR DADU',
  'watchAdReroll': 'Tonton iklan → Lempar ulang',
  'tapHighlighted': 'Ketuk bidak yang menyala',
  'computerPlaying': 'Komputer sedang bermain…',
  'finished': 'Selesai',
  'gameOver': 'Permainan Selesai',
  'menu': 'Menu',
  'playAgain': 'Main Lagi',
  'removeAds': 'Hapus Iklan',
  'removeAdsSubtitle': 'Bebas iklan selamanya',
  'removeAdsPerkBanner': 'Tanpa banner iklan',
  'removeAdsPerkInterstitial': 'Tanpa iklan sela antar permainan',
  'removeAdsPerkForever': 'Berlaku selamanya di akun kamu',
  'removeAdsPerkSupport': 'Dukung pengembangan game ini',
  'removeAdsOneTime': 'Sekali bayar, bukan langganan',
  'buyNow': 'BELI SEKARANG',
  'restorePurchase': 'Pulihkan pembelian',
  'adsRemovedTitle': 'Iklan sudah hilang!',
  'adsRemovedBody':
      'Terima kasih sudah mendukung. Selamat main tanpa gangguan!',
  'purchaseRestored': 'Pembelian berhasil dipulihkan.',
  'purchaseNothingToRestore': 'Tidak ada pembelian yang bisa dipulihkan.',
  'purchaseCanceled': 'Pembelian dibatalkan.',
  'purchaseFailed': 'Pembelian gagal. Coba lagi nanti.',
  'storeUnavailable': 'Toko tidak tersedia di perangkat ini.',
  'settings': 'Pengaturan',
  'language': 'Bahasa',
  'music': 'Musik',
  'sound': 'Suara',
  'on': 'Aktif',
  'off': 'Nonaktif',
  'close': 'Tutup',
  'colorRed': 'Merah',
  'colorGreen': 'Hijau',
  'colorYellow': 'Kuning',
  'colorBlue': 'Biru',
  'turnOf': 'Giliran {c}',
  'wins': '{c} menang! 🎉',
  'thinking': '{c} (Komputer) sedang berpikir…',
  'turnRoll': 'Giliran {c} — lempar dadu!',
  'threeSixes': 'Tiga angka 6 beruntun! Giliran hangus.',
  'sixNoMove': '{c}: dapat 6 tapi tak ada langkah.',
  'noMove': '{c}: dadu {n}, tidak ada langkah.',
  'botMoves': '{c} (Komputer) jalan {n}…',
  'rolledTap': 'Dadu {n} — ketuk bidak yang menyala.',
  'freeReroll': '{c}: lempar ulang gratis!',
  'captured': '🎯 {c} menangkap bidak lawan!',
  'reachedHome': '🏠 {c}: satu bidak sampai rumah!',
  'anotherTurn': '{c}: dapat giliran lagi!',
};

const _hi = <String, String>{
  'tagline': '2-4 खिलाड़ियों के साथ खेलें',
  'continueGame': 'जारी रखें',
  'mode': 'मोड',
  'vsComputer': 'कंप्यूटर से',
  'local': 'लोकल (1 डिवाइस)',
  'chooseYourColor': 'अपना रंग चुनें',
  'choosePlayerColors': 'खिलाड़ियों के रंग चुनें (कम से कम 2)',
  'playerCount': 'खिलाड़ियों की संख्या',
  'yourName': 'आपका नाम',
  'playerNames': 'खिलाड़ियों के नाम',
  'rank': 'रैंक {n}',
  'newGame': 'नया गेम',
  'start': 'शुरू करें',
  'rollDice': 'पासा फेंकें',
  'watchAdReroll': 'विज्ञापन देखें → दोबारा फेंकें',
  'tapHighlighted': 'चमकती हुई गोटी पर टैप करें',
  'computerPlaying': 'कंप्यूटर खेल रहा है…',
  'finished': 'समाप्त',
  'gameOver': 'गेम समाप्त',
  'menu': 'मेन्यू',
  'playAgain': 'फिर से खेलें',
  'removeAds': 'विज्ञापन हटाएँ',
  'removeAdsSubtitle': 'हमेशा के लिए विज्ञापन-मुक्त',
  'removeAdsPerkBanner': 'कोई बैनर विज्ञापन नहीं',
  'removeAdsPerkInterstitial': 'गेम के बीच कोई विज्ञापन नहीं',
  'removeAdsPerkForever': 'हमेशा के लिए आपका, किसी भी डिवाइस पर',
  'removeAdsPerkSupport': 'डेवलपर का साथ दें',
  'removeAdsOneTime': 'एक बार का भुगतान, सदस्यता नहीं',
  'buyNow': 'अभी खरीदें',
  'restorePurchase': 'खरीद बहाल करें',
  'adsRemovedTitle': 'विज्ञापन हट गए!',
  'adsRemovedBody': 'सहयोग के लिए धन्यवाद। बिना रुकावट गेम का आनंद लें!',
  'purchaseRestored': 'खरीद बहाल हो गई।',
  'purchaseNothingToRestore': 'बहाल करने के लिए कोई खरीद नहीं मिली।',
  'purchaseCanceled': 'खरीद रद्द कर दी गई।',
  'purchaseFailed': 'खरीद विफल रही। बाद में फिर कोशिश करें।',
  'storeUnavailable': 'इस डिवाइस पर स्टोर उपलब्ध नहीं है।',
  'settings': 'सेटिंग्स',
  'language': 'भाषा',
  'music': 'संगीत',
  'sound': 'ध्वनि',
  'on': 'चालू',
  'off': 'बंद',
  'close': 'बंद करें',
  'colorRed': 'लाल',
  'colorGreen': 'हरा',
  'colorYellow': 'पीला',
  'colorBlue': 'नीला',
  'turnOf': '{c} की बारी',
  'wins': '{c} जीत गया! 🎉',
  'thinking': '{c} (कंप्यूटर) सोच रहा है…',
  'turnRoll': '{c} की बारी — पासा फेंकें!',
  'threeSixes': 'लगातार तीन 6! बारी समाप्त।',
  'sixNoMove': '{c}: 6 आया पर कोई चाल नहीं।',
  'noMove': '{c}: पासा {n}, कोई चाल नहीं।',
  'botMoves': '{c} (कंप्यूटर) {n} चल रहा है…',
  'rolledTap': 'पासा {n} — चमकती गोटी पर टैप करें।',
  'freeReroll': '{c}: मुफ़्त दोबारा फेंक!',
  'captured': '🎯 {c} ने विरोधी की गोटी काटी!',
  'reachedHome': '🏠 {c}: एक गोटी घर पहुँची!',
  'anotherTurn': '{c}: एक और बारी मिली!',
};

const _pt = <String, String>{
  'tagline': 'Jogue com 2 a 4 jogadores',
  'continueGame': 'CONTINUAR',
  'mode': 'Modo',
  'vsComputer': 'vs Computador',
  'local': 'Local (1 aparelho)',
  'chooseYourColor': 'Escolha sua cor',
  'choosePlayerColors': 'Escolha as cores dos jogadores (mín. 2)',
  'playerCount': 'Número de jogadores',
  'yourName': 'Seu nome',
  'playerNames': 'Nomes dos jogadores',
  'rank': '{n}º lugar',
  'newGame': 'NOVO JOGO',
  'start': 'COMEÇAR',
  'rollDice': 'ROLAR DADO',
  'watchAdReroll': 'Ver anúncio → Rolar de novo',
  'tapHighlighted': 'Toque no peão destacado',
  'computerPlaying': 'O computador está jogando…',
  'finished': 'Terminou',
  'gameOver': 'Fim de Jogo',
  'menu': 'Menu',
  'playAgain': 'Jogar de Novo',
  'removeAds': 'Remover Anúncios',
  'removeAdsSubtitle': 'Sem anúncios para sempre',
  'removeAdsPerkBanner': 'Sem banners',
  'removeAdsPerkInterstitial': 'Sem anúncios entre as partidas',
  'removeAdsPerkForever': 'Seu para sempre, em qualquer aparelho',
  'removeAdsPerkSupport': 'Apoie o desenvolvedor',
  'removeAdsOneTime': 'Pagamento único, não é assinatura',
  'buyNow': 'COMPRAR AGORA',
  'restorePurchase': 'Restaurar compra',
  'adsRemovedTitle': 'Os anúncios sumiram!',
  'adsRemovedBody': 'Obrigado pelo apoio. Bom jogo, sem interrupções!',
  'purchaseRestored': 'Compra restaurada.',
  'purchaseNothingToRestore': 'Nenhuma compra encontrada para restaurar.',
  'purchaseCanceled': 'Compra cancelada.',
  'purchaseFailed': 'A compra falhou. Tente novamente mais tarde.',
  'storeUnavailable': 'A loja não está disponível neste aparelho.',
  'settings': 'Configurações',
  'language': 'Idioma',
  'music': 'Música',
  'sound': 'Som',
  'on': 'Ligado',
  'off': 'Desligado',
  'close': 'Fechar',
  'colorRed': 'Vermelho',
  'colorGreen': 'Verde',
  'colorYellow': 'Amarelo',
  'colorBlue': 'Azul',
  'turnOf': 'Vez de {c}',
  'wins': '{c} venceu! 🎉',
  'thinking': '{c} (Computador) está pensando…',
  'turnRoll': 'Vez de {c} — role o dado!',
  'threeSixes': 'Três 6 seguidos! Vez perdida.',
  'sixNoMove': '{c}: tirou 6, mas sem jogadas.',
  'noMove': '{c}: tirou {n}, sem jogadas.',
  'botMoves': '{c} (Computador) anda {n}…',
  'rolledTap': 'Tirou {n} — toque num peão destacado.',
  'freeReroll': '{c}: rolagem grátis!',
  'captured': '🎯 {c} capturou um adversário!',
  'reachedHome': '🏠 {c}: um peão chegou em casa!',
  'anotherTurn': '{c}: ganhou outra jogada!',
};

const _es = <String, String>{
  'tagline': 'Juega con 2 a 4 jugadores',
  'continueGame': 'CONTINUAR',
  'mode': 'Modo',
  'vsComputer': 'vs Computadora',
  'local': 'Local (1 dispositivo)',
  'chooseYourColor': 'Elige tu color',
  'choosePlayerColors': 'Elige los colores (mín. 2)',
  'playerCount': 'Número de jugadores',
  'yourName': 'Tu nombre',
  'playerNames': 'Nombres de jugadores',
  'rank': 'Puesto {n}',
  'newGame': 'NUEVA PARTIDA',
  'start': 'EMPEZAR',
  'rollDice': 'TIRAR DADO',
  'watchAdReroll': 'Ver anuncio → Volver a tirar',
  'tapHighlighted': 'Toca la ficha resaltada',
  'computerPlaying': 'La computadora está jugando…',
  'finished': 'Terminado',
  'gameOver': 'Fin de la partida',
  'menu': 'Menú',
  'playAgain': 'Jugar otra vez',
  'removeAds': 'Quitar anuncios',
  'removeAdsSubtitle': 'Sin anuncios para siempre',
  'removeAdsPerkBanner': 'Sin banners',
  'removeAdsPerkInterstitial': 'Sin anuncios entre partidas',
  'removeAdsPerkForever': 'Tuyo para siempre, en cualquier dispositivo',
  'removeAdsPerkSupport': 'Apoya al desarrollador',
  'removeAdsOneTime': 'Pago único, no es suscripción',
  'buyNow': 'COMPRAR AHORA',
  'restorePurchase': 'Restaurar compra',
  'adsRemovedTitle': '¡Los anuncios se fueron!',
  'adsRemovedBody': 'Gracias por tu apoyo. ¡Disfruta el juego sin cortes!',
  'purchaseRestored': 'Compra restaurada.',
  'purchaseNothingToRestore': 'No se encontró ninguna compra para restaurar.',
  'purchaseCanceled': 'Compra cancelada.',
  'purchaseFailed': 'La compra falló. Inténtalo más tarde.',
  'storeUnavailable': 'La tienda no está disponible en este dispositivo.',
  'settings': 'Ajustes',
  'language': 'Idioma',
  'music': 'Música',
  'sound': 'Sonido',
  'on': 'Activado',
  'off': 'Desactivado',
  'close': 'Cerrar',
  'colorRed': 'Rojo',
  'colorGreen': 'Verde',
  'colorYellow': 'Amarillo',
  'colorBlue': 'Azul',
  'turnOf': 'Turno de {c}',
  'wins': '¡{c} gana! 🎉',
  'thinking': '{c} (Computadora) está pensando…',
  'turnRoll': 'Turno de {c}: ¡tira el dado!',
  'threeSixes': '¡Tres 6 seguidos! Turno perdido.',
  'sixNoMove': '{c}: sacó 6 pero no hay jugadas.',
  'noMove': '{c}: sacó {n}, no hay jugadas.',
  'botMoves': '{c} (Computadora) avanza {n}…',
  'rolledTap': 'Sacó {n}: toca una ficha resaltada.',
  'freeReroll': '{c}: ¡tirada gratis!',
  'captured': '🎯 ¡{c} capturó a un rival!',
  'reachedHome': '🏠 {c}: ¡una ficha llegó a casa!',
  'anotherTurn': '{c}: ¡tiene otro turno!',
};

const _ar = <String, String>{
  'tagline': 'العب مع 2-4 لاعبين',
  'continueGame': 'متابعة',
  'mode': 'الوضع',
  'vsComputer': 'ضد الكمبيوتر',
  'local': 'محلي (جهاز واحد)',
  'chooseYourColor': 'اختر لونك',
  'choosePlayerColors': 'اختر ألوان اللاعبين (2 على الأقل)',
  'playerCount': 'عدد اللاعبين',
  'yourName': 'اسمك',
  'playerNames': 'أسماء اللاعبين',
  'rank': 'المركز {n}',
  'newGame': 'لعبة جديدة',
  'start': 'ابدأ',
  'rollDice': 'ارمِ النرد',
  'watchAdReroll': 'شاهد إعلانًا ← أعد الرمي',
  'tapHighlighted': 'اضغط على القطعة المميزة',
  'computerPlaying': 'الكمبيوتر يلعب…',
  'finished': 'انتهى',
  'gameOver': 'انتهت اللعبة',
  'menu': 'القائمة',
  'playAgain': 'العب مرة أخرى',
  'removeAds': 'إزالة الإعلانات',
  'removeAdsSubtitle': 'بدون إعلانات للأبد',
  'removeAdsPerkBanner': 'بدون إعلانات بانر',
  'removeAdsPerkInterstitial': 'بدون إعلانات بين الجولات',
  'removeAdsPerkForever': 'لك للأبد، على أي جهاز',
  'removeAdsPerkSupport': 'ادعم المطوّر',
  'removeAdsOneTime': 'دفعة واحدة، وليست اشتراكًا',
  'buyNow': 'اشترِ الآن',
  'restorePurchase': 'استعادة الشراء',
  'adsRemovedTitle': 'اختفت الإعلانات!',
  'adsRemovedBody': 'شكرًا لدعمك. استمتع باللعب دون انقطاع!',
  'purchaseRestored': 'تمت استعادة الشراء.',
  'purchaseNothingToRestore': 'لا توجد عملية شراء لاستعادتها.',
  'purchaseCanceled': 'تم إلغاء الشراء.',
  'purchaseFailed': 'فشل الشراء. حاول مرة أخرى لاحقًا.',
  'storeUnavailable': 'المتجر غير متاح على هذا الجهاز.',
  'settings': 'الإعدادات',
  'language': 'اللغة',
  'music': 'الموسيقى',
  'sound': 'الصوت',
  'on': 'مفعّل',
  'off': 'معطّل',
  'close': 'إغلاق',
  'colorRed': 'أحمر',
  'colorGreen': 'أخضر',
  'colorYellow': 'أصفر',
  'colorBlue': 'أزرق',
  'turnOf': 'دور {c}',
  'wins': 'فاز {c}! 🎉',
  'thinking': '{c} (الكمبيوتر) يفكر…',
  'turnRoll': 'دور {c} — ارمِ النرد!',
  'threeSixes': 'ثلاث ستات متتالية! ضاع الدور.',
  'sixNoMove': '{c}: ظهر 6 لكن لا توجد حركة.',
  'noMove': '{c}: النرد {n}، لا توجد حركة.',
  'botMoves': '{c} (الكمبيوتر) يتحرك {n}…',
  'rolledTap': 'النرد {n} — اضغط على قطعة مميزة.',
  'freeReroll': '{c}: رمية مجانية!',
  'captured': '🎯 {c} أسقط قطعة الخصم!',
  'reachedHome': '🏠 {c}: وصلت قطعة إلى البيت!',
  'anotherTurn': '{c}: حصل على دور آخر!',
};

const _zh = <String, String>{
  'tagline': '2-4 人一起玩',
  'continueGame': '继续游戏',
  'mode': '模式',
  'vsComputer': '人机对战',
  'local': '本地（单设备）',
  'chooseYourColor': '选择你的颜色',
  'choosePlayerColors': '选择玩家颜色（至少 2 个）',
  'playerCount': '玩家人数',
  'yourName': '你的名字',
  'playerNames': '玩家名字',
  'rank': '第 {n} 名',
  'newGame': '新游戏',
  'start': '开始',
  'rollDice': '掷骰子',
  'watchAdReroll': '观看广告 → 重掷',
  'tapHighlighted': '点击高亮的棋子',
  'computerPlaying': '电脑正在走棋…',
  'finished': '已完成',
  'gameOver': '游戏结束',
  'menu': '菜单',
  'playAgain': '再玩一局',
  'removeAds': '去除广告',
  'removeAdsSubtitle': '永久无广告',
  'removeAdsPerkBanner': '没有横幅广告',
  'removeAdsPerkInterstitial': '对局之间没有广告',
  'removeAdsPerkForever': '永久有效，任何设备都可用',
  'removeAdsPerkSupport': '支持开发者',
  'removeAdsOneTime': '一次性付费，非订阅',
  'buyNow': '立即购买',
  'restorePurchase': '恢复购买',
  'adsRemovedTitle': '广告已移除！',
  'adsRemovedBody': '感谢支持，祝你玩得开心！',
  'purchaseRestored': '购买已恢复。',
  'purchaseNothingToRestore': '没有找到可恢复的购买记录。',
  'purchaseCanceled': '购买已取消。',
  'purchaseFailed': '购买失败，请稍后再试。',
  'storeUnavailable': '此设备上无法使用商店。',
  'settings': '设置',
  'language': '语言',
  'music': '音乐',
  'sound': '音效',
  'on': '开',
  'off': '关',
  'close': '关闭',
  'colorRed': '红色',
  'colorGreen': '绿色',
  'colorYellow': '黄色',
  'colorBlue': '蓝色',
  'turnOf': '轮到 {c}',
  'wins': '{c} 获胜！🎉',
  'thinking': '{c}（电脑）正在思考…',
  'turnRoll': '轮到 {c} — 掷骰子！',
  'threeSixes': '连续三个 6！本回合作废。',
  'sixNoMove': '{c}：掷出 6，但无法移动。',
  'noMove': '{c}：掷出 {n}，无法移动。',
  'botMoves': '{c}（电脑）走 {n} 步…',
  'rolledTap': '掷出 {n} — 点击高亮的棋子。',
  'freeReroll': '{c}：免费重掷！',
  'captured': '🎯 {c} 吃掉了对手的棋子！',
  'reachedHome': '🏠 {c}：一颗棋子到家了！',
  'anotherTurn': '{c}：再走一回合！',
};
