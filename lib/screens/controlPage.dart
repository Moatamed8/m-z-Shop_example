
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/config/color_config.dart';
import 'package:shop/screens/orders_screens.dart';
import 'package:shop/screens/product_overview_screen.dart';
import 'package:shop/screens/settings.dart';
import '../screens/favorite_screen.dart';



class Control extends StatefulWidget {

  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> {
  final Color inActiveIconColor = Color(0xFFB6B6B6);

  int _counter = 0;
  bool isSelected = false;


  void _selectConatiner(int index,) {
    setState(() {
      _counter = index;
    });
  }

  List _pages=[
    ProductOverviewScreen(),
    FavoriteScreen(),
    OrdersScreen(),
    Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        child: _pages[_counter],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -15),
              blurRadius: 20,
              color: Color(0xFFDADADA).withOpacity(0.15),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/Shop Icon.svg",
                    color: _counter==0
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () =>_selectConatiner(0),
                ),
                IconButton(
                  icon: SvgPicture.asset("assets/icons/Heart Icon.svg",
                  color: _counter ==1
                      ? kPrimaryColor
                      : inActiveIconColor,
                  ),
                  onPressed: () => _selectConatiner(1),
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/shopping-bag.svg",
                    color: _counter==2
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () => _selectConatiner(2),
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/User Icon.svg",
                    color:_counter == 3
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () => _selectConatiner(3),
                ),
              ],
            )),
      ),

    );
  }
}
