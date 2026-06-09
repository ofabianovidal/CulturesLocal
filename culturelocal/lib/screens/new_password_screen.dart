import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  late final TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showMessage('Digite seu e-mail institucional para continuar.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.sendPasswordResetEmail(email);
      if (!mounted) {
        return;
      }

      _showMessage('Enviamos o link de redefinicao para o seu e-mail.');
      Navigator.of(context).pop();
    } on AppAuthException catch (error) {
      _showMessage(error.message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return CultureAuthScaffold(
      title: 'Recuperar Senha',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(36, 114, 36, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informe o e-mail institucional vinculado a sua conta para receber o link de redefinicao.',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 24),
            CultureTextField(
              label: 'E-mail institucional',
              hintText: 'seu.nome@souunit.com.br',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 34),
            Center(
              child: CulturePillButton(
                label: _isLoading ? 'Enviando...' : 'Enviar Link',
                width: 198,
                height: 38,
                fontSize: 14,
                onPressed: _isLoading ? null : _sendResetEmail,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
