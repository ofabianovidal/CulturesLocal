import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/create_event_screen.dart';
import 'screens/event_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/index_screen.dart';
import 'screens/support_screen.dart';
import 'screens/login_screen.dart';
import 'screens/my_events_screen.dart';
import 'screens/new_password_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/start_screen.dart';
import 'screens/success_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CultureLocalApp());
}

class CultureLocalApp extends StatelessWidget {
  const CultureLocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Culture Local',
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const StartScreen(),
        AppRoutes.index: (_) => const IndexScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.newPassword: (_) => const NewPasswordScreen(),
        AppRoutes.favorites: (_) => const FavoritesScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.myEvents: (_) => const MyEventsScreen(),
        AppRoutes.event: (_) => const EventScreen(),
        AppRoutes.cart: (_) => const CartScreen(),
        AppRoutes.checkout: (_) => const CheckoutScreen(),
        AppRoutes.success: (_) => const SuccessScreen(),
        AppRoutes.notifications: (_) => const NotificationsScreen(),
        AppRoutes.filters: (_) => const FiltersScreen(),
        AppRoutes.createEvent: (_) => const CreateEventScreen(),
        AppRoutes.support: (_) => const SupportScreen(),
        AppRoutes.prototypeMenu: (_) => const MenuScreen(),
      },
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4C65A),

      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,

        title: const Text(
          'Culture Local',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          openScreen(
            context,
            'Evento',
            const EventScreen(),
          ),

          openScreen(
            context,
            'Carrinho',
            const CartScreen(),
          ),

          openScreen(
            context,
            'Pagamento',
            const CheckoutScreen(),
          ),

          openScreen(
            context,
            'Compra Finalizada',
            const SuccessScreen(),
          ),

          openScreen(
            context,
            'Notificações',
            const NotificationsScreen(),
          ),

          openScreen(
            context,
            'Filtros',
            const FiltersScreen(),
          ),

          openScreen(
            context,
            'Criar Evento',
            const CreateEventScreen(),
          ),

          openScreen(
            context,
            'Suporte',
            const SupportScreen(),
          ),
        ],
      ),
    );
  }

  Widget openScreen(
    BuildContext context,
    String title,
    Widget screen,
  ) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: SizedBox(
        height: 56,

        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => screen,
              ),
            );
          },

          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
