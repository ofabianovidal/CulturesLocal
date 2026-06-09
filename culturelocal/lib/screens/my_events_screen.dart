import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/app_event.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/custom_button.dart';
import '../widgets/event_card.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  int _selectedTab = 0;

  static const _tabs = ['Ativos', 'Completos', 'Cancelados'];
  static const _statusByTab = ['ativo', 'completo', 'cancelado'];

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
    return CultureAuthScaffold(
      title: 'Meus eventos',
      onBack: () => navigateToRootRoute(context, AppRoutes.index),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: Column(
                children: [
                  Row(
                    children: List.generate(_tabs.length, (index) {
                      final isSelected = index == _selectedTab;
                      return Padding(
                        padding: EdgeInsets.only(right: index == 2 ? 0 : 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTab = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.green
                                  : const Color(0xFFFFE83B),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              _tabs[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CulturePillButton(
                      label: 'Novo Evento',
                      width: 150,
                      height: 38,
                      fontSize: 13,
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.createEvent);
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: StreamBuilder<List<AppEvent>>(
                      stream: FirestoreService.instance.watchMyEvents(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final events = (snapshot.data ?? const <AppEvent>[])
                            .where(
                              (event) =>
                                  event.status == _statusByTab[_selectedTab],
                            )
                            .toList();

                        if (events.isEmpty) {
                          return _emptyState(context);
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: events.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return CultureEventCard(
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(AppRoutes.event, arguments: event);
                              },
                              title: event.nome,
                              description: event.descricao,
                              dateLabel: event.formattedDate,
                              priceLabel: event.formattedPrice,
                              topRight: PopupMenuButton<_EventAction>(
                                onSelected: (action) {
                                  switch (action) {
                                    case _EventAction.edit:
                                      Navigator.of(context).pushNamed(
                                        AppRoutes.createEvent,
                                        arguments: event,
                                      );
                                    case _EventAction.delete:
                                      _deleteEvent(event);
                                  }
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: _EventAction.edit,
                                    child: Text('Editar'),
                                  ),
                                  PopupMenuItem(
                                    value: _EventAction.delete,
                                    child: Text('Excluir'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const CultureBottomNav(currentItem: CultureBottomNavItem.myEvents),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    final icon = switch (_statusByTab[_selectedTab]) {
      'completo' => Icons.task_alt_outlined,
      'cancelado' => Icons.event_busy_outlined,
      _ => Icons.assignment_return_outlined,
    };

    final text = switch (_statusByTab[_selectedTab]) {
      'completo' => 'Você não tem eventos\ncompletos',
      'cancelado' => 'Você não tem eventos\ncancelados',
      _ => 'Você não tem eventos\nativos',
    };

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.createEvent);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 186, color: const Color(0xFFFFE83B)),
          const SizedBox(height: 26),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.green,
              fontSize: 26,
              fontWeight: FontWeight.w600,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Toque aqui para criar o seu primeiro registro.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.text, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

enum _EventAction { edit, delete }
