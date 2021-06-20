import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/screens/about_screen.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/orders_screens.dart';
import 'package:shop/screens/user_products_screen.dart';

import 'profile_menu.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SizedBox(
            height: 115,
            width: 115,),
          ProfileMenu(
            text: "Manage My Products",
            icon: "assets/icons/Shop Icon.svg",
            press: () => Navigator.pushNamed(context,
                UserProductScreen.routeName),
          ),
          ProfileMenu(
            text: "Add New Products",
            icon: "assets/icons/Shop Icon.svg",
            press: () => Navigator.pushNamed(context,
                EditProductScreen.routeName),
          ),
          ProfileMenu(
            text: "Completed Order",
            icon: "assets/icons/shopping-bag.svg",
            press: () => Navigator.pushNamed(context,
                OrdersScreen.routeName),
          ),
          ProfileMenu(
            text: "About Developer",
            icon: "assets/icons/Question mark.svg",
            press: () => Navigator.pushNamed(context,
                AboutScreen.routeName),
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context,listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
