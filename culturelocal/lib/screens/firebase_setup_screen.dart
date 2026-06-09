import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FirebaseSetupScreen extends StatelessWidget {
  const FirebaseSetupScreen({super.key, this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellow,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: 560,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.softPanel,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Firebase pendente',
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'O codigo da autenticacao e do Firestore ja esta pronto. '
                    'Agora falta conectar o projeto ao Firebase do grupo para '
                    'ativar login, Google Sign-In e banco em tempo real.',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 15,
                      height: 1.35,
                    ),
                  ),
                  if (errorMessage != null &&
                      errorMessage!.trim().isNotEmpty) ...[
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.green.withValues(alpha: 0.25),
                        ),
                      ),
                      child: SelectableText(
                        errorMessage!,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  const _StepItem(
                    title: '1. Criar ou abrir o projeto do Firebase',
                    description:
                        'No Console, ative Authentication e Cloud Firestore.',
                  ),
                  const _StepItem(
                    title: '2. Habilitar os provedores obrigatorios',
                    description:
                        'Ative Email/Senha e Google dentro de Authentication.',
                  ),
                  const _StepItem(
                    title: '3. Gerar a configuracao FlutterFire',
                    description:
                        'Rode `flutterfire configure` na pasta do app para '
                        'substituir `lib/firebase_options.dart`.',
                  ),
                  const _StepItem(
                    title: '4. Adicionar os arquivos nativos',
                    description:
                        'Coloque `google-services.json` em '
                        '`android/app/` e `GoogleService-Info.plist` no '
                        'projeto iOS/macOS.',
                  ),
                  const _StepItem(
                    title: '5. Finalizar o Google Sign-In no Android',
                    description:
                        'Cadastre a SHA-1 da maquina/app no Firebase para o '
                        'login Google funcionar.',
                  ),
                  const _StepItem(
                    title: '6. Publicar as regras do Firestore',
                    description:
                        'Use o arquivo `firestore.rules` incluido no projeto.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.green,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 14,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
