import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/evento.dart';
import 'auth_service.dart';

/// Centraliza todas as operações de banco (CRUD) no Cloud Firestore.
/// Cada registro gravado carrega o e-mail do usuário logado.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  // ---------- EVENTOS (Criar Evento, Event, Filters) ----------

  CollectionReference get _eventos => _db.collection('eventos');

  /// CREATE — cria um novo evento. O criado_por vem do Firebase Auth.
  Future<void> criarEvento({
    required String nome,
    required String data,
    required double preco,
    required String telefone,
  }) async {
    await _eventos.add({
      'nome': nome,
      'data': data,
      'preco': preco,
      'telefone': telefone,
      'criado_por': _auth.currentEmail, // dinâmico, nunca string estática
      'criado_em': FieldValue.serverTimestamp(),
    });
  }

  /// READ — escuta a lista de eventos em tempo real (mais novo primeiro).
  Stream<List<Evento>> ouvirEventos() {
    return _eventos
        .orderBy('criado_em', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Evento.fromDoc(d)).toList());
  }

  /// UPDATE — atualiza campos de um evento existente.
  Future<void> atualizarEvento(String id, Map<String, dynamic> campos) async {
    await _eventos.doc(id).update(campos);
  }

  /// DELETE — remove um evento pelo id.
  Future<void> deletarEvento(String id) async {
    await _eventos.doc(id).delete();
  }

  // ---------- PEDIDOS (Cart / Checkout / Success) ----------

  CollectionReference get _pedidos => _db.collection('pedidos');

  /// Salva um pedido finalizado. Pagamento apenas simulado.
  Future<String> criarPedido({
    required String nomeEvento,
    required int quantidade,
    required double total,
    required String enderecoCobranca,
    required String cartaoMascarado,
  }) async {
    final doc = await _pedidos.add({
      'evento': nomeEvento,
      'quantidade': quantidade,
      'total': total,
      'endereco_cobranca': enderecoCobranca,
      'cartao': cartaoMascarado,
      'status': 'confirmado',
      'usuario_logado': _auth.currentEmail, // exigência da atividade
      'criado_em': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  // ---------- PREFERÊNCIAS DE NOTIFICAÇÃO (tela Notificações) ----------

  /// Salva as preferências do usuário (id do doc = e-mail do usuário).
  Future<void> salvarPreferencias(Map<String, bool> prefs) async {
    await _db.collection('preferencias').doc(_auth.currentEmail).set({
      ...prefs,
      'usuario_logado': _auth.currentEmail,
      'atualizado_em': FieldValue.serverTimestamp(),
    });
  }

  /// Lê as preferências salvas (ou null se nunca salvou).
  Future<Map<String, dynamic>?> lerPreferencias() async {
    final doc =
        await _db.collection('preferencias').doc(_auth.currentEmail).get();
    return doc.exists ? doc.data() : null;
  }

  // ---------- MENSAGENS DE SUPORTE (tela Suporte) ----------

  /// Registra uma solicitação de contato/suporte do usuário.
  Future<void> enviarSolicitacaoSuporte({
    required String canal,
    required String mensagem,
  }) async {
    await _db.collection('suporte').add({
      'canal': canal,
      'mensagem': mensagem,
      'usuario_logado': _auth.currentEmail,
      'criado_em': FieldValue.serverTimestamp(),
    });
  }
}