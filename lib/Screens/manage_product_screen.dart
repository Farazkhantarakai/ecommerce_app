import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_app/Provider/Products.dart' as prod;
import 'package:shop_app/Screens/edit_product_screen.dart';
import '../Provider/Products.dart ';
import 'package:shop_app/Widgets/maindrawer.dart';
import 'package:provider/provider.dart';
import '../Widgets/manage_product_item.dart';

class ManageProductScreen extends StatelessWidget {
  const ManageProductScreen({Key? key}) : super(key: key);
  static const routName = 'ManageProductScreen';

  Future<void> _refreshDate(BuildContext context) async {
    await Provider.of<prod.Products>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MainDrawer(),
        appBar: AppBar(
          title: const Text('Manage Products'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditedProductScreen.routName);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => _refreshDate(context),
          child: Consumer<prod.Products>(
            builder: (ctx, productData, child) => ListView.builder(
                itemCount: productData.item.length,
                itemBuilder: (ctx, index) {
                  log(productData.item[index].imageUrl);
                  return Column(
                    children: [
                      ManageProductItem(
                        id: productData.item[index].id,
                        imageUrl: productData.item[index].imageUrl,
                        title: productData.item[index].title,
                      ),
                      const Divider(),
                    ],
                  );
                }),
          ),
        ));
  }
}
