import 'package:flutter/material.dart';

import '../billing/purchase_manager.dart';
import '../l10n/strings.dart';
import 'glossy_button.dart';

Future<void> showRemoveAds(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => const RemoveAdsDialog(),
  );
}

class RemoveAdsDialog extends StatefulWidget {
  const RemoveAdsDialog({super.key});

  @override
  State<RemoveAdsDialog> createState() => _RemoveAdsDialogState();
}

class _RemoveAdsDialogState extends State<RemoveAdsDialog> {
  final _pm = PurchaseManager.instance;
  void Function(PurchaseOutcome)? _previousHandler;

  @override
  void initState() {
    super.initState();
    _previousHandler = _pm.onResult;
    _pm.onResult = _handleOutcome;
  }

  @override
  void dispose() {
    _pm.onResult = _previousHandler;
    super.dispose();
  }

  void _handleOutcome(PurchaseOutcome outcome) {
    if (!mounted) return;
    switch (outcome) {
      case PurchaseOutcome.purchased:
      case PurchaseOutcome.restored:
        setState(() {});
      case PurchaseOutcome.nothingToRestore:
        _toast(tr.purchaseNothingToRestore);
      case PurchaseOutcome.canceled:
        _toast(tr.purchaseCanceled);
      case PurchaseOutcome.failed:
        _toast(_pm.storeAvailable ? tr.purchaseFailed : tr.storeUnavailable);
    }
  }

  void _toast(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ValueListenableBuilder<bool>(
        valueListenable: _pm.adsRemoved,
        builder: (context, adsRemoved, _) {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8FB),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x55000000),
                    blurRadius: 30,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: adsRemoved ? _buildOwned() : _buildOffer(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOwned() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
              ),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 44,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            tr.adsRemovedTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1F2A36),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr.adsRemovedBody,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6B7A8A),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: GlossyButton(
              color: const Color(0xFF43A047),
              icon: Icons.videogame_asset_rounded,
              label: tr.close,
              fontSize: 16,
              vertical: 15,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _header(),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _perk(Icons.block_rounded, tr.removeAdsPerkBanner),
              _perk(Icons.hourglass_disabled_rounded, tr.removeAdsPerkInterstitial),
              _perk(Icons.casino_rounded, tr.removeAdsPerkReroll),
              _perk(Icons.favorite_rounded, tr.removeAdsPerkSupport),
              const SizedBox(height: 18),
              Text(
                tr.removeAdsOneTime,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF8C99A8),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              ValueListenableBuilder<bool>(
                valueListenable: _pm.busy,
                builder: (context, busy, _) {
                  final unavailable = !_pm.storeAvailable;
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Opacity(
                          opacity: (busy || unavailable) ? 0.55 : 1,
                          child: GlossyButton(
                            color: const Color(0xFFFFC107),
                            icon: busy
                                ? Icons.hourglass_top_rounded
                                : Icons.lock_open_rounded,
                            label: _buyLabel(busy),
                            fontSize: 16,
                            vertical: 16,
                            onTap: (busy || unavailable) ? () {} : _pm.buy,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextButton(
                        onPressed: busy ? null : _pm.restore,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF6B7A8A),
                        ),
                        child: Text(
                          tr.restorePurchase,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _buyLabel(bool busy) {
    if (busy) return '…';
    if (!_pm.storeAvailable) return tr.storeUnavailable;
    final price = _pm.price;
    return price == null ? tr.buyNow : '${tr.buyNow} · $price';
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 26, 14, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x33FFC107), Color(0x00FFC107)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFD54F), Color(0xFFFFA000)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFC107).withValues(alpha: 0.45),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.block_rounded,
              color: Color(0xFF4A3200),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.removeAds,
                  style: const TextStyle(
                    color: Color(0xFF1F2A36),
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  tr.removeAdsSubtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B7A8A),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close_rounded,
              color: Color(0xFF8C99A8),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _perk(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFE9EEF3),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF2D6FB3)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF3A4750),
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
