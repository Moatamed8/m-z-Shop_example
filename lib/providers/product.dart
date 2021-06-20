import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop/models/http_exception.dart';

class ProductProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductProvider({
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newVal) {
    isFavorite = newVal;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    // if internet coonection lost make item as on
    final url =
        'https://shopflutterapp-9b1c3-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';

    try {
      final res = await http.put(url, body: jsonEncode(isFavorite));
      if (res.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (e) {}
  }
}
