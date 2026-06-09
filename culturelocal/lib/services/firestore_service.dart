import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_event.dart';
import '../models/app_order.dart';
import '../models/app_user_profile.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  CollectionReference<Map<String, dynamic>> get _events =>
      _db.collection('events');

  CollectionReference<Map<String, dynamic>> get _orders =>
      _db.collection('orders');

  User get _requiredUser {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Usuario nao autenticado.');
    }
    return user;
  }

  CollectionReference<Map<String, dynamic>> _favoritesCollection(String uid) {
    return _users.doc(uid).collection('favorites');
  }

  // ── User profile ──────────────────────────────────────────────────────────

  Future<void> ensureCurrentUserProfile({
    String? name,
    String? phone,
    String? birthDate,
  }) async {
    final user = _requiredUser;
    final docRef = _users.doc(user.uid);
    final snapshot = await docRef.get();

    final currentData = snapshot.data() ?? <String, dynamic>{};
    final resolvedName = _pickValue(
      primary: name,
      secondary: currentData['nome'] as String?,
      fallback: user.displayName,
    );
    final resolvedPhone = _pickValue(
      primary: phone,
      secondary: currentData['telefone'] as String?,
    );
    final resolvedBirthDate = _pickValue(
      primary: birthDate,
      secondary: currentData['data_nascimento'] as String?,
    );

    final payload = <String, dynamic>{
      'uid': user.uid,
      'nome': resolvedName,
      'email': user.email ?? '',
      'telefone': resolvedPhone,
      'data_nascimento': resolvedBirthDate,
      'criado_por': user.email ?? '',
      'atualizado_em': FieldValue.serverTimestamp(),
    };

    if (!snapshot.exists) {
      payload['criado_em'] = FieldValue.serverTimestamp();
    }

    await docRef.set(payload, SetOptions(merge: true));
  }

  Stream<AppUserProfile?> watchCurrentUserProfile() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream<AppUserProfile?>.value(null);
    }

    return _users.doc(user.uid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return AppUserProfile.fromDocument(snapshot);
    });
  }

  Future<void> updateCurrentUserProfile({
    required String name,
    required String phone,
    required String birthDate,
  }) async {
    final user = _requiredUser;

    await ensureCurrentUserProfile(
      name: name,
      phone: phone,
      birthDate: birthDate,
    );

    final trimmedName = name.trim();
    if (trimmedName.isNotEmpty && trimmedName != user.displayName) {
      await user.updateDisplayName(trimmedName);
    }
  }

  // ── Events ────────────────────────────────────────────────────────────────

  Stream<List<AppEvent>> watchPublicEvents() {
    return _events
        .orderBy('data')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(AppEvent.fromDocument).toList());
  }

  Stream<List<AppEvent>> watchMyEvents() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream<List<AppEvent>>.value(const <AppEvent>[]);
    }

    return _events
        .where('uid_criador', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          final events = snapshot.docs.map(AppEvent.fromDocument).toList();
          events.sort((a, b) => a.data.compareTo(b.data));
          return events;
        });
  }

  Stream<AppEvent?> watchEvent(String eventId) {
    return _events.doc(eventId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return AppEvent.fromDocument(snapshot);
    });
  }

  Future<String> saveEvent({
    String? eventId,
    required String nome,
    required String descricao,
    required String telefone,
    required String status,
    required DateTime data,
    required double preco,
    required String categoria,
  }) async {
    final user = _requiredUser;
    final docRef = eventId == null ? _events.doc() : _events.doc(eventId);
    final snapshot = await docRef.get();

    final payload = <String, dynamic>{
      'nome': nome.trim(),
      'descricao': descricao.trim(),
      'telefone': telefone.trim(),
      'status': status,
      'data': Timestamp.fromDate(data),
      'preco': preco,
      'categoria': categoria,
      'uid_criador': user.uid,
      'criado_por': user.email ?? '',
      'atualizado_em': FieldValue.serverTimestamp(),
    };

    if (!snapshot.exists) {
      payload['criado_em'] = FieldValue.serverTimestamp();
    }

    await docRef.set(payload, SetOptions(merge: true));
    return docRef.id;
  }

  Future<void> deleteEvent(String eventId) async {
    await _events.doc(eventId).delete();
  }

  // ── Favorites ─────────────────────────────────────────────────────────────

  Stream<List<AppEvent>> watchFavoriteEvents() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream<List<AppEvent>>.value(const <AppEvent>[]);
    }

    return _favoritesCollection(user.uid)
        .orderBy('favoritado_em', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(AppEvent.fromFavoriteDocument).toList(),
        );
  }

  Stream<bool> watchIsFavorite(String eventId) {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream<bool>.value(false);
    }

    return _favoritesCollection(
      user.uid,
    ).doc(eventId).snapshots().map((snapshot) => snapshot.exists);
  }

  Future<void> toggleFavorite(AppEvent event) async {
    final user = _requiredUser;
    final docRef = _favoritesCollection(user.uid).doc(event.id);
    final snapshot = await docRef.get();

    if (snapshot.exists) {
      await docRef.delete();
      return;
    }

    await docRef.set(
      event.toFavoriteDocument(
        favoritadoPor: user.email ?? '',
        uidUsuario: user.uid,
      ),
    );
  }

  // ── Orders ────────────────────────────────────────────────────────────────

  Future<String> saveOrder({
    required List<AppOrderItem> items,
    required double subtotal,
    required double taxa,
    required double total,
  }) async {
    final user = _requiredUser;
    final docRef = _orders.doc();

    await docRef.set({
      'uid': user.uid,
      'items': items.map((i) => i.toMap()).toList(),
      'subtotal': subtotal,
      'taxa': taxa,
      'total': total,
      'criado_em': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  Stream<List<AppOrder>> watchMyOrders() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream<List<AppOrder>>.value(const <AppOrder>[]);
    }

    return _orders
        .where('uid', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs.map(AppOrder.fromDocument).toList();
          orders.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
          return orders;
        });
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _pickValue({String? primary, String? secondary, String? fallback}) {
    final trimmedPrimary = primary?.trim();
    if (trimmedPrimary != null && trimmedPrimary.isNotEmpty) {
      return trimmedPrimary;
    }

    final trimmedSecondary = secondary?.trim();
    if (trimmedSecondary != null && trimmedSecondary.isNotEmpty) {
      return trimmedSecondary;
    }

    final trimmedFallback = fallback?.trim();
    if (trimmedFallback != null && trimmedFallback.isNotEmpty) {
      return trimmedFallback;
    }

    return '';
  }
}
