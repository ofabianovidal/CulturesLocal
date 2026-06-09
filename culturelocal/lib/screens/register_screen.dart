import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _birthDateController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _birthDateController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final password = _passwordController.text;
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final birthDate = _birthDateController.text.trim();

    if (name.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        birthDate.isEmpty) {
      _showMessage('Preencha todos os campos para finalizar o cadastro.');
      return;
    }

    if (password.length < 6) {
      _showMessage('A senha precisa ter pelo menos 6 caracteres.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.registerWithEmail(
        name: name,
        email: email,
        password: password,
        phone: phone,
        birthDate: birthDate,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.index, (_) => false);
    } on AppAuthException catch (error) {
      _showMessage(error.message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      await AuthService.instance.signInWithGoogle();

      if (!mounted) {
        return;
      }

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.index, (_) => false);
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
      title: 'Cadastro',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(36, 30, 36, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CultureTextField(
              label: 'Nome completo',
              hintText: 'Exemplo De Exemplo',
              controller: _nameController,
            ),
            const SizedBox(height: 8),
            CultureTextField(
              label: 'Senha',
              hintText: '************',
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 8),
            CultureTextField(
              label: 'Email',
              hintText: 'exemplo@exemplo.com',
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            const SizedBox(height: 8),
            CultureTextField(
              label: 'Número de Telefone',
              hintText: '+55 (11) 12345-6789',
              keyboardType: TextInputType.phone,
              controller: _phoneController,
            ),
            const SizedBox(height: 8),
            CultureTextField(
              label: 'Data de Nascimento',
              hintText: 'DD / MM / YYY',
              keyboardType: TextInputType.datetime,
              textInputAction: TextInputAction.done,
              controller: _birthDateController,
            ),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                'Para continuar, você aceita os temos de serviço.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: CulturePillButton(
                label: _isLoading ? 'Salvando...' : 'Cadastrar',
                onPressed: _isLoading ? null : _register,
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'ou entre com a sua conta Google institucional',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GoogleButton(onTap: _isLoading ? null : _signInWithGoogle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CultureSocialButton(
      onTap: onTap,
      child: const Text(
        'G',
        style: TextStyle(
          color: AppColors.green,
          fontSize: 21,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
