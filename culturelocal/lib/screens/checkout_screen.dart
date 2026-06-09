import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../services/firestore_service.dart';

/// Pagamento (simulado) + gravação do pedido no Firestore.
/// Recebe nomeEvento, quantidade e total pelos argumentos da rota.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);
  static const _fieldBg = Color(0xFFF5F0D8);

  final _firestore = FirestoreService();
  final _enderecoCtrl = TextEditingController(text: 'Avenida ASD, 144');
  final _cartaoCtrl = TextEditingController();

  String _nomeEvento = 'Evento';
  int _quantidade = 1;
  double _total = 0;

  bool _autorizado = false;
  bool _processando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _nomeEvento = args['nomeEvento'] ?? 'Evento';
      _quantidade = args['quantidade'] ?? 1;
      _total = (args['total'] ?? 0).toDouble();
    }
  }

  @override
  void dispose() {
    _enderecoCtrl.dispose();
    _cartaoCtrl.dispose();
    super.dispose();
  }

  /// Pagamento é apenas SIMULADO (combinado com a professora).
  /// Marcamos como autorizado e gravamos o pedido no Firestore.
  Future<void> _pagar() async {
    if (!_autorizado) {
      _aviso('Autorize o pagamento marcando a opção do cartão.');
      return;
    }
    final cartao = _cartaoCtrl.text.trim();
    if (cartao.length < 4) {
      _aviso('Digite ao menos os 4 últimos dígitos do cartão.');
      return;
    }

    setState(() => _processando = true);
    try {
      final mascarado = '**** **** **** ${cartao.substring(cartao.length - 4)}';
      await _firestore.criarPedido(
        nomeEvento: _nomeEvento,
        quantidade: _quantidade,
        total: _total,
        enderecoCobranca: _enderecoCtrl.text.trim(),
        cartaoMascarado: mascarado,
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.success);
      }
    } catch (e) {
      _aviso('Erro ao processar pedido: $e');
    } finally {
      if (mounted) setState(() => _processando = false);
    }
  }

  void _aviso(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _card(
                      title: 'Endereço De Cobrança',
                      child: TextField(controller: _enderecoCtrl, decoration: _input()),
                    ),
                    const SizedBox(height: 16),
                    _card(
                      title: 'Pedido',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_nomeEvento,
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text('$_quantidade item(s)',
                                  style: const TextStyle(color: Colors.black45, fontSize: 13)),
                            ],
                          ),
                          Text('R\$ ${_total.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _card(
                      title: 'Método de Pagamento (simulado)',
                      child: Column(
                        children: [
                          TextField(
                            controller: _cartaoCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _input(hint: 'Últimos dígitos do cartão'),
                          ),
                          const SizedBox(height: 8),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            activeColor: _green,
                            value: _autorizado,
                            onChanged: (v) => setState(() => _autorizado = v ?? false),
                            title: const Text('Autorizo a cobrança neste cartão',
                                style: TextStyle(fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _payButton(),
          ],
        ),
      ),
    );
  }

  InputDecoration _input({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: _fieldBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
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
              child: Text('Pagamento',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _payButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _yellow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: _processando ? null : _pagar,
          child: _processando
              ? const SizedBox(
                  width: 22, height: 22,
                  child: CircularProgressIndicator(color: Colors.black54, strokeWidth: 2))
              : const Text('Pagar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87)),
        ),
      ),
    );
  }
}