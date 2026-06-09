import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/event_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _qty = 2;
  static const _green = Color(0xFF1A7A3C);
  static const _yellow = Color(0xFFE4C65A);

  double get _subtotal => _qty * 10.0;
  double get _taxa => 1.0;
  double get _total => _subtotal + _taxa;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _green,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _cartItem(),
                    const SizedBox(height: 40),
                    _summary(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _checkoutButton(context),
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
            child: const Icon(Icons.chevron_left, size: 28, color: Colors.white),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Carrinho',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _cartItem() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: const CultureEventPoster(
              width: 64,
              height: 64,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Festa Sertaneja', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
                SizedBox(height: 4),
                Text('01/11/01', style: TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: _yellow, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 4),
                  Text('$_qty', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.cancel, color: Colors.white54, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'R\$ ${(_qty * 10).toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summary() {
    return Column(
      children: [
        _summaryRow('Subtotal', 'R\$ ${_subtotal.toStringAsFixed(0)}'),
        const SizedBox(height: 10),
        _summaryRow('Taxa', 'R\$ ${_taxa.toStringAsFixed(0)}'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(child: Container(height: 1, color: Colors.white24)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('- - - - -', style: TextStyle(color: Colors.white38, letterSpacing: 2)),
              ),
              Expanded(child: Container(height: 1, color: Colors.white24)),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'R\$ ${_total.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 15)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
      ],
    );
  }

  Widget _checkoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _yellow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.checkout),
          child: const Text(
            'Finalizar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return const CultureBottomNav(
      currentItem: CultureBottomNavItem.home,
    );
  }
}
