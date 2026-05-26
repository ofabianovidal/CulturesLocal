import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CultureAuthScaffold(
      title: 'Nova Senha',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(36, 114, 36, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CultureTextField(
              label: 'Senha',
              hintText: '************',
              obscureText: true,
            ),
            const SizedBox(height: 24),
            const CultureTextField(
              label: 'Confirmar Senha',
              hintText: '************',
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 34),
            Center(
              child: CulturePillButton(
                label: 'Criar Nova Senha',
                width: 198,
                height: 38,
                fontSize: 14,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
