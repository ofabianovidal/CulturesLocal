import 'package:flutter/material.dart';

import '../widgets/bottom_nav.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);

  // true = verde, false = amarelo
  final Map<String, bool> _prefs = {
    'Gerais': true,
    'Sons': true,
    'Eventos novos': true,
    'Vibrar': false,
    'Ofertas especiais': false,
    'Pagamentos': true,
    'Promoções': true,
    'Cashback': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _yellow,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  children: _prefs.entries.map((e) => _notifRow(e.key, e.value)).toList(),
                ),
              ),
            ),
            _bottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.chevron_left, size: 28),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Configurar Notificações',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _notifRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          Switch(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: _green,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: _yellow,
            onChanged: (v) => setState(() => _prefs[label] = v),
          ),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return const CultureBottomNav(
      currentItem: CultureBottomNavItem.home,
    );
  }
}
