import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/evento.dart';
import '../services/firestore_service.dart';
import '../widgets/bottom_nav.dart';

/// Lista os eventos do Firestore em tempo real (READ) e permite excluir (DELETE).
/// Tocar no carrinho de um evento leva ao fluxo de compra passando o evento.
class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      backgroundColor: _yellow,
      floatingActionButton: FloatingActionButton(
        backgroundColor: _green,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createEvent),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: StreamBuilder<List<Evento>>(
                stream: firestore.ouvirEventos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }

                  final eventos = snapshot.data ?? [];
                  if (eventos.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum evento ainda.\nToque em + para criar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: eventos.length,
                    itemBuilder: (_, i) => _eventoCard(context, firestore, eventos[i]),
                  );
                },
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.chevron_left, size: 28),
          ),
          const Expanded(
            child: Center(
              child: Text('Eventos',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.filters),
            child: const Icon(Icons.tune, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _eventoCard(BuildContext context, FirestoreService firestore, Evento e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey.shade300,
              child: const Icon(Icons.image, color: Colors.white54),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(e.data, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                const SizedBox(height: 2),
                Text('por ${e.criadoPor}',
                    style: const TextStyle(color: Colors.black38, fontSize: 11)),
              ],
            ),
          ),
          Column(
            children: [
              Text('R\$ ${e.preco.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: _green)),
              const SizedBox(height: 6),
              Row(
                children: [
                  // Vai para o carrinho levando este evento.
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.cart, arguments: e),
                    child: const Icon(Icons.shopping_bag_outlined, size: 22, color: _green),
                  ),
                  const SizedBox(width: 10),
                  // DELETE
                  GestureDetector(
                    onTap: () => _confirmarExclusao(context, firestore, e),
                    child: const Icon(Icons.delete_outline, size: 22, color: Colors.redAccent),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarExclusao(
      BuildContext context, FirestoreService firestore, Evento e) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir evento'),
        content: Text('Deseja excluir "${e.nome}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );
    if (ok == true) {
      await firestore.deletarEvento(e.id);
    }
  }
}