import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/controlPage.dart';
import 'package:shop/widgets/home/categories.dart';

import './config/routes.dart';
import './providers/auth.dart';
import './providers/orders.dart';
import './providers/cart.dart';
import './providers/products.dart';
/*
import './providers/categroie.dart';
*/


import 'screens/auth_screen.dart';
import 'screens/splash_Screen.dart';
import 'config/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
            create: (_) => ProductsProvider(),
            update: (ctx, authValue, previousProducts) => previousProducts
              ..getData(authValue.token, authValue.userId,
                  previousProducts == null ? null : previousProducts.items)),
      /*  ChangeNotifierProxyProvider<AuthProvider, CategoriesProvider>(
            create: (_) => CategoriesProvider(),
            update: (ctx, authValue, previousProducts) => previousProducts
              ..getData(authValue.token, authValue.userId,
                  previousProducts == null ? null : previousProducts.catItems)),*/
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
            create: (_) => OrdersProvider(),
            update: (ctx, authValue, previousOrders) => previousOrders
              ..getData(authValue.token, authValue.userId,
                  previousOrders == null ? null : previousOrders.orders)),
        ChangeNotifierProvider.value(value: CartProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme(),
          home: auth.isAuth
              ? Control()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (BuildContext context, AsyncSnapshot authSnapShot) =>
                      authSnapShot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: routes,
        ),
      ),
    );
  }
}
