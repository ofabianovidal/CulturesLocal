import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../widgets/bottom_nav.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);

  bool _showFaq = true;
  int? _expanded;

  static const _faq = [
    (
      'Como faço para comprar ingressos?',
      'Encontre o evento desejado na tela inicial, toque nele, escolha a quantidade e adicione ao carrinho. Depois acesse o carrinho e finalize o pagamento.',
    ),
    (
      'Posso cancelar meu pedido?',
      'Cancelamentos podem ser solicitados em até 48 horas antes do evento pelo chat ou WhatsApp. Reembolsos são processados em até 5 dias úteis.',
    ),
    (
      'Como crio um evento?',
      'Acesse "Meu Perfil" e toque em "Criar Evento". Preencha os dados e publique. O evento aparecerá no início imediatamente.',
    ),
    (
      'Meu pagamento foi recusado. O que fazer?',
      'Verifique os dados do cartão e tente novamente. Caso persista, entre em contato pelo SAC (0800 079 0042) ou pelo WhatsApp (79) 99812-3456.',
    ),
    (
      'Como favorito um evento?',
      'Toque no ícone de coração no card do evento na tela inicial ou dentro da tela do evento.',
    ),
  ];

  static const _contacts = [
    (
      Icons.headset_mic_outlined,
      'Chat ao Vivo',
      'Seg – Sex, 8h às 20h\nSáb, 9h às 15h',
      'Atendimento em até 5 minutos',
    ),
    (
      Icons.language_outlined,
      'Site Oficial',
      'www.culturelocal.com.br',
      'Disponível 24h por dia',
    ),
    (
      Icons.chat_outlined,
      'WhatsApp',
      '(79) 99812-3456',
      'Seg – Sex, 8h às 22h',
    ),
    (
      Icons.facebook_outlined,
      'Facebook',
      '/CultureLocalOficial',
      'Resposta em até 1 dia útil',
    ),
    (
      Icons.camera_alt_outlined,
      'Instagram',
      '@culturelocal',
      'Resposta em até 1 dia útil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _topBanner(context),
            Expanded(
              child: _showFaq ? _faqList() : _contactList(),
            ),
            _bottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _faqList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: _faq.length,
      itemBuilder: (_, i) => _faqItem(i),
    );
  }

  Widget _faqItem(int index) {
    final item = _faq[index];
    final isOpen = _expanded == index;

    return GestureDetector(
      onTap: () => setState(() => _expanded = isOpen ? null : index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.$1,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _green,
                  ),
                ],
              ),
              if (isOpen) ...[
                const SizedBox(height: 8),
                Text(
                  item.$2,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        const Text(
          'SAC Gratuito',
          style: TextStyle(
            fontSize: 13,
            color: Colors.black45,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '0800 079 0042',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _green,
          ),
        ),
        const Text(
          'Seg – Sex, 8h às 20h  •  Ligação gratuita',
          style: TextStyle(fontSize: 12, color: Colors.black45),
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 8),
        ...List.generate(_contacts.length, (i) => _contactItem(i)),
      ],
    );
  }

  Widget _contactItem(int index) {
    final item = _contacts[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.$1, size: 22, color: _green),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.$2,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    item.$3,
                    style: const TextStyle(
                      fontSize: 14,
                      color: _green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    item.$4,
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _yellow,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => navigateToRootRoute(context, AppRoutes.index),
                child: const Icon(Icons.chevron_left, size: 28),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Suporte',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 28),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Precisa De Ajuda?',
            style: TextStyle(
              color: _green,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _tabBtn('FAQ', _showFaq, () {
                  setState(() {
                    _showFaq = true;
                    _expanded = null;
                  });
                }),
                _tabBtn('Nos Ligue', !_showFaq, () {
                  setState(() {
                    _showFaq = false;
                    _expanded = null;
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: active ? (label == 'FAQ' ? _yellow : _green) : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: active
                ? (label == 'FAQ' ? Colors.black87 : Colors.white)
                : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return const CultureBottomNav(currentItem: CultureBottomNavItem.support);
  }
}
