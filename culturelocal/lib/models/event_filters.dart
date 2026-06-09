import 'app_event.dart';

const kCategoryKeys = [
  'sertaneja',
  'forro',
  'musica',
  'teatro',
  'outras',
];

const kCategoryLabels = [
  'Sertaneja',
  'Forró',
  'Música',
  'Teatro',
  'Outras',
];

class EventFilters {
  const EventFilters({
    this.categoria,
    this.periodo,
    this.maxPreco = 200,
  });

  final String? categoria;
  final String? periodo;
  final double maxPreco;

  static const empty = EventFilters();

  bool get isActive =>
      categoria != null || periodo != null || maxPreco < 200;

  EventFilters copyWith({
    Object? categoria = _sentinel,
    Object? periodo = _sentinel,
    double? maxPreco,
  }) {
    return EventFilters(
      categoria: categoria == _sentinel
          ? this.categoria
          : categoria as String?,
      periodo: periodo == _sentinel ? this.periodo : periodo as String?,
      maxPreco: maxPreco ?? this.maxPreco,
    );
  }

  bool matches(AppEvent event) {
    if (categoria != null && event.categoria != categoria) return false;
    if (periodo != null && event.periodo != periodo) return false;
    if (event.preco > maxPreco) return false;
    return true;
  }
}

const _sentinel = Object();
