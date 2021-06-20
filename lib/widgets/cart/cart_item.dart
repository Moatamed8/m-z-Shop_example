import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/config/color_config.dart';
import 'package:shop/config/size_config.dart';
import 'package:shop/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final int quantity;
  final double price;
  final String title;
  final String imageUrl;

  const CartItem(this.id, this.productId, this.price, this.quantity, this.title,
      this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {

        Provider.of<CartProvider>(context,listen:false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Are you sure ?"),
                  content: Text("Do you want to remove item from the cart ?"),
                  actions: [
                    TextButton(
                      child: Text('No'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),TextButton(
                      child: Text('Yes'),
                      onPressed: () => Navigator.of(context).pop(true),
                    )
                  ],
                ));
      },
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Color(0xFFFFE6E6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Spacer(),
            SvgPicture.asset("assets/icons/Trash.svg"),
          ],
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: FadeInImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  placeholder:
                      AssetImage('assets/images/product-placeholder.png'),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: "\$$price",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                  children: [
                    TextSpan(
                        text: " x$quantity",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
