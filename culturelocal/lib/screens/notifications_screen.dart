import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import '../widgets/bottom_nav.dart';

/// Preferências de notificação por E-MAIL (não há push no celular,
/// conforme combinado com a professora). Salvas no Firestore, atreladas
/// ao e-mail do usuário logado (READ ao abrir, WRITE ao salvar).
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);

  final _firestore = FirestoreService();

  final Map<String, bool> _prefs = {
    'Eventos novos por e-mail': true,
    'Confirmação de compra por e-mail': true,
    'Lembretes de evento por e-mail': false,
    'Ofertas e promoções por e-mail': false,
    'Resumo semanal por e-mail': true,
  };

  bool _carregando = true;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  /// READ — carrega as preferências já salvas (se existirem).
  Future<void> _carregarPreferencias() async {
    try {
      final dados = await _firestore.lerPreferencias();
      if (dados != null) {
        for (final chave in _prefs.keys) {
          if (dados[chave] is bool) _prefs[chave] = dados[chave];
        }
      }
    } catch (_) {
      // mantém os valores padrão em caso de erro
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  /// WRITE — salva as preferências atuais no Firestore.
  Future<void> _salvar() async {
    setState(() => _salvando = true);
    try {
      await _firestore.salvarPreferencias(_prefs);
      _aviso('Preferências salvas!');
    } catch (e) {
      _aviso('Erro ao salvar: $e');
    } finally {
      if (mounted) setState(() => _salvando = false);
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
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: _carregando
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        children: [
                          ..._prefs.entries.map((e) => _row(e.key, e.value)),
                          const SizedBox(height: 20),
                          _saveButton(),
                        ],
                      ),
              ),
            ),
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
            child: const Icon(Icons.chevron_left, size: 28),
          ),
          const Expanded(
            child: Center(
              child: Text('Notificações por E-mail',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _row(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
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

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: _salvando ? null : _salvar,
        child: _salvando
            ? const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Salvar preferências',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }
}