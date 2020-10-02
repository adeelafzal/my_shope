import 'package:flutter/material.dart';

class CartItem {
  final String id, title;
  final int quantity;
  final String price;

  CartItem(this.id, this.title, this.quantity, this.price);
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  int get totalAmount {
    var total = 0;
    _items.forEach((key, value) {
      total += (int.parse(value.price) * value.quantity);
    });
    return total;
  }

  void addItem(String id, String price, String title) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (value) => CartItem(
          value.id,
          value.title,
          value.quantity + 1,
          value.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          DateTime.now().toString(),
          title,
          1,
          price,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (value) => CartItem(
                value.id,
                value.title,
                value.quantity - 1,
                value.price,
              ));
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeProduct(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
