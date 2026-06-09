import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../widgets/bottom_nav.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);

  bool _showFaq = true;
  int? _expanded;

  static const _items = [
    (Icons.headset_mic_outlined, 'Chat'),
    (Icons.language_outlined, 'Site'),
    (Icons.chat_outlined, 'Whatsapp'),
    (Icons.facebook_outlined, 'Facebook'),
    (Icons.camera_alt_outlined, 'Instagram'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _topBanner(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: List.generate(_items.length, (i) => _expandableItem(i)),
              ),
            ),
            _bottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _topBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _yellow,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => navigateToRootRoute(context, AppRoutes.index),
                child: const Icon(Icons.chevron_left, size: 28),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Suporte',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 28),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Precisa De Ajuda?',
            style: TextStyle(color: _green, fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _tabBtn('FAQ', _showFaq, () => setState(() => _showFaq = true)),
                _tabBtn('Nos Ligue', !_showFaq, () => setState(() => _showFaq = false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: active ? (_showFaq && label == 'FAQ' ? _yellow : _green) : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: active ? (_showFaq && label == 'FAQ' ? Colors.black87 : Colors.white) : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _expandableItem(int index) {
    final item = _items[index];
    final isOpen = _expanded == index;

    return GestureDetector(
      onTap: () => setState(() => _expanded = isOpen ? null : index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.$1, size: 22, color: _green),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.$2,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Icon(
                isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: _green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return const CultureBottomNav(
      currentItem: CultureBottomNavItem.support,
    );
  }
}
