import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/app_event.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/event_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CultureAuthScaffold(
      title: 'Favoritos',
      onBack: () => navigateToRootRoute(context, AppRoutes.index),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<AppEvent>>(
              stream: FirestoreService.instance.watchFavoriteEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final favorites = snapshot.data ?? const <AppEvent>[];
                if (favorites.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(24, 38, 24, 12),
                    child: Column(
                      children: [
                        Text(
                          'Voce ainda nao favoritou nenhum evento.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Abra um evento na tela inicial e toque no coracao para salvá-lo aqui.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.text, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(18, 28, 18, 12),
                  itemCount: favorites.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final event = favorites[index];
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
                      posterWidth: 158,
                      posterHeight: 122,
                    );
                  },
                );
              },
            ),
          ),
          const CultureBottomNav(currentItem: CultureBottomNavItem.favorites),
        ],
      ),
    );
  }
}
