import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:shop_app/Provider/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Widgets/cart_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _order = [];

  List<OrderItem> get order {
    return [..._order];
  }

  Future<void> addOrder(List<Cart> product, double total) async {
    String url =
        'https://myproject-fc918-default-rtdb.firebaseio.com/order.json';

    final time = DateTime.now();

    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          'amount': total,
          'datetime': time.toIso8601String(),
          'product': product
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'price': e.price,
                    'quantity': e.quantity
                  })
              .toList()
        }));

    final result = jsonDecode(response.body);

    _order.insert(
        0,
        OrderItem(
            id: result['name'],
            amount: total,
            products: product,
            dateTime: DateTime.parse(time.toIso8601String())));
    notifyListeners();
  }

  Future<void> fecthOrderedData() async {
    String url =
        'https://myproject-fc918-default-rtdb.firebaseio.com/order.json';
    List<OrderItem> _newOrder = [];
    final response = await http.get(Uri.parse(url));
    print(jsonDecode(response.body));
    var _extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (_extractedData == null) {
      return;
    }
    _extractedData.forEach(
      (orderId, orderData) {
        _newOrder.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['product'] as List<dynamic>)
                .map((e) => Cart(
                    title: e['title'],
                    id: e['id'],
                    price: e['price'],
                    quantity: e['quantity']))
                .toList(),
            dateTime: DateTime.parse(orderData['datetime'])));
      },
    );
    _order = _newOrder.reversed.toList();
    notifyListeners();
  }
}
