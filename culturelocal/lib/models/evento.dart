import 'package:cloud_firestore/cloud_firestore.dart';

/// Representa um evento salvo no Firestore (coleção "eventos").
class Evento {
  final String id;
  final String nome;
  final String data;
  final double preco;
  final String telefone;
  final String criadoPor; // e-mail de quem criou (exigência da atividade)
  final Timestamp? criadoEm;

  Evento({
    required this.id,
    required this.nome,
    required this.data,
    required this.preco,
    required this.telefone,
    required this.criadoPor,
    this.criadoEm,
  });

  /// Converte um documento do Firestore em objeto Evento.
  factory Evento.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Evento(
      id: doc.id,
      nome: d['nome'] ?? '',
      data: d['data'] ?? '',
      preco: (d['preco'] ?? 0).toDouble(),
      telefone: d['telefone'] ?? '',
      criadoPor: d['criado_por'] ?? '',
      criadoEm: d['criado_em'],
    );
  }
}