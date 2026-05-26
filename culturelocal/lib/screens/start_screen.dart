import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 72, 28, 42),
                  child: Column(
                    children: [
                      const Text(
                        'CultureLocal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -1.1,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: 258,
                        height: 236,
                        child: Image.asset(
                          'assets/images/culturelocal_hat_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const SizedBox(
                        width: 295,
                        child: Text(
                          'Um local para você criar, organizar e participar\nde eventos culturais!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 44),
                      CulturePillButton(
                        label: 'Login',
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.green,
                        width: 208,
                        height: 46,
                        fontSize: 19,
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.login);
                        },
                      ),
                      const SizedBox(height: 8),
                      CulturePillButton(
                        label: 'Cadastrar',
                        backgroundColor: AppColors.paleYellow,
                        foregroundColor: AppColors.green,
                        width: 208,
                        height: 46,
                        fontSize: 19,
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.register);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
