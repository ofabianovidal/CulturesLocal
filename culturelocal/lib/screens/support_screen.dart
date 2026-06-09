import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import '../widgets/bottom_nav.dart';

/// Suporte: ao expandir um canal, o usuário pode enviar uma mensagem,
/// que é gravada no Firestore com o usuario_logado.
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);

  final _firestore = FirestoreService();

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
            _banner(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: List.generate(_items.length, (i) => _item(i)),
              ),
            ),
            const CultureBottomNav(currentItem: CultureBottomNavItem.support),
          ],
        ),
      ),
    );
  }

  /// Abre um formulário simples e grava a mensagem no Firestore.
  Future<void> _abrirFormulario(String canal) async {
    final ctrl = TextEditingController();
    final enviar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Contato via $canal'),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Escreva sua mensagem...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Enviar')),
        ],
      ),
    );

    if (enviar == true && ctrl.text.trim().isNotEmpty) {
      try {
        await _firestore.enviarSolicitacaoSuporte(canal: canal, mensagem: ctrl.text.trim());
        _aviso('Mensagem enviada! Responderemos por e-mail.');
      } catch (e) {
        _aviso('Erro ao enviar: $e');
      }
    }
  }

  void _aviso(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _banner(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _yellow,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: const Icon(Icons.chevron_left, size: 28),
              ),
              const Expanded(
                child: Center(
                  child: Text('Suporte',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 28),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Precisa De Ajuda?',
              style: TextStyle(color: _green, fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _tab('FAQ', _showFaq, () => setState(() => _showFaq = true)),
                _tab('Nos Ligue', !_showFaq, () => setState(() => _showFaq = false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    final isFaq = label == 'FAQ';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: active ? (isFaq ? _yellow : _green) : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: active ? (isFaq ? Colors.black87 : Colors.white) : Colors.black54)),
      ),
    );
  }

  Widget _item(int index) {
    final item = _items[index];
    final isOpen = _expanded == index;

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = isOpen ? null : index),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(10)),
                  child: Icon(item.$1, size: 22, color: _green),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(item.$2,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
                Icon(isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: _green),
              ],
            ),
          ),
        ),
        if (isOpen)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _abrirFormulario(item.$2),
                icon: const Icon(Icons.send, size: 18, color: _green),
                label: Text('Enviar mensagem via ${item.$2}',
                    style: const TextStyle(color: _green)),
              ),
            ),
          ),
      ],
    );
  }
}