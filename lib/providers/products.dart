import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shop/models/http_exception.dart';
import 'product.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductProvider> _items = [
/*    ProductProvider(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    ProductProvider(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    ProductProvider(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    ProductProvider(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    ProductProvider(
      id: 'p5',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    ProductProvider(
      id: 'p6',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    ProductProvider(
      id: 'p7',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    ProductProvider(
      id: 'p8',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];
  String authtoken;
  String userId;

  getData(String authToken, String uId, List<ProductProvider> products) {
    authtoken = authToken;
    userId = uId;
    _items = products;
    notifyListeners();
  }

  List<ProductProvider> get items {
    return [..._items];
  }

  List<ProductProvider> get favoritesItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  ProductProvider findById(String id) {
    return _items.firstWhere((prodId) => prodId.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filteredString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shopflutterapp-9b1c3-default-rtdb.firebaseio.com/products.json?auth=$authtoken&$filteredString';
    try {
      final res = await http.get(url);
      final extractData = jsonDecode(res.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      url =
          'https://shopflutterapp-9b1c3-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authtoken';
      final favRes = await http.get(url);
      final favData = jsonDecode(favRes.body);

      final List<ProductProvider> loadedProducts = [];
      extractData.forEach((prodId, prodData) {
        loadedProducts.add(ProductProvider(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: favData == null ? false : favData['prodId'] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(ProductProvider product) async {
    final url =
        'https://shopflutterapp-9b1c3-default-rtdb.firebaseio.com/products.json?auth=$authtoken';

    try {
      final res = await http.post(url,
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));
      final newProduct = ProductProvider(
        id: jsonDecode(res.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(ProductProvider newProduct, String id) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shopflutterapp-9b1c3-default-rtdb.firebaseio.com/products/$id.json?auth=$authtoken';
      await http.patch(url,
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shopflutterapp-9b1c3-default-rtdb.firebaseio.com/products/$id.json?auth=$authtoken';

    final existingprodIndex = _items.indexWhere((element) => element.id == id);
    var existingPrduct = _items[existingprodIndex];
    _items.removeAt(existingprodIndex);

    final res = await http.delete(url);

    if (res.statusCode >= 400) {
      _items.insert(existingprodIndex, existingPrduct);
      notifyListeners();
      throw HttpException('could not delete product');
    }
    existingPrduct = null;
  }
}
