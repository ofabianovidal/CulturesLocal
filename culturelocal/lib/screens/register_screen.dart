import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CultureAuthScaffold(
      title: 'Cadastro',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(36, 30, 36, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CultureTextField(
              label: 'Nome completo',
              hintText: 'Exemplo De Exemplo',
            ),
            const SizedBox(height: 8),
            const CultureTextField(
              label: 'Senha',
              hintText: '************',
              obscureText: true,
            ),
            const SizedBox(height: 8),
            const CultureTextField(
              label: 'Email',
              hintText: 'exemplo@exemplo.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            const CultureTextField(
              label: 'Número de Telefone',
              hintText: '+55 (11) 12345-6789',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            const CultureTextField(
              label: 'Data de Nascimento',
              hintText: 'DD / MM / YYY',
              keyboardType: TextInputType.datetime,
              textInputAction: TextInputAction.done,
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
                label: 'Cadastrar',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.index,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'ou se cadastre de outras maneiras',
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
              children: const [
                _GoogleButton(),
                SizedBox(width: 10),
                _FacebookButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton();

  @override
  Widget build(BuildContext context) {
    return CultureSocialButton(
      child: const Text(
        'G',
        style: TextStyle(
          color: AppColors.green,
          fontSize: 21,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {},
    );
  }
}

class _FacebookButton extends StatelessWidget {
  const _FacebookButton();

  @override
  Widget build(BuildContext context) {
    return CultureSocialButton(
      child: const Icon(
        Icons.facebook,
        color: AppColors.green,
        size: 23,
      ),
      onTap: () {},
    );
  }
}
