import 'package:flutter/material.dart';

import 'screens/event_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/success_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/create_event_screen.dart';
import 'screens/support_screen.dart';

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

      theme: ThemeData(
        fontFamily: 'Roboto',
      ),

      home: const MenuScreen(),
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