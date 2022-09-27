import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/Product.dart';
import 'package:shop_app/Provider/Products.dart';
import 'dart:developer';

class ProductDescription extends StatelessWidget {
  ProductDescription({this.title});

  static String routName = '/product_description';
  final String? title;
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments;
    var product = Provider.of<Products>(context)
        .item
        .firstWhere((element) => element.id == productId);
    // log(product.title);

    return Scaffold(
        appBar: AppBar(title: Text(product.title)),
        body: Column(
          children: [
            Container(
              constraints: BoxConstraints.expand(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
              child: Image.asset(product.imageUrl),
            ),
            Text(
              product.title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Text(product.description)),
          ],
        ));
  }
}
