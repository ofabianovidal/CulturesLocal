import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/app_order.dart';
import '../services/firestore_service.dart';
import '../widgets/bottom_nav.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);

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
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: StreamBuilder<List<AppOrder>>(
                  stream: FirestoreService.instance.watchMyOrders(),
                  builder: (context, snapshot) {
                    final orders = snapshot.data ?? const <AppOrder>[];

                    return ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      children: [
                        if (orders.isNotEmpty) ...[
                          const Text(
                            'Confirmações de Pedidos',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2DB84B),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...orders.take(5).map(
                                (order) => _orderNotification(context, order),
                              ),
                          const Divider(height: 28),
                        ],
                        const Text(
                          'Preferências',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._prefs.entries
                            .map((e) => _notifRow(e.key, e.value)),
                      ],
                    );
                  },
                ),
              ),
            ),
            _bottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _orderNotification(BuildContext context, AppOrder order) {
    final names = order.items.map((i) => '${i.qty}x ${i.eventNome}').join(', ');
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.myOrders),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FFF4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2DB84B).withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Color(0xFF2DB84B),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pedido Confirmado',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    names,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              order.formattedTotal,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: _green,
              ),
            ),
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
                'Notificações',
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
          Text(
            label,
            style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
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
    return const CultureBottomNav(currentItem: CultureBottomNavItem.home);
  }
}
