import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/Products.dart';
import 'package:shop_app/Provider/cart.dart';
import 'package:shop_app/Screens/cart_screen.dart';
import 'package:shop_app/Widgets/Badge.dart';
import 'package:shop_app/Widgets/product_item.dart';
import '../Widgets/maindrawer.dart';

class Screen_Overview extends StatefulWidget {
  const Screen_Overview({Key? key}) : super(key: key);
  @override
  State<Screen_Overview> createState() => _Screen_OverviewState();
}

enum Filter { favorite, showAll }

class _Screen_OverviewState extends State<Screen_Overview> {
  bool _isInit = true;
  bool _isLoading = false;
  //as this methods is runing multiple time therefore we have to run it once
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchData().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = productData.item;
    // final cart = Provider.of<CartItem>(context,listen: false);
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Shop App'),
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                if (value == Filter.favorite) {
                  productData.showFavorite();
                } else {
                  productData.showAll();
                }
              },
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: Filter.favorite,
                      child: Text('Favorite'),
                    ),
                    const PopupMenuItem(
                      value: Filter.showAll,
                      child: Text('Show All'),
                    ),
                  ]),
          Consumer<CartItem>(
            builder: (ctx, cartData, ch) => Badge(
              value: cartData.cartValue.toString(),
              color: Colors.red,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routName);
                    setState(() {});
                  },
                  icon: const Icon(Icons.shopping_cart)),
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              //where you want to dispose the data then we use cnp.value otherwise
              //the other shit
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: products[i],
                    child: ProductItem(
                        // id: product[i].id,
                        // title: product[i].title,
                        // imageUrl: product[i].imageUrl,
                        ),
                  )),
    );
  }
}
