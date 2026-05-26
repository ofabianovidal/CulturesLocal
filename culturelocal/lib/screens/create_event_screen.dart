import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);
  static const _fieldBg = Color(0xFFF5F0D8);

  final _nameCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dateCtrl.dispose();
    _priceCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _yellow,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _coverPicker(),
                    const SizedBox(height: 24),
                    _label('Nome do Evento'),
                    const SizedBox(height: 8),
                    _field(controller: _nameCtrl, hint: 'Asd Asd'),
                    const SizedBox(height: 16),
                    _label('Data'),
                    const SizedBox(height: 8),
                    _field(controller: _dateCtrl, hint: '01 /01 /2001'),
                    const SizedBox(height: 16),
                    _label('Preço'),
                    const SizedBox(height: 8),
                    _field(controller: _priceCtrl, hint: 'R\$ 20'),
                    const SizedBox(height: 16),
                    _label('Número de Telefone'),
                    const SizedBox(height: 8),
                    _field(controller: _phoneCtrl, hint: '+55 (11) 12345-6789'),
                    const SizedBox(height: 28),
                    _createButton(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _bottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.chevron_left, size: 28),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Criar Evento',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _coverPicker() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 100,
            height: 100,
            color: Colors.grey.shade300,
            child: const Icon(Icons.image, size: 40, color: Colors.white54),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: _green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.sync, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _field({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        filled: true,
        fillColor: _fieldBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _createButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Evento criado com sucesso!')),
          );
        },
        child: const Text(
          'Criar Evento',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home_outlined, () {}),
          _navIcon(Icons.person_outline, () {}),
          _navIcon(Icons.favorite_border, () {}),
          _navIcon(Icons.receipt_long_outlined, () {}),
          _navIcon(Icons.headset_mic_outlined, () {}),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }
}