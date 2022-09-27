import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/Products.dart';
import 'package:shop_app/Provider/auth.dart';
import 'package:shop_app/Provider/cart.dart';
import 'package:shop_app/Provider/order.dart';
import 'package:shop_app/Screens/auth-screen.dart';
import 'package:shop_app/Screens/cart_screen.dart';
import 'package:shop_app/Screens/order_screen.dart';
import 'package:shop_app/Screens/product_description.dart';
import 'package:shop_app/Screens/screen_overview.dart';
import './Screens/manage_product_screen.dart';
import './Screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((context) => Authentication())),
          ChangeNotifierProxyProvider<Authentication, Products>(
              update: ((context, authenticate, previous) => Products(
                  authenticate.token,
                  previous!.item == null ? [] : previous.item)),
              create: ((ctx) {
                return Products('', []);
              })),
          ChangeNotifierProvider(create: ((context) => CartItem())),
          ChangeNotifierProvider(create: (ctx) => Orders()),
          ChangeNotifierProvider(
            create: (ctx) => Authentication(),
          )
        ],
        child: Consumer<Authentication>(
          builder: (ctx, authData, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              ProductDescription.routName: (context) => ProductDescription(),
              CartScreen.routName: ((context) => const CartScreen()),
              OrderScreen.routName: ((ctx) => const OrderScreen()),
              ManageProductScreen.routName: ((ctx) =>
                  const ManageProductScreen()),
              EditedProductScreen.routName: ((ctx) =>
                  const EditedProductScreen())
            },
            theme: ThemeData(primaryColor: Colors.black87),
            home: authData.auth ? const Screen_Overview() : AuthScreen(),
          ),
        ));
  }
}
