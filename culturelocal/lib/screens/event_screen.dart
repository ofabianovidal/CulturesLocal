import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/app_event.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/event_card.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  int _qty = 1;

  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);

  Future<void> _toggleFavorite(AppEvent event) async {
    try {
      await FirestoreService.instance.toggleFavorite(event);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel atualizar o favorito.')),
      );
    }
  }

  Future<void> _deleteEvent(AppEvent event) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir evento'),
          content: Text('Deseja excluir "${event.nome}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    if (!mounted) {
      return;
    }

    try {
      await FirestoreService.instance.deleteEvent(event.id);
      if (!mounted) {
        return;
      }
      navigateToRootRoute(context, AppRoutes.myEvents);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Evento "${event.nome}" excluido.')),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel excluir o evento.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialEvent =
        ModalRoute.of(context)?.settings.arguments as AppEvent?;
    if (initialEvent == null) {
      return Scaffold(
        backgroundColor: _yellow,
        body: const Center(
          child: Text(
            'Nenhum evento foi selecionado.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return StreamBuilder<AppEvent?>(
      stream: FirestoreService.instance.watchEvent(initialEvent.id),
      builder: (context, snapshot) {
        final event = snapshot.data ?? initialEvent;
        final isOwner = event.belongsTo(AuthService.instance.currentUser?.uid);

        return Scaffold(
          backgroundColor: _yellow,
          body: SafeArea(
            child: Column(
              children: [
                _header(context, event, isOwner),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _coverImage(),
                        const SizedBox(height: 20),
                        _priceAndQty(event),
                        const SizedBox(height: 16),
                        Text(
                          event.nome,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.descricao,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _infoLine(Icons.event_outlined, event.formattedDate),
                        const SizedBox(height: 8),
                        _infoLine(Icons.phone_outlined, event.telefone),
                        const SizedBox(height: 8),
                        _infoLine(
                          Icons.verified_user_outlined,
                          event.criadoPor,
                        ),
                        const SizedBox(height: 8),
                        _infoLine(
                          Icons.flag_outlined,
                          'Status: ${event.statusLabel}',
                        ),
                        if (isOwner) ...[
                          const SizedBox(height: 22),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      AppRoutes.createEvent,
                                      arguments: event,
                                    );
                                  },
                                  child: const Text('Editar'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _deleteEvent(event),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red.shade700,
                                  ),
                                  child: const Text('Excluir'),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                _buyButton(context),
                _bottomNav(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context, AppEvent event, bool isOwner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.chevron_left, size: 28),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              event.nome,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
          if (isOwner)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Seu evento',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          StreamBuilder<bool>(
            stream: FirestoreService.instance.watchIsFavorite(event.id),
            builder: (context, snapshot) {
              final isFavorite = snapshot.data ?? false;
              return GestureDetector(
                onTap: () => _toggleFavorite(event),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isFavorite ? Colors.red : Colors.black87,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _coverImage() {
    return CultureEventPoster(
      width: MediaQuery.of(context).size.width - 32,
      height: 220,
      borderRadius: BorderRadius.circular(20),
    );
  }

  Widget _priceAndQty(AppEvent event) {
    return Row(
      children: [
        Text(
          event.formattedPrice,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              _qtyBtn(Icons.remove, () {
                if (_qty > 1) {
                  setState(() => _qty--);
                }
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '$_qty',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              _qtyBtn(Icons.add, () => setState(() => _qty++)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Icon(icon, size: 18),
      ),
    );
  }

  Widget _infoLine(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _green),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: _green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          icon: const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: 20,
          ),
          label: const Text(
            'Comprar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.cart),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return const CultureBottomNav(currentItem: CultureBottomNavItem.home);
  }
}
