import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/app_event.dart';
import '../models/event_filters.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/event_card.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  EventFilters _filters = EventFilters.empty;

  static const _categoryIcons = [
    Icons.music_note_outlined,
    Icons.queue_music_outlined,
    Icons.library_music_outlined,
    Icons.theater_comedy_outlined,
    Icons.more_horiz_rounded,
  ];

  int get _selectedCategory {
    if (_filters.categoria == null) return -1;
    return kCategoryKeys.indexOf(_filters.categoria!);
  }

  Future<void> _openFilters() async {
    final result = await Navigator.of(context).pushNamed(
      AppRoutes.filters,
      arguments: _filters,
    );
    if (result is EventFilters) {
      setState(() => _filters = result);
    }
  }

  void _selectCategory(int index) {
    final key = kCategoryKeys[index];
    setState(() {
      _filters = _filters.copyWith(
        categoria: _filters.categoria == key ? null : key,
      );
    });
  }

  Future<void> _toggleFavorite(AppEvent event) async {
    try {
      await FirestoreService.instance.toggleFavorite(event);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel atualizar o favorito.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellow,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
              child: Column(
                children: [
                  _topRow(context),
                  const SizedBox(height: 20),
                  _categoriesRow(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 2),
                decoration: const BoxDecoration(
                  color: AppColors.softPanel,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
                ),
                child: StreamBuilder<List<AppEvent>>(
                  stream: FirestoreService.instance.watchPublicEvents(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final all = snapshot.data ?? const <AppEvent>[];
                    final events = _filters.isActive
                        ? all.where(_filters.matches).toList()
                        : all;

                    if (events.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Text(
                            all.isEmpty
                                ? 'Nenhum evento cadastrado ainda.\nCrie o primeiro em "Meus eventos".'
                                : 'Nenhum evento encontrado com os filtros aplicados.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 90),
                      itemCount: events.length,
                      separatorBuilder: (_, _) =>
                          Container(height: 1, color: const Color(0xFFE9D5C4)),
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return StreamBuilder<bool>(
                          stream: FirestoreService.instance.watchIsFavorite(
                            event.id,
                          ),
                          builder: (context, favSnap) {
                            return CultureEventCard(
                              onTap: () => Navigator.of(context).pushNamed(
                                AppRoutes.event,
                                arguments: event,
                              ),
                              title: event.nome,
                              description: event.descricao,
                              dateLabel: event.formattedDate,
                              priceLabel: event.formattedPrice,
                              showFavoriteBadge: true,
                              isFavorite: favSnap.data ?? false,
                              onFavoriteTap: () => _toggleFavorite(event),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const CultureBottomNav(currentItem: CultureBottomNavItem.home),
          ],
        ),
      ),
    );
  }

  Widget _topRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _openFilters,
            child: Container(
              height: 28,
              padding: const EdgeInsets.only(left: 12, right: 4),
              decoration: BoxDecoration(
                color: _filters.isActive
                    ? AppColors.green.withValues(alpha: 0.12)
                    : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: _filters.isActive
                    ? Border.all(color: AppColors.green, width: 1)
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _filters.isActive
                          ? 'Filtros ativos — toque para editar'
                          : 'Buscar eventos...',
                      style: TextStyle(
                        color: _filters.isActive
                            ? AppColors.green
                            : const Color(0xFF9F9F9F),
                        fontSize: 12,
                        fontWeight: _filters.isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _openFilters,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _filters.isActive
                            ? AppColors.green
                            : AppColors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _topAction(
          icon: Icons.shopping_cart_outlined,
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.cart),
        ),
        const SizedBox(width: 8),
        _topAction(
          icon: Icons.notifications_none_rounded,
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
        ),
      ],
    );
  }

  Widget _topAction({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: AppColors.green),
      ),
    );
  }

  Widget _categoriesRow() {
    return SizedBox(
      height: 102,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(kCategoryKeys.length, (index) {
          final isSelected = index == _selectedCategory;

          return GestureDetector(
            onTap: () => _selectCategory(index),
            child: isSelected
                ? Container(
                    width: 74,
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        _categoryIcon(_categoryIcons[index]),
                        const SizedBox(height: 6),
                        Text(
                          kCategoryLabels[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.text,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 10),
                      _categoryIcon(_categoryIcons[index]),
                      const SizedBox(height: 6),
                      Text(
                        kCategoryLabels[index],
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.text,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
          );
        }),
      ),
    );
  }

  Widget _categoryIcon(IconData icon) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFFBE89A),
        borderRadius: BorderRadius.circular(29),
      ),
      child: Icon(icon, size: 31, color: Colors.black),
    );
  }
}
