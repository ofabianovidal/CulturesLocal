import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_routes.dart';
import '../models/app_event.dart';
import '../models/event_filters.dart';
import '../services/firestore_service.dart';
import '../widgets/bottom_nav.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  static const _yellow = Color(0xFFE4C65A);
  static const _green = Color(0xFF1A7A3C);
  static const _fieldBg = Color(0xFFF5F0D8);

  final _dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  AppEvent? _editingEvent;
  bool _hasLoadedEvent = false;
  bool _isSaving = false;
  String _selectedStatus = 'ativo';
  String _selectedCategoria = 'outras';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_hasLoadedEvent) return;

    final event = ModalRoute.of(context)?.settings.arguments as AppEvent?;
    if (event != null) {
      _editingEvent = event;
      _nameCtrl.text = event.nome;
      _descriptionCtrl.text = event.descricao;
      _dateCtrl.text = _dateFormatter.format(event.data);
      _priceCtrl.text = event.preco.toStringAsFixed(2).replaceAll('.', ',');
      _phoneCtrl.text = event.telefone;
      _selectedStatus = event.status;
      _selectedCategoria = event.categoria;
    } else {
      _dateCtrl.text = _dateFormatter.format(
        DateTime.now().add(const Duration(days: 1)),
      );
    }

    _hasLoadedEvent = true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _dateCtrl.dispose();
    _priceCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final initialDate = _parseDate(_dateCtrl.text) ?? now;

    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDate: initialDate,
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime == null) return;

    final composed = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    _dateCtrl.text = _dateFormatter.format(composed);
    setState(() {});
  }

  Future<void> _saveEvent() async {
    final nome = _nameCtrl.text.trim();
    final descricao = _descriptionCtrl.text.trim();
    final telefone = _phoneCtrl.text.trim();
    final data = _parseDate(_dateCtrl.text.trim());
    final preco = _parsePrice(_priceCtrl.text.trim());

    if (nome.isEmpty ||
        descricao.isEmpty ||
        telefone.isEmpty ||
        data == null ||
        preco == null) {
      _showMessage(
        'Preencha nome, descricao, data, preco e telefone corretamente.',
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await FirestoreService.instance.saveEvent(
        eventId: _editingEvent?.id,
        nome: nome,
        descricao: descricao,
        telefone: telefone,
        status: _selectedStatus,
        data: data,
        preco: preco,
        categoria: _selectedCategoria,
      );

      if (!mounted) return;

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.myEvents, (_) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _editingEvent == null
                ? 'Evento criado com sucesso!'
                : 'Evento atualizado com sucesso!',
          ),
        ),
      );
    } catch (_) {
      _showMessage('Nao foi possivel salvar o evento.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  DateTime? _parseDate(String value) {
    try {
      return _dateFormatter.parseStrict(value);
    } catch (_) {
      return null;
    }
  }

  double? _parsePrice(String value) {
    final normalized = value
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingEvent != null;

    return Scaffold(
      backgroundColor: _yellow,
      body: SafeArea(
        child: Column(
          children: [
            _header(context, isEditing),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _coverPreview(),
                    const SizedBox(height: 24),
                    _label('Nome do Evento'),
                    const SizedBox(height: 8),
                    _field(controller: _nameCtrl, hint: 'Ex.: Feira Cultural'),
                    const SizedBox(height: 16),
                    _label('Descricao'),
                    const SizedBox(height: 8),
                    _multilineField(
                      controller: _descriptionCtrl,
                      hint: 'Explique rapidamente a proposta do evento.',
                    ),
                    const SizedBox(height: 16),
                    _label('Categoria'),
                    const SizedBox(height: 8),
                    _categoriaSelector(),
                    const SizedBox(height: 16),
                    _label('Data e hora'),
                    const SizedBox(height: 8),
                    _field(
                      controller: _dateCtrl,
                      hint: '10/06/2026 19:30',
                      readOnly: true,
                      onTap: _pickDateTime,
                    ),
                    const SizedBox(height: 8),
                    _periodoInfo(),
                    const SizedBox(height: 16),
                    _label('Preco'),
                    const SizedBox(height: 8),
                    _field(
                      controller: _priceCtrl,
                      hint: '20,00',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _label('Numero de Telefone'),
                    const SizedBox(height: 8),
                    _field(
                      controller: _phoneCtrl,
                      hint: '+55 (11) 12345-6789',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _label('Status'),
                    const SizedBox(height: 8),
                    _statusSelector(),
                    const SizedBox(height: 28),
                    _createButton(isEditing),
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

  Widget _header(BuildContext context, bool isEditing) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.chevron_left, size: 28),
          ),
          Expanded(
            child: Center(
              child: Text(
                isEditing ? 'Editar Evento' : 'Criar Evento',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _coverPreview() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 40, color: Colors.black38),
          SizedBox(height: 10),
          Text(
            'Capa ilustrativa',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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

  Widget _categoriaSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategoria,
          items: List.generate(kCategoryKeys.length, (i) {
            return DropdownMenuItem(
              value: kCategoryKeys[i],
              child: Text(kCategoryLabels[i]),
            );
          }),
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedCategoria = value);
          },
        ),
      ),
    );
  }

  Widget _periodoInfo() {
    final parsed = _parseDate(_dateCtrl.text);
    if (parsed == null) return const SizedBox.shrink();
    final isDiurno = parsed.hour >= 6 && parsed.hour < 18;
    return Row(
      children: [
        Icon(
          isDiurno ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
          size: 16,
          color: _green,
        ),
        const SizedBox(width: 6),
        Text(
          isDiurno ? 'Período: Diurno' : 'Período: Noturno',
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _statusSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatus,
          items: const [
            DropdownMenuItem(value: 'ativo', child: Text('Ativo')),
            DropdownMenuItem(value: 'completo', child: Text('Completo')),
            DropdownMenuItem(value: 'cancelado', child: Text('Cancelado')),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedStatus = value);
          },
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        filled: true,
        fillColor: _fieldBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _multilineField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        filled: true,
        fillColor: _fieldBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _createButton(bool isEditing) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: _isSaving ? null : _saveEvent,
        child: Text(
          _isSaving
              ? 'Salvando...'
              : (isEditing ? 'Salvar Alteracoes' : 'Criar Evento'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return const CultureBottomNav(currentItem: CultureBottomNavItem.myEvents);
  }
}
