import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CultureAuthScaffold(
      title: 'Entrar',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(36, 28, 36, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bem-Vindo',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 94),
            const CultureTextField(
              label: 'Email ou número de telefone',
              hintText: 'exemplo@exemplo.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            const CultureTextField(
              label: 'Senha',
              hintText: '************',
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(top: 10),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.newPassword);
                },
                child: const Text(
                  'Esqueci A Senha',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 54),
            Center(
              child: CulturePillButton(
                label: 'Entrar',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.index,
                  );
                },
              ),
            ),
            const SizedBox(height: 26),
            const Center(
              child: Text(
                'ou tente de outras maneiras',
                style: TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 13,
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
