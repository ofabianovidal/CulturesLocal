import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserProfile {
  const AppUserProfile({
    required this.uid,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.dataNascimento,
    required this.criadoPor,
    this.criadoEm,
  });

  final String uid;
  final String nome;
  final String email;
  final String telefone;
  final String dataNascimento;
  final String criadoPor;
  final DateTime? criadoEm;

  factory AppUserProfile.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};

    return AppUserProfile(
      uid: doc.id,
      nome: data['nome'] as String? ?? '',
      email: data['email'] as String? ?? '',
      telefone: data['telefone'] as String? ?? '',
      dataNascimento: data['data_nascimento'] as String? ?? '',
      criadoPor: data['criado_por'] as String? ?? '',
      criadoEm: (data['criado_em'] as Timestamp?)?.toDate(),
    );
  }
}
