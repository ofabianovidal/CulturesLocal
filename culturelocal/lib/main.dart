import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
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

// main() virou assíncrono para inicializar o Firebase antes do app subir.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _open(context, 'Evento', AppRoutes.event),
          _open(context, 'Carrinho', AppRoutes.cart),
          _open(context, 'Pagamento', AppRoutes.checkout),
          _open(context, 'Compra Finalizada', AppRoutes.success),
          _open(context, 'Notificações', AppRoutes.notifications),
          _open(context, 'Filtros', AppRoutes.filters),
          _open(context, 'Criar Evento', AppRoutes.createEvent),
          _open(context, 'Suporte', AppRoutes.support),
        ],
      ),
    );
  }

  Widget _open(BuildContext context, String title, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          onPressed: () => Navigator.pushNamed(context, route),
          child: Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }
}