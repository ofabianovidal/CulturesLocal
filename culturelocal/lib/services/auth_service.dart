import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Domínio institucional exigido pela atividade.
/// Só contas terminando em @souunit.com.br podem acessar.
const String kDominioPermitido = '@souunit.com.br';

/// Exceção lançada quando o e-mail não pertence ao domínio permitido.
class DominioInvalidoException implements Exception {
  final String message;
  DominioInvalidoException(this.message);
  @override
  String toString() => message;
}

/// Centraliza a autenticação: e-mail/senha, Google e validação de domínio.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Stream que emite o usuário sempre que o login/logout muda.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Usuário logado no momento (ou null).
  User? get currentUser => _auth.currentUser;

  /// E-mail do usuário logado. Usado para preencher "criado_por" no Firestore.
  String get currentEmail => _auth.currentUser?.email ?? 'desconhecido';

  /// Confere se o e-mail pertence ao domínio institucional.
  bool _dominioValido(String? email) {
    if (email == null) return false;
    return email.toLowerCase().endsWith(kDominioPermitido);
  }

  /// LOGIN COM E-MAIL E SENHA
  Future<User?> entrarComEmail(String email, String senha) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );

    // Regra de negócio: barra quem não é do domínio e desloga na hora.
    if (!_dominioValido(cred.user?.email)) {
      await sair();
      throw DominioInvalidoException(
        'Acesso permitido apenas para contas $kDominioPermitido',
      );
    }
    return cred.user;
  }

  /// CADASTRO COM E-MAIL E SENHA
  Future<User?> cadastrarComEmail(String email, String senha) async {
    if (!_dominioValido(email)) {
      throw DominioInvalidoException(
        'Cadastro permitido apenas para contas $kDominioPermitido',
      );
    }
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
    return cred.user;
  }

  /// LOGIN COM GOOGLE (Google Sign-In)
  Future<User?> entrarComGoogle() async {
    // 1. Abre o popup de seleção de conta Google.
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // usuário cancelou

    // 2. Pega os tokens dessa conta.
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // 3. Cria a credencial do Firebase a partir dos tokens.
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 4. Faz login no Firebase com a credencial.
    final cred = await _auth.signInWithCredential(credential);

    // 5. Valida o domínio. Se não for institucional, desloga.
    if (!_dominioValido(cred.user?.email)) {
      await sair();
      throw DominioInvalidoException(
        'Acesso permitido apenas para contas $kDominioPermitido',
      );
    }
    return cred.user;
  }

  /// LOGOUT (desconecta do Firebase e do Google)
  Future<void> sair() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}