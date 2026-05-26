import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/bottom_nav.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  int _selectedTab = 0;

  static const _tabs = ['Ativos', 'Completos', 'Cancelados'];

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
                  const SizedBox(height: 84),
                  Expanded(
                    child: _selectedTab == 0
                        ? _activeEmptyState(context)
                        : _genericEmptyState(),
                  ),
                ],
              ),
            ),
          ),
          const CultureBottomNav(
            currentItem: CultureBottomNavItem.myEvents,
          ),
        ],
      ),
    );
  }

  Widget _activeEmptyState(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.createEvent);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(
            Icons.assignment_return_outlined,
            size: 186,
            color: Color(0xFFFFE83B),
          ),
          SizedBox(height: 26),
          Text(
            'Você não tem eventos\nativos',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.green,
              fontSize: 26,
              fontWeight: FontWeight.w600,
              height: 1.05,
            ),
          ),
        ],
      ),
    );
  }

  Widget _genericEmptyState() {
    final text = _selectedTab == 1
        ? 'Você não tem eventos\ncompletos'
        : 'Você não tem eventos\ncancelados';

    return Column(
      children: [
        Icon(
          _selectedTab == 1
              ? Icons.task_alt_outlined
              : Icons.event_busy_outlined,
          size: 148,
          color: const Color(0xFFFFE83B),
        ),
        const SizedBox(height: 20),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.green,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            height: 1.05,
          ),
        ),
      ],
    );
  }
}
