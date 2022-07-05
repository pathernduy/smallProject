import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section8/providers/auth.dart';
import 'package:section8/providers/cart.dart';
import 'package:section8/providers/orders.dart';
import 'package:section8/screens/auth_screen.dart';
import 'package:section8/screens/cart_screen.dart';
import 'package:section8/screens/edit_product_screen.dart';
import 'package:section8/screens/orders_screen.dart';
import 'package:section8/screens/splash_screen.dart';
import 'package:section8/screens/user_products.dart';
import './providers/products_provider.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('', '', []),
          update: (context, auth, previousProducts) => Products(
              auth.token ?? '',
              auth.userId ?? '',
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders('', '', []),
            update: (context, auth, previousOrders) => Orders(
                auth.token ?? '',
                auth.userId ?? '',
                previousOrders == null ? [] : previousOrders.orders)),
      ],
      child: Consumer<Auth>(
        builder: ((context, auth, _) => MaterialApp(
              title: 'My Shop',
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  accentColor: Colors.deepOrange,
                  fontFamily: 'Lato'),
              home: auth.isAuth
                  ? ProductOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
              routes: {
                ProductDetalScreen.routeName: (context) => ProductDetalScreen(),
                CartScreen.routeName: (context) => CartScreen(),
                OrderScreen.routeName: ((context) => OrderScreen()),
                UserProductsScreen.routeName: ((context) =>
                    UserProductsScreen()),
                EditProductScreen.routeName: ((context) => EditProductScreen()),
              },
            )),
      ),
    );
  }
}
