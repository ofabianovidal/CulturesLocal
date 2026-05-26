import 'package:flutter/material.dart';
import 'cart_screen.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  int _qty = 1;
  bool _favorited = false;

  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _yellow,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _coverImage(),
                    const SizedBox(height: 20),
                    _priceAndQty(),
                    const SizedBox(height: 16),
                    const Text(
                      'Festa Sertaneja',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Festa raiz com músicas antigas',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buyButton(context),
            _bottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.chevron_left, size: 28),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Festival Sertanejo',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: 9,
            height: 9,
            margin: const EdgeInsets.only(right: 14),
            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          ),
          GestureDetector(
            onTap: () => setState(() => _favorited = !_favorited),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(
                _favorited ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: _favorited ? Colors.red : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _coverImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 220,
        width: double.infinity,
        color: const Color(0xFFD9D9D9),
        child: const Center(child: Icon(Icons.image, size: 60, color: Colors.white54)),
      ),
    );
  }

  Widget _priceAndQty() {
    return Row(
      children: [
        const Text(
          'R\$ 20',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              _qtyBtn(Icons.remove, () { if (_qty > 1) setState(() => _qty--); }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('$_qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              _qtyBtn(Icons.add, () => setState(() => _qty++)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Icon(icon, size: 18),
      ),
    );
  }

  Widget _buyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: _green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
          label: const Text(
            'Comprar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartScreen()),
          ),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home_outlined, () {}),
          _navIcon(Icons.person_outline, () {}),
          _navIcon(Icons.favorite_border, () {}),
          _navIcon(Icons.receipt_long_outlined, () {}),
          _navIcon(Icons.headset_mic_outlined, () {}),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }
}