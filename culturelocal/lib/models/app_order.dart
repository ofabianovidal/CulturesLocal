import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppOrderItem {
  const AppOrderItem({
    required this.eventId,
    required this.eventNome,
    required this.eventDescricao,
    required this.qty,
    required this.preco,
  });

  final String eventId;
  final String eventNome;
  final String eventDescricao;
  final int qty;
  final double preco;

  double get subtotal => preco * qty;

  Map<String, dynamic> toMap() => {
        'event_id': eventId,
        'event_nome': eventNome,
        'event_descricao': eventDescricao,
        'qty': qty,
        'preco': preco,
      };

  factory AppOrderItem.fromMap(Map<String, dynamic> map) => AppOrderItem(
        eventId: map['event_id'] as String? ?? '',
        eventNome: map['event_nome'] as String? ?? '',
        eventDescricao: map['event_descricao'] as String? ?? '',
        qty: (map['qty'] as num?)?.toInt() ?? 1,
        preco: (map['preco'] as num?)?.toDouble() ?? 0,
      );
}

class AppOrder {
  const AppOrder({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.taxa,
    required this.total,
    required this.criadoEm,
  });

  final String id;
  final List<AppOrderItem> items;
  final double subtotal;
  final double taxa;
  final double total;
  final DateTime criadoEm;

  String get formattedTotal =>
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(total);

  String get formattedDate =>
      DateFormat('dd/MM/yyyy - HH:mm', 'pt_BR').format(criadoEm);

  factory AppOrder.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final itemsData = data['items'] as List<dynamic>? ?? [];
    return AppOrder(
      id: doc.id,
      items: itemsData
          .whereType<Map<String, dynamic>>()
          .map(AppOrderItem.fromMap)
          .toList(),
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0,
      taxa: (data['taxa'] as num?)?.toDouble() ?? 0,
      total: (data['total'] as num?)?.toDouble() ?? 0,
      criadoEm: _readDate(data['criado_em']),
    );
  }

  static DateTime _readDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    return DateTime.now();
  }
}
