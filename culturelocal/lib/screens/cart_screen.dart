import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../services/cart_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/event_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const _green = Color(0xFF1A7A3C);
  static const _yellow = Color(0xFFE4C65A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _green,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: CartService.instance,
          builder: (context, _) {
            final cart = CartService.instance;
            return Column(
              children: [
                _header(context),
                Expanded(
                  child: cart.isEmpty
                      ? _emptyState()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              ...cart.items.map(
                                (item) => _cartItem(context, item),
                              ),
                              const SizedBox(height: 40),
                              _summary(cart),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                ),
                if (!cart.isEmpty) _checkoutButton(context),
                _bottomNav(),
              ],
            );
          },
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
            child: const Icon(
              Icons.chevron_left,
              size: 28,
              color: Colors.white,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Carrinho',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.white38),
          SizedBox(height: 16),
          Text(
            'Seu carrinho está vazio.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Adicione ingressos na tela de um evento.',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _cartItem(BuildContext context, CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.event.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.event.formattedDate,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => CartService.instance.setQty(
                      item.event.id,
                      item.qty - 1,
                    ),
                    child: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${item.qty}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => CartService.instance.setQty(
                      item.event.id,
                      item.qty + 1,
                    ),
                    child: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () =>
                        CartService.instance.remove(item.event.id),
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item.event.formattedPrice.replaceFirst('R\$', 'R\$ ') +
                    (item.qty > 1 ? ' × ${item.qty}' : ''),
                style: const TextStyle(
                  color: _yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summary(CartService cart) {
    return Column(
      children: [
        _summaryRow(
          'Subtotal',
          'R\$ ${cart.subtotal.toStringAsFixed(2).replaceAll('.', ',')}',
        ),
        const SizedBox(height: 10),
        _summaryRow(
          'Taxa',
          'R\$ ${cart.taxa.toStringAsFixed(2).replaceAll('.', ',')}',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(child: Container(height: 1, color: Colors.white24)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '- - - - -',
                  style: TextStyle(color: Colors.white38, letterSpacing: 2),
                ),
              ),
              Expanded(child: Container(height: 1, color: Colors.white24)),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'R\$ ${cart.total.toStringAsFixed(2).replaceAll('.', ',')}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
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
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.checkout),
          child: const Text(
            'Finalizar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return const CultureBottomNav(currentItem: CultureBottomNavItem.home);
  }
}
