import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/event_filters.dart';
import '../widgets/bottom_nav.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);

  EventFilters _initial = EventFilters.empty;
  bool _loaded = false;

  late int _selectedCategory;
  late String? _selectedPeriodo;
  late double _maxPrice;

  static const _categoryIcons = [
    Icons.music_note_outlined,
    Icons.queue_music_outlined,
    Icons.audiotrack_outlined,
    Icons.theater_comedy_outlined,
    Icons.more_horiz,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is EventFilters) {
      _initial = args;
    }

    _selectedCategory = _initial.categoria == null
        ? -1
        : kCategoryKeys.indexOf(_initial.categoria!);
    _selectedPeriodo = _initial.periodo;
    _maxPrice = _initial.maxPreco;
    _loaded = true;
  }

  void _apply() {
    final categoria =
        _selectedCategory >= 0 ? kCategoryKeys[_selectedCategory] : null;
    final filters = EventFilters(
      categoria: categoria,
      periodo: _selectedPeriodo,
      maxPreco: _maxPrice,
    );
    Navigator.of(context).pop(filters);
  }

  void _clear() {
    Navigator.of(context).pop(EventFilters.empty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _yellow,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      _sectionLabel('Categoria'),
                      const SizedBox(height: 14),
                      _categoriesRow(),
                      const SizedBox(height: 24),
                      _sectionLabel('Período'),
                      const SizedBox(height: 12),
                      _periodoRow(),
                      const SizedBox(height: 24),
                      _sectionLabel('Preço máximo', color: _green),
                      const SizedBox(height: 12),
                      _priceSlider(),
                      const SizedBox(height: 32),
                      _applyButton(context),
                      const SizedBox(height: 12),
                      _clearButton(context),
                    ],
                  ),
                ),
              ),
            ),
            _bottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.chevron_left, size: 28),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Filtros',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            children: [
              _headerIcon(
                Icons.shopping_cart_outlined,
                () => Navigator.of(context).pushNamed(AppRoutes.cart),
              ),
              const SizedBox(width: 10),
              _headerIcon(
                Icons.notifications_outlined,
                () => Navigator.of(context).pushNamed(AppRoutes.notifications),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Icon(icon, size: 24));
  }

  Widget _sectionLabel(String text, {Color color = Colors.black87}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  Widget _categoriesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(kCategoryKeys.length, (i) {
        final selected = _selectedCategory == i;
        return GestureDetector(
          onTap: () => setState(
            () => _selectedCategory = selected ? -1 : i,
          ),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: selected ? _yellow : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14),
                  border: selected ? Border.all(color: _green, width: 2) : null,
                ),
                child: Icon(_categoryIcons[i], size: 26, color: _green),
              ),
              const SizedBox(height: 6),
              Text(
                kCategoryLabels[i],
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _periodoRow() {
    return Row(
      children: [
        _periodoChip('diurno', Icons.wb_sunny_outlined, 'Diurno'),
        const SizedBox(width: 12),
        _periodoChip('noturno', Icons.nights_stay_outlined, 'Noturno'),
      ],
    );
  }

  Widget _periodoChip(String value, IconData icon, String label) {
    final selected = _selectedPeriodo == value;
    return GestureDetector(
      onTap: () =>
          setState(() => _selectedPeriodo = selected ? null : value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _green : _yellow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: selected ? Colors.white : Colors.black87),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceSlider() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _green,
            inactiveTrackColor: Colors.grey.shade200,
            thumbColor: _green,
            overlayColor: _green.withValues(alpha: 0.15),
            trackHeight: 4,
          ),
          child: Slider(
            value: _maxPrice,
            min: 10,
            max: 200,
            onChanged: (v) => setState(() => _maxPrice = v),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'R\$10',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(
                'Até R\$ ${_maxPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Text(
                'R\$200',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _applyButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: _apply,
        child: const Text(
          'Aplicar Filtros',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _clearButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: _green,
          side: const BorderSide(color: Color(0xFF1A7A3C)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: _clear,
        child: const Text(
          'Limpar Filtros',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return const CultureBottomNav(currentItem: CultureBottomNavItem.home);
  }
}
