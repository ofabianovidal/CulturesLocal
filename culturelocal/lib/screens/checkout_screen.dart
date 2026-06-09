import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_routes.dart';
import '../models/app_order.dart';
import '../services/cart_service.dart';
import '../services/firestore_service.dart';
import '../widgets/bottom_nav.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);

  // Cartão salvo em memória (simulado)
  String? _cardNumber;
  String? _cardName;
  String? _cardExpiry;

  bool _isPaying = false;

  final _fmt = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  Future<void> _pay() async {
    if (_cardNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione um cartão de pagamento primeiro.'),
        ),
      );
      return;
    }

    final cart = CartService.instance;
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seu carrinho está vazio.')),
      );
      return;
    }

    setState(() => _isPaying = true);

    try {
      final items = cart.items
          .map(
            (i) => AppOrderItem(
              eventId: i.event.id,
              eventNome: i.event.nome,
              eventDescricao: i.event.descricao,
              qty: i.qty,
              preco: i.event.preco,
            ),
          )
          .toList();

      await FirestoreService.instance.saveOrder(
        items: items,
        subtotal: cart.subtotal,
        taxa: cart.taxa,
        total: cart.total,
      );

      cart.clear();

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.success,
        (route) => route.settings.name == AppRoutes.index,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao processar pagamento.')),
      );
    } finally {
      if (mounted) setState(() => _isPaying = false);
    }
  }

  void _openAddCard() {
    final numberCtrl = TextEditingController(text: _cardNumber ?? '');
    final nameCtrl = TextEditingController(text: _cardName ?? '');
    final expiryCtrl = TextEditingController(text: _cardExpiry ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adicionar Cartão',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _sheetField(numberCtrl, 'Número do cartão', '0000 0000 0000 0000',
                TextInputType.number),
            const SizedBox(height: 14),
            _sheetField(nameCtrl, 'Nome no cartão', 'Como aparece no cartão',
                TextInputType.text),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _sheetField(expiryCtrl, 'Validade', 'MM/AA',
                      TextInputType.datetime),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _sheetField(
                    TextEditingController(),
                    'CVV',
                    '•••',
                    TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _cardNumber = numberCtrl.text.trim().isEmpty
                        ? null
                        : numberCtrl.text.trim();
                    _cardName = nameCtrl.text.trim().isEmpty
                        ? null
                        : nameCtrl.text.trim();
                    _cardExpiry = expiryCtrl.text.trim().isEmpty
                        ? null
                        : expiryCtrl.text.trim();
                  });
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  'Salvar Cartão',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetField(
    TextEditingController ctrl,
    String label,
    String hint,
    TextInputType type,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: Colors.black38, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFFF5F0D8),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _yellow,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: CartService.instance,
          builder: (context, _) {
            final cart = CartService.instance;
            return Column(
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
                          title: 'Pedido',
                          trailingLabel: 'Editar',
                          onTrailingTap: () =>
                              Navigator.of(context).pop(),
                          child: Column(
                            children: [
                              ...cart.items.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${item.qty}x ${item.event.nome}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        _fmt.format(
                                            item.event.preco * item.qty),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (cart.items.length > 1) ...[
                                const Divider(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Taxa',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 13),
                                    ),
                                    Text(
                                      _fmt.format(cart.taxa),
                                      style: const TextStyle(
                                          color: Colors.black45,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    _fmt.format(cart.total),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: _green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _sectionCard(
                          title: 'Método de Pagamento',
                          trailingLabel:
                              _cardNumber == null ? 'Adicionar' : 'Trocar',
                          onTrailingTap: _openAddCard,
                          child: _cardNumber == null
                              ? GestureDetector(
                                  onTap: _openAddCard,
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.add_card,
                                        size: 22,
                                        color: Colors.black38,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Nenhum cartão adicionado',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.credit_card,
                                        size: 20,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '**** **** **** ${_cardNumber!.replaceAll(' ', '').length >= 4 ? _cardNumber!.replaceAll(' ', '').substring(_cardNumber!.replaceAll(' ', '').length - 4) : '****'}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87),
                                        ),
                                        if (_cardName != null)
                                          Text(
                                            _cardName!,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black45),
                                          ),
                                      ],
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
    String? trailingLabel,
    VoidCallback? onTrailingTap,
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
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              if (trailingLabel != null)
                GestureDetector(
                  onTap: onTrailingTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      trailingLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: _isPaying ? null : _pay,
          child: Text(
            _isPaying ? 'Processando...' : 'Pagar',
            style: const TextStyle(
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
