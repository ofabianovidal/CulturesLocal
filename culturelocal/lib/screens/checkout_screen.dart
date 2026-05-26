import 'package:flutter/material.dart';
import 'success_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _yellow,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionCard(
                      title: 'Endereço De Cobrança',
                      trailingIcon: Icons.edit_outlined,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0D8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Avenida ASD, 144', style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _sectionCard(
                      title: 'Pedido',
                      trailingLabel: 'Editar',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Festa Sertaneja', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              SizedBox(height: 2),
                              Text('2 items', style: TextStyle(color: Colors.black45, fontSize: 13)),
                            ],
                          ),
                          const Text('R\$ 21', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _sectionCard(
                      title: 'Método de Pagamento',
                      trailingLabel: 'Editar',
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.credit_card, size: 20, color: Colors.black54),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            '**** **** 43 /00 /000',
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _payButton(context),
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
                'Pagamento',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    IconData? trailingIcon,
    String? trailingLabel,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              if (trailingIcon != null)
                Icon(trailingIcon, size: 18, color: Colors.black54),
              if (trailingLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trailingLabel,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _payButton(BuildContext context) {
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
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SuccessScreen()),
          ),
          child: const Text(
            'Pagar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
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
          _navIcon(Icons.home_outlined),
          _navIcon(Icons.person_outline),
          _navIcon(Icons.favorite_border),
          _navIcon(Icons.receipt_long_outlined),
          _navIcon(Icons.headset_mic_outlined),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon) {
    return Icon(icon, color: Colors.white, size: 26);
  }
}