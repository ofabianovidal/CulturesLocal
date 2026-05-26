import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);
  static const _neon = Color(0xFFC8F53C);

  int _selectedCategory = 0;
  int _stars = 4;
  final Set<String> _selectedTags = {'Noturno'};
  double _maxPrice = 55;

  final _categories = const [
    (Icons.music_note_outlined, 'Sertanejo'),
    (Icons.queue_music_outlined, 'Forró'),
    (Icons.audiotrack_outlined, 'Música'),
    (Icons.theater_comedy_outlined, 'Teatro'),
    (Icons.more_horiz, 'Outras'),
  ];

  final _tags = ['Raiz', 'Atual', 'Diurno', 'Adultos', 'Noturno', 'Jovens'];

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
                      _sectionLabel('Categories'),
                      const SizedBox(height: 14),
                      _categoriesRow(),
                      const SizedBox(height: 24),
                      _sectionLabel('Ordenar por'),
                      const SizedBox(height: 12),
                      _starsRow(),
                      const SizedBox(height: 8),
                      _sectionLabel('Categorias'),
                      const SizedBox(height: 12),
                      _tagsWrap(),
                      const SizedBox(height: 24),
                      _sectionLabel('Preço', color: _green),
                      const SizedBox(height: 12),
                      _priceSlider(),
                      const SizedBox(height: 32),
                      _applyButton(context),
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
              _headerIcon(Icons.shopping_cart_outlined, () {}),
              const SizedBox(width: 10),
              _headerIcon(Icons.notifications_outlined, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 24),
    );
  }

  Widget _sectionLabel(String text, {Color color = Colors.black87}) {
    return Text(
      text,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color),
    );
  }

  Widget _categoriesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_categories.length, (i) {
        final selected = _selectedCategory == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = i),
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
                child: Icon(_categories[i].$1, size: 26, color: _green),
              ),
              const SizedBox(height: 6),
              Text(
                _categories[i].$2,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _starsRow() {
    return Row(
      children: List.generate(5, (i) {
        return GestureDetector(
          onTap: () => setState(() => _stars = i + 1),
          child: Icon(
            i < _stars ? Icons.star : Icons.star_border,
            color: i < _stars ? _green : Colors.grey.shade300,
            size: 28,
          ),
        );
      }),
    );
  }

  Widget _tagsWrap() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _tags.map((tag) {
        final sel = _selectedTags.contains(tag);
        return GestureDetector(
          onTap: () => setState(() {
            sel ? _selectedTags.remove(tag) : _selectedTags.add(tag);
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: sel ? _green : _yellow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tag,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: sel ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
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
            overlayColor: _green.withOpacity(0.15),
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
            children: const [
              Text('R\$10', style: TextStyle(fontSize: 12, color: Colors.black54)),
              Text('R\$50', style: TextStyle(fontSize: 12, color: Colors.black54)),
              Text('R\$100', style: TextStyle(fontSize: 12, color: Colors.black54)),
              Text('R\$200 >', style: TextStyle(fontSize: 12, color: Colors.black54)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () => Navigator.maybePop(context),
        child: const Text(
          'Aplicar',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home_outlined, () {}),
          _navIcon(Icons.person_outline, () {}),
          _navIcon(Icons.favorite_border, () {}),
          _navIcon(Icons.receipt_long_outlined, () {}),
          _navIcon(Icons.headset_mic_outlined, () {}),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }
}