import 'package:flutter/cupertino.dart';

class Cart {
  final String id;
  final String title;
  double price;
  final int quantity;
  Cart(
      {required this.title,
      required this.id,
      required this.price,
      required this.quantity});
}

class CartItem with ChangeNotifier {
  //you have to assign a value else this will not work
  Map<String, Cart> items = {};

  Map<String, Cart> get cartItem {
    return {...items};
  }

  double get total {
    double calculate = 0;
    items.forEach((key, value) {
      {
        calculate += value.price * value.quantity;
      }
    });

    notifyListeners();
    return calculate;
  }

  int get cartValue {
    // notifyListeners();
    return items.length;
  }

  void removeSingleItem(String id) {
    if (!items.containsKey(id)) {
      return;
    }
    if (items[id]!.quantity > 1) {
      items.update(
          id,
          (existingValue) => Cart(
              title: existingValue.title,
              id: existingValue.id,
              price: existingValue.price,
              quantity: existingValue.quantity - 1));
    } else {
      items.remove(id);
    }
    notifyListeners();
  }

  void addItem(String id, String title, double price) {
    if (items.containsKey(id)) {
      items.update(
          id,
          (existingCartItem) => Cart(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1));
    } else {
      //if item donot have that specific id then add this item
      (items.putIfAbsent(
          id,
          () => Cart(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1)));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    items.remove(id);
    notifyListeners();
  }

  void clear() {
    items = {};
    notifyListeners();
  }
}
