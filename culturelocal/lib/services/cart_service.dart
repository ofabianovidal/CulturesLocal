import 'package:flutter/foundation.dart';

import '../models/app_event.dart';

class CartItem {
  CartItem({required this.event, required this.qty});

  final AppEvent event;
  int qty;
}

class CartService extends ChangeNotifier {
  CartService._();

  static final CartService instance = CartService._();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get subtotal =>
      _items.fold(0.0, (s, i) => s + i.event.preco * i.qty);

  double get taxa => _items.isEmpty ? 0.0 : 1.0;

  double get total => subtotal + taxa;

  int get totalQty => _items.fold(0, (s, i) => s + i.qty);

  bool get isEmpty => _items.isEmpty;

  void add(AppEvent event, {int qty = 1}) {
    final idx = _items.indexWhere((i) => i.event.id == event.id);
    if (idx >= 0) {
      _items[idx].qty += qty;
    } else {
      _items.add(CartItem(event: event, qty: qty));
    }
    notifyListeners();
  }

  void remove(String eventId) {
    _items.removeWhere((i) => i.event.id == eventId);
    notifyListeners();
  }

  void setQty(String eventId, int qty) {
    if (qty <= 0) {
      remove(eventId);
      return;
    }
    final idx = _items.indexWhere((i) => i.event.id == eventId);
    if (idx >= 0) {
      _items[idx].qty = qty;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
