import 'package:flutter/material.dart';

import '../app_routes.dart';
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 28, 18, 12),
              child: Column(
                children: [
                  const Text(
                    'Aqui estão seus eventos favoritos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CultureEventCard(
                    posterWidth: 158,
                    posterHeight: 122,
                    showPrice: false,
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.event);
                    },
                  ),
                ],
              ),
            ),
          ),
          const CultureBottomNav(
            currentItem: CultureBottomNavItem.favorites,
          ),
        ],
      ),
    );
  }
}
