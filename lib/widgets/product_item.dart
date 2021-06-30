import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/config/color_config.dart';
import 'package:shop/config/size_config.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
   ProductItem({
    Key key,
    this.width = 140,
    this.aspectRetio = 1.02,

  }) : super(key: key);

  final double width, aspectRetio;


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
     final product = Provider.of<ProductProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final authData = Provider.of<AuthProvider>(context, listen: false);


    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () =>
              Navigator.pushNamed(
                context,
                ProductDetailScreen.routeName,arguments: product.id
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Hero(
                    tag: product.id,
                    child: FadeInImage(
                      image: NetworkImage(product.imageUrl,),fit: BoxFit.cover,
                      placeholder: AssetImage(
                          'assets/images/product-placeholder.png'),),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.title,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price}",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  Row(
                    children: [
                      Consumer<ProductProvider>(
                        builder: (ctx,productsa,_) => InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            productsa.toggleFavoriteStatus(authData.token, authData.userId);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:product.isFavorite?Text("Added to Your Favorite!"):Text("Cleared From Your Favorite!") ,
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(label: 'UNDO!',onPressed: (){
                                productsa.toggleFavoriteStatus(authData.token, authData.userId);

                              },),
                            ));
                          },
                          child: Container(
                            padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                            height: getProportionateScreenWidth(28),
                            width: getProportionateScreenWidth(28),
                            decoration: BoxDecoration(
                              color: product.isFavorite
                                  ? kPrimaryColor.withOpacity(0.15)
                                  : kSecondaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/Heart Icon_2.svg",
                              color: product.isFavorite
                                  ? Color(0xFFFF4848)
                                  : Color(0xFFDBDEE4),
                            ),
                          ),
                        ),

                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            cart.addItem(product.id, product.price, product.title, product.imageUrl);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Added to cart!"),
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(label: 'UNDO!',onPressed: (){
                                cart.removeSingleItem(product.id);

                              },),
                            ));
                          },
                          child: Container(
                            padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                            height: getProportionateScreenWidth(28),
                            width: getProportionateScreenWidth(28),
                            decoration: BoxDecoration(
                              color: product.isFavorite
                                  ? kPrimaryColor.withOpacity(0.15)
                                  : kSecondaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                                "assets/icons/Cart Icon.svg",
                                color:Color(0xFFFF4848),
                            ),

                          ),
                        ),
                      ),
                    ],

                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
