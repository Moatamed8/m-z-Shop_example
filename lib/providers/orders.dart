import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shop/models/http_exception.dart';

class OrderItem {
  final String id;
  final double amount;

  OrderItem({this.id, this.amount, this.products, this.dateTime});

  final List<CartItem> products;
  final DateTime dateTime;
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authtoken;
  String userId;

  getData(String authToken, String uId, List<OrderItem> products) {
    authtoken = authToken;
    userId = uId;
    _orders = products;
    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shopflutterapp-9b1c3-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authtoken';
    try {
      final res = await http.get(url);
      final extractData = jsonDecode(res.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      final List<OrderItem> loadedOrders = [];
      extractData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quntity: item['quntity'],
                    price: item['price'],
                    imageUrl: item['imageUrl']
                  ))
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        'https://shopflutterapp-9b1c3-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authtoken';

    try {
      final timestamp = DateTime.now();
      final res = await http.post(url,
          body: jsonEncode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProduct
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'imageUrl': cp.imageUrl,
                      'price': cp.price,
                      'quntity': cp.quntity,
                    })
                .toList(),
          }));

      _orders.insert(
          0,
          OrderItem(
              id: jsonDecode(res.body)['name'],
              amount: total,
              dateTime: timestamp,
              products: cartProduct));
      notifyListeners();

    } catch (e) {
      throw e;
    }
  }
}
