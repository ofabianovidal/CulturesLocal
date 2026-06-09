import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';

enum CultureBottomNavItem { home, profile, favorites, myEvents, support }

void navigateToRootRoute(BuildContext context, String routeName) {
  if (ModalRoute.of(context)?.settings.name == routeName) {
    return;
  }

  Navigator.of(context).pushNamedAndRemoveUntil(routeName, (_) => false);
}

class CultureBottomNav extends StatelessWidget {
  const CultureBottomNav({super.key, required this.currentItem});

  final CultureBottomNavItem currentItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: const BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: CultureBottomNavItem.values.map((item) {
          return _BottomNavButton(
            icon: _iconFor(item),
            isActive: currentItem == item,
            onTap: () => navigateToRootRoute(context, _routeFor(item)),
          );
        }).toList(),
      ),
    );
  }

  IconData _iconFor(CultureBottomNavItem item) {
    switch (item) {
      case CultureBottomNavItem.home:
        return Icons.home_outlined;
      case CultureBottomNavItem.profile:
        return Icons.person_outline_rounded;
      case CultureBottomNavItem.favorites:
        return Icons.favorite_border_rounded;
      case CultureBottomNavItem.myEvents:
        return Icons.assignment_outlined;
      case CultureBottomNavItem.support:
        return Icons.headset_mic_outlined;
    }
  }

  String _routeFor(CultureBottomNavItem item) {
    switch (item) {
      case CultureBottomNavItem.home:
        return AppRoutes.index;
      case CultureBottomNavItem.profile:
        return AppRoutes.profile;
      case CultureBottomNavItem.favorites:
        return AppRoutes.favorites;
      case CultureBottomNavItem.myEvents:
        return AppRoutes.myEvents;
      case CultureBottomNavItem.support:
        return AppRoutes.support;
    }
  }
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Icon(icon, color: Colors.white, size: isActive ? 28 : 26),
      ),
    );
  }
}
