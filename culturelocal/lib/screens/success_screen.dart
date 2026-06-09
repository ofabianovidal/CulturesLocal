import 'package:flutter/material.dart';

import '../app_routes.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _yellow,
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 130, color: Color(0xFF2DB84B)),
                  SizedBox(height: 32),
                  Text('Pedido Confirmado',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Seu pedido foi concluído com sucesso, mais informações no e-mail.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Para qualquer dúvida, consulte o suporte.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black45)),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  // Volta para a tela de eventos, limpando a pilha de compra.
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.event, (_) => false),
                  child: const Text('Voltar aos eventos',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}