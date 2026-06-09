import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppEvent {
  const AppEvent({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.telefone,
    required this.status,
    required this.criadoPor,
    required this.uidCriador,
    required this.data,
    required this.preco,
    this.criadoEm,
  });

  final String id;
  final String nome;
  final String descricao;
  final String telefone;
  final String status;
  final String criadoPor;
  final String uidCriador;
  final DateTime data;
  final double preco;
  final DateTime? criadoEm;

  factory AppEvent.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};

    return AppEvent(
      id: doc.id,
      nome: data['nome'] as String? ?? 'Evento sem nome',
      descricao: data['descricao'] as String? ?? '',
      telefone: data['telefone'] as String? ?? '',
      status: data['status'] as String? ?? 'ativo',
      criadoPor: data['criado_por'] as String? ?? '',
      uidCriador: data['uid_criador'] as String? ?? '',
      data: _readDate(data['data']),
      preco: _readDouble(data['preco']),
      criadoEm: _readDateNullable(data['criado_em']),
    );
  }

  factory AppEvent.fromFavoriteDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};

    return AppEvent(
      id: data['event_id'] as String? ?? doc.id,
      nome: data['nome'] as String? ?? 'Evento favoritado',
      descricao: data['descricao'] as String? ?? '',
      telefone: data['telefone'] as String? ?? '',
      status: data['status'] as String? ?? 'ativo',
      criadoPor: data['criado_por_evento'] as String? ?? '',
      uidCriador: data['uid_criador'] as String? ?? '',
      data: _readDate(data['data']),
      preco: _readDouble(data['preco']),
      criadoEm: _readDateNullable(data['criado_em_evento']),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'nome': nome,
      'descricao': descricao,
      'telefone': telefone,
      'status': status,
      'criado_por': criadoPor,
      'uid_criador': uidCriador,
      'data': Timestamp.fromDate(data),
      'preco': preco,
      if (criadoEm != null) 'criado_em': Timestamp.fromDate(criadoEm!),
    };
  }

  Map<String, dynamic> toFavoriteDocument({
    required String favoritadoPor,
    required String uidUsuario,
  }) {
    return {
      'event_id': id,
      'nome': nome,
      'descricao': descricao,
      'telefone': telefone,
      'status': status,
      'data': Timestamp.fromDate(data),
      'preco': preco,
      'uid_criador': uidCriador,
      'criado_por_evento': criadoPor,
      'criado_em_evento': criadoEm == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(criadoEm!),
      'criado_por': favoritadoPor,
      'uid_usuario': uidUsuario,
      'favoritado_em': FieldValue.serverTimestamp(),
    };
  }

  bool belongsTo(String? uid) => uid != null && uidCriador == uid;

  String get formattedDate =>
      DateFormat('dd/MM/yyyy - HH:mm', 'pt_BR').format(data);

  String get formattedPrice =>
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(preco);

  String get statusLabel {
    switch (status) {
      case 'completo':
        return 'Completo';
      case 'cancelado':
        return 'Cancelado';
      default:
        return 'Ativo';
    }
  }

  static DateTime _readDate(dynamic value) {
    return _readDateNullable(value) ?? DateTime.now();
  }

  static DateTime? _readDateNullable(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }

  static double _readDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value.replaceAll(',', '.')) ?? 0;
    }

    return 0;
  }
}
