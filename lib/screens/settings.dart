import 'package:flutter/material.dart';

import 'package:shop/widgets/setting/body.dart';

class Setting extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
/*
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
*/
    );
  }
}