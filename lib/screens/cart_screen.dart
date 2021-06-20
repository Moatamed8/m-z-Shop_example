import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';
import 'package:shop/config/size_config.dart';
import '../providers/cart.dart' show  CartProvider;
import 'package:shop/widgets/cart/cart_item.dart';
import 'package:shop/widgets/cart/check_out_card.dart';

class CartScreen extends StatefulWidget {

  static const routeName='/cartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart= Provider.of<CartProvider>(context);

    AppBar buildAppBar() {
      return AppBar(
        title: Column(
          children: [
            Text(
              "Your Cart",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "${cart.itemCount} items",
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
    }

    return Scaffold(

    appBar: buildAppBar(),
      body: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: ListView.builder(
          itemCount: cart.items.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10),

              child: CartItem(
                cart.items.values.toList()[index].id,
                cart.items.keys.toList()[index],
                cart.items.values.toList()[index].price,
                cart.items.values.toList()[index].quntity,
                cart.items.values.toList()[index].title,
                cart.items.values.toList()[index].imageUrl,

              ),
            ),
          ),
        ),

      bottomNavigationBar: CheckoutCard(),

    );
  }
}
