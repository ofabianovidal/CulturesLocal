import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/app_user_profile.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
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
  bool _didLoadProfile = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _birthController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final birthDate = _birthController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || birthDate.isEmpty || phone.isEmpty) {
      _showMessage('Preencha nome, data de nascimento e telefone.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      await FirestoreService.instance.updateCurrentUserProfile(
        name: name,
        phone: phone,
        birthDate: birthDate,
      );
      _showMessage('Perfil atualizado com sucesso!');
    } catch (_) {
      _showMessage('Nao foi possivel atualizar o perfil.');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _logout() async {
    await AuthService.instance.signOut();
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
  }

  void _syncControllers(AppUserProfile? profile) {
    if (_didLoadProfile) {
      return;
    }

    _nameController.text = profile?.nome ?? '';
    _birthController.text = profile?.dataNascimento ?? '';
    _emailController.text =
        profile?.email ?? AuthService.instance.currentUser?.email ?? '';
    _phoneController.text = profile?.telefone ?? '';
    _didLoadProfile = true;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return CultureAuthScaffold(
      title: 'Meu perfil',
      onBack: () => navigateToRootRoute(context, AppRoutes.index),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<AppUserProfile?>(
              stream: FirestoreService.instance.watchCurrentUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !_didLoadProfile) {
                  return const Center(child: CircularProgressIndicator());
                }

                _syncControllers(snapshot.data);

                return SingleChildScrollView(
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
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: const BoxDecoration(
                                color: AppColors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified_user_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Os dados abaixo sao carregados do Firebase e vinculados ao usuario autenticado.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 24),
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
                        label: 'Email autenticado',
                        hintText: '',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: true,
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
                      Row(
                        children: [
                          Expanded(
                            child: CulturePillButton(
                              label: _isSaving
                                  ? 'Salvando...'
                                  : 'Atualizar Perfil',
                              width: double.infinity,
                              height: 38,
                              fontSize: 13,
                              onPressed: _isSaving ? null : _saveProfile,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CulturePillButton(
                              label: 'Criar Evento',
                              width: double.infinity,
                              height: 38,
                              fontSize: 13,
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(AppRoutes.createEvent);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: CulturePillButton(
                          label: 'Meus Pedidos',
                          width: 168,
                          height: 38,
                          fontSize: 13,
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.myOrders);
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: CulturePillButton(
                          label: 'Sair da Conta',
                          width: 168,
                          height: 38,
                          fontSize: 13,
                          backgroundColor: AppColors.paleYellow,
                          foregroundColor: AppColors.green,
                          onPressed: _logout,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const CultureBottomNav(currentItem: CultureBottomNavItem.profile),
        ],
      ),
    );
  }
}
