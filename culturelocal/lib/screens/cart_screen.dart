import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/evento.dart';
import '../widgets/bottom_nav.dart';

/// Carrinho. Recebe o Evento pelos argumentos da rota (definidos no EventScreen).
/// Se nenhum evento for passado, mostra um aviso.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const _green = Color(0xFF1A7A3C);
  static const _darkGreen = Color(0xFF145F2E);
  static const _yellow = Color(0xFFE4C65A);

  int _qty = 1;
  Evento? _evento;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lê o evento passado como argumento da rota.
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Evento) _evento = args;
  }

  double get _subtotal => _qty * (_evento?.preco ?? 0);
  double get _taxa => 1.0;
  double get _total => _subtotal + _taxa;

  @override
  Widget build(BuildContext context) {
    if (_evento == null) {
      return const Scaffold(
        backgroundColor: _green,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Nenhum evento selecionado.\nVolte e escolha um evento.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

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
                  ],
                ),
              ),
            ),
            _checkoutButton(context),
            const CultureBottomNav(currentItem: CultureBottomNavItem.myEvents),
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
              child: Text('Carrinho',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 22),
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
            child: Container(
              width: 64,
              height: 64,
              color: Colors.grey.shade300,
              child: const Icon(Icons.image, color: Colors.white54, size: 30),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_evento!.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
                const SizedBox(height: 4),
                Text(_evento!.data, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _qtyBtn(Icons.remove, () { if (_qty > 1) setState(() => _qty--); }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('$_qty',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  _qtyBtn(Icons.add, () => setState(() => _qty++)),
                ],
              ),
              const SizedBox(height: 6),
              Text('R\$ ${_subtotal.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Icon(icon, color: Colors.white, size: 18));
  }

  Widget _summary() {
    return Column(
      children: [
        _row('Subtotal', 'R\$ ${_subtotal.toStringAsFixed(0)}'),
        const SizedBox(height: 10),
        _row('Taxa', 'R\$ ${_taxa.toStringAsFixed(0)}'),
        const Divider(color: Colors.white24, height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total', style: TextStyle(color: Colors.white70)),
            Text('R\$ ${_total.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
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
          // Passa um mapa simples com os dados do pedido para o checkout.
          onPressed: () => Navigator.pushNamed(
            context,
            AppRoutes.checkout,
            arguments: {
              'nomeEvento': _evento!.nome,
              'quantidade': _qty,
              'total': _total,
            },
          ),
          child: const Text('Finalizar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87)),
        ),
      ),
    );
  }
}