import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/config/size_config.dart';
import 'package:shop/screens/all_products.dart';
/*import 'package:shop/screens/categories/cars_screens.dart';
import 'package:shop/screens/categories/electronics_screen.dart';
import 'package:shop/screens/categories/game_Screen.dart';
import 'package:shop/screens/categories/gifts_screens.dart';*/




class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": "assets/icons/Flash Icon.svg", "text": "Electronics",'press':()=> Navigator.pushNamed(context, AllProducts.routeName),
      },
      {"icon": "assets/icons/Bill Icon.svg", "text": "Cars",'press':()=> Navigator.pushNamed(context, AllProducts.routeName)},
      {"icon": "assets/icons/Game Icon.svg", "text": "Game",'press':()=> Navigator.pushNamed(context, AllProducts.routeName)},
      {"icon": "assets/icons/Gift Icon.svg", "text": "Gift",'press':()=> Navigator.pushNamed(context, AllProducts.routeName)},
      {"icon": "assets/icons/Discover.svg", "text": "More",'press':()=> Navigator.pushNamed(context, AllProducts.routeName)},
    ];
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            press:categories[index]["press"],

          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: getProportionateScreenWidth(55),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              height: getProportionateScreenWidth(55),
              width: getProportionateScreenWidth(55),
              decoration: BoxDecoration(
                color: Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(icon),
            ),
            SizedBox(height: 5),
            Text(text, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
