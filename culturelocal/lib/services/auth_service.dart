import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firestore_service.dart';

class AppAuthException implements Exception {
  const AppAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _googleInitialized = false;

  static const _institutionalDomain = '@souunit.com.br';

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> initialize() async {
    if (!kIsWeb && !_googleInitialized) {
      await GoogleSignIn.instance.initialize(hostedDomain: 'souunit.com.br');
      _googleInitialized = true;
    }

    await evictUnauthorizedSession();
  }

  bool isInstitutionalEmail(String? email) {
    final normalized = email?.trim().toLowerCase();
    return normalized != null && normalized.endsWith(_institutionalDomain);
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (!isInstitutionalEmail(email)) {
      throw const AppAuthException(
        'Use um e-mail institucional @souunit.com.br para entrar.',
      );
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await _enforceInstitutionalAccess(credential.user);
      await FirestoreService.instance.ensureCurrentUserProfile();
    } on FirebaseAuthException catch (error) {
      throw AppAuthException(_firebaseMessage(error));
    }
  }

  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String birthDate,
  }) async {
    if (!isInstitutionalEmail(email)) {
      throw const AppAuthException(
        'O cadastro so pode ser feito com um e-mail @souunit.com.br.',
      );
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (name.trim().isNotEmpty) {
        await credential.user?.updateDisplayName(name.trim());
      }

      await _enforceInstitutionalAccess(credential.user);
      await FirestoreService.instance.ensureCurrentUserProfile(
        name: name,
        phone: phone,
        birthDate: birthDate,
      );
    } on FirebaseAuthException catch (error) {
      throw AppAuthException(_firebaseMessage(error));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (!isInstitutionalEmail(email)) {
      throw const AppAuthException(
        'Informe um e-mail institucional @souunit.com.br.',
      );
    }

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      throw AppAuthException(_firebaseMessage(error));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final credential = kIsWeb
          ? await _signInWithGoogleOnWeb()
          : await _signInWithGoogleOnNative();

      await _enforceInstitutionalAccess(credential.user);
      await FirestoreService.instance.ensureCurrentUserProfile(
        name: credential.user?.displayName,
      );
    } on GoogleSignInException catch (error) {
      throw AppAuthException(_googleMessage(error));
    } on FirebaseAuthException catch (error) {
      throw AppAuthException(_firebaseMessage(error));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();

    if (!kIsWeb) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {
        // If Google session cleanup fails, the Firebase logout above is enough
        // to block app access and keep the workflow consistent.
      }
    }
  }

  Future<void> evictUnauthorizedSession() async {
    final user = currentUser;
    if (user != null && !isInstitutionalEmail(user.email)) {
      await signOut();
    }
  }

  Future<UserCredential> _signInWithGoogleOnWeb() async {
    final provider = GoogleAuthProvider()
      ..setCustomParameters({'hd': 'souunit.com.br'});

    return _auth.signInWithPopup(provider);
  }

  Future<UserCredential> _signInWithGoogleOnNative() async {
    if (!_googleInitialized) {
      await GoogleSignIn.instance.initialize(hostedDomain: 'souunit.com.br');
      _googleInitialized = true;
    }

    final googleUser = await GoogleSignIn.instance.authenticate();
    final googleAuth = googleUser.authentication;
    final firebaseCredential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return _auth.signInWithCredential(firebaseCredential);
  }

  Future<void> _enforceInstitutionalAccess(User? user) async {
    if (!isInstitutionalEmail(user?.email)) {
      await signOut();
      throw const AppAuthException(
        'Acesso permitido apenas para contas @souunit.com.br.',
      );
    }
  }

  String _firebaseMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'Este e-mail ja esta cadastrado.';
      case 'invalid-credential':
      case 'wrong-password':
        return 'E-mail ou senha invalidos.';
      case 'invalid-email':
        return 'Digite um e-mail valido.';
      case 'network-request-failed':
        return 'Falha de conexao. Verifique sua internet.';
      case 'too-many-requests':
        return 'Muitas tentativas seguidas. Tente novamente em instantes.';
      case 'user-not-found':
        return 'Usuario nao encontrado.';
      case 'weak-password':
        return 'A senha precisa ter pelo menos 6 caracteres.';
      default:
        return error.message ?? 'Nao foi possivel concluir a autenticacao.';
    }
  }

  String _googleMessage(GoogleSignInException error) {
    switch (error.code) {
      case GoogleSignInExceptionCode.canceled:
        return 'Login com Google cancelado.';
      case GoogleSignInExceptionCode.interrupted:
        return 'O login com Google foi interrompido. Tente novamente.';
      default:
        return 'Nao foi possivel entrar com o Google.';
    }
  }
}
