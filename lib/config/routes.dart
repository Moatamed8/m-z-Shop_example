import 'package:shop/screens/about_screen.dart';

import '../screens/auth_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/edit_product_screen.dart';
import '../screens/orders_screens.dart';
import '../screens/product_detail_screen.dart';
import '../screens/splash_Screen.dart';
import '../screens/user_products_screen.dart';
import '../screens/all_products.dart';
import '../screens/settings.dart';
import '../screens/favorite_screen.dart';
import '../screens/product_overview_screen.dart';





var routes={

  ProductDetailScreen.routeName: (_)=>ProductDetailScreen(),
  AuthScreen.routeName: (_)=>AuthScreen(),
  CartScreen.routeName: (_)=>CartScreen(),
  EditProductScreen.routeName: (_)=>EditProductScreen(),
  OrdersScreen.routeName: (_)=>OrdersScreen(),
  SplashScreen.routeName: (_)=>SplashScreen(),
  UserProductScreen.routeName: (_)=>UserProductScreen(),
  AllProducts.routeName:(_)=>AllProducts(),
  Setting.routeName:(_)=>Setting(),
  FavoriteScreen.routeName:(_)=>FavoriteScreen(),
  ProductOverviewScreen.routeName:(_)=>ProductOverviewScreen(),
  AboutScreen.routeName :(_)=>AboutScreen(),





};