import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/config/color_config.dart';
import 'package:shop/config/size_config.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';

class DefaultButton extends StatefulWidget {
  const DefaultButton({
    Key key,
    this.cart,
  }) : super(key: key);
  final CartProvider cart;

  @override
  _DefaultButtonState createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: kPrimaryColor,
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<OrdersProvider>(context, listen: false)
                    .addOrder(widget.cart.items.values.toList(),
                        widget.cart.totalAmount);
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              },
        child: _isLoading
            ? CircularProgressIndicator()
            : Text(
                "Order Now",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
