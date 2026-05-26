import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/event_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _birthController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Asd Asd');
    _birthController = TextEditingController(text: '01 /01 /2001');
    _emailController = TextEditingController(text: 'exemplo@exemplo.com');
    _phoneController = TextEditingController(text: '+55 (11) 12345-6789');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CultureAuthScaffold(
      title: 'Meu perfil',
      onBack: () => navigateToRootRoute(context, AppRoutes.index),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(36, 14, 36, 18),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomRight,
                    children: [
                      const CultureReferenceCrop(
                        assetPath: 'assets/images/profile_reference.png',
                        sourceWidth: 507,
                        sourceHeight: 934,
                        cropLeft: 198,
                        cropTop: 182,
                        cropWidth: 98,
                        cropHeight: 98,
                        width: 98,
                        height: 98,
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                      Positioned(
                        right: -20,
                        bottom: -8,
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Alteração de foto disponível em breve.'),
                              ),
                            );
                          },
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              color: AppColors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.photo_camera_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  CultureTextField(
                    label: 'Nome completo',
                    hintText: '',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 18),
                  CultureTextField(
                    label: 'Data de Nascimento',
                    hintText: '',
                    controller: _birthController,
                  ),
                  const SizedBox(height: 18),
                  CultureTextField(
                    label: 'Email',
                    hintText: '',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 18),
                  CultureTextField(
                    label: 'Número de Telefone',
                    hintText: '',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 38),
                  CulturePillButton(
                    label: 'Atualizar o Perfil',
                    width: 176,
                    height: 36,
                    fontSize: 14,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Perfil atualizado com sucesso!'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const CultureBottomNav(
            currentItem: CultureBottomNavItem.profile,
          ),
        ],
      ),
    );
  }
}
