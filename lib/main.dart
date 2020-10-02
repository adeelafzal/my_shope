import 'package:flutter/material.dart';
import 'package:my_shope/models/auth.dart';
import 'package:my_shope/models/cart.dart';
import 'package:my_shope/models/orders.dart';
import 'package:my_shope/models/product_provider.dart';
import 'package:my_shope/screens/auth_screen.dart';
import 'package:my_shope/screens/cart_detail.dart';
import 'package:my_shope/screens/edit_product_screen.dart';
import 'package:my_shope/screens/order_screen.dart';
import 'package:my_shope/screens/product_details.dart';
import 'package:my_shope/screens/user_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_shope/screens/products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          builder: (ctx, auth, previousProduct) => ProductProvider(
              auth.token, previousProduct == null ? [] : previousProduct.items,auth.userid),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousOrders) => Orders(
              auth.token, previousOrders == null ? [] : previousOrders.ordsers),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.pink,
            fontFamily: 'Lato',
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => auth.isAuth ? ProductScreen() : AuthScreen(),
            ProductScreen.routeName: (context) => ProductScreen(),
            Productdetail.routeName: (context) => Productdetail(),
            CartDetail.routeName: (context) => CartDetail(),
            OrderScreen.routeName: (context) => OrderScreen(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen()
          },
        ),
      ),
    );
  }
}
