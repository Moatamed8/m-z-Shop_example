import 'package:flutter/material.dart';

class CartItem{
  final String id;
  final String title;
  final int quntity;
  final double price;
  final String imageUrl;

  CartItem({this.id, this.title, this.quntity, this.price, this.imageUrl});
}

class CartProvider with ChangeNotifier{
  Map<String,CartItem> _items={};

  Map<String,CartItem> get items{
    return {..._items};
  }
  int get itemCount{
    return _items.length;
  }

  double get totalAmount{

    var total =0.0;
    _items.forEach((key, cartItem) {
      total+=cartItem.price*cartItem.quntity;
    });
    return total;
  }
  void addItem(String productId,double price,String title,String imageUrl){
    if(_items.containsKey(productId)){
      _items.update(productId, (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quntity: existingCartItem.quntity+1,
        imageUrl: existingCartItem.imageUrl,
      ));
    }else{
      _items.putIfAbsent(productId, () => CartItem(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        quntity: 1,
        imageUrl:imageUrl,

      ));
      notifyListeners();
    }
  }
  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void clear(){
    _items={};
    notifyListeners();
  }
  void removeSingleItem(String productId){
    if(!_items.containsKey(productId)){
      return;
    }
    if(_items[productId].quntity>1){
      _items.update(productId, (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quntity: existingCartItem.quntity-1,
        imageUrl: existingCartItem.imageUrl,
      ));
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }



}