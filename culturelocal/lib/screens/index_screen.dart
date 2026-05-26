import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/event_card.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int _selectedCategory = 0;

  static const _categories = [
    ('Sertaneja', Icons.music_note_outlined),
    ('Forró', Icons.queue_music_outlined),
    ('Música', Icons.library_music_outlined),
    ('Teatro', Icons.theater_comedy_outlined),
    ('Outras', Icons.more_horiz_rounded),
  ];

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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
                  child: Column(
                    children: [
                      CultureEventCard(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.event);
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 1,
                        color: const Color(0xFFE9D5C4),
                      ),
                      const SizedBox(height: 20),
                      _promoBanner(),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ),
            const CultureBottomNav(
              currentItem: CultureBottomNavItem.home,
            ),
          ],
        ),
      ),
    );
  }

  Widget _topRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 28,
            padding: const EdgeInsets.only(left: 12, right: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Search',
                    style: TextStyle(
                      color: Color(0xFF9F9F9F),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.filters);
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.green,
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

  Widget _topAction({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.green,
        ),
      ),
    );
  }

  Widget _categoriesRow() {
    return SizedBox(
      height: 102,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_categories.length, (index) {
          final item = _categories[index];
          final isSelected = index == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = index;
              });
            },
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
                        _categoryIcon(item.$2),
                        const SizedBox(height: 6),
                        Text(
                          item.$1,
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
                      _categoryIcon(item.$2),
                      const SizedBox(height: 6),
                      Text(
                        item.$1,
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
      child: Icon(
        icon,
        size: 31,
        color: Colors.black,
      ),
    );
  }

  Widget _promoBanner() {
    return Container(
      width: double.infinity,
      height: 165,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0x12F6D15D),
            Color(0x25F6D15D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(22, 30, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Experience\nDelicious New Dish',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.05,
              ),
            ),
            Spacer(),
            Text(
              '30% OFF',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
