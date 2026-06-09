import 'package:flutter/material.dart';

import '../models/evento.dart';
import '../services/firestore_service.dart';
import '../widgets/bottom_nav.dart';

/// Filtros aplicados sobre os eventos lidos do Firestore (dados dinâmicos).
/// A pré-visualização mostra, em tempo real, os eventos dentro do filtro de preço.
class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);

  final _firestore = FirestoreService();

  int _selectedCategory = 0;
  int _stars = 4;
  final Set<String> _selectedTags = {'Noturno'};
  double _maxPrice = 200;

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
                      _label('Categorias'),
                      const SizedBox(height: 14),
                      _categoriesRow(),
                      const SizedBox(height: 24),
                      _label('Ordenar por'),
                      const SizedBox(height: 12),
                      _starsRow(),
                      const SizedBox(height: 8),
                      _label('Tags'),
                      const SizedBox(height: 12),
                      _tagsWrap(),
                      const SizedBox(height: 24),
                      _label('Preço máximo: R\$ ${_maxPrice.toStringAsFixed(0)}', color: _green),
                      _priceSlider(),
                      const SizedBox(height: 16),
                      _label('Eventos dentro do filtro (tempo real)'),
                      const SizedBox(height: 8),
                      _preview(),
                      const SizedBox(height: 24),
                      _applyButton(context),
                    ],
                  ),
                ),
              ),
            ),
            const CultureBottomNav(currentItem: CultureBottomNavItem.myEvents),
          ],
        ),
      ),
    );
  }

  /// Lê os eventos do Firestore e mostra só os que cabem no filtro de preço.
  Widget _preview() {
    return StreamBuilder<List<Evento>>(
      stream: _firestore.ouvirEventos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Carregando eventos...', style: TextStyle(color: Colors.black45)),
          );
        }
        final filtrados = snapshot.data!.where((e) => e.preco <= _maxPrice).toList();
        if (filtrados.isEmpty) {
          return const Text('Nenhum evento dentro do filtro.',
              style: TextStyle(color: Colors.black45));
        }
        return Column(
          children: filtrados.map((e) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event, color: _green),
              title: Text(e.nome),
              trailing: Text('R\$ ${e.preco.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            );
          }).toList(),
        );
      },
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
              child: Text('Filtros', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _label(String t, {Color color = Colors.black87}) =>
      Text(t, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color));

  Widget _categoriesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_categories.length, (i) {
        final sel = _selectedCategory == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = i),
          child: Column(
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: sel ? _yellow : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14),
                  border: sel ? Border.all(color: _green, width: 2) : null,
                ),
                child: Icon(_categories[i].$1, size: 26, color: _green),
              ),
              const SizedBox(height: 6),
              Text(_categories[i].$2, style: const TextStyle(fontSize: 11)),
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
          child: Icon(i < _stars ? Icons.star : Icons.star_border,
              color: i < _stars ? _green : Colors.grey.shade300, size: 28),
        );
      }),
    );
  }

  Widget _tagsWrap() {
    return Wrap(
      spacing: 10, runSpacing: 10,
      children: _tags.map((tag) {
        final sel = _selectedTags.contains(tag);
        return GestureDetector(
          onTap: () => setState(() => sel ? _selectedTags.remove(tag) : _selectedTags.add(tag)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: sel ? _green : _yellow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(tag,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: sel ? Colors.white : Colors.black87)),
          ),
        );
      }).toList(),
    );
  }

  Widget _priceSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: _green,
        inactiveTrackColor: Colors.grey.shade200,
        thumbColor: _green,
      ),
      child: Slider(
        value: _maxPrice,
        min: 10, max: 200,
        onChanged: (v) => setState(() => _maxPrice = v),
      ),
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
        child: const Text('Aplicar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }
}